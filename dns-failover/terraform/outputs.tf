output "deployer_private_key_pem" {
  sensitive = true
  value     = "${tls_private_key.deployer.private_key_pem }"
}

output "deployer_public_key_pem" {
  sensitive = true                                         # not sensitive, but verbose
  value     = "${tls_private_key.deployer.public_key_pem}"
}

output "instance_ids" {
  value = "${aws_instance.web.*.id}"
}

output "instance_public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}

output "dns_record" {
  value = "${aws_route53_record.www.name}"
}
