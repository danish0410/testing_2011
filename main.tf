terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# ✅ Get subnet details
data "aws_subnet" "selected" {
  id = var.subnet_id
}

# ✅ Create Internet Gateway if missing
resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_subnet.selected.vpc_id
}

# ✅ Create route table
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_subnet.selected.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# ✅ Associate subnet with route table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.public_rt.id
}

# ✅ Create EC2 instance
resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}

# ✅ Output Public IP
output "public_ip" {
  value = aws_instance.ec2.public_ip
}
