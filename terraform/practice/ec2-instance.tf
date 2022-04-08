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

  ingress {
    description      = "Open Jenkins Connection"
    from_port        = 8080
    to_port          = 8080
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

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-main-1"
    Project = "Terraform"
  }
}

# resource "aws_internet_gateway_attachment" "igw-attach-vpc" {
#   internet_gateway_id = aws_internet_gateway.gw.id
#   vpc_id              = aws_vpc.main.id
# }

resource "aws_route_table" "rt-main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "rt-main-1"
    Project = "Terraform"
  }  
}

resource "aws_key_pair" "deployer" {
  key_name   = "kp-20220408"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7zZgJzaHGzhpsmjOW2Sp4DI9r8EJtDXf6kbA6BGyxi+kjC70YjSOpybiU8/mQ3/RHTC6VGBGegjXwI0B9lykoqjksENdH729xwOBQ2OwjkxQdHyguucswnGZq/0qLtQyV3toDwUR3se9Zdjcghc9arFhdmTB852cNO+MkuJb1Hu2Rh4uI/09aR6S7x/q/gukunmNOK1OqhdYgd6FheMW3H8trLeZbOMlYbo5bTzJboEexxMuYLQAfBF3btmKlfzWIFGYodwBfe7oKHHs8YwwOVcBu+rdsUcJPAvAvk1Xi3Dux0frDQv0lwlcpNzNsaMOBzkTyEsuv8WZlve+J8fJ7CxmhSsr60Pi+O1qfo79uxTEE8ks6STRgk4u32CaFPe+W3vugOo+1SyWcqSACULGfgqMOKyEIO/ByN3g48CYqjs8HR78wKlHrqTDp5Ot9HNo5bPGAp/sEoWbRxJvXecIsvDatgTVCFN33NxKgi+oynvxn48ta5X3ik4VOtCMVzOIVGUlM+j8etnKWQ329BFCSs2FrkcqygWTidlLuVXlDkkPSwgZrhwMClvmrdTmEJoSRLpvXo+E9uPDe2vxrGTwiBONhDtWnX1u4X5dkAD9Uk+nPqI6lM0PnI9L+qshRk5xdbdvT65IYWYtpW9D6P9MqPqMTZHwOgYJFslXieLRjyQ== hvb.careers@gmail.com"
}
resource "aws_instance" "sample-server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnets.id
  security_groups = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  key_name = "kp-20220408"
  credit_specification {
    cpu_credits = "standard"
  }
  user_data = <<EOF
#!/bin/bash -xe
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
EOF

    tags = {
    Name = "sample-server"
    Project = "Terraform"
  }
}