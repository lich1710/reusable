variable "db_password" {
  description = "Password of the mySQL DB"
  default = "admin1234"
}

variable "db_instance_class" {
  default = "db.t2.micro"
  description = "Type of instance for the DB"
}

variable "db_allocated_storage" {
  default = "10"
  description = "How much to assign to the storage"
}

variable "db_name" {
  default = "mySQL database"
  description = "Name of the database"
}
