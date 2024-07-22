terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.59.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

variable "vpc_cidr_block" {
  description = "This is the cidr block for my custom vpc"
  type        = string
}

variable "subnet_cidr_block_1" {
  description = "subnet cidr block in availability zone 1"
  type        = string
}

variable "subnet_cidr_block_2" {
  description = "Cidr vlock for subnet in availability zone 2"
  type        = string
}

variable "environment" {
  description = "This is the environment used"
  type        = string
}

variable "my_ip" {
  description = "This is my ip address"
  type = string
}

variable "instance_type" {
  description = "instance type"
}

variable "public_key" {
  description = "public key"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "my_vpc_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr_block_1
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.environment}-subnet_1"
  }
}

resource "aws_subnet" "my_vpc_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr_block_2
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.environment}-vpc-subnet-2"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.environment}-vpc_igw"
  }
}

/*resource "aws_route_table" "my_app-route-table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "${var.environment}-vpc-route-table"
  }
}*/

/*resource "aws_route_table_association" "my_app-subnet-1-route-association" {
  subnet_id      = aws_subnet.my_vpc_subnet_1.id
  route_table_id = aws_route_table.my_app-route-table.id
}

resource "aws_route_table_association" "my_app-subnet-2-route-association" {
  subnet_id      = aws_subnet.my_vpc_subnet_2.id
  route_table_id = aws_route_table.my_app-route-table.id
}*/

/* let's edit the default route table */
resource "aws_default_route_table" "my_app-default-route-table" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "${var.environment}-vpc-default-route-table"
  }
}

resource "aws_route_table_association" "my-app-subnet_1-association" {
  subnet_id = aws_subnet.my_vpc_subnet_1.id
  route_table_id = aws_default_route_table.my_app-default-route-table.id
}

resource "aws_route_table_association" "my-app-subnet_2-association" {
  subnet_id = aws_subnet.my_vpc_subnet_2.id
  route_table_id = aws_default_route_table.my_app-default-route-table.id
}

/*security group*/
resource "aws_default_security_group" "default-sg"{
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.environment}-vpc-default-sg"
    }
} 

data "aws_ami" "latest-linux_ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "my_server_key_pair" {
  key_name = "Light_server_key"
  public_key = "${file(var.public_key)}"
}

resource "aws_instance" "myapp_server_1" {
  ami = data.aws_ami.latest-linux_ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_vpc_subnet_1.id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.my_server_key_pair.key_name
  user_data = file("script.sh")
  
  tags = {
    Name = "${var.environment}-vpc-server_1"
  }
}

resource "aws_instance" "my_app_server_2" {
  ami = data.aws_ami.latest-linux_ami.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.my_vpc_subnet_2.id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.my_server_key_pair.key_name
  user_data = file("script.sh")
  tags = {
    Name = "${var.environment}-vpc-server_2"
  }
}

