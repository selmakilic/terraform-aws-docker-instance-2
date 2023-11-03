#!/bin/bash
hostnamectl set-hostname ${server-name}     ##makine hostname  olarak server-name verilir
yum update -y
amazon-linux-extras install docker -y    ##docker kurulumu yapiliyor 
systemctl start docker
systemctl enable docker      # makine kapatilip acildiginda icerinde hazir bir sekilde docker kurulu olacaktir
usermod -a -G docker ec2-user    #usermod ile yetkiler docker ec2-user grubuna eklenmis olur cunku docker in bazi yetkilere ihtiyaci var/
# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \              ##docker compose u burdan indirip docker kurulumunu yapiyor
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose     #makinye yetki veriliyor chmod ile 