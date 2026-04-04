module "sg" {
  source = "./modules/security-group"
  vpc_id = local.vpc_id
}

module "control_plane" {
  source          = "./modules/ec2"
  name            = "k8s-control-plane"
  subnet_id       = local.subnet_id
  sg_id           = module.sg.sg_id
  instance_type   = var.instance_type
  key_name        = var.key_name
}

module "worker" {
  source          = "./modules/ec2"
  name            = "k8s-worker"
  subnet_id       = local.subnet_id
  sg_id           = module.sg.sg_id
  instance_type   = var.instance_type
  key_name        = var.key_name
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    control_ip = module.control_plane.public_ip
    worker_ip  = module.worker.public_ip
  })
  filename = "../ansible/inventory.ini"
}