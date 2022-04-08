resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-main"
    Project = "Terraform"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "190.160.1.0/24"

  tags = {
    Name = "Subnet-main-1"
    Project = "Terraform"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
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
    Name = "SSH-SG"
    Project = "Terraform"
  }
}

resource "aws_instance" "sample-server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnets.id
  security_groups = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  credit_specification {
    cpu_credits = "standard"
  }

    tags = {
    Name = "sample-server"
    Project = "Terraform"
  }
}