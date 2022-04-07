variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "190.160.0.0/16"
}

variable "subnet_cidr" {
  default = "190.160.1.0/24"
}

variable "ami_id" {
  default = "ami-0e472ba40eb589f49"
}


# variable "azs" {
#     type = list(string)
#     default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
# }

variable "azs" {
    type = list(string)
    default = ["us-east-1a"]
}

# variable "subnet_cidrs" {
#   type = list(string)
#   default = ["190.160.1.0/24", "190.160.2.0/24", "190.160.3.0/24", "190.160.4.0/24", "190.160.5.0/24", "190.160.6.0/24"]
# }

variable "subnet_cidrs" {
  type = list(string)
  default = ["190.160.1.0/24"]
}

# # Declare the data source
# data "aws_availability_zones" "azs" {
#   state = "available"
# }