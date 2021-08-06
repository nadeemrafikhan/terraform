variable "region" { default = "ap-south-1"}

variable "cidr_block" { default = "190.160.0.0/16"}

variable "Psubnet_cidr" { 
  type = list 
  default = ["190.160.1.0/24", "190.160.2.0/24", "190.160.3.0/24"]
}

variable "Prvsubnet_cidr" { 
  type = list 
  default = ["190.160.4.0/24", "190.160.5.0/24", "190.160.6.0/24"]
}

#variable "azs" {
 # type = list 
  #default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
#}

#Get the availability zone dynmic
data "aws_availability_zones" "azs" {}