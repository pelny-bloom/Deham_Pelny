#creating DB Subnet Group
resource "aws_db_subnet_group" "private_group" {
  name       = "private-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "Private-Group"
  }
}

# retrieving the values from secrets manager
data "aws_secretsmanager_secret" "secret" {
  name = "rds-secret"
  depends_on = [
    aws_secretsmanager_secret.rds_secret
  ]
}

# retrieving specific version of secrets manager
data "aws_secretsmanager_secret_version" "rds_secret_version" {
    secret_id = aws_secretsmanager_secret.rds_secret.id
}

#create RDS database

resource "aws_db_instance" "mysqlgallery" {
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.default.arn
  depends_on              = [aws_secretsmanager_secret_version.rds_secret_version] 
  allocated_storage      = "10"
  db_name                = "galleryDB"
  engine                 = "mysql"
  engine_version         = "8.0.39"
  instance_class         = "db.t3.micro"
  identifier             = "rds-db"
  username               = "gallerist"
  password               = data.aws_secretsmanager_secret_version.rds_secret_version.secret_string
  skip_final_snapshot    = true
  multi_az               = false
  storage_encrypted      = false
  vpc_security_group_ids = [aws_security_group.rds_mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.private_group.name #Associate private subnet to db instance

  provisioner "local-exec" {
    command = "chmod +x rds_login.sh && ./rds_login.sh"
  }

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
output "rds_password" {
  value     = data.aws_secretsmanager_secret_version.rds_secret_version.secret_string
  sensitive = true
}
output "rds_endpoint" {
  value = data.aws_db_instance.mysql_data.endpoint
}