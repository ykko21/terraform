provider "aws" {
  region = "us-east-1"
}

variable "ingressrules" {
  type = list(number)
  default = [ 80,443 ]  
}

variable "egressrules" {
  type = list(number)
  default = [ 80,25,53,443,3306,8080 ]  
}

resource "aws_instance" "ec2" {
  ami = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.webtraffic.name]
  tags = {
    Name = "HelloEC2"
  }
}

resource "aws_security_group" "webtraffic" {
  name = "Allow HTTPS"
  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }  
  egress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
