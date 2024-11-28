provider "aws" {
  region = "us-west-2"
}

# configuration of autoscaling launch
resource "aws_launch_configuration" "scaling_launch_config" {
  image_id        = data.aws_ami.amazon_linux2.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.gallery_sg.id}"]
  key_name        = "vockey"
}

# configuration of the launch template 
resource "aws_launch_template" "scaling_launch_template" {
  name_prefix            = "scaling_launch_template"
  image_id               = data.aws_ami.amazon_linux2.id
  instance_type          = "t2.micro"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.gallery_sg.id]
  user_data              = base64encode(data.template_file.UserdataEC2.rendered)
lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Gallery instance as"
    }
  }
  }

# Creating the autoscaling group
resource  "aws_autoscaling_group" "gallery_autoscaling_group" {
  launch_template {
    id      = aws_launch_template.scaling_launch_template.id
    version = aws_launch_template.scaling_launch_template.latest_version
  }
  

  name                      = "gallery-asg"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.public_1.id, aws_subnet.public_2.id] #var.private_subnet_cidr_blocks
  target_group_arns         = [aws_lb_target_group.gallery_target_group.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "gallery_instance_as"
    propagate_at_launch = true
  }
}


# Defining autoscaling policy
resource "aws_autoscaling_policy" "autoscale_out" {
  name                   = "autoscale_out"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.gallery_autoscaling_group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
} 