# =====================
# Stage 1: Builder
# =====================
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies (reproducible & cached)
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build Next.js (creates .next/standalone)
RUN npm run build


# =====================
# Stage 2: Runtime (DISTROLESS)
# =====================
FROM gcr.io/distroless/nodejs20-debian12

WORKDIR /app

# Copy ONLY the standalone output
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

ENV NODE_ENV=production
EXPOSE 3000

# Distroless already runs node internally
CMD ["server.js"]

