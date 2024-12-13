#!/bin/bash

#update the system
sudo yum update -y

# Configure AWS CLI with IAM role credentials
aws configure set default.region us-west-2

#Install apache server
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd


#Install PHP & mysql
sudo amazon-linux-extras install -y php8.0
sudo amazon-linux-extras enable mariadb10.5
sudo yum clean metadata
sudo yum install -y mariadb unzip

sudo yum install mysql -y
sudo yum install php-mysql -y

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

#Wordpress database login
$DBRootPassword='rootpassword'
mysqladmin -u root password $DBRootPassword

# Retrieve RDS endpoint from Terraform output
$DBName="galleryDB"
$DBUser="gallerist"
$DBPassword=")n1B6+6S49>"
$RDS_ENDPOINT=data.aws_db_instance.mysql_data.endpoint

# Create a temporary file to store the database value
sudo touch db.txt
sudo chmod 777 db.txt
sudo echo "DATABASE $DBName;" >> db.txt
sudo echo "USER $DBUser;" >> db.txt
sudo echo "PASSWORD $DBPassword;" >> db.txt
sudo echo "HOST $RDS_ENDPOINT;" >> db.txt

# Copy wp-config.php file to wordpress directory
sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'galleryDB'/'$DBName'/g" wp-config.php
sudo sed -i "s/'gallerist'/'$DBUser'/g" wp-config.php
sudo sed -i "s/')n1B6+6S49>'/'$DBPassword'/g" wp-config.php
sudo sed -i "s/'localhostdata.aws_db_instance.mysql_data.endpoint'/'$RDS_ENDPOINT'/g" wp-config.php

sudo mysql -h "$RDS_ENDPOINT" -u "$DBUser" -p"$DBPassword" "$DBName" -e "SHOW DATABASES;"

#Restart Apache
sudo systemctl restart httpd