# Part 2 - Use K3d and Argo CD for continuous deployment

*This project was created as part of the 42 curriculum by jmougel, klombard, and mmorot.*

## Description

La partie 3 de ce projet conciste a faire notre premier CD (Continuous Deployment) a l'aide de Argo CD.
Dans un premier temps on doit creer un cluster K3d (La version dockeriser de K3s qui nous evite de passer par une machine virtuel), ensuite on doit creer 2 Namespace: dev (Qui sera le namespace qui contiendra l'application surveiller par Argo CD sur un repository Github) et argocd (qui contiendra Argo CD).
Ensuite on doit verifier qu'Argo CD redeploie bien la bonne image Docker quand on met a jour le fichier Deployment dans le repo Github surveille par Argo CD.

### Manifest Types Used

* **Deployment**: used to deploy and manage an application by creating and maintaining ReplicaSets and Pods.
* **Service**: used to provide a stable network endpoint for a set of Pods and make the application reachable from within the cluster.
* **Ingress**: used to route external HTTP requests to the appropriate Service based on the requested host.
* **Namespace**: Utiliser pour compartimenter un cluster Kubernetes (Pour l'organisation principalement, le reseau n'est pas compartimenter et toute les applications presentent dans le cluster peuvent communiquer entre elle qu'elles soit dans le meme namespace ou pas).

The Docker image used for this exercise is:

* `wil42/playground:v1`
* `wil42/playground:v2`

## Constraints

* Create two namespaces:
    - The first one will be dedicated to Argo CD
    - The second one will be named dev and will contain an application. This application will be automatically deployed by Argo CD using your online GitHub repository.
* You can use the pre-made application created by Wil, which is available on Docker Hub.
* Be able to change the version from your public GitHub repository, then check that the application has been correctly updated.

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

Execute le script qui install l'environnement pour lancer le projet et demarre le cluster K3d.

```bash
make clean
```

Supprime les executable installer dans /usr/local/bin/ par le script d'installation de l'environnement et desinstalle docker egalement a l'aide d'un script.

```bash
make help
```

Displays the list of available commands.

### Dashboard

Se rendre a cette adresse pour avoir accee au dashboard Argo CD: http://argocd.local/

Login : admin
Mot de passe adminadmin

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
    │   ├── argocd-app.yaml.yaml
    │   ├── ingress.yaml
    │   └── namespace.yaml
    └── k3d-config.yaml
```

## Resources

### Image

![K3d project structure](https://i.postimg.cc/7PVdqGrF/Screenshot-from-2026-04-10-17-26-47.png)
![K3d structure](https://tse3.mm.bing.net/th/id/OIP.7MD59m547aIA46rnCg4w5gHaDf?pid=Api)

### Articles

* [Créer des clusters Kubernetes locaux avec k3d](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/k3d/)
* [Namespaces Kubernetes : organiser et isoler logiquement vos ressources](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/kubernetes/namespaces/)
* [Argo CD](https://argo-cd.readthedocs.io/en/stable//)
* [ArgoCD — Sécuriser votre déploiement GitOps](https://blog.stephane-robert.info/docs/pipeline-cicd/argocd/securiser/)
* [Installer ArgoCD sur Kubernetes](https://blog.stephane-robert.info/docs/pipeline-cicd/argocd/installation/)
* [ArgoCD — Déployer votre première application](https://blog.stephane-robert.info/docs/pipeline-cicd/argocd/premiere-application/)

### Videos

* [Namespaces and Contexts - #Kubernetes 13](https://www.youtube.com/watch?v=KthldM3Y4lg)
* [ARGO-EVENTS - 01. INTRODUCTION](https://www.youtube.com/watch?v=xZr7rF8I3Wc)

## AI Usage

I mainly used AI to help me understand concepts, generate diagrams, and create quizzes.

## Author

* **Login:** jmougel
* **GitHub:** [jasonmgl](https://github.com/jasonmgl)