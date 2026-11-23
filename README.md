# vagrant-envs

| Project | Environment | Guest resources |
| --- | --- | --- |
| [Neo4j](neo4j/README.md) | Ubuntu 24.04, Docker, and Neo4j Community 5.26 with a sample graph | 2 vCPUs, 4 GB RAM |
| [CKAD](ckad/README.md) | Ubuntu 24.04 and Kubernetes 1.36.1 with kubeadm and Cilium | Two VMs with 2 vCPUs and 4 GB RAM each |

Install Vagrant and a version of VirtualBox that supports your host architecture. The labs use Bento Ubuntu 24.04 box version `202510.26.0`. Internet access is required to download the box and packages. The configurations support ARM64 guests on Apple Silicon and AMD64 guests on x86-64 hosts.

## Check versions on macOS and Linux

From the repository root, run:

```sh
./check-versions.sh
```

The shared baseline is Vagrant `2.4.9` and VirtualBox `7.2.20`. The script accepts newer patch versions within each baseline's major and minor series. A missing executable, an older patch version, or a different series returns exit code `1`. The script checks the executables on `PATH`. Update both hosts' shared baseline in `check-versions.sh`.

## Start a lab

From the lab directory, run:

```sh
vagrant up --provider=virtualbox
vagrant status
```

Each clone creates its own VMs on the host. Neo4j data, cluster state, and Vagrant keys stay local. Use `vagrant halt` to stop a VM and keep its disk. `vagrant destroy` deletes the VM and its data. If two copies of the same lab run on one host, their VirtualBox VM names may conflict. Check the existing VMs and back up any data you need before deleting a VM.

Commit VM configuration, provisioning scripts, and sample data. Keep private Neo4j imports in `neo4j/imports/`. Review `git diff --cached` for secrets and local files before committing.

## Language

Write documentation, code comments, commit messages, and script output in English.
# 3d-queue
