variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_name" {
  type    = string
  default = "my-ec2-instance"
}