#!/usr/bin/env zsh
set -e
set -o NO_NOMATCH  # Prevent "no matches found" errors on wildcard patterns

echo "🔎 Detecting Linux distribution..."
source /etc/os-release

case "$ID" in
  amzn)
    if [[ "$VERSION_ID" =~ '^2' ]]; then
      OS="amzn2"
    else
      OS="amzn2023"
    fi
    ;;
  centos)
    if [[ "$VERSION_ID" =~ '^8' ]]; then
      OS="centos8"
    elif [[ "$VERSION_ID" =~ '^9' ]]; then
      OS="centos9"
    else
      echo "❌ Unsupported CentOS version: $VERSION_ID"
      exit 1
    fi
    ;;
  *)
    echo "❌ Unsupported distro: $ID"
    exit 1
    ;;
esac

echo "📦 Installing Docker..."

if [[ "$OS" == "amzn2" ]]; then
  sudo yum update -y
  sudo amazon-linux-extras install docker -y

elif [[ "$OS" == "amzn2023" ]]; then
  sudo dnf update -y
  sudo dnf install docker -y

elif [[ "$OS" == "centos8" ]]; then
  sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io

elif [[ "$OS" == "centos9" ]]; then
  sudo dnf config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io --allowerasing
fi

echo "🔧 Enabling Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "👤 Adding current user to docker group..."
sudo usermod -aG docker "$USER"

echo "⬇️ Fetching latest Docker Compose v2 version..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)

echo "📥 Installing Docker Compose v2 ($DOCKER_COMPOSE_VERSION)..."
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo "✅ Verifying installation..."
docker --version
docker-compose --version

echo ""
echo "🎉 Docker & Docker Compose installed successfully!"
echo "⚠️ Run 'newgrp docker' or log out/in for group permissions to apply."