variable "ami" {default = ""}
variable "subnet_id" {default = ""}
variable "environment" {default = ""}
variable "vpc_security_group_ids" {default = ""}
variable name { default = "EC2-default-name"}
variable "region" {
  default = "us-west-2"
}

variable "access_key" {default = ""}
variable "secret_key" {default = ""}

variable "identity" {
  default = "rpt"
}
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region #"us-east-1"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "servers" {
  description = "Map of server types to configuration"
  type        = map(any)
  default = {
    server-iis = {
      ami                    = "ami-07f5c641c23596eb9"
      instance_type          = "t2.micro",
      environment            = "dev"
      subnet_id              = "subnet-031bf0c9a309fcd8d"
      vpc_security_group_ids = ["sg-01380b40dc19ad166"]
    },
    server-apache = {
      ami                    = "ami-07f5c641c23596eb9"
      instance_type          = "t2.nano",
      environment            = "test"
      subnet_id              = "subnet-031bf0c9a309fcd8d"
      vpc_security_group_ids = ["sg-01380b40dc19ad166"]
    }
  }
}

resource "aws_instance" "web" {
  for_each               = var.servers
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids

  tags = {
    "Identity"    = var.identity
    "Name"        = each.key
    "Environment" = each.value.environment
  }
}

// testing comments

output "public_dns" {
  value = aws_instance.web
}
