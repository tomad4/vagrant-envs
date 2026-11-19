# CKAD on Vagrant

This lab runs Kubernetes 1.36.1 for CKAD practice. Provisioning installs containerd and Cilium and configures two nodes on a private VirtualBox network.

| VM | Role | Address |
| --- | --- | --- |
| `k8s-cp` | Control plane | `192.168.56.10` |
| `k8s-worker` | Worker | `192.168.56.11` |

Each VM has 2 vCPUs and 4 GB of RAM. The control plane requires a root filesystem of at least 20 GiB. The first run downloads the pinned Kubernetes packages and the Cilium CLI.

From this directory, run:

```sh
vagrant up --provider=virtualbox
vagrant ssh k8s-cp -c 'kubectl get nodes -o wide'
vagrant ssh k8s-cp -c 'kubectl apply -f /vagrant/basic.yaml -f /vagrant/basicservice.yaml'
```

Both nodes should reach `Ready`. If the worker is waiting to join, check whether control-plane provisioning completed `kubeadm init`. Provisioning generates `join-command.sh`, which contains a join token and is ignored by Git.

[CKAD practice topics](CKAD-scope.md)
