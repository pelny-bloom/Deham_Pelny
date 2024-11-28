#!/bin/bash

#update the system
sudo yum update -y

# Configure AWS CLI with IAM role credentials
aws configure set default.region us-west-2

#Install apache server
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd

#Install PHP
sudo yum install -y php 
sudo amazon-linux-extras install
sudo amazon-linux-extras enable php8.0
sudo yum clean metadata
sudo yum install php-cli php-pdo php-fpm php-mysqlnd php-json php-mbstring php-xml php-common

# Update all installed 
sudo yum update -y

#Restart Apache
sudo systemctl restart httpd

#wordpress installation
sudo yum install -y wget
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html/

cd /var/www/html
sudo tar -zxvf latest.tar.gz
sudo cp -rvf wordpress/* .

sudo rm -R wordpress
sudo rm latest.tar.gz
