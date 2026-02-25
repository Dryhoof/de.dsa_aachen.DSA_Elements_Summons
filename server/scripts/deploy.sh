#!/usr/bin/env bash
# =============================================================================
# deploy.sh — Build and run the DSA Elements Summons PWA Docker container
#
# Usage (from repository root or any directory):
#   ./server/scripts/deploy.sh [OPTIONS]
#
# Options:
#   --prod          Deploy with Caddy HTTPS (requires DOMAIN + ACME_EMAIL env vars)
#   --no-cache      Force a full rebuild without using Docker layer cache
#   --pull          Pull newer base images before building
#   --port PORT     Override the host port in non-prod mode (default: 8080)
#   --tag  TAG      Docker image tag to use (default: latest)
#   -h, --help      Show this help message
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SERVER_DIR="${REPO_ROOT}/server"

IMAGE_NAME="dsa-elements-summons-pwa"
IMAGE_TAG="latest"
HOST_PORT="8080"
PROD_MODE=false
NO_CACHE=""
PULL_FLAG=""

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --prod)
            PROD_MODE=true
            shift
            ;;
        --no-cache)
            NO_CACHE="--no-cache"
            shift
            ;;
        --pull)
            PULL_FLAG="--pull"
            shift
            ;;
        --port)
            HOST_PORT="${2:?--port requires a value}"
            shift 2
            ;;
        --tag)
            IMAGE_TAG="${2:?--tag requires a value}"
            shift 2
            ;;
        -h|--help)
            sed -n '2,20p' "$0"   # Print the usage block at the top of this file
            exit 0
            ;;
        *)
            echo "[ERROR] Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }
err()  { echo "[ERROR] $*" >&2; exit 1; }

require_cmd() {
    command -v "$1" &>/dev/null || err "'$1' is not installed or not in PATH."
}

# ---------------------------------------------------------------------------
# Pre-flight checks
# ---------------------------------------------------------------------------
require_cmd docker

if ! docker compose version &>/dev/null 2>&1; then
    err "Docker Compose v2 is required. Please install it: https://docs.docker.com/compose/install/"
fi

if [[ "${PROD_MODE}" == "true" ]]; then
    [[ -n "${DOMAIN:-}" ]]     || err "DOMAIN environment variable must be set for production deployment."
    [[ -n "${ACME_EMAIL:-}" ]] || err "ACME_EMAIL environment variable must be set for production deployment."
fi

# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------
log "Building Docker image '${IMAGE_NAME}:${IMAGE_TAG}'..."

docker build \
    ${NO_CACHE} \
    ${PULL_FLAG} \
    --tag "${IMAGE_NAME}:${IMAGE_TAG}" \
    --file "${SERVER_DIR}/Dockerfile" \
    "${REPO_ROOT}"

log "Image built successfully: ${IMAGE_NAME}:${IMAGE_TAG}"

# ---------------------------------------------------------------------------
# Deploy
# ---------------------------------------------------------------------------
if [[ "${PROD_MODE}" == "true" ]]; then
    log "Starting PRODUCTION stack with Caddy HTTPS (domain: ${DOMAIN})..."

    docker compose \
        -f "${SERVER_DIR}/docker-compose.yml" \
        -f "${SERVER_DIR}/docker-compose.prod.yml" \
        up -d --remove-orphans

    log "Production stack started."
    log "Caddy is obtaining a Let's Encrypt certificate for ${DOMAIN}."
    log "The PWA will be available at: https://${DOMAIN}"

else
    log "Starting DEVELOPMENT stack on port ${HOST_PORT}..."

    # Temporarily override the host port via environment variable
    HOST_PORT="${HOST_PORT}" docker compose \
        -f "${SERVER_DIR}/docker-compose.yml" \
        up -d --remove-orphans

    log "Development stack started."
    log "The PWA is available at: http://localhost:${HOST_PORT}"
    log ""
    log "NOTE: Service workers require HTTPS in production."
    log "      Use --prod for a deployment with automatic HTTPS."
fi

# ---------------------------------------------------------------------------
# Status
# ---------------------------------------------------------------------------
log ""
log "Running containers:"
docker compose -f "${SERVER_DIR}/docker-compose.yml" ps
