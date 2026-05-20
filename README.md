# Vanilla Kubernetes Installation Guide (AWS + Terraform + Ansible)

This document provides a **step-by-step guide** to provision and deploy a **Vanilla Kubernetes cluster on AWS EC2** using **Terraform** for infrastructure provisioning and **Ansible** for configuration management.

---

## Architecture Overview

- 1 Terraform Runner EC2
- 1 Kubernetes Control Plane EC2
- 1 Kubernetes Worker EC2
- NGINX application exposed via NodePort

---

## Prerequisites

- AWS Account
- EC2 Key Pair (example: `k8s-terraform.pem`)
- IAM permissions to create EC2, VPC, Security Groups
- Linux-based EC2 instance to run Terraform and Ansible

---

## Step 1: Provision Terraform Runner EC2

1. Login to AWS Console
2. Launch an EC2 instance (Ubuntu preferred)
3. SSH into the instance

---

## Step 2: Install Required Tools

Install the following on the Terraform runner EC2:

```bash
sudo apt update
sudo apt install -y terraform ansible awscli
```

Verify installations:

```bash
terraform -v
ansible --version
aws --version
```

---

## Step 3: Configure AWS CLI

```bash
aws configure
```

Provide:
- AWS Access Key
- AWS Secret Key
- Default Region
- Output format (json)

---

## Step 4: Clone the Repository

```bash
cd /root
git clone https://github.com/hritam2001/kubesible.git
or
git clone https://github.com/AvilashBhowmick12/kubesible.git
cd kubesible
```

---

## Step 5: Provision Infrastructure Using Terraform

Navigate to terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Apply Terraform configuration:

```bash
terraform apply -var="key_name=k8s-terraform"
or "new key" ->
terraform apply -var="key_name=my-key.pem"
```

Confirm with `yes` when prompted.

---

## Step 6: Capture Terraform Outputs

```bash
terraform output
```

Note down:
- Control Plane IP
- Worker Node IP

---

## Step 7: Configure Ansible

Navigate to ansible directory:

```bash
cd ../ansible
```

Verify Ansible connectivity:

```bash
ansible all -m ping
```

Expected output: **SUCCESS** from all hosts.

---

## Step 8: Deploy Kubernetes Cluster

Run the Ansible playbook:

```bash
ansible-playbook playbook.yml
```

This will:
- Install container runtime
- Initialize Kubernetes control plane
- Join worker node
- Deploy NGINX application

---

## Step 9: Verify Kubernetes Cluster

SSH into Control Plane:

```bash
ssh -i k8s-terraform.pem ubuntu@<CONTROL_PLANE_IP>
or
ssh -i my-key.pem ubuntu@<CONTROL_PLANE_IP>
```

Check nodes:

```bash
kubectl get nodes
```

Expected output:

```
control-plane   Ready
worker          Ready
```

Check pods:

```bash
kubectl get pods -A
```

---

## Step 10: Access Application

Check NGINX service:

```bash
kubectl get svc nginx
```

Note the NodePort.

Access application:

```
http://<WORKER_NODE_IP>:<NODEPORT>
```

Expected output:

```
Welcome to nginx!
(or custom website)
```

---

## Cleanup (Optional)

To destroy all resources:

```bash
cd terraform
terraform destroy
```

---

## Outcome

✅ Vanilla Kubernetes Cluster on AWS
✅ Terraform-based Infrastructure
✅ Ansible-based Kubernetes Deployment
✅ Application exposed and accessible

---

Happy Learning 🚀 – Avilash X [Hritam](https://github.com/hritam2001)

