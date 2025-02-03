sudo whoami
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> $HOME/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /$HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
/opt/homebrew/bin/brew install --cask cinc-workstation
sudo cinc-client -z --config ./client.rb  -j run_list.json



