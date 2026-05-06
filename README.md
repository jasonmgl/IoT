# Inception Of Things

*This project was created as part of the 42 curriculum by jmougel, klombard, and mmorot.*

## Description

The goal of this project is to discover Kubernetes through a progressive approach using **K3s**, **K3d**, **Vagrant**, **Argo CD**, and **Helm**.

It is divided into three main parts and one bonus part:

| Partie | Description |
|---------|-------------|
| **P1** | Build and provision a 2-node K3s cluster with Vagrant. |
| **P2** | Deploy multiple applications using Kubernetes manifests. |
| **P3** | Use K3d and Argo CD to explore continuous deployment. |
| **Bonus** |  Local GitLab, Argo CD, and Helm on K3d. |

## Tech Stack

* **Languages:** Bash, YAML
* **Tools:** K3s, K3d, Docker, Vagrant, Argo CD, Helm

## Project Parts

* [P1: Build a 2-node K3s cluster with Vagrant](./p1/README.md)
* [P2: Deploy apps with Kubernetes manifests](./p2/README.md)
* [P3: Use K3d and Argo CD for continuous deployment](./p3/README.md)
* [Bonus: Local GitLab, Argo CD, and Helm on K3d](./bonus/README.md)

Each part introduces new concepts and tools related to container orchestration and deployment automation.

## Installation

```bash
git clone https://github.com/jasonmgl/InceptionOfThings
cd InceptionOfThings
```

Refer to each part's README for its specific setup and requirements.

## Project Structure

```text
InceptionOfThings
├── p1/
├── p2/
├── p3/
├── bonus/
├── .gitignore
└── README.md
```

## Author

* **Login:** jmougel
* **GitHub:** [jasonmgl](https://github.com/jasonmgl)
