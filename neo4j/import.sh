#!/usr/bin/env bash
set -euo pipefail

IMPORT_FILE="${1:-/vagrant/sample.cypher}"
if [[ "$IMPORT_FILE" != /* ]]; then
  IMPORT_FILE="/vagrant/$IMPORT_FILE"
fi
if [[ ! -f "$IMPORT_FILE" ]]; then
  echo "Import file not found: $IMPORT_FILE" >&2
  echo "Pass a file from the shared /vagrant directory, for example: /vagrant/import.sh my-data.cypher" >&2
  exit 1
fi

if [[ -z "${NEO4J_PASSWORD:-}" ]]; then
  NEO4J_PASSWORD="$(sudo cat /etc/neo4j-lab/password 2>/dev/null || true)"
fi
if [[ -z "$NEO4J_PASSWORD" ]]; then
  echo "Could not read the saved Neo4j password; set NEO4J_PASSWORD explicitly" >&2
  exit 1
fi

if ! docker container inspect neo4j >/dev/null 2>&1; then
  echo "Neo4j container is not running; start the VM with 'vagrant up' first" >&2
  exit 1
fi

docker exec neo4j cypher-shell \
  -u neo4j \
  -p "$NEO4J_PASSWORD" \
  --file "$IMPORT_FILE"
