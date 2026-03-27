# Inception of Things (IoT) 🚀

## 📖 Overview

This project is part of the 42 curriculum and aims to introduce Kubernetes concepts through practical implementation using **K3s**, **Vagrant**, and **containerized applications**.

The goal is to simulate a lightweight infrastructure close to an **edge computing environment**, where services are deployed and managed locally.

---

## 🧠 Objectives

- Understand Kubernetes fundamentals
- Deploy a lightweight cluster using **K3s**
- Manage infrastructure using **Vagrant**
- Deploy and expose multiple applications
- Configure **Ingress routing**
- Work in a DevOps-oriented environment

---

## ⚙️ Project Structure

.
├── p1/  # K3s + Vagrant (multi-node cluster)
├── p2/  # K3s + 3 applications + Ingress
└── p3/  # (Work in progress)

---

# 🧩 Part 1 — K3s & Vagrant

## 📌 Description

This part consists of setting up a **2-node Kubernetes cluster** using **K3s** inside virtual machines managed by **Vagrant**.

## 🏗️ Architecture

Host Machine
   │
   ├── VM 1 (Server / Control Plane)
   │     └── K3s Server
   │
   └── VM 2 (Worker)
         └── K3s Agent

## ⚙️ Configuration

- **VMs created with Vagrant**
- Minimal resources:
  - 1 CPU
  - 512 MB RAM
- Static IPs:
  - `192.168.56.110` → Server
  - `192.168.56.111` → Worker
- SSH access without password

## 🚀 Implementation

### 🔹 K3s Server
- Installed in **control plane mode**
- Initializes the cluster

### 🔹 K3s Agent
- Joins the cluster using a **token**
- Executes workloads (pods)

### 🔹 Tools used
- `kubectl` for cluster management
- Shell provisioning via Vagrant

## ✅ Result

- Functional multi-node Kubernetes cluster
- Nodes successfully connected and visible via:

kubectl get nodes

---

# 🌐 Part 2 — K3s & Applications

## 📌 Description

This part focuses on deploying **three web applications** inside the K3s cluster and exposing them using **Ingress routing**.

## 🏗️ Architecture

Client → Ingress → Service → Pods (Deployment)

## 🚀 Implementation

### 🔹 Applications

Three applications are deployed:

- `app1`
- `app2` (with 3 replicas)
- `app3` (default)

### 🔹 Kubernetes Resources

Each application includes:

- **Deployment**
  - Manages pods lifecycle
  - Ensures availability
- **Service**
  - Provides stable access to pods
  - Load balances traffic
- **Ingress**
  - Routes traffic based on hostname

---

## 🌍 Routing Logic

| Host        | Target App |
|------------|-----------|
| app1.com   | app1      |
| app2.com   | app2      |
| other      | app3      |

## ⚡ Example Flow
```
Request → 192.168.56.110
Host: app2.com
        ↓
Ingress
        ↓
Service app2
        ↓
Pods (3 replicas)
```

---

## 🧪 Key Features

- Multi-application deployment
- Load balancing (replicas)
- Host-based routing with Ingress
- Internal networking via Services

---

## ⚠️ Challenges Faced

- Ingress configuration and routing
- Service-to-pod communication
- Debugging networking issues
- Ensuring pods readiness before access

---

## 🛠️ DevOps Practices

- Infrastructure as Code (Vagrant)
- Containerization (Docker)
- Orchestration (Kubernetes / K3s)
- Declarative configuration (YAML manifests)

---

## 🚧 Part 3 (Work in Progress)

Part 3 will introduce:

- **K3d (Kubernetes in Docker)**
- **Argo CD (GitOps)**
- Continuous deployment pipelines

---

## 💡 Key Learnings

- Difference between Pods, Services, and Ingress
- Kubernetes networking basics
- Cluster setup and node communication
- Importance of readiness and deployment stability
- Real-world DevOps workflow simulation

---

## 📎 Author

**Jason Mougel**

- GitHub: https://github.com/jasonmgl
- LinkedIn: Jason MOUGEL

