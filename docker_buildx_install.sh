rm -f ~/.docker/cli-plugins/docker-buildx
mkdir -p ~/.docker/cli-plugins

# Pick latest tag
TAG=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep tag_name | cut -d'"' -f4)

# Map arch names
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
esac

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
URL="https://github.com/docker/buildx/releases/download/${TAG}/buildx-${TAG}.${OS}-${ARCH}"

# Download to the standard plugin location
curl -fSL "$URL" -o ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx

# Verify
docker buildx version
