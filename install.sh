#!/usr/bin/env bash
# ==============================================================================
# TECBEE HYPRLAND DOTFILES — UNIVERSAL INSTALL & UPDATE SCRIPT
# github.com/gothssmy-design/hyprland-dotfiles
#
# SAFE: Does NOT remove any apps or existing files from your system.
# It only ADDS configs and assets. Your current setup is fully preserved.
# ==============================================================================

set -e

REPO="https://github.com/gothssmy-design/hyprland-dotfiles"
RAW="https://raw.githubusercontent.com/gothssmy-design/hyprland-dotfiles/main"
INSTALL_DIR="$HOME/.dotfiles-tecbee"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  🐝  TECBEE OS — HYPRLAND RETRO SETUP           ║${NC}"
echo -e "${CYAN}║      Minimalist Vintage Hyprland Dotfiles        ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ── DEPENDENCY CHECK ──────────────────────────────────────────────────────────
echo -e "${YELLOW}[CHECK]${NC} Verifying required tools..."
MISSING=()
for cmd in git hyprctl waybar foot wofi mako swaybg; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING+=("$cmd")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo -e "${RED}[WARN]${NC}  Missing tools: ${MISSING[*]}"
    echo ""
    echo -e "  Install them with:"
    if command -v apt &>/dev/null; then
        echo -e "  ${CYAN}sudo apt install hyprland waybar foot wofi mako swaybg swaylock grim slurp wl-clipboard brightnessctl${NC}"
    elif command -v pacman &>/dev/null; then
        echo -e "  ${CYAN}sudo pacman -S hyprland waybar foot wofi mako swaybg swaylock grim slurp wl-clipboard brightnessctl${NC}"
    fi
    echo ""
    read -p "Continue anyway? (y/N): " CONT
    [[ "$CONT" =~ ^[Yy]$ ]] || exit 0
fi

# ── INSTALL or UPDATE ──────────────────────────────────────────────────────────
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${YELLOW}[UPDATE]${NC} Pulling latest from GitHub..."
    cd "$INSTALL_DIR"
    git pull origin main
    echo -e "${GREEN}[OK]${NC}    Pulled latest version!"
else
    echo -e "${YELLOW}[INSTALL]${NC} Cloning dotfiles from GitHub..."
    git clone "$REPO" "$INSTALL_DIR"
    echo -e "${GREEN}[OK]${NC}    Cloned successfully!"
fi

cd "$INSTALL_DIR"

# ── BACKUP existing configs (NON-DESTRUCTIVE) ─────────────────────────────────
BACKUP="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
echo ""
echo -e "${YELLOW}[BACKUP]${NC} Backing up existing configs to ${CYAN}$BACKUP${NC}..."
mkdir -p "$BACKUP"
for dir in hypr waybar foot wofi mako neofetch; do
    if [ -d "$HOME/.config/$dir" ]; then
        cp -r "$HOME/.config/$dir" "$BACKUP/" 2>/dev/null
        echo -e "  ${GREEN}✓${NC} Backed up $dir"
    fi
done

# ── INSTALL CONFIGS ────────────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[COPY]${NC} Installing configs to ${CYAN}~/.config/${NC}..."
cp -r .config/* "$HOME/.config/"
echo -e "${GREEN}[OK]${NC}    Configs installed!"

# ── FIX NEOFETCH PATH (make image_source dynamic) ─────────────────────────────
NEOFETCH_CONF="$HOME/.config/neofetch/config.conf"
if [ -f "$NEOFETCH_CONF" ]; then
    sed -i "s|image_source=.*bee.txt|image_source=\"$HOME/.config/neofetch/bee.txt\"|g" "$NEOFETCH_CONF"
    echo -e "${GREEN}[OK]${NC}    Neofetch path updated for your user!"
fi

# ── INSTALL WALLPAPERS ────────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[WALLPAPER]${NC} Installing wallpapers..."
mkdir -p "$HOME/Pictures/Wallpapers"

if [ -f assets/wallpaper.png ]; then
    cp assets/wallpaper.png "$HOME/Pictures/Wallpapers/wallpaper.png"
    echo -e "  ${GREEN}✓${NC} Installed wallpaper.png (Ghibli)"
fi

if [ -f assets/defaultwallpaper.png ]; then
    cp assets/defaultwallpaper.png "$HOME/Pictures/Wallpapers/defaultwallpaper.png"
    echo -e "  ${GREEN}✓${NC} Installed defaultwallpaper.png (TecBee Default)"
fi

if [ -f assets/beelogo.png ]; then
    cp assets/beelogo.png "$HOME/Pictures/beelogo.png"
    echo -e "  ${GREEN}✓${NC} Installed beelogo.png"
fi

# ── MAKE SCRIPTS EXECUTABLE ───────────────────────────────────────────────────
chmod +x "$HOME/.config/hypr/"*.sh 2>/dev/null || true
echo -e "${GREEN}[OK]${NC}    Scripts made executable!"

# ── RELOAD HYPRLAND (if running) ──────────────────────────────────────────────
if command -v hyprctl &>/dev/null && hyprctl monitors &>/dev/null 2>&1; then
    echo ""
    echo -e "${YELLOW}[RELOAD]${NC} Reloading Hyprland..."
    hyprctl reload && echo -e "${GREEN}[OK]${NC}    Hyprland reloaded!"
    sleep 0.5
    pkill -x waybar 2>/dev/null || true
    sleep 0.2
    waybar &
    echo -e "${GREEN}[OK]${NC}    Waybar restarted!"
fi

# ── DONE ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓  DONE! TecBee Setup Installed Successfully!  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Your existing apps and files were NOT touched.${NC}"
echo -e "  Backup saved to: ${CYAN}$BACKUP${NC}"
echo -e "  Repo location:   ${CYAN}$INSTALL_DIR${NC}"
echo ""
echo -e "  To update in future:"
echo -e "  ${CYAN}curl -sSL $RAW/install.sh | bash${NC}"
echo ""
