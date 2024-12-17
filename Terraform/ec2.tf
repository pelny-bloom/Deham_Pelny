#create ec2 instance
locals {
  name = "Gallery Instance"
}
#Get latest ami ID of Amazon Linux - values = ["al2023-ami-2023*x86_64"]
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20241113.1-x86_64-gp2"]
  }
}

resource "aws_instance" "gallery_instance" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  key_name                    = "vockey"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.gallery_sg.id]
  subnet_id                   = aws_subnet.public_1.id # Choose one of the public subnets

  tags = {
    Name = local.name
  }
  #user_data = file("UserDataEC2.tpl")
  user_data = data.template_file.UserdataEC2.rendered
}

data "template_file" "UserdataEC2" {
  template =  file("${path.module}/UserDataEC2.tpl")
} 