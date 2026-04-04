resource "aws_security_group" "this" {
  name   = "k8s-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { 
    from_port = 6443 
    to_port = 6443 
    protocol = "tcp" 
    self = true 
  }
  ingress { 
    from_port = 2379 
    to_port = 2380 
    protocol = "tcp" 
    self = true 
  }
  ingress { 
    from_port = 10250 
    to_port = 10250 
    protocol = "tcp" 
    self = true 
  }
  ingress { 
    from_port = 30000 
    to_port = 32767 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}