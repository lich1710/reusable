
resource "aws_db_instance" "mysql_instance" {

  engine = "mysql"
  allocated_storage = "${var.db_allocated_storage}"
  instance_class = "${var.db_instance_class}"
  name = "${var.db_name}"
  username = "admin"
  password = "${var.db_password}"
}
