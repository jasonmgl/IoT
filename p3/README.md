# Part 3 - Use K3d and Argo CD for Continuous Deployment

*This project was created as part of the 42 curriculum by jmougel, klombard, and mmorot.*

[Back](../README.md)

## Description

Part 3 of this project consists of setting up a first **Continuous Deployment** workflow using **Argo CD**.

The first step is to create a **K3d** cluster, which runs a **K3s** cluster inside Docker containers and avoids the need for a virtual machine. Then, two namespaces must be created:

* **argocd**, which contains Argo CD
* **dev**, which contains the application monitored and deployed by Argo CD from a GitHub repository

The goal is to verify that Argo CD automatically synchronizes the cluster state with the Kubernetes manifests stored in the GitHub repository.  
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

Make sure the following tools are installed on your system:

* Make

Make sure the following entries are present in your `/etc/hosts` file:

| IP Address | Hosts |
|------------|-------|
| `127.0.0.1` | `argocd.local`, `jmougel.local` |

A `.env.sample` file is provided to help customize the local environment.

### Usage

A **Makefile** is provided to make the project easier to run. The following commands are available:

| Command | Description |
|---------|-------------|
| `make re` | Runs `make purge` and then `make up`. |
| `make up` | Installs the required environment for the project and starts the K3d cluster. |
| `make purge` | Completely removes the tools installed by the setup script and uninstalls Docker from the host machine. Use this command with caution. |
| `make help` | Displays the list of available commands. |

### Dashboard

Go to the following address to access the Argo CD dashboard:

```text
http://argocd.local/
```

### Application Access

Go to the following address to access the application deployed by Argo CD:

```text
http://jmougel.local/
```

### Credentials

For demonstration purposes, the default credentials used in this project are:

* **Argo CD** — `admin` / `adminadmin`

## Validation

You can verify that the environment is running correctly with:

```bash
kubectl get namespaces
kubectl get pods -n argocd
kubectl get pods -n dev
kubectl get ingress -A
```

## Project Structure

```text
p3
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

## AI Usage

I mainly used AI to help me understand concepts, generate diagrams, and create quizzes.

## Author

* **Login:** jmougel
* **GitHub:** [jasonmgl](https://github.com/jasonmgl)

[Back](../README.md)
