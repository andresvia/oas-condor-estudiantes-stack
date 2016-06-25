variable "aws_access_key" {
    type = "string"
}
variable "aws_secret_key" {
    type = "string"
}
variable "aws_region" {
    type = "string"
}
variable "branch" {
    type = "string"
}
variable "commit" {
    type = "string"
}
variable "build_number" {
    type = "string"
}
variable "instance_type" {
    type = "string"
}
variable "subnet_1" {
    type = "string"
}
variable "subnet_2" {
    type = "string"
}
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}
