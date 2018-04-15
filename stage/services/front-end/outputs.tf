#output "instance_ip" {
#  value = "${module.frontend_1.instance_ip}"
#}

output "elb_dns" {
  value = "${module.frontend_1.elb_dns}"
}
