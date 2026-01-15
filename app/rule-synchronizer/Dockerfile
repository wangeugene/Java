FROM node:24-alpine

# Minimal tooling; Corepack provides pnpm
RUN apk add --no-cache curl \
  && corepack enable

WORKDIR /app

# Install dependencies first (better layer caching)
# Copy lockfile(s) for reproducible installs
COPY package.json pnpm-lock.yaml* .npmrc* ./

RUN corepack prepare pnpm@10.20.0 --activate \
  && pnpm install --prod --frozen-lockfile --no-optional

# App code
COPY . .

# Run as non-root
USER node

# Default to production start; override with `pnpm schedule` if desired
CMD ["pnpm", "start"]