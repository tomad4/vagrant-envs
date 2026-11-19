# Grafana plugin lab on K3s

This lab runs a single Ubuntu VM with K3s and Grafana OSS 13.3.1. It uses 2 vCPUs and 4 GB RAM. K3s provides local storage and a NodePort. Grafana uses SQLite on a persistent volume. The plugin deployment uses node-local container images, so a registry is optional for future multi-node setups.

## 1. Start K3s

Install Git, Vagrant, and VirtualBox on macOS or Linux. Run `../check-versions.sh` from this directory to check the shared version baseline.

Grafana always binds to `192.168.0.80:3000` on the host. Before starting the VM, make sure this IP is free on your LAN and assign it as a secondary address on the active host. Use the address on only one host at a time.

```sh
# macOS example for en0 on a /24 LAN
sudo ifconfig en0 inet 192.168.0.80 netmask 255.255.255.0 alias

# Linux example for enp3s0 on a /24 LAN
sudo ip address add 192.168.0.80/24 dev enp3s0
```

Use the appropriate interface and subnet mask for your host. These commands configure a temporary address. To keep the address after a reboot, configure it in the host's network settings. If the VM is already up, run `vagrant reload` after adding the address to apply the forwarding rule.

```sh
vagrant up --provider=virtualbox
vagrant ssh -c 'sudo k3s kubectl get nodes -o wide'
```

Vagrant installs K3s `v1.35.9+k3s1` and applies the Grafana manifests during provisioning. The guest and host need internet access to download the box, binaries, and images.

## 2. Open Grafana

Open <http://192.168.0.80:3000>. Sign in as `admin` and retrieve the initial password locally:

```sh
vagrant ssh -c 'sudo k3s kubectl -n grafana get secret grafana-admin -o jsonpath="{.data.password}" | base64 -d; echo'
```

The host firewall must allow TCP port 3000 on the LAN. Grafana serves plain HTTP on this development network. Vagrant forwards SSH only on loopback. To check the Grafana deployment from the VM:

```sh
vagrant ssh -c 'sudo k3s kubectl -n grafana get deployment,pods,svc,pvc'
```

## 3. Set up the plugin toolchain

Start a Docker daemon on the development host, such as Docker Desktop on macOS or Docker Engine on Linux. The Docker build runs Node.js 24 in a build stage and copies the plugin bundle into the Grafana image. Git and Docker run on the host. The guest uses K3s containerd to run Grafana.

The example is a frontend panel with zero npm dependencies. To check the bundle locally with Node.js 24:

```sh
cd plugin
node build.mjs
cd ..
```

For a full TypeScript project, scaffold a panel with `npx @grafana/create-plugin@latest`, install dependencies from its lockfile, and use its bundle as the Docker build output. Add Go and Mage when developing a backend plugin. Build the backend executable for Linux on each target architecture using the scaffold's Mage targets and include it in the bundle.

## 4. Deploy and update Hello World

From this directory, run:

```sh
./deploy-plugin.sh
```

The script builds from the current Git commit, targets the VM's architecture, imports the image into K3s, and waits for the Grafana Deployment rollout. Grafana allows the unsigned `tomad4-hello-panel` plugin in this lab. The image also provisions the **Plugin Lab** dashboard. Open <http://192.168.0.80:3000/d/plugin-hello/plugin-lab>.

To exercise an update, change the greeting in `plugin/module.js`, then commit and deploy:

```sh
git add plugin/module.js
git commit -m "Update the Hello World panel greeting"
./deploy-plugin.sh
```

Refresh the dashboard to see the new greeting. To undo that rollout:

```sh
vagrant ssh -c 'sudo k3s kubectl -n grafana rollout undo deployment/grafana &&
  sudo k3s kubectl -n grafana rollout status deployment/grafana --timeout=300s'
```

Grafana briefly restarts on each update because the Deployment uses `Recreate` with a single SQLite volume. Rollback needs the previous image to remain in node-local containerd. `vagrant halt` preserves the cluster and Grafana data. `vagrant destroy` removes both.
