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

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║     Kitty Terminal Setup Uninstaller       ║"
echo "╚════════════════════════════════════════════╝"
echo ""

read -p "This will remove the kitty and starship configs. Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Restore backups or remove configs
if [[ -f ~/.config/kitty/kitty.conf.backup ]]; then
    print_status "Restoring kitty.conf from backup..."
    mv ~/.config/kitty/kitty.conf.backup ~/.config/kitty/kitty.conf
else
    print_status "Removing kitty.conf..."
    rm -f ~/.config/kitty/kitty.conf
fi

if [[ -f ~/.config/starship.toml.backup ]]; then
    print_status "Restoring starship.toml from backup..."
    mv ~/.config/starship.toml.backup ~/.config/starship.toml
else
    print_status "Removing starship.toml..."
    rm -f ~/.config/starship.toml
fi

echo ""
print_warning "Note: Kitty, Starship, and the Nerd Font were NOT uninstalled."
echo "To fully remove them, run:"
echo "  brew uninstall --cask kitty"
echo "  brew uninstall starship"
echo "  brew uninstall --cask font-jetbrains-mono-nerd-font"
echo ""
print_status "Config files removed/restored successfully!"
echo ""
