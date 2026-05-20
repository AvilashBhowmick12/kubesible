resource "aws_instance" "this" {
  ami                    = "ami-0b5a4e51202cd98e5"
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = var.name
  }
}
