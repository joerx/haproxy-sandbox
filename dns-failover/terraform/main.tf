provider "aws" {
  profile = "yodo"
  region  = "${var.aws_region}"
}

data "aws_route53_zone" "selected" {
  name         = "${var.zone_name}."
  private_zone = false
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}

resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.namespace}"
  public_key = "${tls_private_key.deployer.public_key_openssh}"
}

locals {
  num_subnets = "${length(data.aws_subnet_ids.default.ids)}"
}

resource "aws_instance" "web" {
  count         = "${var.num_instances}"
  ami           = "${lookup(var.ami_id, var.aws_region)}"
  instance_type = "t2.micro"

  associate_public_ip_address = true

  subnet_id              = "${data.aws_subnet_ids.default.ids[count.index % local.num_subnets]}"
  key_name               = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  user_data = <<USER_DATA
#!/bin/sh
apt-get update
apt-get -y install nginx
echo "<h1>$(curl -sS http://169.254.169.254/latest/meta-data/instance-id)</h1>" > /var/www/html/index.html
USER_DATA

  tags = {
    Name = "${var.namespace}-${count.index}"
  }
}

resource "aws_security_group" "default" {
  name        = "${var.namespace}"
  description = "Allow inbound SSH and web traffic"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH ingress"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP ingress"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS ingress"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Egress to all"
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.namespace}.${var.zone_name}"
  type    = "CNAME"
  ttl     = "30"
  records = ["${random_shuffle.selected_instance.result[0]}"]
}

resource "random_shuffle" "selected_instance" {
  input = ["${aws_instance.web.*.public_dns}"]

  keepers = {
    timestamp = "${timestamp()}"
  }
}
