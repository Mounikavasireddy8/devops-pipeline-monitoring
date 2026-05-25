variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "devops-pipeline"
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "c7i-flex.large"
}