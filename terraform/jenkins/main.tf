provider "aws"{
    region = "us-east-1"
}

variable "name" {
    description = "Name the instance on deploy"
}

resource "aws_instance" "jenkins-server"{
    ami = "ami-0e472ba40eb589f49"
    instance_type = "t2.micro"
    tags = {
        Name = "${var.name}"
    }
}