########################################
# Provider
########################################
provider "aws" {
  region = "ap-south-1"
}

########################################
# Fetch Existing Default VPC
########################################
data "aws_vpc" "default" {
  default = true
}

########################################
# Fetch Public Subnets from VPC
########################################
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


########################################
# Security Group for Jenkins
########################################
resource "aws_security_group" "jenkins" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins UI"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

########################################
# Jenkins EC2 Instance
########################################
resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = "t3.medium"
  subnet_id = data.aws_subnets.public.ids[0]
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "jenkins-server"
  }
}
