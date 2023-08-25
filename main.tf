provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region, e.g., us-east-1
}

# Create a VPC
resource "aws_vpc" "seamlesshr_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a public subnet within the VPC
resource "aws_subnet" "seamlesshr_public_subnet" {
  vpc_id                  = aws_vpc.seamlesshr_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}

# Create a private subnet within the VPC
resource "aws_subnet" "seamlesshr_private_subnet" {
  vpc_id                  = aws_vpc.seamlesshr_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"  # Replace with your desired availability zone
}

# Create a security group for EC2 instances
resource "aws_security_group" "seamlesshr_ec2_sg" {
  name        = "seamlesshr_ec2_security_group"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.seamlesshr_vpc.id

  # Define inbound and outbound rules here
}

# Create a security group for the Load Balancer
resource "aws_security_group" "seamlesshr_lb_sg" {
  name        = "seamlesshr_lb_security_group"
  description = "Security group for Load Balancer"
  vpc_id      = aws_vpc.seamlesshr_vpc.id

  # Define inbound and outbound rules here
}

# Create a launch configuration for Auto Scaling
resource "aws_launch_configuration" "seamlesshr_lc" {
  name_prefix   = "seamlesshr-lc-"
  image_id      = "your-ami-id"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = "your-key-pair"  # Replace with your desired key pair name

  security_groups             = [aws_security_group.seamlesshr_ec2_sg.id]
  associate_public_ip_address = true
}

# Create an Auto Scaling group
resource "aws_autoscaling_group" "seamlesshr_asg" {
  name             = "seamlesshr-asg"
  launch_configuration = aws_launch_configuration.seamlesshr_lc.name
  vpc_zone_identifier  = [aws_subnet.seamlesshr_private_subnet.id]
  min_size           = 2
  max_size           = 5

  # Define additional autoscaling configurations here
}

# Create a Load Balancer
resource "aws_lb" "seamlesshr_lb" {
  name               = "seamlesshr-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.seamlesshr_public_subnet.id]

  enable_deletion_protection = false

  enable_http2     = true
  idle_timeout     = 60
  enable_cross_zone_load_balancing = true

  

  tags = {
    Name = "seamlesshr-lb"
  }

  # Define listener configurations here (e.g., HTTP/HTTPS)
}

# Output the public DNS of the Load Balancer
output "load_balancer_dns" {
  value = aws_lb.seamlesshr_lb.dns_name
}
