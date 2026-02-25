# =============================================================================
# Dockerfile — DSA Elements Summons PWA
#
# Multi-stage build:
#   Stage 1 (builder) : Install deps and build the Vite/React app
#   Stage 2 (runtime) : Serve the static output with nginx:alpine
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1 — Builder
# -----------------------------------------------------------------------------
FROM node:20-alpine AS builder

# Install build tools that some native Node modules may need
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files first so Docker can cache the npm ci layer
COPY pwa/package.json pwa/package-lock.json ./

# Install all dependencies (including devDependencies needed for the build)
RUN npm ci --ignore-scripts

# Copy the rest of the PWA source
COPY pwa/ ./

# Build the production bundle (output goes to ./dist by default in Vite)
RUN npm run build

# -----------------------------------------------------------------------------
# Stage 2 — Runtime (nginx)
# -----------------------------------------------------------------------------
FROM nginx:1.27-alpine AS runtime

# Remove the default nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy compiled assets from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy our custom nginx configuration
COPY server/nginx/nginx.conf /etc/nginx/nginx.conf

# Expose HTTP port
EXPOSE 80

# Lightweight health check — nginx responds with 200 on /healthz
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://localhost/healthz || exit 1

# nginx runs in the foreground by default in the official image
CMD ["nginx", "-g", "daemon off;"]
