#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# ==========================================
# 1. CONFIGURATION VARIABLES
# ==========================================
DOMAIN="za-pharma-intel.mywire.org"
EMAIL="moganepaballo@gmail.com"
TIMEZONE="Africa/Johannesburg"

echo "=========================================="
echo "Starting n8n + Python Deployment Script"
echo "Target Domain: $DOMAIN"
echo "=========================================="

# ==========================================
# 2. UPDATE SYSTEM & INSTALL DEPENDENCIES
# ==========================================
echo "Step 1: Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl gnupg lsb-release nginx certbot python3-certbot-nginx python3-pip python3-venv

# ==========================================
# 3. INSTALL DOCKER (If not installed)
# ==========================================
if ! command -v docker &> /dev/null; then
    echo "Step 2: Installing Docker..."
    sudo curl -fsSL https://docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
else
    echo "Docker is already installed. Skipping..."
fi

# ==========================================
# 4. CONFIGURE NGINX REVERSE PROXY
# ==========================================
echo "Step 3: Configuring Nginx Reverse Proxy..."
NGINX_CONF="/etc/nginx/sites-available/default"

sudo bash -c "cat << 'EOF' > $NGINX_CONF
server {
    listen 80;
    server_name $DOMAIN;

    client_max_body_size 50M;

    location / {
        proxy_pass http://127.0.0.1:5678;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # Web socket / editor connection headers
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        
        proxy_buffering off;
        proxy_read_timeout 3600s;
    }
}
EOF"

# Test and reload Nginx
sudo nginx -t
sudo systemctl restart nginx

# ==========================================
# 5. GENERATE SSL CERTIFICATE
# ==========================================
echo "Step 4: Requesting SSL Certificate via Certbot..."
# The --non-interactive flag prevents the script from stalling for inputs
sudo certbot --nginx -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email --redirect

# ==========================================
# 6. DEPLOY SECURED N8N DOCKER CONTAINER
# ==========================================
echo "Step 5: Deploying secured n8n-python Docker container..."

# Stop and remove old container if it exists to avoid naming conflicts
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^n8n$"; then
    echo "Stopping existing n8n container..."
    sudo docker stop n8n || true
    sudo docker rm n8n || true
fi

sudo docker run -d \
 --name n8n \
 --restart always \
 -p 127.0.0.1:5678:5678 \
 -e N8N_HOST="$DOMAIN" \
 -e N8N_PROTOCOL="https" \
 -e NODE_ENV="production" \
 -e WEBHOOK_URL="https://$DOMAIN" \
 -e GENERIC_TIMEZONE="$TIMEZONE" \
 -e TZ="$TIMEZONE" \
 -e N8N_BLOCK_ENV_ACCESS_IN_PYTHON=false \
 -e N8N_PYTHON_PATH="/usr/bin/python3" \
 -v n8n_data:/home/node/.n8n \
 naskio/n8n-python:latest

echo "=========================================="
echo "Deployment successful!"
echo "Your n8n instance is live at: https://$DOMAIN"
echo "=========================================="
