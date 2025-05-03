#!/bin/bash

# Ensure the script is run with sudo
sudo whoami

# Install Homebrew (non-interactively)
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Detect architecture and set Homebrew prefix
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# Add Homebrew to shell profile
echo >> "$HOME/.zprofile"
echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\"" >> "$HOME/.zprofile"
eval "$(${BREW_PREFIX}/bin/brew shellenv)"

# Install cinc-workstation using Homebrew
brew install --cask cinc-workstation

# Run cinc-client with local configuration
sudo cinc-client -z --config ./client.rb -j run_list.json



