variable "namespace" {
  default = "haproxy-dns-test"
}

# Set TF_VAR_zone_name
variable "zone_name" {}

variable "aws_region" {
  default = "eu-central-1"
}

variable "ami_id" {
  default = {
    eu-central-1   = "ami-0bdf93799014acdc4"
    ap-southeast-1 = "ami-0c5199d385b432989"
  }
}

variable "num_instances" {
  default = 3
}
