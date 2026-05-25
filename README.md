# Vanilla Kubernetes on AWS  
## (Terraform + Ansible + EBS CSI + WordPress)

This repository provisions and configures a **vanilla Kubernetes cluster on AWS EC2** using **Terraform** for infrastructure provisioning and **Ansible** for configuration management.

The setup is intentionally **EKS‑free** and designed for:
- Kubernetes fundamentals learning
- Infrastructure & storage debugging practice
- Migration and platform POCs

---

## Architecture Overview

| Component | Count | Purpose |
|---------|------:|---------|
| Terraform Runner | 1 | Runs Terraform and Ansible |
| Control Plane | 1 | Kubernetes API & control components |
| Worker Node | 1 | Application workloads |
| Storage | EBS (gp3) | Persistent volumes via CSI |
| CNI | Calico | Pod networking |

Applications are exposed using **NodePort** services.

---

## Key Design Decisions

- **kubeadm‑based Kubernetes** (no EKS)
- **Immutable infrastructure** via Terraform modules
- **AWS EBS CSI Driver** for dynamic persistent volumes
- **Single‑replica MySQL & WordPress** (EBS is ReadWriteOnce)
- **gp3 volumes (15Gi)** for MySQL and WordPress PVCs
- **20Gi root disk on EC2 nodes** (critical to avoid `DiskPressure`)
- Explicit IAM permissions for EBS CSI
- Calico CNI for networking

> ⚠️ Root disk sizing is mandatory. Kubernetes uses node root storage for **ephemeral‑storage**.

---

## Prerequisites

- AWS account
- EC2 Key Pair
- IAM permissions for EC2, VPC, IAM, and EBS
- Linux machine to run Terraform and Ansible

---

## Terraform – Infrastructure Provisioning

```bash
cd terraform
terraform init
terraform apply
```

---

## Ansible – Kubernetes Bootstrap

```bash
cd ansible
ansible-playbook playbook.yml
```

---

## Storage Configuration (EBS CSI)

| PVC | Size | Access Mode |
|---|---:|---|
| mysql-pvc | 15Gi | ReadWriteOnce |
| wordpress-pvc | 15Gi | ReadWriteOnce |

---

## Access WordPress

```bash
kubectl get svc wordpress
```

Open in browser:

```
http://<WORKER_NODE_IP>:<NODEPORT>
```

---

## Cleanup

```bash
kubectl delete pvc --all
cd terraform
terraform destroy
```

---

## Outcome

✅ Vanilla Kubernetes cluster on AWS  
✅ Terraform‑managed infrastructure  
✅ Ansible‑managed Kubernetes bootstrap  
✅ EBS‑backed persistent storage via CSI  
✅ WordPress successfully deployed

---

## Authors

Avilash Bhowmick  X Hritam Kar – https://github.com/hritam2001

