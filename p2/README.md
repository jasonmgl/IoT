# Part 2 - Deploy apps with Kubernetes manifests

[Back](../README.md)
<br/>
*This project was created as part of the 42 curriculum by jmougel, klombard, and mmorot.*

## Description

Part 2 of this project consists of creating, on a virtual machine using Vagrant, a single-node K3s cluster hosting 3 web applications.

Each application displays the name of the Pod being accessed.  
The second application is deployed with 3 replicas in order to distribute traffic and improve availability.

### Manifest Types Used

* **Deployment**: used to deploy and manage an application by creating and maintaining ReplicaSets and Pods.
* **Service**: used to provide a stable network endpoint for a set of Pods and make the application reachable from within the cluster.
* **Ingress**: used to route external HTTP requests to the appropriate Service based on the requested host.

The Docker image used for this exercise is:

* `paulbouwer/hello-kubernetes:1`

## Constraints

* Only one virtual machine with the latest stable version of the distribution of your choice.
* K3s must be installed in server mode.
* Set up 3 web applications of your choice.
* The applications must be accessible depending on the **HOST** used when making a request to the IP address **192.168.56.110**.
* The name of this machine must be your login followed by **S**.
* When a client enters the IP address **192.168.56.110** in their browser with the host **app1.com**, the server must display **app1**.
* When the host **app2.com** is used, the server must display **app2**.
* Otherwise, **app3** must be selected by default.

## Tech Stack

* **Languages:** Bash, YAML
* **Tools:** Vagrant, K3s

## Instructions

### Installation

```bash
git clone https://github.com/jasonmgl/InceptionOfThings
cd InceptionOfThings/p2
make up
```

Make sure the following tools are installed on your system:

* Vagrant
* VirtualBox

Make sure the following hosts are in your /etc/hosts file:

* 192.168.56.110 app1.local
* 192.168.56.110 app2.local
* 192.168.56.110 app3.local

### Usage

A **Makefile** is provided to make the project easier to run. The following commands are available:

```bash
make up
```

Starts the Vagrant virtual machine.

```bash
make down
```

Stops the Vagrant virtual machine properly.

```bash
make provision
```

Reprovisions the Vagrant virtual machine if the scripts have been updated.

```bash
make fclean
```

Removes the Vagrant virtual machine and its cached files.

```bash
make test
```

Runs `curl` requests against each application to verify that host-based routing is working correctly.

```bash
make help
```

Displays the list of available commands.

### Validation

```bash
kubectl get pods -o wide
kubectl get svc
kubectl get ingress
make test
```

## Project Structure

```text
p2
├── Vagrantfile
├── Makefile
├── README.md
├── scripts
│   └── install_server.sh
└── confs
    ├── app1
    │   ├── deployment.yaml
    │   └── service.yaml
    ├── app2
    │   ├── deployment.yaml
    │   └── service.yaml
    ├── app3
    │   ├── deployment.yaml
    │   └── service.yaml
    └── ingress
        └── ingress.yaml
```

```
Cluster IP -- > 192.168.56.110

app1 --> Host: http://app1.local/

app2 --> Host: http://app2.local/

app3 --> Host: http://app3.local/
```

## Resources

### Image

![K3s Service/Ingress](https://lh5.googleusercontent.com/ZKJZ5_b2BuaU9KnDYkeCOc0ePvpHQdhfMwvZPjU3pTK5aHL1022YNwY0G9qr4udwae7yI9hgGmhK3g0fuC66HK8ol3BtdVQ_z27nJFfHAfW38oMmhL9Ot8nc3r2Jxel5yTM9h5az33ws0DLwoCKmIZs)

### Articles

* [Kubernetes Pods: create, observe, and understand their lifecycle](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/kubernetes/pods/)
* [Kubernetes Deployments: deploy and update your applications](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/kubernetes/deployments/)
* [Kubernetes Services: expose and connect your applications](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/kubernetes/services/)
* [Kubernetes Manifests: write, validate, and fix them quickly](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/kubernetes/ecrire-manifests/)
* [How to connect to Kubernetes Pods](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/outils/kubectl-exec-debug/)
* [Kubernetes Ingress: expose your HTTP/HTTPS applications](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/kubernetes/ingress/)

### Videos

* [Kubernetes 005 - What is a Pod?](https://www.youtube.com/watch?v=maD16sgsFTY&list=PLn6POgpklwWo6wiy2G3SjBubF6zXjksap&index=7)
* [Kubernetes 016 - What is a Deployment?](https://www.youtube.com/watch?v=AFEU_mBbzr0&list=PLn6POgpklwWo6wiy2G3SjBubF6zXjksap&index=18)
* [Kubernetes 018 - What is a Service? (objectives, ClusterIP, expose...)](https://www.youtube.com/watch?v=Z62WCbIIWyg&list=PLn6POgpklwWo6wiy2G3SjBubF6zXjksap&index=20)

## AI Usage

I mainly used AI to help me understand concepts, generate diagrams, and create quizzes.

## Author

* **Login:** jmougel
* **GitHub:** [jasonmgl](https://github.com/jasonmgl)