provider "aws" {
 region = "us-west-2"
}

data "aws_vpc" "default" {
 default = true
}

resource "aws_security_group" "allow_HTTP_HTTPS" {
  name        = "allow_HTTP_HTTPS"
  description = "Allow HTTP,HTTPS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

ingress {
    description      = "HTTP Allow"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "HTTPS Allow"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_RDP"
  }
}
