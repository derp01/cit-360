# DB security group
resource "aws_security_group" "default" {
    name = "rds_sg"
    description = "Managed by derp"
    ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["172.31.0.0/16"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
      Name = "allow_all"
    }
}


/* Instances Security group */
resource "aws_security_group" "allow_all" {
  name = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
       from_port = -1
       to_port = -1
       protocol = "icmp"
       cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
         from_port = -1
         to_port = -1
         protocol = "icmp"
         cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
	vpc_id = "${var.vpc_id}"
}

# Security Group for ELB
resource "aws_security_group" "elb" {
	name = "elb"
	description = "Allow access from anywhere to an instance on port 80 (HTTP)"
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
