variable "aws_region" {
  default = "ca-central-1"
}
variable "vpc_cidr" {
  default = "172.0.0.0/24"
}
variable "subnets_cidr" {
  type    = list(string)
  default = ["172.0.0.0/25", "172.0.0.128/25"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["ca-central-1a", "ca-central-1b"]
}
variable "ubuntuami" {
  default = "ami-0801628222e2e96d6"
}
variable "redhatami" {
  default = "ami-0277fbe7afa8a33a6"
}
variable "key_name" {
  default = "jenkins-key"
}
