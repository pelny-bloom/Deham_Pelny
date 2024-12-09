# creating random password for RDS
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_secretsmanager_secret" "rds_secret" {
    kms_key_id = aws_kms_key.default.key_id
    name = "rds-secret"
    description = "Password for RDS"
    recovery_window_in_days = 14

    tags = {
        Name = "terraform_rds_secrets_manager"
    }
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
    secret_id = aws_secretsmanager_secret.rds_secret.id
    secret_string = random_password.rds_password.result
}

# storing RDS details
resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    db_name  = aws_db_instance.mysqlgallery.db_name
    username = aws_db_instance.mysqlgallery.username
    password = random_password.rds_password.result
    endpoint = aws_db_instance.mysqlgallery.endpoint
  })
}