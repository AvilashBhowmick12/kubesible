[control]
${control_ip}

[worker]
${worker_ip}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/k8s-terraform.pem