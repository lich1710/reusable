output "public_subnet_ids" {
  value = [
    "${aws_subnet.stage-1a.id}",
    "${aws_subnet.stage-1b.id}",
    "${aws_subnet.stage-1c.id}"
  ]
}
