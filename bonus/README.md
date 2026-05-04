# Bonus - Local GitLab, Argo CD, and Helm on K3d

*This project was created as part of the 42 curriculum by jmougel, klombard, and mmorot.*

[Back](../README.md)

## Description

The bonus part of this project consists of reproducing the [Part 3](../p3/README.md) setup, but this time using a local GitLab instance instead of a public GitHub repository.

This part also introduces **Helm**, which can be used to simplify the installation and upgrade of applications on Kubernetes.

**Helm** is a package manager for Kubernetes. It simplifies application installation, upgrade, and removal by generating the required manifests and allowing chart values to be customized through a `values.yaml` file.

The first step is to create a **K3d** cluster, which runs a **K3s** cluster inside Docker containers and avoids the need for a virtual machine. Then, three namespaces must be created:

* **argocd**, which contains Argo CD
* **gitlab**, which contains GitLab
* **dev**, which contains the application monitored and deployed by Argo CD from a local GitLab repository

**MinIO** is used as an S3-compatible object storage service required by the local GitLab setup.

The goal is to verify that Argo CD automatically synchronizes the cluster state with the Kubernetes manifests stored in the GitLab repository.  
When the Deployment definition is updated in the repository, the application is automatically updated in the cluster.

### Manifest Types Used

* **Deployment**: used to deploy and manage an application by creating and maintaining ReplicaSets and Pods.
* **Service**: used to provide a stable network endpoint for a set of Pods and make the application reachable from within the cluster.
* **Ingress**: used to route external HTTP requests to the appropriate Service based on the requested host.
* **Namespace**: used to logically organize and separate resources inside a Kubernetes cluster. It is mainly intended for organization rather than full network isolation, since applications from different namespaces can still communicate with each other by default.

The Docker images used for this exercise are:

* `wil42/playground:v1`
* `wil42/playground:v2`

## Constraints

* Create three namespaces:
  * The first one must be dedicated to Argo CD.
  * The second one must be dedicated to GitLab.
  * The third one must be named **dev** and contain an application automatically deployed by Argo CD from your local GitLab repository.
* You may use the prebuilt application provided by Wil, available on Docker Hub.
* You must be able to change the application version from your GitLab repository and verify that the application is updated correctly.

## Tech Stack

* **Languages:** Bash, YAML
* **Tools:** K3d, Docker, Argo CD, Helm, GitLab

## Instructions

### Installation

```bash
git clone https://github.com/jasonmgl/InceptionOfThings
cd InceptionOfThings/bonus
make up
```

Make sure `make` is installed on your system before starting the setup.

Make sure the following entries are present in your `/etc/hosts` file:
```text
127.0.0.1 argocd.local gitlab.local minio.local jmougel.local
```

A `.env.sample` file is provided to help customize the local environment.

### Usage

A **Makefile** is provided to make the project easier to run. The following commands are available:

```bash
make re
```

Runs `make purge` and then `make up`.

```bash
make up
```

Installs the required environment for the project and starts the K3d cluster.

```bash
make purge
```

Completely removes the tools installed by the setup script and uninstalls Docker from the host machine. Use this command with caution.

```bash
make help
```

Displays the list of available commands.

### Dashboards and Access

All services are exposed locally through the same ingress entry point on port `8888`, using host-based routing.

Go to the following address to access the Argo CD dashboard:

```text
http://argocd.local:8888/
```

Go to the following address to access the GitLab dashboard:

```text
http://gitlab.local:8888/
```

Go to the following address to access the application monitored by Argo CD:

```text
http://jmougel.local:8888/
```

Go to the following address to access the MinIO dashboard:

```text
http://minio.local:8888/
```

### Credentials

For demonstration purposes, the default credentials used in this project are:

* **Argo CD** — `admin` / `adminadmin`
* **GitLab** — `root` / `Mmorot1234@`
* **MinIO** — `admin` / `adminadmin`

## Validation

You can verify that the environment is running correctly with:

```bash
kubectl get namespaces
kubectl get pods -n argocd
kubectl get pods -n gitlab
kubectl get pods -n dev
kubectl get ingress -A
```

## Project Structure

```text
bonus
├── Makefile
├── README.md
├── .env.sample
├── scripts
│   ├── get-docker.sh
│   ├── install.sh
│   ├── uninstall.sh
│   └── remove-docker.sh
└── confs
    ├── argocd
    │   ├── argocd-app.yaml
    │   ├── ingress.yaml
    │   └── namespace.yaml
    ├── gitlab
    │   ├── values.yaml
    │   └── namespace.yaml
    └── k3d-config.yaml
```

## Resources

### Images

![K3d project structure](https://i.postimg.cc/7PVdqGrF/Screenshot-from-2026-04-10-17-26-47.png)
![K3d structure](https://tse3.mm.bing.net/th/id/OIP.7MD59m547aIA46rnCg4w5gHaDf?pid=Api)

### Articles

* [Helm install: deploy and manage your releases](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/outils/helm/install-releases/#_top)
* [Helm in 15 minutes: install and deploy your first chart](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/outils/helm/introduction/)
* [Helm repositories: add, search, and inspect charts](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/outils/helm/repos-charts/)
* [Helm values: customize charts properly with -f and --set](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/outils/helm/values/)
* [MinIO : stockage objet S3-compatible](https://blog.stephane-robert.info/docs/services/stockage/minio/)

## AI Usage

I mainly used AI to help me understand concepts, generate diagrams, and create quizzes.

## Author

* **Login:** jmougel
* **GitHub:** [jasonmgl](https://github.com/jasonmgl)

[Back](../README.md)
