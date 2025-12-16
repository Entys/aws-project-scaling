#!/bin/bash
set -e

# Mettre à jour et installer les dépendances de base sauf curl
yum update -y
yum install -y git docker || true

# Docker
systemctl enable docker
systemctl start docker

# Docker Compose (sans yum)
if ! command -v docker-compose &> /dev/null
then
  curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
    -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

################################
# Clone projet
################################
git clone https://github.com/Oreo81/aws-project-scaling.git /opt/aws-project-scaling

chown -R ec2-user:ec2-user /opt/aws-project-scaling

################################
# FIX permissions Grafana
################################
mkdir -p /opt/aws-project-scaling/monitoring/grafana/data
chown -R 472:472 /opt/aws-project-scaling/monitoring/grafana/data
chmod -R 775 /opt/aws-project-scaling/monitoring/grafana/data

################################
# Lancer monitoring stack
################################
cd /opt/aws-project-scaling/monitoring
docker-compose up -d