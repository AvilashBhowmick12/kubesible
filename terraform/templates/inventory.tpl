[control]
${control_ip}

[worker]
${worker_ip}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/kubesible_PR/ansible/my-key.pem
ansible_python_interpreter=/usr/bin/python3
