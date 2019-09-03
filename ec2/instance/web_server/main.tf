resource "aws_instance" "web_server" {
  ami = "ami-0bbc25e23a7640b9b"
  instance_type = "t2.micro"

  subnet_id = var.subnet_id
  vpc_security_group_ids = [
    var.vpc_security_group_id]

  key_name = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    service httpd start
    chkconfig httpd on
    cd /var/www/html
    echo "<html><h1>Hello Jorge!</h1></html>" > index.html
    EOF

  tags = var.tags
}