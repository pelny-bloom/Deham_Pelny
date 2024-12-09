#!/bin/bash

# Retrieve RDS details from Terraform outputs
RDS_ENDPOINT=$(terraform output -raw rds_endpoint)
DB_NAME=$(terraform output -raw rds_db_name)
DB_USER=$(terraform output -raw rds_username)
DB_PASSWORD=$(terraform output -raw rds_password)

# Escape special characters in the password
ESCAPED_PASSWORD=$(echo $DB_PASSWORD | sed 's/[&/\]/\\&/g')

# Attempt to connect to the database
mysql -h "$RDS_ENDPOINT" -u "$DB_USER" -p"$ESCAPED_PASSWORD" "$DB_NAME" -e "SHOW DATABASES;"

if [ $? -eq 0 ]; then
    echo "Successfully connected to the database."
else
    echo "Failed to connect to the database."
fi