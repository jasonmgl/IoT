# Part 3 - Use K3d and Argo CD for Continuous Deployment

*This project was created as part of the 42 curriculum by jmougel, klombard, and mmorot.*
<br/>
[Back](../README.md)

## Description

Part 3 of this project consists of setting up a first **Continuous Deployment** workflow using **Argo CD**.

The first step is to create a **K3d** cluster, which runs **K3s** clusters inside Docker containers and avoids the need for a virtual machine. Then, two namespaces must be created:

* **argocd**, which contains Argo CD
* **dev**, which contains the application monitored and deployed by Argo CD from a GitHub repository

The goal is to verify that Argo CD automatically synchronizes the cluster state with the Kubernetes manifests stored in the GitHub repository.
When the Deployment definition is updated in the repository, the application is automatically updated in the cluster.

### Manifest Types Used

* **Deployment**: used to deploy and manage an application by creating and maintaining ReplicaSets and Pods.
* **Service**: used to provide a stable network endpoint for a set of Pods and make the application reachable from within the cluster.
* **Ingress**: used to route external HTTP requests to the appropriate Service based on the requested host.
* **Namespace**: used to logically organize and separate resources inside a Kubernetes cluster. It is mainly intended for organization, not for full network isolation, since applications from different namespaces can still communicate with each other by default.

The Docker images used for this exercise are:

* `wil42/playground:v1`
* `wil42/playground:v2`

## Constraints

* Create two namespaces:
  * The first one must be dedicated to Argo CD.
  * The second one must be named **dev** and contain an application automatically deployed by Argo CD from your public GitHub repository.
* You may use the prebuilt application provided by Wil, available on Docker Hub.
* You must be able to change the version from your public GitHub repository and verify that the application is updated correctly.

## Tech Stack

* **Languages:** Bash, YAML
* **Tools:** K3d, Docker, Argo CD

## Instructions

### Installation

```bash
git clone https://github.com/jasonmgl/InceptionOfThings
cd InceptionOfThings/p3
make up
```

### Usage

A **Makefile** is provided to make the project easier to run. The following commands are available:

```bash
make up
```

Runs the script that installs the required environment for the project and starts the K3d cluster.

```bash
make purge
```

Removes the executables installed in `/usr/local/bin` by the environment setup script and also uninstalls Docker using a dedicated removal script.

```bash
make help
```

Displays the list of available commands.

### Dashboard

Go to the following address to access the Argo CD dashboard:

```text
http://argocd.local/
```

**Login:** `admin`  
**Password:** `adminadmin`

## Project Structure

```text
p3
├── Makefile
├── README.md
├── scripts
│   ├── get-docker.sh
│   ├── init.sh
│   └── remove-docker.sh
└── confs
    ├── argocd
    │   ├── argocd-app.yaml
    │   ├── ingress.yaml
    │   └── namespace.yaml
    └── k3d-config.yaml
```

## Resources

### Images

![K3d project structure](https://i.postimg.cc/7PVdqGrF/Screenshot-from-2026-04-10-17-26-47.png)
![K3d structure](https://tse3.mm.bing.net/th/id/OIP.7MD59m547aIA46rnCg4w5gHaDf?pid=Api)

### Articles

* [Create local Kubernetes clusters with K3d](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/k3d/)
* [Kubernetes Namespaces: organize and logically isolate your resources](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/kubernetes/namespaces/)
* [Argo CD Documentation](https://argo-cd.readthedocs.io/en/stable/)
* [Argo CD — Secure your GitOps deployment](https://blog.stephane-robert.info/docs/pipeline-cicd/argocd/securiser/)
* [Install Argo CD on Kubernetes](https://blog.stephane-robert.info/docs/pipeline-cicd/argocd/installation/)
* [Argo CD — Deploy your first application](https://blog.stephane-robert.info/docs/pipeline-cicd/argocd/premiere-application/)

### Videos

* [Namespaces and Contexts - #Kubernetes 13](https://www.youtube.com/watch?v=KthldM3Y4lg)
* [ARGO-EVENTS - 01. INTRODUCTION](https://www.youtube.com/watch?v=xZr7rF8I3Wc)

## AI Usage

I mainly used AI to help me understand concepts, generate diagrams, and create quizzes.

## Author

* **Login:** jmougel
* **GitHub:** [jasonmgl](https://github.com/jasonmgl)