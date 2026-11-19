# Neo4j on Vagrant

This folder contains an isolated Ubuntu VM running Neo4j Community in Docker. The example graph in `sample.cypher` contains 10 nodes and 20 relationships and is imported during provisioning. The file also shows a repeatable `MERGE`-based import pattern.

## Start

From this folder, run:

```sh
vagrant up --provider=virtualbox
```

Neo4j listens on its standard ports inside the VM: HTTP `7474` and Bolt `7687`. Open <http://localhost:7474> and connect drivers to `bolt://localhost:7687`.

Default credentials: `neo4j` / `neo4jpassword`. Set a different password when starting the VM:

```sh
NEO4J_PASSWORD='your-password' vagrant up --provider=virtualbox
```

To reload the sample graph after editing `sample.cypher`:

```sh
vagrant ssh -c 'sudo /vagrant/import.sh'
```

The import script accepts a file name from the shared project folder, so you can keep private `.cypher` files in the Git-ignored `imports/` directory and run one in a single host command:

```sh
vagrant ssh -c 'sudo /vagrant/import.sh /vagrant/imports/my-data.cypher'
```

You can also pass just the file name (`imports/my-data.cypher`); the script looks for it under `/vagrant`. To use it interactively, run `sudo /vagrant/import.sh imports/my-data.cypher` after `vagrant ssh`.

The database files live in a Docker volume in the VM and survive reprovisioning. `vagrant destroy` removes the VM and that volume.

## Useful commands

```sh
vagrant ssh
vagrant halt
vagrant destroy
```
## Host-specific port checks

If Vagrant reports that loopback ports are in use even though they are free, run `VAGRANT_SKIP_LOOPBACK_PORT_CHECK=1 vagrant up --provider=virtualbox`. VirtualBox still rejects a real port bind conflict. When Vagrant auto-corrects a forwarded port, check the actual mapping with `vagrant port`.

Choose the database password when provisioning a fresh VM. If you reprovision a VM with an existing data volume, use the password already set in that database.
