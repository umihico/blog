---
tags: "AWS,Terraform"
excerpt: 'ECSのアプリがRDSのDBにつながらない事態が発生し、どうも解決できないのでEC2を同じVPCに立ててRDSに接続できるか確かめてみることにしました。再利用できるようにメモ'
---

# 調査用のEC2をサクッと立ち上げるterraformスニペット

ECSのアプリがRDSのDBにつながらない事態が発生し、どうも解決できないのでEC2を同じVPCに立ててRDSに接続できるか確かめてみることにしました。再利用できるようにメモ

カスタムした点として以下を入れてます

- 256GBの保存容量
- docker, docker-compose
- MySQL Client

tfファイルはこちらです。

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

variable "vpc_id" { type = string }            # TF_VAR_vpc_id
variable "subnet_id" { type = string }         # TF_VAR_subnet_id
variable "my_ip" { type = string }             # TF_VAR_my_ip
variable "security_group_id" { type = string } # TF_VAR_security_group_id

resource "random_integer" "priority" {
  min = 1000000
  max = 10000000
}

resource "aws_security_group" "temp" {
  name   = "temp${random_integer.priority.result}"
  vpc_id = var.vpc_id

  ingress {
    description = "allow from home"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_iam_role" "temp_role" {
  name = "temp_role${random_integer.priority.result}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Action" : "sts:AssumeRole"
        "Effect" : "Allow"
        "Principal" : {
          "Service" : ["ec2.amazonaws.com"]
        },
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/PowerUserAccess",
  ]
}


resource "aws_iam_instance_profile" "temp" {
  name = "temp_role_profile${random_integer.priority.result}"
  role = aws_iam_role.temp_role.name
}

resource "aws_instance" "temp" {
  ami                         = "ami-0bcc04d20228d0cf6"
  vpc_security_group_ids      = concat([aws_security_group.temp.id], length(var.security_group_id) > 0 ? [var.security_group_id] : [])
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.umihico.id
  instance_type               = "t2.micro"
  iam_instance_profile        = "temp_role_profile${random_integer.priority.result}"
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 256 # default is 8
    volume_type           = "gp2"
  }
  user_data = <<-EOF
    #!/bin/bash

    sudo yum update -y
    sudo yum groupinstall "Development Tools" -y

    # docker
    sudo yum install -y docker
    sudo systemctl start docker
    sudo usermod -a -G docker ec2-user
    sudo systemctl enable docker
    sudo chmod 666 /var/run/docker.sock

    # docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    # mysql client(5.7)
    sudo yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm -y
    sudo yum-config-manager --disable mysql80-community
    sudo yum-config-manager --enable mysql57-community
    sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
    sudo yum install mysql-community-client -y
  EOF
}

resource "aws_key_pair" "umihico" {
  # https://github.com/umihico.keys
  key_name   = "umihico${random_integer.priority.result}"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUMIHICoCb3Sy2n1qPXOxc2mFBqW9Hg0dRigxl2F3nW"
}

output "temp" {
  value = {
    instance : aws_instance.temp
  }
}
```

applyするときのスクリプト

```bash
#!/bin/bash

export TF_VAR_vpc_id=
export TF_VAR_subnet_id=
export TF_VAR_security_group_id=
export TF_VAR_my_ip=$(curl -s http://checkip.amazonaws.com)

cd $(dirname $0)

terraform init
terraform apply -auto-approve
OUTPUT=$(terraform output -json)
PUBLIC_DNS=$(echo $OUTPUT | jq -r ".temp.value.instance.public_dns")
INSTANCE_ID=$(echo $OUTPUT | jq -r ".temp.value.instance.id")
echo ssh ec2-user@${PUBLIC_DNS}
echo aws ssm start-session --target ${INSTANCE_ID}
# terraform destroy -auto-approve
```

sshで入ってdumpしたりするコマンド
```bash

export DATABASE_USER=
export PORT=
export DATABASE_NAME=
export MYSQL_PWD=
export DATABASE_HOST=

# dump
mysqldump -u $DATABASE_USER -h $DATABASE_HOST -P $PORT --set-gtid-purged=OFF $DATABASE_NAME > dump.sql

# import
cat dump.sql | mysql -u $DATABASE_USER -P $PORT --password=$MYSQL_PWD -h $DATABASE_HOST $DATABASE_NAME
```
