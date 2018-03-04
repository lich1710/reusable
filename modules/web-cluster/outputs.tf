output "asg_name" {
  value = "${aws_autoscaling_group.cluster.name}"
}

output "elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}
