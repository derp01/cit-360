# DB Subnet group
resource "aws_db_subnet_group" "db-1" {
    name = "main"
    description = "Managed by derp"
    subnet_ids = ["${aws_subnet.private_subnet_a.id}", "${aws_subnet.private_subnet_b.id}"]

    tags {
        Name = "My DB subnet group"
    }
}

# Relations Database Service (RDS) instance
resource "aws_db_instance" "rds-1" {
  allocated_storage    = 5
  engine               = "mariadb"
  engine_version       = "10.0.24"
  identifier           = "i-luv-devops"
  instance_class       = "db.t2.micro"
  multi_az             = false
  storage_type         = "gp2"
# name                 = "mariadb"
  username             = "${var.username}"
  password             = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.db-1.id}"
# parameter_group_name = "default.mysql5.6"
  tags {
    Name = "MariaDB instance"
  }
}

# Elastic Load balancer
resource "aws_elb" "bar" {
  name = "foobar-terraform-elb"

  subnets = ["${aws_subnet.public_subnet_b.id}" , "${aws_subnet.public_subnet_c.id}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port = 80
    instance_protocol = "HTTP"
    lb_port = 80
    lb_protocol = "HTTP"
  }

  health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 5
   target = "HTTP:80/"
   interval = 30
 }

  instances = ["${aws_instance.webserver_b.id}" , "${aws_instance.webserver_c.id}"]
  cross_zone_load_balancing = true
  #idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 60

  tags {
    Name = "foobar-terraform-elb"
  }

}

# webserver instance
resource "aws_instance" "webserver_b" {
    ami = "ami-5ec1673e"

    subnet_id = "${aws_subnet.private_subnet_b.id}"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.allow_all.id}"]
    tags {
        Name = "webserver-b"
        Service = "curriculum"
    }
}

# webserver instance
resource "aws_instance" "webserver_c" {
    ami = "ami-5ec1673e"

    subnet_id = "${aws_subnet.private_subnet_c.id}"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.allow_all.id}"]
    tags {
        Name = "webserver-c"
        Service = "curriculum"
    }
}
