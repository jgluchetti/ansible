terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAII3ATB2FUY4ZEWQQ"
  secret_key = "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"
  
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
  availability_zone = "us-east-1a"

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
  ami       = "ami-03d315ad33b9d49c4"
  subnet_id = aws_subnet.my_subnet.id
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  associate_public_ip_address = true
  security_groups = [aws_security_group.my_sec_group.id]
  key_name = "access-key"

  user_data = <<-EOF
              #!/bin/ksh
              sudo apt update -y
              sudo apt install ansible -y
              ansible-playbook -i ${aws_instance.my_server.public_ip}, deploy-app.yaml
              EOF
   
              
provisioner "local-exec" {
  command = "ansible-playbook -i ${aws_instance.my_server.public_ip}, deploy-app.yaml"

}
 
}

