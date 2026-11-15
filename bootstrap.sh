#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || pwd)"
TMP_REPO_DIR=""
PERSONA="all"
ATTRIBUTES_FILE=""
VERIFY=false
AUTO_YES=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Bootstrap and configure a macOS workstation with LazyMac.

Options:
  -p, --persona <name>       Persona policy to apply: all (default), developer, devops, base
  -a, --attributes <file>    Path to YAML/JSON file overriding cookbook attributes
                             (defaults to ./attributes.local.yml if present)
  -v, --verify               Run Cinc Auditor (InSpec) integration tests after convergence
  -y, --yes                  Automatically accept cinc-workstation upgrades
  -h, --help                 Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--persona)
      PERSONA="${2:-}"
      shift 2
      ;;
    -a|--attributes)
      ATTRIBUTES_FILE="${2:-}"
      shift 2
      ;;
    -v|--verify)
      VERIFY=true
      shift
      ;;
    -y|--yes)
      AUTO_YES=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: Unknown option '$1'" >&2
      usage >&2
      exit 1
      ;;
  esac
done

# Do not allow running the script directly as root (Homebrew forbids it)
if [ "$EUID" -eq 0 ]; then
  echo "Error: Do not run this script with sudo. Run './bootstrap.sh' as your regular user." >&2
  exit 1
fi

# Prompt for sudo upfront and keep credentials alive until the script exits
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!

cleanup() {
  kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
  if [ -n "$TMP_REPO_DIR" ] && [ -d "$TMP_REPO_DIR" ]; then
    sudo rm -rf "$TMP_REPO_DIR"
  fi
}
trap cleanup EXIT

# Ensure Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
  echo "Xcode Command Line Tools not found. Triggering installation..."
  xcode-select --install || true
  echo "Please complete the Xcode Command Line Tools installation dialog, then re-run ./bootstrap.sh."
  exit 1
fi

# If invoked remotely via curl | bash, download the repository to a temporary directory
if [ ! -d "${SCRIPT_DIR}/policies" ] || [ ! -d "${SCRIPT_DIR}/macbook_config" ]; then
  echo "Downloading LazyMac repository..."
  TMP_REPO_DIR="$(mktemp -d)"
  curl -fsSL https://github.com/threeturn/LazyMac/archive/refs/heads/main.tar.gz | tar -xz -C "$TMP_REPO_DIR" --strip-components=1
  SCRIPT_DIR="$TMP_REPO_DIR"
fi

# Validate persona Policyfile
POLICY_FILE="${SCRIPT_DIR}/policies/${PERSONA}.rb"
if [ ! -f "$POLICY_FILE" ]; then
  echo "Error: Unknown persona '${PERSONA}'. Available personas:" >&2
  for f in "${SCRIPT_DIR}"/policies/*.rb; do
    echo "  - $(basename "$f" .rb)" >&2
  done
  exit 1
fi

# Resolve attributes override file
if [ -n "$ATTRIBUTES_FILE" ]; then
  if [ ! -f "$ATTRIBUTES_FILE" ]; then
    echo "Error: Attributes file not found: ${ATTRIBUTES_FILE}" >&2
    exit 1
  fi
  ATTRIBUTES_FILE="$(cd "$(dirname "$ATTRIBUTES_FILE")" && pwd)/$(basename "$ATTRIBUTES_FILE")"
elif [ -f "${SCRIPT_DIR}/attributes.local.yml" ]; then
  ATTRIBUTES_FILE="${SCRIPT_DIR}/attributes.local.yml"
elif [ -f "${SCRIPT_DIR}/attributes.local.yaml" ]; then
  ATTRIBUTES_FILE="${SCRIPT_DIR}/attributes.local.yaml"
fi

# Detect architecture and set Homebrew prefix
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# Check if Homebrew is installed
if [ ! -x "${BREW_PREFIX}/bin/brew" ]; then
  echo "Homebrew not found. Installing..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed. Skipping installation."
fi

# Ensure Homebrew is configured in ~/.zprofile (idempotently) and active in current session
touch "$HOME/.zprofile"
if ! grep -Fq "${BREW_PREFIX}/bin/brew shellenv" "$HOME/.zprofile"; then
  echo "" >> "$HOME/.zprofile"
  echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\"" >> "$HOME/.zprofile"
fi
eval "$(${BREW_PREFIX}/bin/brew shellenv)"

# Install or upgrade cinc-workstation via Cinc Omnitruck
if ! command -v cinc-client &> /dev/null && [ ! -f /opt/cinc-workstation/version-manifest.txt ]; then
  echo "Installing cinc-workstation..."
  curl -fsSL https://omnitruck.cinc.sh/install.sh | sudo bash -s -- -P cinc-workstation
else
  INSTALLED_VERSION=""
  if [ -f /opt/cinc-workstation/version-manifest.txt ]; then
    INSTALLED_VERSION=$(awk 'NR==1 {print $2}' /opt/cinc-workstation/version-manifest.txt)
  elif command -v cinc &> /dev/null; then
    INSTALLED_VERSION=$(cinc --version 2>/dev/null | awk '/Cinc Workstation version:/ {print $4}')
  fi

  MACOS_VER=$(sw_vers -productVersion | cut -d. -f1,2)
  LATEST_VERSION=$(curl -fsSL "https://omnitruck.cinc.sh/stable/cinc-workstation/metadata?p=mac_os_x&pv=${MACOS_VER}&m=${ARCH}&v=latest" 2>/dev/null | awk '/^version/ {print $2}' || true)
  if [ -z "$LATEST_VERSION" ]; then
    MACOS_MAJOR=$(sw_vers -productVersion | cut -d. -f1)
    LATEST_VERSION=$(curl -fsSL "https://omnitruck.cinc.sh/stable/cinc-workstation/metadata?p=mac_os_x&pv=${MACOS_MAJOR}&m=${ARCH}&v=latest" 2>/dev/null | awk '/^version/ {print $2}' || true)
  fi

  if [ -n "$LATEST_VERSION" ] && [ -n "$INSTALLED_VERSION" ] && [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
    if [ "$AUTO_YES" = true ]; then
      response="y"
    else
      read -r -p "A new version of cinc-workstation is available (${INSTALLED_VERSION} -> ${LATEST_VERSION}). Do you want to upgrade? [y/N] " response
    fi
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "Upgrading cinc-workstation to ${LATEST_VERSION}..."
      curl -fsSL https://omnitruck.cinc.sh/install.sh | sudo bash -s -- -P cinc-workstation -v "$LATEST_VERSION"
    else
      echo "Skipping cinc-workstation upgrade."
    fi
  else
    echo "cinc-workstation already installed and up to date (${INSTALLED_VERSION:-unknown})."
  fi
fi

# Compile and export the selected persona Policyfile
EXPORT_DIR="${SCRIPT_DIR}/.policy_export"
LOCK_FILE="${POLICY_FILE%.rb}.lock.json"

echo "Applying persona '${PERSONA}'..."
if [ -n "$ATTRIBUTES_FILE" ]; then
  echo "Using attribute overrides from: ${ATTRIBUTES_FILE}"
  export LAZYMAC_ATTRIBUTES_FILE="$ATTRIBUTES_FILE"
fi

rm -f "$LOCK_FILE"
sudo rm -rf "$EXPORT_DIR"
cinc install "$POLICY_FILE"
cinc export "$POLICY_FILE" "$EXPORT_DIR" --force

# Run cinc-client with the exported policy
(
  cd "$EXPORT_DIR"
  sudo -E cinc-client -z
)

# Optional post-convergence verification
if [ "$VERIFY" = true ]; then
  echo "Running Cinc Auditor verification tests..."
  cinc-auditor exec "${SCRIPT_DIR}/macbook_config/test/integration/default"
fi
