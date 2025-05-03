#!/bin/bash

# Ensure the script is run with sudo
sudo whoami

# Detect architecture and set Homebrew prefix
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Installing..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to shell profile
  echo >> "$HOME/.zprofile"
  echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\"" >> "$HOME/.zprofile"
  eval "$(${BREW_PREFIX}/bin/brew shellenv)"
else
  echo "Homebrew already installed. Skipping installation."

  # Ensure the current session has brew in PATH
  eval "$(${BREW_PREFIX}/bin/brew shellenv)"
fi

# Install cinc-workstation if not already installed
if ! brew list --cask cinc-workstation &> /dev/null; then
  echo "Installing cinc-workstation..."
  brew install --cask cinc-workstation
else
  echo "cinc-workstation already installed."
fi

# Run cinc-client with local configuration
sudo cinc-client -z --config ./client.rb -j run_list.json
