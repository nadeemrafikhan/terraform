 provider "aws" {
  region = "${var.region}"
} 

# terraform state file with locking remotely (it help to keep in sync for multiple users)
#terraform {
 # backend "s3" {
  #  bucket = "trstatefile"
   # key    = "terraform/terraform.tfstate"
    #region = "ap-south-1"
	#dynamodb_table = "terraformstate"
 # }
#}