#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║     Kitty Terminal Setup Installer         ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This installer is designed for macOS only."
    exit 1
fi

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    print_status "Homebrew already installed"
fi

# Install Kitty
if ! command -v kitty &> /dev/null; then
    print_status "Installing Kitty terminal..."
    brew install --cask kitty
else
    print_status "Kitty already installed"
fi

# Install Nerd Font
print_status "Installing JetBrains Mono Nerd Font..."
brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || print_warning "Font may already be installed"

# Install Starship
if ! command -v starship &> /dev/null; then
    print_status "Installing Starship prompt..."
    brew install starship
else
    print_status "Starship already installed"
fi

# Create config directories
print_status "Creating config directories..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config

# Backup existing configs
if [[ -f ~/.config/kitty/kitty.conf ]]; then
    print_warning "Backing up existing kitty.conf to kitty.conf.backup"
    cp ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.backup
fi

if [[ -f ~/.config/starship.toml ]]; then
    print_warning "Backing up existing starship.toml to starship.toml.backup"
    cp ~/.config/starship.toml ~/.config/starship.toml.backup
fi

# Copy config files
print_status "Installing kitty config..."
cp "$SCRIPT_DIR/config/kitty/kitty.conf" ~/.config/kitty/kitty.conf

print_status "Installing starship config..."
cp "$SCRIPT_DIR/config/starship.toml" ~/.config/starship.toml

# Add starship to shell config
SHELL_CONFIG=""
if [[ -f ~/.zshrc ]]; then
    SHELL_CONFIG=~/.zshrc
elif [[ -f ~/.bashrc ]]; then
    SHELL_CONFIG=~/.bashrc
fi

if [[ -n "$SHELL_CONFIG" ]]; then
    if ! grep -q 'eval "$(starship init' "$SHELL_CONFIG"; then
        print_status "Adding Starship to $SHELL_CONFIG..."
        echo '' >> "$SHELL_CONFIG"
        echo '# Starship prompt' >> "$SHELL_CONFIG"
        echo 'eval "$(starship init zsh)"' >> "$SHELL_CONFIG"
    else
        print_status "Starship already configured in $SHELL_CONFIG"
    fi
else
    print_warning "Could not find .zshrc or .bashrc. Please add the following to your shell config:"
    echo '    eval "$(starship init zsh)"'
fi

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║          Installation Complete!            ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo "To start using your new setup:"
echo "  1. Open Kitty from your Applications folder"
echo "  2. Or run 'kitty' from your current terminal"
echo ""
echo "Your old configs (if any) were backed up with .backup extension"
echo ""
