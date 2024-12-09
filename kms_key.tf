# kms key is used to encrypt the secrets manager secret values.
# creating a KMS key for RDS, which is deleted after 7 days and password rotation is enabled.

resource "aws_kms_key" "default" {
  description             = "KMS key for RDS"
  deletion_window_in_days = 7
  is_enabled = true
  enable_key_rotation = true

  tags = {
    Name = "terraform_rds_secrets_manager"
  }
}