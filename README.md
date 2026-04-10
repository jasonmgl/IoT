# Inception Of Things

*This project was created as part of the 42 curriculum by jmougel, klombard, and mmorot.*

## Description

The goal of this project was to become familiar with Kubernetes using K3s and K3d in order to create a cluster with or without Docker, learn how to use Vagrant to easily create a virtual machine cluster, and discover CI/CD concepts with Argo CD.

## Tech Stack

* **Languages:** Bash, YAML
* **Tools:** K3s, K3d, Vagrant, Argo CD

## Instructions

The project is divided into 3 parts:

* [P1: build a 2-node K3s cluster with Vagrant](https://github.com/jasonmgl/IoT/blob/main/p1/README.md)
* [P2: deploy apps with Kubernetes manifests](https://github.com/jasonmgl/IoT/blob/main/p2/README.md)
* [P3: use K3d and Argo CD for continuous deployment](https://github.com/jasonmgl/IoT/blob/main/p3/README.md)

Each part introduces new concepts and tools.

### Installation

```bash
git clone https://github.com/jasonmgl/InceptionOfThings
cd InceptionOfThings
```

Make sure the following tools are installed on your system:

* Vagrant
* VirtualBox

## Project Structure

```text
InceptionOfThings
├── p1/
├── p2/
├── p3/
├── .gitignore
└── README.md
```

## Author

* **Login:** jmougel
* **GitHub:** [jasonmgl](https://github.com/jasonmgl)