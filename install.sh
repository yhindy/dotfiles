#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/yhindy/dotfiles.git"

echo "Installing dotfiles..."

# Install zsh if not present
if ! command -v zsh &> /dev/null; then
  echo "Installing zsh..."
  if command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y zsh
  elif command -v yum &> /dev/null; then
    sudo yum install -y zsh
  elif command -v brew &> /dev/null; then
    brew install zsh
  else
    echo "Please install zsh manually"
    exit 1
  fi
fi

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Clone dotfiles repo
if [ -d "$DOTFILES_DIR" ]; then
  echo "Updating dotfiles..."
  cd "$DOTFILES_DIR" && git pull
else
  echo "Cloning dotfiles..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

# Run setup script
cd "$DOTFILES_DIR"
chmod +x setup.sh
./setup.sh

# Install optional tools
echo ""
echo "Optional: install fzf and fd for better search"
if command -v apt-get &> /dev/null; then
  echo "  sudo apt-get install fzf fd-find"
elif command -v brew &> /dev/null; then
  echo "  brew install fzf fd"
fi

echo ""
echo "Done! Restart your shell or run: exec zsh"
