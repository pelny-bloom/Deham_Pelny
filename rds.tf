#creating DB Subnet Group
resource "aws_db_subnet_group" "private_group" {
  name       = "private-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "Private-Group"
  }
}

#create RDS database
resource "aws_db_instance" "mysqlgallery" {
  allocated_storage      = "10"
  db_name                = "galleryDB"
  engine                 = "mysql"
  engine_version         = "8.0.39"
  instance_class         = "db.t3.micro"
  identifier             = "rds-db"
  username               = "gallerist"
  password               = ")n1B6+6S49>"
  skip_final_snapshot    = true
  multi_az               = true
  storage_encrypted      = false
  vpc_security_group_ids = [aws_security_group.rds_mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.private_group.name #Associate private subnet to db instance

  tags = {
    Name = "rds_db"
  }
}

data "aws_db_instance" "mysql_data" {
  db_instance_identifier = aws_db_instance.mysqlgallery.identifier
}
#Get Database name, username, password, endpoint from above RDS
output "rds_db_name" {
  value = data.aws_db_instance.mysql_data.db_name
}
output "rds_username" {
  value = "gallerist"
}
output "rds_passwordword" {
  value     = ")n1B6+6S49>"
  sensitive = true
}
output "rds_endpoint" {
  value = data.aws_db_instance.mysql_data.endpoint
}