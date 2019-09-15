resource "aws_security_group" "db" {
  name = "wordpress_db_sg"
  description = "Allow ICMP echo, HTTP, HTTPS, MySQL and SSH inbound traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"

    security_groups = [
      var.web_server_security_group_id]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"

    security_groups = [
      var.web_server_security_group_id]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"

    security_groups = [
      var.web_server_security_group_id]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    security_groups = [
      var.web_server_security_group_id]
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"

    security_groups = [
      var.web_server_security_group_id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  name = "main"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "Wordpress DB subnet group"
  }
}

resource "aws_db_instance" "wordpress_db" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  name = "wordpress_db"
  username = "wordpress"
  password = "wordpress"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.wordpress_db_subnet_group.name
  vpc_security_group_ids = [
    aws_security_group.db.id]
  tags = var.tags
  skip_final_snapshot = true
}