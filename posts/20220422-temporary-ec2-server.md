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

variable "vpc_id" { type = string }    # TF_VAR_vpc_id
variable "subnet_id" { type = string } # TF_VAR_subnet_id
variable "my_ip" { type = string }     # TF_VAR_my_ip

resource "aws_security_group" "temp" {
  name   = "temp"
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

resource "aws_instance" "temp" {
  ami                         = "ami-0bcc04d20228d0cf6"
  vpc_security_group_ids      = [aws_security_group.allow_umihico.id]
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.umihico.id
  instance_type               = "t2.micro"
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
  key_name   = "umihico"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUMIHICoCb3Sy2n1qPXOxc2mFBqW9Hg0dRigxl2F3nW"
}
```
