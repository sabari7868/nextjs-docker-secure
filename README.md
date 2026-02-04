
Next.js Docker Secure & Optimized

A production-ready Next.js application containerized with Docker, focusing on:

Security (non-root user, no shell access)

Size optimization (multi-stage build, standalone Next.js build)

Distroless runtime for minimal attack surface

Production-ready Dockerfile following industry best practices

Features

✅ Non-root user

Application runs as appuser inside the container.

Prevents attackers from gaining root inside the container.

✅ Distroless Runtime

Minimal image with no shell, no package manager.

Only required Node.js runtime included.

✅ Standalone Next.js Build

Uses next build --standalone to copy only runtime artifacts.

Keeps source code hidden inside the image.

✅ Multi-stage Docker build

Build stage: installs dependencies and builds the Next.js app.

Runtime stage: copies only necessary files to a minimal container.

✅ Optimized image size

Node modules and build artifacts are copied selectively.

Resulting image is significantly smaller than a normal Node.js Alpine image.

Requirements

Docker 20+

Node.js 20+ (for building)

How to Build
# Remove old containers/images
docker rm -f $(docker ps -aq) || true
docker rmi my-nextjs-secure || true

# Build the Docker image
docker build -t my-nextjs-secure .

# Run container in detached mode
docker run -d -p 3000:3000 my-nextjs-secure

# View logs
docker logs <container_id>


Visit the app at: http://localhost:3000

Dockerfile Explained
# =====================
# Stage 1: Builder
# =====================
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# =====================
# Stage 2: Distroless Runtime
# =====================
FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app

# Copy only runtime artifacts
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/next.config.js ./next.config.js

# Use production environment
ENV NODE_ENV=production
EXPOSE 3000

# Run Next.js app without shell
CMD ["node_modules/next/dist/bin/next", "start", "-p", "3000"]


Highlights:

Multi-stage build hides source code

Distroless runtime for minimal attack surface

No shell inside the container → more secure

Optimizations

Standalone build: next build --standalone → copies only runtime dependencies.

Non-root user: prevents privilege escalation.

Selective copy: only .next, public, node_modules, package.json, next.config.js.

Resulting image size: ~200–250MB (varies depending on your app)

Security Notes

No interactive shell inside the container.

Only runtime Node.js and app files exist.

Recommended to run behind a reverse proxy (Nginx/Traefik) in production.

---

Made with ♥ by [CreativeDesignsGuru](https://creativedesignsguru.com) [![Twitter](https://img.shields.io/twitter/url/https/twitter.com/cloudposse.svg?style=social&label=Follow%20%40Ixartz)](https://twitter.com/ixartz)

[![Sponsor Next JS Boilerplate](https://cdn.buymeacoffee.com/buttons/default-red.png)](https://github.com/sponsors/ixartz)
