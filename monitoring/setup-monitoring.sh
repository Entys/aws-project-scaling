#!/bin/bash
set -e

yum update -y
yum install -y git docker

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

systemctl enable docker
systemctl start docker

# Attendre que Docker soit prêt
sleep 10

git clone https://github.com/Oreo81/aws-project-scaling.git /opt/aws-project-scaling

chown -R ec2-user:ec2-user /opt/aws-project-scaling

# FIX PERMISSIONS GRAFANA
mkdir -p /opt/aws-project-scaling/monitoring/grafana/data
chown -R 472:472 /opt/aws-project-scaling/monitoring/grafana/data
chmod -R 775 /opt/aws-project-scaling/monitoring/grafana/data

cd /opt/aws-project-scaling/monitoring
docker-compose up -d
