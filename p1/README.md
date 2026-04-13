# Part 1 - Build a 2-node K3s cluster with Vagrant

*This project was created as part of the 42 curriculum by jmougel, klombard, and mmorot.*


[Back](../README.md)

## Description

Part 1 of this project consists of creating and provisioning a 2-node K3s cluster using Vagrant.

Two virtual machines are deployed automatically:
* the first one runs **K3s** in **server mode**
* the second one joins the cluster in **agent mode**

The goal is to build a minimal Kubernetes environment with automated provisioning and passwordless SSH access between the machines.

### Constraints

* Use the latest stable version of the Linux distribution of your choice as the operating system.
* The machines must run with Vagrant.
* The machine names must match the login of a member of your team.
* The hostname of the first machine must end with the capital letter **S** (for **Server**).
* The hostname of the second machine must end with **SW** (for **ServerWorker**).
* The IP address of the first machine (**Server**) must be **192.168.56.110**.
* The IP address of the second machine (**ServerWorker**) must be **192.168.56.111**.
* You must be able to connect to both machines through SSH without a password.
* **K3s** must be installed on the first machine (**Server**) in server mode.
* **K3s** must be installed on the second machine (**ServerWorker**) in agent mode.

## Tech Stack

* **Languages:** Bash, YAML
* **Tools:** Vagrant, K3s

## Instructions

### Installation

```bash
git clone https://github.com/jasonmgl/InceptionOfThings
cd InceptionOfThings/p1
make up
```

Make sure the following tools are installed on your system:

* Vagrant
* VirtualBox

### Usage

A **Makefile** is provided to make the project easier to run. The following commands are available:

```bash
make up
```

Starts the Vagrant cluster.

```bash
make down
```

Stops the Vagrant cluster properly.

```bash
make provision
```

Reprovisions the Vagrant cluster if the scripts have been updated.

```bash
make clean
```

Removes the file containing the K3s node token.

```bash
make fclean
```

Runs `clean`, then removes the Vagrant virtual machines and cached files.

```bash
make help
```

Displays the list of available commands.

### Validation

```bash
vagrant status
vagrant ssh jmougelS
sudo kubectl get nodes -o wide
```

## Project Structure

```text
p1
├── Vagrantfile
├── Makefile
├── README.md
└── scripts
    ├── install_server.sh
    └── install_worker.sh
```

## Resources

### Images

![K3s architecture](https://framerusercontent.com/images/dWSIayJXKNQbiDmppiNvPcemA.jpeg)

### Articles

* [Master Vagrant for your environments](https://blog.stephane-robert.info/docs/infra-as-code/provisionnement/vagrant/)
* [K3s: Lightweight Kubernetes for edge, IoT, and homelab](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/k3s/)
* [Kubernetes Deployments: Deploy and update your applications](https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/kubernetes/deployments/)
* [Configuration Options](https://docs.k3s.io/installation/configuration)

### Videos

* [Kubernetes 000 - Preamble: why??](https://www.youtube.com/watch?v=KViZkMialxo&list=PLn6POgpklwWo6wiy2G3SjBubF6zXjksap&index=1)
* [Kubernetes 001 - History, context, and solutions](https://www.youtube.com/watch?v=eRH_cetVAck&list=PLn6POgpklwWo6wiy2G3SjBubF6zXjksap&index=2)
* [Kubernetes 002 - Architecture: declarative vs imperative](https://www.youtube.com/watch?v=56i8lXmAtUw&list=PLn6POgpklwWo6wiy2G3SjBubF6zXjksap&index=3)
* [Kubernetes 003 - Architecture diagram: how does it work?](https://www.youtube.com/watch?v=PlraENp_bMk&list=PLn6POgpklwWo6wiy2G3SjBubF6zXjksap&index=4)
* [Kubernetes 004 - Scheduling: from ETCD to container](https://www.youtube.com/watch?v=M7o21hmxI28&list=PLn6POgpklwWo6wiy2G3SjBubF6zXjksap&index=5)

## AI Usage

I mainly used AI to help me understand concepts, generate diagrams, and create quizzes.

## Author

* **Login:** jmougel
* **GitHub:** [jasonmgl](https://github.com/jasonmgl)
