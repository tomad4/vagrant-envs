# vagrant-envs

| Projekt | Co uruchamia | Zasoby gości |
| --- | --- | --- |
| [Neo4j](neo4j/README.md) | Ubuntu 24.04, Docker i Neo4j Community 5.26 z przykładowym grafem | 2 vCPU, 4 GB RAM |
| [CKAD](ckad/README.md) | Ubuntu 24.04, Kubernetes 1.36.1 z kubeadm i Cilium | 2 VM po 2 vCPU i 4 GB RAM |

Na każdym hoście zainstaluj Vagrant (konfiguracje sprawdzono składniowo z 2.4.9) i VirtualBox w wersji obsługującej architekturę hosta. Projekty używają obrazu Bento Ubuntu 24.04 w wersji `202510.26.0`. Do pobrania obrazu i pakietów potrzebny jest internet. Konfiguracje przewidują gości ARM64 na Apple Silicon i AMD64 na komputerach x86-64.

Wejdź do katalogu wybranego projektu i uruchom:

```sh
vagrant up --provider=virtualbox
vagrant status
```

Każdy klon tworzy na danym hoście własne VM. Dane Neo4j, stan klastra i klucze Vagranta pozostają lokalne. `vagrant halt` zatrzymuje VM i zachowuje jej dysk. `vagrant destroy` usuwa VM wraz z jej danymi. Jeśli stary i nowy katalog działają na tym samym hoście, VirtualBox może zgłosić zajętą nazwę VM. Najpierw sprawdź stan istniejących VM i zabezpiecz dane, zanim usuniesz którąkolwiek z nich.

Do repozytorium dodawaj konfigurację VM, skrypty provisioningu i przykładowe dane. Własne pliki do importu Neo4j trzymaj w `neo4j/imports/`. Przed commitem sprawdź `git diff --cached` pod kątem sekretów i plików lokalnych.
