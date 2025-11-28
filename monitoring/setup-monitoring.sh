#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

# Vérifier Docker & docker-compose
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker non trouvé. Installation requise."
  exit 1
fi

# Créer les dossiers si manquants
mkdir -p prometheus grafana/provisioning/datasources grafana/provisioning/dashboards grafana/dashboards

# Lancer docker-compose
docker compose up -d

echo "Prometheus (9090) et Grafana (3000) démarrés."
echo "Accède à Grafana : http://<IP_PROMETHEUS>:3000 (admin/admin par défaut)"
