# 自家製ngrokの作り方
Ngrokと同じことをするのに何が必要かというとこれだけでした。
- リモートポートフォワードでSSHする
- Nginxでフォワードされたポートをインターネットに公開するよう設定する

EC2の起動テンプレートをterraformで作り、起動テンプレから立ち上がったサーバーはあらかじめ仕込まれたユーザーデータのスクリプトで自動でNginxや必要なセットアップを行うようにしました。

## Terraform

```hcl
resource "aws_key_pair" "umihico" {
  # ２人目以降はuser_data.shから直接~/.ssh/authorized_keysに足す
  key_name   = "umihico"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUMIHICoCb3Sy2n1qPXOxc2mFBqW9Hg0dRigxl2F3nW"
}


resource "aws_security_group" "ssh" {
  name   = "self-hosted-ngrok-sg"
  vpc_id = var.vpc_id

  ingress {
    description      = "allow only SSH"
    from_port        = 1234
    to_port          = 1234
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_launch_template" "this" {
  name          = "self-hosted-ngrok"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.umihico.id
  image_id      = "ami-0bcc04d20228d0cf6"
  user_data     = filebase64("${path.module}/user_data.sh")
  network_interfaces {
    subnet_id       = var.public_subnets[0]
    security_groups = [aws_security_group.ssh.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "self-hosted-ngrok"
    }
  }
}
```

## user_data.sh

```bash
#!/bin/bash

# サーバー費削減のために毎朝3時に自動でstopするようにcronを追加
sudo timedatectl set-timezone Asia/Tokyo
sudo sh -c "echo '0 3 * * * root /usr/sbin/shutdown -h now' > /etc/cron.d/auto-shutdown"
sudo systemctl crond restart

# SSHポートをパブリックに公開するならデフォの22から変更して攻撃量を減らしておく
sudo sed -i -e "s/#Port 22/Port 1234/" /etc/ssh/sshd_config 
sudo systemctl restart sshd

sudo yum update -y

sudo amazon-linux-extras install nginx1 -y
sudo tee /etc/nginx/conf.d/server.conf << END
upstream tunnel {
  server 127.0.0.1:8080;
}
server {
  location = /nginx-healthcheck {
    add_header Content-Type text/html;
    return 200 '<html><body><h1>OK</h1></body></html>';
  }
  location / {
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;
    proxy_redirect off;
    
    proxy_pass http://tunnel;
  }
}
END
sudo systemctl start nginx.service
```

Nginxサーバーが立ち上がったどうかだけ/nginx-healthcheckから確認できます。
無事にNginxが動いていれば、次に以下のSSHコマンドです。ローカルでポート3000で見えるものがEC2のパブリックDNSにも見えたら成功です。

```bash
ssh -N -p 1234 -R 8080:localhost:3000 -oStrictHostKeyChecking=no ec2-user@$DnsName
```

これのほか起動時に前回使ったstoppedなサーバーをterminateしたり、https使ったり証明書を発行したりする必要がありますが、この辺のルーティングまわりやスクリプトは各自の環境次第なので省略
