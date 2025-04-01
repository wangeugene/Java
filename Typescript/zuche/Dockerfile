# Use Node.js LTS version as base image
FROM node:20-alpine

# Install pnpm
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy pnpm lock and package files
COPY pnpm-lock.yaml package.json ./

# Install dependencies
RUN pnpm install 

# Copy source code
COPY . .

# Build TypeScript code
RUN  pnpm run build 

# Debugging the output
RUN ls -la dist

# Expose any necessary ports (if your app has an HTTP server)
# EXPOSE 3000

# Run the application
CMD ["node", "dist/index.js"]