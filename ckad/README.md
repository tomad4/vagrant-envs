# CKAD na Vagrancie

Lab do ćwiczeń z Kubernetes 1.36.1. Provisioning instaluje containerd i Cilium oraz konfiguruje dwa węzły połączone przez sieć prywatną VirtualBox.

| VM | Rola | Adres |
| --- | --- | --- |
| `k8s-cp` | Control plane | `192.168.56.10` |
| `k8s-worker` | Worker | `192.168.56.11` |

Każda VM ma 2 vCPU i 4 GB RAM. Control plane wymaga co najmniej 20 GiB przestrzeni na partycji root. Pierwsze uruchomienie pobiera pakiety Kubernetes w przypiętej wersji oraz CLI Cilium.

Z tego katalogu uruchom:

```sh
vagrant up --provider=virtualbox
vagrant ssh k8s-cp -c 'kubectl get nodes -o wide'
vagrant ssh k8s-cp -c 'kubectl apply -f /vagrant/basic.yaml -f /vagrant/basicservice.yaml'
```

Oba węzły powinny osiągnąć stan `Ready`. Jeśli worker czeka na dołączenie, sprawdź, czy provisioning control plane przeszedł etap `kubeadm init`. Skrypt `join-command.sh` zawiera wygenerowany token, jest tworzony automatycznie i ignorowany przez Git.

[Zakres ćwiczeń CKAD](CKAD-scope.md)
