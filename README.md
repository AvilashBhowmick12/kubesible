# Vanilla Kubernetes on AWS  
## (Terraform + Ansible + EBS CSI + WordPress)

This repository provisions and configures a **vanilla Kubernetes cluster on AWS EC2** using **Terraform** for infrastructure provisioning and **Ansible** for configuration management. The setup is intentionally **EKS‑free**, suitable for learning, demos, and migration POCs.

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

- kubeadm‑based Kubernetes (no EKS)
- AWS EBS CSI Driver for persistent storage
- Single‑replica MySQL & WordPress (EBS is ReadWriteOnce)
- gp3 volumes (15Gi) for MySQL and WordPress
- ≥30Gi root disk on EC2 nodes to avoid DiskPressure
- Explicit IAM permissions for EBS CSI

---

## Prerequisites

- AWS account
- EC2 Key Pair (e.g. k8s-terraform.pem)
- IAM permissions for EC2, VPC, IAM roles, and EBS
- Linux EC2 instance to run Terraform and Ansible

---

## Security Groups

### Control Plane Security Group

| Rule | Port(s) | Source |
|---|---|---|
| SSH | 22 | Your IP |
| Kubernetes API | 6443 | Worker SG |
| etcd | 2379–2380 | Control Plane SG |
| kubelet / control traffic | 10250–10255 | Cluster CIDR |
| NodePort | 30000–32767 | Worker SG |

### Worker Node Security Group

| Rule | Port(s) | Source |
|---|---|---|
| SSH | 22 | Your IP |
| kubelet | 10250 | Control Plane SG |
| NodePort | 30000–32767 | 0.0.0.0/0 |
| Egress | ALL | 0.0.0.0/0 |

---

## Terraform – Infrastructure Provisioning

### Terraform Enhancements

- Root disk increased to 30Gi (gp3)
- Worker IAM role attached with AmazonEBSCSIDriverPolicy
- IAM instance profiles explicitly attached to EC2 instances
- EBS lifecycle decoupled from Terraform state

### Provision Infrastructure

```bash
cd terraform
terraform init
```

Record the control plane and worker public IPs.

---

## Ansible – Kubernetes Bootstrap

```bash
cd ansible
ansible all -m ping
ansible-playbook playbook.yml
```

### What the Playbook Does

- Disables swap
- Installs containerd
- Installs kubeadm, kubelet, kubectl
- Initializes the control plane
- Joins the worker node
- Installs Calico CNI
- Installs AWS EBS CSI Driver
- Deploys NGINX, MySQL, WordPress, StorageClass and PVCs

---

## Storage Configuration (EBS CSI)

### StorageClass (ebs-sc)

```yaml
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
allowVolumeExpansion: true
parameters:
  type: gp3
```

### PersistentVolumeClaims

| PVC | Size | Access Mode |
|---|---:|---|
| mysql-pvc | 15Gi | RWO |
| wordpress-pvc | 15Gi | RWO |

---

## Stateful Workload Rules

EBS volumes are ReadWriteOnce. Only one pod can mount a volume at a time.

```bash
kubectl scale deployment mysql --replicas=1
kubectl scale deployment wordpress --replicas=1
```

---

## Cluster Verification

```bash
kubectl get nodes
kubectl get pods -A
kubectl get pvc
```

---

## Access WordPress

```bash
kubectl get svc wordpress
```

Open in browser:

```
http://<WORKER_PUBLIC_IP>:<NODEPORT>
```

---

## Cleanup

```bash
kubectl delete pvc --all
kubectl delete pv --all
cd terraform
terraform destroy
```

---

## Outcome

✅ Vanilla Kubernetes cluster on AWS  
✅ Terraform‑managed infrastructure  
✅ Ansible‑managed Kubernetes bootstrap  
✅ EBS‑backed persistent storage via CSI  
✅ WordPress successfully deployed and accessible

---

### Authors

Avilash Bhowmick  X  Hritam Kar – https://github.com/hritam2001


