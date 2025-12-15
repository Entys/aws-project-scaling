#!/bin/bash
set -euo pipefail  # Fail fast

echo "Installing application..."

sudo apt-get update
sudo apt-get install -y python3-pip nginx git

sudo mkdir -p /opt/app
sudo cp -r aws-project-scaling/app/* /opt/app/

cd /opt/app
sudo pip3 install --break-system-packages --ignore-installed -r /opt/app/requirements.txt

sudo cp /opt/app/nginx.conf /etc/nginx/sites-available/app
sudo ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl restart nginx

sudo cp /opt/app/app.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable app
sudo systemctl enable nginx

# Start services (juste pour tester, pas besoin en AMI)
# sudo systemctl start app
# sudo systemctl start nginx

echo "Application installed successfully!"