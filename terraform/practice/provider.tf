provider "aws" {
  region     = var.region
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "vpc-main"
    Project = "Terraform"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id     = aws_vpc.main.id
  count = length(data.aws_availability_zones.azs.names)
  cidr_block = element(var.subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)

  tags = {
    Name = "Subnet-main-${count.index + 1}"
    Project = "Terraform"
  }
}