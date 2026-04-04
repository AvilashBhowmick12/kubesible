output "control_plane_ip" {
  value = module.control_plane.public_ip
}

output "worker_ip" {
  value = module.worker.public_ip
}