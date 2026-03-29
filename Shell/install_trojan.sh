#!/usr/bin/env bash
set -Eeuo pipefail

# Usage example:
# sudo DOMAIN=vultr.309906615.xyz \
#   TROJAN_PASSWORD='<YOUR_PASSWORD>' \
#   CERT_PATH='/etc/letsencrypt/live/vultr.309906615.xyz/fullchain.pem' \
#   KEY_PATH='/etc/letsencrypt/live/vultr.309906615.xyz/privkey.pem' \
#   TROJAN_USER='root' \
#   FALLBACK_ADDR='127.0.0.1' \
#   FALLBACK_PORT='80' \
#   ./install_trojan.sh

TROJAN_VERSION="${TROJAN_VERSION:-1.16.0}"
DOMAIN="${DOMAIN:-}"
TROJAN_PASSWORD="${TROJAN_PASSWORD:-}"
CERT_PATH="${CERT_PATH:-}"
KEY_PATH="${KEY_PATH:-}"
LISTEN_HOST="${LISTEN_HOST:-0.0.0.0}"
LISTEN_PORT="${LISTEN_PORT:-443}"
FALLBACK_ADDR="${FALLBACK_ADDR:-127.0.0.1}"
FALLBACK_PORT="${FALLBACK_PORT:-80}"
TROJAN_USER="${TROJAN_USER:-trojan}"
TROJAN_GROUP="${TROJAN_GROUP:-trojan}"
CONFIG_DIR="/usr/local/etc/trojan"
CONFIG_FILE="${CONFIG_DIR}/config.json"
BIN_PATH="/usr/local/bin/trojan"
SERVICE_FILE="/etc/systemd/system/trojan.service"
DOWNLOAD_URL="https://github.com/trojan-gfw/trojan/releases/download/v${TROJAN_VERSION}/trojan-${TROJAN_VERSION}-linux-amd64.tar.xz"

log() {
  printf '\n[%s] %s\n' "$(date '+%F %T')" "$*"
}

die() {
  printf '\n[ERROR] %s\n' "$*" >&2
  exit 1
}

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    die "Please run this script with sudo or as root."
  fi
}

run_letsencrypt_once() {
  log "Installing certbot for Let's Encrypt certificates for the current domain (${DOMAIN})..."
  log "Make sure port 80 is open and not used by other services before running this script, as certbot will need to bind to it temporarily for domain validation."
  echo "🛑 Step 1: Killing any running certbot processes..."
  sudo pkill -f certbot || true
  sudo killall -9 certbot || true 

  echo "🧹 Step 2: Removing Certbot lock files..."
  sudo rm -f /var/lib/letsencrypt/.certbot.lock
  sudo rm -f /var/log/letsencrypt/.certbot.lock

  echo "🧹 Step 3: Cleaning temporary Certbot files..."
  sudo rm -rf /tmp/certbot-*

  echo "🔍 Step 4: Checking if port 80 is free..."
  if sudo lsof -i:80; then
  echo "❌ Port 80 is still in use. Please stop the service using it."
  exit 1
  else
  echo "✅ Port 80 is free."
  fi
  
  echo "Step 5: Checking for any remaining certbot processes..."
  if pgrep -f certbot > /dev/null; then
    echo "❌ There are still certbot processes running. Please stop them before proceeding."
    echo " Attempting to kill certbot processes..."
    certbot_pids=$(pgrep -f certbot)
        if [[ -n "${certbot_pids}" ]]; then
            kill -9 ${certbot_pids}
        fi
    exit 1
  else
    echo "✅ No certbot processes are running."
    echo "🛡️ Step 7: Requesting Let's Encrypt certificate for domain ${DOMAIN}..."
    sudo certbot certonly --standalone -d ${DOMAIN}
  fi
}

validate_inputs() {
  [[ -n "${DOMAIN}" ]] || die "Missing DOMAIN"
  [[ -n "${TROJAN_PASSWORD}" ]] || die "Missing TROJAN_PASSWORD"
  [[ -n "${CERT_PATH}" ]] || die "Missing CERT_PATH"
  [[ -n "${KEY_PATH}" ]] || die "Missing KEY_PATH"

  [[ -f "${CERT_PATH}" ]] || die "CERT_PATH does not exist: ${CERT_PATH}"
  [[ -f "${KEY_PATH}" ]] || die "KEY_PATH does not exist: ${KEY_PATH}"
}

install_packages() {
  log "Installing packages..."
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y \
    ca-certificates \
    curl \
    xz-utils \
    openssl \
    libssl-dev \
    libboost-system1.74.0 \
    libboost-program-options1.74.0 \
    libboost-filesystem1.74.0 \
    certbot
}

create_service_user() {
  if ! getent group "${TROJAN_GROUP}" >/dev/null 2>&1; then
    groupadd --system "${TROJAN_GROUP}"
  fi

  if ! id -u "${TROJAN_USER}" >/dev/null 2>&1; then
    useradd \
      --system \
      --gid "${TROJAN_GROUP}" \
      --home-dir /nonexistent \
      --shell /usr/sbin/nologin \
      "${TROJAN_USER}"
  fi
}

install_binary() {
  log "Downloading trojan ${TROJAN_VERSION}..."
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "${tmp_dir}"' EXIT

  curl -fL "${DOWNLOAD_URL}" -o "${tmp_dir}/trojan.tar.xz"
  tar -xJf "${tmp_dir}/trojan.tar.xz" -C "${tmp_dir}"

  extracted_dir="$(find "${tmp_dir}" -maxdepth 1 -type d -name "trojan" -o -name "trojan-${TROJAN_VERSION}" | head -n 1)"
  if [[ -z "${extracted_dir}" ]]; then
    extracted_dir="$(find "${tmp_dir}" -maxdepth 2 -type f -name trojan -print | head -n 1)"
    [[ -n "${extracted_dir}" ]] || die "Failed to locate trojan binary after extraction"
    install -m 0755 "${extracted_dir}" "${BIN_PATH}"
  else
    install -m 0755 "${extracted_dir}/trojan" "${BIN_PATH}"
  fi

  "${BIN_PATH}" --version || true
}

install_config() {
  log "Writing config to ${CONFIG_FILE}..."
  mkdir -p "${CONFIG_DIR}"

  cat > "${CONFIG_FILE}" <<EOF
{
  "run_type": "server",
  "local_addr": "${LISTEN_HOST}",
  "local_port": ${LISTEN_PORT},
  "remote_addr": "${FALLBACK_ADDR}",
  "remote_port": ${FALLBACK_PORT},
  "password": [
    "${TROJAN_PASSWORD}"
  ],
  "log_level": 3,
  "ssl": {
    "cert": "${CERT_PATH}",
    "key": "${KEY_PATH}",
    "key_password": "",
    "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
    "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256",
    "prefer_server_cipher": true,
    "alpn": [
      "http/1.1"
    ],
    "reuse_session": true,
    "session_ticket": false,
    "session_timeout": 600,
    "plain_http_response": "",
    "curves": "",
    "dhparam": ""
  },
  "tcp": {
    "prefer_ipv4": false,
    "no_delay": true,
    "keep_alive": true,
    "reuse_port": false,
    "fast_open": false,
    "fast_open_qlen": 20
  },
  "mysql": {
    "enabled": false,
    "server_addr": "127.0.0.1",
    "server_port": 3306,
    "database": "trojan",
    "username": "trojan",
    "password": "",
    "ssl": {
      "enabled": false,
      "verify": true,
      "ca": "",
      "cert": "",
      "key": "",
      "key_password": ""
    }
  }
}
EOF

  chmod 644 "${CONFIG_FILE}"
}

validate_files_permissions() {
  sudo -u "${TROJAN_USER}" test -r "${CONFIG_FILE}" || die "Trojan user cannot read config: ${CONFIG_FILE}"
  sudo -u "${TROJAN_USER}" test -r "${CERT_PATH}" || die "Trojan user cannot read cert: ${CERT_PATH}"
  sudo -u "${TROJAN_USER}" test -r "${KEY_PATH}" || die "Trojan user cannot read key: ${KEY_PATH}"
}

fix_permissions() {
  log "Fixing file permissions for trojan user..."

  # Config
  chown root:${TROJAN_GROUP} "${CONFIG_FILE}"
  chmod 640 "${CONFIG_FILE}"
  chmod 755 "${CONFIG_DIR}"

  # Base Let's Encrypt dirs must be traversable
  chmod 755 /etc/letsencrypt
  chmod 755 /etc/letsencrypt/live
  chmod 755 /etc/letsencrypt/archive

  local cert_live_dir key_live_dir cert_real key_real cert_archive_dir key_archive_dir
  cert_live_dir="$(dirname "${CERT_PATH}")"
  key_live_dir="$(dirname "${KEY_PATH}")"

  cert_real="$(readlink -f "${CERT_PATH}")"
  key_real="$(readlink -f "${KEY_PATH}")"

  cert_archive_dir="$(dirname "${cert_real}")"
  key_archive_dir="$(dirname "${key_real}")"

  # Domain-specific live dirs
  chgrp "${TROJAN_GROUP}" "${cert_live_dir}" "${key_live_dir}" || true
  chmod 750 "${cert_live_dir}" "${key_live_dir}" || true

  # Domain-specific archive dirs
  chgrp "${TROJAN_GROUP}" "${cert_archive_dir}" "${key_archive_dir}" || true
  chmod 750 "${cert_archive_dir}" "${key_archive_dir}" || true

  # Real cert/key files
  chgrp "${TROJAN_GROUP}" "${cert_real}" "${key_real}"
  chmod 640 "${cert_real}" "${key_real}"

  log "Permissions fixed."
}

install_systemd_service() {
  log "Writing systemd service..."
  cat > "${SERVICE_FILE}" <<EOF
[Unit]
Description=Trojan Proxy Service
After=network-online.target nss-lookup.target
Wants=network-online.target

[Service]
Type=simple
User=${TROJAN_USER}
Group=${TROJAN_GROUP}
ExecStart=${BIN_PATH} -c ${CONFIG_FILE}
ExecReload=/bin/kill -USR1 \$MAINPID
Restart=on-failure
RestartSec=2s
LimitNOFILE=1048576
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable trojan
  systemctl restart trojan
}

verify_service() {
  log "Checking service status..."
  systemctl --no-pager --full status trojan || true

  log "Checking if trojan is listening on :${LISTEN_PORT}..."
  ss -ltnp | grep ":${LISTEN_PORT}" || true

  log "Recent logs:"
  journalctl -u trojan -n 50 --no-pager || true
}

main() {
  echo "Installation Menu:"
  echo "1. Require root and install packages"
  echo "2. Install Certbot and obtain certificates for the current domain (${DOMAIN})"
  echo "3. Install Trojan service with the provided configuration"
  echo "4. Verify Trojan service status and logs"
  read -p "Choose an option: " choice
  case $choice in
    1)
      require_root
      install_packages
      ;;
    2)
      require_root
      [[ -n "${DOMAIN}" ]] || die "Missing DOMAIN"
      run_letsencrypt_once
      ;;
    3)
      require_root
      validate_inputs
      create_service_user
      install_binary
      install_config
      validate_files_permissions
      fix_permissions
      install_systemd_service
      verify_service
      ;;
    4)
      validate_files_permissions
      verify_service
      ;;
    *)
      echo "Invalid option. Exiting."
      exit 1
      ;;

  esac
  log "Done."
  echo
  echo "Config file : ${CONFIG_FILE}"
  echo "Service file: ${SERVICE_FILE}"
  echo "Binary      : ${BIN_PATH}"
  echo
  echo "Useful commands:"
  echo "  sudo systemctl status trojan"
  echo "  sudo journalctl -u trojan -f"
  echo "  sudo systemctl restart trojan"
}

main "$@"
