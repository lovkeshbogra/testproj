provider "aws" {
  region = "us-east-1"
}

# Refine VPC filter to ensure uniqueness
data "aws_vpc" "selected_vpc" {
  filter {
    name   = "tag:Name"
    values = ["GTM-AWS-EUS-INT-DFS-CS-VPC"] # Replace with the actual Name tag of the VPC
  }
}

resource "aws_security_group" "allow_HTTP_HTTPS_RDP" {
  name        = "allow_HTTP_HTTPS_RDP"
  description = "Allow HTTP, HTTPS, and RDP inbound traffic"
  vpc_id      = data.aws_vpc.selected_vpc.id

  ingress {
    description = "RDP Allow"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Allow"
    from_port   = 443
    to_port     = 443
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
    Name = "allow_HTTP_HTTPS_RDP"
  }
}
