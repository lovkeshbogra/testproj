provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "GTM-AWS-EUS-INT-DFS-CS-VPC" {
  filter {
    name   = "tag:Name" # Match by the Name tag of the VPC
    values = ["GTM-AWS-EUS-INT-DFS-CS-VPC"]
  }

  filter {
    name   = "isDefault" # Exclude default VPCs
    values = ["false"]
  }
}

resource "aws_security_group" "allow_HTTP_HTTPS_RDP" {
  name        = "allow_HTTP_HTTPS_RDP10"
  description = "Allow HTTP, HTTPS, RDP inbound traffic"
  vpc_id      = data.aws_vpc.GTM-AWS-EUS-INT-DFS-CS-VPC.id

  ingress {
    description = "RDP Allow"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (not recommended for production)
  }

  ingress {
    description = "SSH Allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (not recommended for production)
  }

  ingress {
    description = "HTTPS Allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (common for web servers)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "allow_HTTP_HTTPS_RDP"
  }
}

