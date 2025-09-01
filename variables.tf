variable "region" {
    type = string
    default = "ap-southeast-1"
}

variable "name_prefix" {
    description = "Prefix used for naming and tagging"
    type        = string
    default     = "prod"
  
}

variable "vpc_cidr" {
    description = "CIDR for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the public subnet"
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
    description = "CIDR for the private subnet"
    type = list(string)
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
}
variable "ami_id" {
    description = "AMI ID for the EC2 instances"
    type = string
    default = "ami-0933f1385008d33c4" 
  
}
variable "bastion_instance_type" {
    description = "EC2 instance type for Bastion Host"
    type = string
    default = "t2.micro"
}
variable "bastion_ami_id" {
    description = "AMI ID for the Bastion Host"
    type = string
    default = "ami-0933f1385008d33c4" 
  
}
variable "desired_capacity" {
    description = "Desired number of instances in the Auto Scaling group"
    type = number
    default = 2
}
variable "max_size" {
    description = "Maximum number of instances in the Auto Scaling group"
    type = number
    default = 3
}
variable "min_size" {
    description = "Minimum number of instances in the Auto Scaling group"
    type = number
    default = 1
  
}
