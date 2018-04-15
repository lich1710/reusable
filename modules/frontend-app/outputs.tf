output "instance_ip" {
  value = "${aws_instance.web_instance.*.public_ip}"
}

output "elb_dns" {
  value = "${aws_elb.elb.dns_name}"
}
