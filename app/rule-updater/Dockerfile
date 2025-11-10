FROM node:24-alpine
RUN apk add --no-cache curl \
 && corepack enable
WORKDIR /app

# Install prod deps
COPY package.json ./
RUN corepack prepare pnpm@10.20.0 --activate \
 && pnpm install --prod --no-optional

# App code
COPY . .

EXPOSE 3000

# Healthcheck with curl (faster + present)
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD \
  curl -fsS http://127.0.0.1:3000/shadowrocket >/dev/null || exit 1

CMD ["pnpm", "start"]