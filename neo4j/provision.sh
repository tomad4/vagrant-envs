#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

if [[ -z "${NEO4J_PASSWORD:-}" ]]; then
  echo "NEO4J_PASSWORD must not be empty" >&2
  exit 1
fi

install -d -m 0700 /etc/neo4j-lab
printf '%s' "$NEO4J_PASSWORD" > /etc/neo4j-lab/password
chmod 0600 /etc/neo4j-lab/password

apt-get update
apt-get install -y docker.io
systemctl enable --now docker

# Keep database files in a Docker-managed volume so they survive VM reprovisioning.
docker volume create neo4j_data >/dev/null
if docker container inspect neo4j >/dev/null 2>&1; then
  docker rm -f neo4j >/dev/null
fi

docker run -d \
  --name neo4j \
  --restart unless-stopped \
  --publish 0.0.0.0:7474:7474 \
  --publish 0.0.0.0:7687:7687 \
  --volume neo4j_data:/data \
  --volume /vagrant:/vagrant:ro \
  --env "NEO4J_AUTH=neo4j/${NEO4J_PASSWORD}" \
  --env NEO4J_server_default__listen__address=0.0.0.0 \
  --env NEO4J_server_http_listen__address=0.0.0.0 \
  --env NEO4J_server_bolt_listen__address=0.0.0.0 \
  neo4j:5.26-community

# Wait for Bolt to accept connections before importing the example graph.
for attempt in $(seq 1 60); do
  if docker exec neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" 'RETURN 1' >/dev/null 2>&1; then
    break
  fi
  if [[ "$attempt" -eq 60 ]]; then
    docker logs neo4j >&2
    echo "Neo4j did not become ready in time" >&2
    exit 1
  fi
  sleep 2
done

NEO4J_PASSWORD="$NEO4J_PASSWORD" /vagrant/import.sh
