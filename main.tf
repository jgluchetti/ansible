terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  ssh_user = "ubuntu"
  key_name = "access-key"
  private_key_path = "/home/ubuntu/ansible/access-key.pem"

}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
  
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "sre-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "sre-subnet"
  }
}

resource "aws_security_group" "my_sec_group" {
  name        = "security_group"
  description = "Allow traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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

    ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "my_server" {
  ami       = "ami-0996d3051b72b5b2c"
  subnet_id = aws_subnet.my_subnet.id
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  associate_public_ip_address = true
  security_groups = [aws_security_group.my_sec_group.id]
  key_name = "access-key"

provisioner "remote-exec" {
   inline = [
          "sudo apt-get update",
	  "sudo apt-get update",
	  "sudo apt install -y docker.io",
	  "sudo apt install -y python3-pip",
	  "sudo  pip3 install docker-py"
   ]

   connection{
     type = "ssh"
     user = "ubuntu"
     private_key= file(local.private_key_path)
     host = aws_instance.my_server.public_ip
   }


}

provisioner "file" {
    source      = "~/ansible/"
    destination = "~/"

    connection{
     type = "ssh"
     user = "ubuntu"
     private_key= file(local.private_key_path)
     host = aws_instance.my_server.public_ip
   }

  }


provisioner "local-exec" {
  command = "/usr/bin/ansible-playbook -i ${aws_instance.my_server.public_ip}, --private-key ${local.private_key_path} deploy-app.yaml"

}

 
}

resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "sre-gateway"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name = "sre-route_table"
  }
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}



