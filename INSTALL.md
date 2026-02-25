# Installation Guide — DSA Elements Summons PWA

This document explains how to set up, run, and deploy the **DSA Elements Summons** Progressive Web App (PWA).

The PWA is built with **React + TypeScript + Vite** and lives in the `pwa/` directory.
The server infrastructure (nginx, Docker, Caddy HTTPS) lives in the `server/` directory.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Local Development](#2-local-development)
3. [Production with Docker (HTTP)](#3-production-with-docker-http)
4. [Production with HTTPS (Let's Encrypt via Caddy)](#4-production-with-https-lets-encrypt-via-caddy)
5. [Manual Deployment (no Docker)](#5-manual-deployment-no-docker)
6. [VPS / Cloud Deployment](#6-vps--cloud-deployment)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Prerequisites

### Node.js 20+

Required for local development and building the app manually.

| Platform | Download / Install |
|---|---|
| **Windows** | https://nodejs.org/en/download (LTS installer) or `winget install OpenJS.NodeJS.LTS` |
| **macOS** | `brew install node@20` or https://nodejs.org/en/download |
| **Linux (Debian/Ubuntu)** | `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs` |
| **Linux (all distros via nvm)** | `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && nvm install 20` |

Verify: `node --version` should print `v20.x.x` or higher.

### Docker + Docker Compose

Required for containerised deployments.

| Platform | Download / Install |
|---|---|
| **Windows** | [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) |
| **macOS** | [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/) |
| **Linux** | [Docker Engine](https://docs.docker.com/engine/install/) + [Compose plugin](https://docs.docker.com/compose/install/linux/) |

Verify:
```bash
docker --version        # Docker version 25+
docker compose version  # Docker Compose version v2.x
```

### Git

```bash
# Windows (if not already installed)
winget install Git.Git

# macOS
brew install git

# Debian / Ubuntu
sudo apt-get install git
```

---

## 2. Local Development

```bash
# 1. Clone the repository
git clone https://github.com/your-org/DSA_Elements_Summons_PWA.git
cd DSA_Elements_Summons_PWA

# 2. Enter the PWA directory
cd pwa

# 3. Install dependencies
npm install

# 4. Start the development server
npm run dev
```

The dev server will be available at **http://localhost:5173** (default Vite port).
Hot Module Replacement (HMR) is enabled — changes to source files reload the browser instantly.

> Service workers are intentionally disabled in development mode by `vite-plugin-pwa`.
> They are enabled automatically in the production build.

### Useful development commands

```bash
# Inside pwa/

npm run dev       # Start dev server with HMR
npm run build     # Production build → pwa/dist/
npm run preview   # Preview the production build locally (http://localhost:4173)
npm run lint      # Run ESLint
npm run type-check # Run TypeScript type checker without emitting files
```

---

## 3. Production with Docker (HTTP)

This runs nginx inside Docker and serves the app on port **8080** of the host.
Suitable for local testing of the production build or LAN deployments.

```bash
# From the repository root
docker compose -f server/docker-compose.yml up -d
```

The PWA is now available at **http://localhost:8080**.

### Rebuild after source changes

```bash
docker compose -f server/docker-compose.yml up --build -d
```

### Stop and remove

```bash
docker compose -f server/docker-compose.yml down
```

> **Note:** Service workers require HTTPS in all browsers except `localhost`.
> For a fully functional PWA (install prompt, offline support) you must use HTTPS — see section 4.

---

## 4. Production with HTTPS (Let's Encrypt via Caddy)

This setup adds **Caddy** as a reverse proxy in front of nginx.
Caddy automatically obtains and renews a free TLS certificate from Let's Encrypt.

### Requirements

- A public server with ports **80** and **443** open.
- A domain name with an **A record** pointing to your server's IP address.

### Steps

```bash
# 1. Set environment variables
export DOMAIN=dsa-pwa.example.com    # your actual domain
export ACME_EMAIL=you@example.com    # Let's Encrypt notification email

# 2. Start the production stack
docker compose \
  -f server/docker-compose.yml \
  -f server/docker-compose.prod.yml \
  up -d
```

Or use the deployment helper script:

```bash
# Make the script executable (once)
chmod +x server/scripts/deploy.sh

DOMAIN=dsa-pwa.example.com \
ACME_EMAIL=you@example.com \
./server/scripts/deploy.sh --prod
```

Caddy handles the ACME challenge automatically.
Within ~30 seconds the PWA will be available at **https://dsa-pwa.example.com**.

### Using a .env file (recommended for servers)

Create `server/.env` (do **not** commit this file):

```dotenv
DOMAIN=dsa-pwa.example.com
ACME_EMAIL=you@example.com
```

Then run:

```bash
docker compose \
  --env-file server/.env \
  -f server/docker-compose.yml \
  -f server/docker-compose.prod.yml \
  up -d
```

### Stop the production stack

```bash
docker compose \
  -f server/docker-compose.yml \
  -f server/docker-compose.prod.yml \
  down
```

---

## 5. Manual Deployment (no Docker)

Use this approach if you have a web server already running and want to deploy the static files directly.

### Step 1 — Build the app

```bash
cd pwa
npm install
npm run build
# Output is in pwa/dist/
```

### Step 2 — Copy dist/ to your web server

```bash
# Example: rsync to a remote server
rsync -avz --delete pwa/dist/ user@your-server:/var/www/dsa-pwa/

# Or copy locally
cp -r pwa/dist/* /var/www/html/dsa-pwa/
```

### Step 3 — Apply nginx configuration

Copy `server/nginx/nginx.conf` to your nginx configuration directory and adjust the `root` directive to point at your document root:

```nginx
root /var/www/dsa-pwa;
```

```bash
# Ubuntu / Debian
sudo cp server/nginx/nginx.conf /etc/nginx/sites-available/dsa-pwa
sudo ln -s /etc/nginx/sites-available/dsa-pwa /etc/nginx/sites-enabled/dsa-pwa
sudo nginx -t            # Test config
sudo systemctl reload nginx
```

### Step 4 — Obtain HTTPS certificate (certbot)

```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d dsa-pwa.example.com --email you@example.com --agree-tos
```

Certbot auto-renews the certificate via a systemd timer or cron job.

---

## 6. VPS / Cloud Deployment

The Docker approach (section 3 or 4) works on any Linux VPS.
Below are quick-start notes for the most common providers.

### DigitalOcean Droplet

1. Create a **Ubuntu 22.04** Droplet (Basic, 1 vCPU / 1 GB RAM is enough).
2. Open firewall ports 22, 80, 443 in the Droplet's Networking settings.
3. SSH in and install Docker:
   ```bash
   curl -fsSL https://get.docker.com | sh
   sudo usermod -aG docker $USER && newgrp docker
   ```
4. Clone the repo and follow section 4.

DigitalOcean Marketplace also offers a **Docker one-click Droplet** that ships Docker pre-installed.

### AWS EC2

1. Launch an **Amazon Linux 2023** or **Ubuntu 22.04** instance (t3.micro free tier).
2. In the Security Group, allow inbound TCP on ports **22**, **80**, **443**.
3. Install Docker:
   ```bash
   # Amazon Linux 2023
   sudo dnf install docker -y
   sudo systemctl enable --now docker
   sudo usermod -aG docker ec2-user && newgrp docker

   # Ubuntu
   curl -fsSL https://get.docker.com | sh
   sudo usermod -aG docker ubuntu && newgrp docker
   ```
4. Allocate an **Elastic IP** and point your domain's A record to it.
5. Clone the repo and follow section 4.

### Hetzner Cloud

1. Create a **CX11** server (Ubuntu 22.04, cheapest tier, ~4 EUR/month).
2. In Hetzner Cloud Firewall, allow TCP 22, 80, 443.
3. SSH in as root:
   ```bash
   curl -fsSL https://get.docker.com | sh
   ```
4. Point your domain's A record to the server IP.
5. Clone the repo and follow section 4.

### General tips for any cloud provider

- Always use a firewall / security group — only expose ports 22, 80, 443.
- Set up SSH key authentication; disable password login.
- Consider a swap file if RAM is 1 GB: `fallocate -l 1G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile`.
- Monitor disk space — Docker build cache can grow large. Run `docker system prune` periodically.

---

## 7. Troubleshooting

### The PWA install prompt does not appear

- Ensure you are accessing the site over **HTTPS** (not HTTP, except localhost).
- Open DevTools → Application → Service Workers and check for registration errors.
- Verify `sw.js` is being served with `Cache-Control: no-cache` (check Network tab).

### nginx returns 404 on page refresh

- The SPA fallback is configured in `server/nginx/nginx.conf` with `try_files $uri $uri/ /index.html`.
- If you are using a custom nginx config, make sure this directive is present in the `location /` block.

### Docker build fails on npm ci

- Ensure `pwa/package-lock.json` is committed and up to date.
- Run `npm install` locally in `pwa/`, then commit the updated `package-lock.json`.

### Caddy cannot obtain a certificate

- Verify your domain's DNS A record resolves to the server IP: `dig +short dsa-pwa.example.com`.
- Ports 80 and 443 must be open and not blocked by a firewall.
- Check Caddy logs: `docker compose -f server/docker-compose.yml -f server/docker-compose.prod.yml logs caddy`.

### Container crashes immediately

```bash
# View logs
docker compose -f server/docker-compose.yml logs pwa

# Enter a running container for inspection
docker compose -f server/docker-compose.yml exec pwa sh
```
