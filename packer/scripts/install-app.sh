#!/bin/bash
set -euo pipefail

echo "Installing application..."

echo "Installing system packages..."
sudo apt-get update
sudo apt-get install -y python3-pip python3-requests nginx git

echo "Setting up application directory..."
sudo mkdir -p /opt/app
sudo cp -r /tmp/packer-app/* /opt/app/
sudo chown -R admin:admin /opt/app

echo "Installing Python dependencies..."
sudo pip3 install --break-system-packages --ignore-installed -r /opt/app/requirements.txt

echo "Configuring nginx..."
sudo cp /opt/app/nginx.conf /etc/nginx/sites-available/app
sudo ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t

echo "Configuring systemd service..."
sudo cp /opt/app/app.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable app
sudo systemctl enable nginx

sudo systemctl reload nginx

echo "Application installed successfully!"