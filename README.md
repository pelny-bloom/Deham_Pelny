THE SP GALLERY

**Project Title and Description**
Our project name is the SP art gallery

The goal of this project is to deploy a fault-tolerant, scalable and secure WordPress blog on AWS.

**Overview**
This project uses Terraform to deploy a scalable WordPress website on AWS. The infrastructure includes EC2 instances in an Auto Scaling Group, an RDS MySQL database, and a load balancer to distribute traffic. The setup ensures high availability, scalability, and secure access using different security layers. 

**Installation Instructions**
Step-by-step guide on how to set up the project locally.
Mention any prerequisites (e.g., software, dependencies) and how to install them.

**Usage**
1. Clone the repository
```
git clone https://github.com/pelny-bloom/Deham_Pelny.git
```
2. Initialize Terraform
```
terraform init
````
3. Review the Terraform plan
```
terrafom plan
```
4. Deploy the infrastructure
```
terraform apply --auto-approve
```


**Features**
Highlight the main functionalities or unique aspects of the project.
Example:
Terraform Project: WordPress Deployment on AWS



**Architecture**

EC2 Instances:
Hosts Apache web servers running WordPress, deployed in an Auto Scaling Group for scalability.
Load Balancer:
Distributes incoming traffic across the EC2 instances to ensure high availability.
RDS MySQL Database:
A managed database in a private subnet, providing secure and reliable storage for WordPress data.
Bastion Host:
Acts as a secure entry point to access the EC2 instances in the private subnet.

**Infrastructure Details**
VPC:
Multi-AZ setup with public and private subnets.
Security Groups:
Configured to restrict traffic and allow only necessary access.
Auto Scaling Group:
Dynamically adjusts the number of EC2 instances based on traffic.
Load Balancer:
Routes HTTP/HTTPS traffic to WordPress instances.
RDS Database:
MySQL database with appropriate parameter groups and subnet groups.

**Prerequisites**
Install Terraform. (hyperlink)
AWS CLI configured with appropriate IAM permissions.
SSH key pair for bastion host access.

**Usage**
git clone <repository-url>  
cd <repository-directory> 

**Initialize Terraform**
terraform init

**Apply Configuration**
terraform apply --auto-approve

**Access the Setup:**
WordPress:
                Access via the Load Balancer DNS (output after deployment).
Database:
                Connected automatically to WordPress instances.
Bastion Host:
                Use the provided SSH key to connect securely.
Notes
Ensure that your AWS account has sufficient service quotas for EC2, RDS, and other resources.
Terminate resources using terraform destroy to avoid unnecessary costs.