#!/usr/bin/env bash
# ==============================================================================
# HYPRLAND DOTFILES — INSTALL & UPDATE SCRIPT
# github.com/gothssmy-design/hyprland-dotfiles
# ==============================================================================

set -e

REPO="https://github.com/gothssmy-design/hyprland-dotfiles"
RAW="https://raw.githubusercontent.com/gothssmy-design/hyprland-dotfiles/main"
INSTALL_DIR="$HOME/.dotfiles-gothssmy"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   HYPRLAND DOTFILES — by gothssmy-design     ║${NC}"
echo -e "${CYAN}║   Minimalist Vintage Retro Setup             ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# Check if git is installed
if ! command -v git &>/dev/null; then
    echo -e "${RED}[ERROR]${NC} git is not installed. Run: sudo apt install git"
    exit 1
fi

# ── INSTALL or UPDATE ──────────────────────────────────────────────────────────
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${YELLOW}[UPDATE]${NC} Updating dotfiles from GitHub..."
    cd "$INSTALL_DIR"
    git pull origin main
    echo -e "${GREEN}[OK]${NC} Pulled latest version!"
else
    echo -e "${YELLOW}[INSTALL]${NC} Cloning dotfiles from GitHub..."
    git clone "$REPO" "$INSTALL_DIR"
    echo -e "${GREEN}[OK]${NC} Cloned successfully!"
fi

cd "$INSTALL_DIR"

# ── BACKUP existing configs ────────────────────────────────────────────────────
BACKUP="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
echo -e "${YELLOW}[BACKUP]${NC} Backing up existing configs to $BACKUP..."
mkdir -p "$BACKUP"
for dir in hypr waybar foot wofi mako neofetch; do
    [ -d "$HOME/.config/$dir" ] && cp -r "$HOME/.config/$dir" "$BACKUP/" && echo "  ✓ Backed up $dir"
done

# ── COPY configs ───────────────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[COPY]${NC} Installing configs to ~/.config/..."
cp -r .config/* "$HOME/.config/"
echo -e "${GREEN}[OK]${NC} Configs installed!"

# ── Make scripts executable ────────────────────────────────────────────────────
chmod +x "$HOME/.config/hypr/"*.sh 2>/dev/null || true
echo -e "${GREEN}[OK]${NC} Scripts made executable!"

# ── COPY wallpaper ─────────────────────────────────────────────────────────────
mkdir -p "$HOME/Pictures/Wallpapers"
if [ -f assets/wallpaper.png ]; then
    cp assets/wallpaper.png "$HOME/Pictures/Wallpapers/wallpaper.png"
    echo -e "${GREEN}[OK]${NC} Wallpaper installed to ~/Pictures/Wallpapers/wallpaper.png"
fi

# ── Reload Hyprland ────────────────────────────────────────────────────────────
if command -v hyprctl &>/dev/null; then
    echo ""
    echo -e "${YELLOW}[RELOAD]${NC} Reloading Hyprland..."
    hyprctl reload && echo -e "${GREEN}[OK]${NC} Hyprland reloaded!"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ DONE! Dotfiles installed successfully!   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Backup saved to: ${CYAN}$BACKUP${NC}"
echo -e "  Repo location:   ${CYAN}$INSTALL_DIR${NC}"
echo ""
echo -e "  To update in future, just run:"
echo -e "  ${CYAN}curl -sSL $RAW/install.sh | bash${NC}"
echo ""
