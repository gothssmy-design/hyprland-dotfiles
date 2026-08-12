#!/usr/bin/env bash
# ==============================================================================
# TECBEE OS — CHROOT SETUP SCRIPT
# Run this INSIDE the Cubic chroot terminal to build TecBee OS
# ==============================================================================

set -e

DOTFILES="https://raw.githubusercontent.com/gothssmy-design/hyprland-dotfiles/main"

echo "🐝 TecBee OS — Setting up chroot environment..."

# ── BRANDING ──────────────────────────────────────────────────────────────────
cat > /etc/os-release << 'EOF'
NAME="TecBee OS"
VERSION="1.0"
ID=tecbee
ID_LIKE=ubuntu
PRETTY_NAME="TecBee OS 1.0"
VERSION_ID="1.0"
HOME_URL="https://gothssmy-design.github.io/hyprland-dotfiles/"
SUPPORT_URL="https://github.com/gothssmy-design/hyprland-dotfiles/issues"
BUG_REPORT_URL="https://github.com/gothssmy-design/hyprland-dotfiles/issues"
EOF

echo "TecBee" > /etc/hostname

# ── INSTALL HYPRLAND STACK ────────────────────────────────────────────────────
apt update
apt install -y \
    hyprland waybar foot wofi mako swaybg swaylock \
    grim slurp wl-clipboard brightnessctl \
    pipewire pipewire-pulse wireplumber \
    neofetch git curl wget unzip \
    fonts-jetbrains-mono \
    network-manager pavucontrol \
    xdg-utils xdg-user-dirs \
    thunar gvfs \
    polkit-gnome \
    libnotify-bin

# ── NERD FONT ─────────────────────────────────────────────────────────────────
mkdir -p /usr/local/share/fonts/JetBrainsMono
curl -sL "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip" \
    -o /tmp/jbm.zip
unzip -o /tmp/jbm.zip -d /usr/local/share/fonts/JetBrainsMono
fc-cache -fv
rm /tmp/jbm.zip

# ── SKEL DIRS ─────────────────────────────────────────────────────────────────
mkdir -p /etc/skel/.config/{hypr,waybar,foot,wofi,mako,neofetch}
mkdir -p /etc/skel/Pictures/Wallpapers

# ── PULL CONFIGS FROM REPO ────────────────────────────────────────────────────
for f in hypr/hyprland.conf hypr/hyprlock.conf hypr/hyprpaper.conf \
          hypr/fix-socket.sh hypr/power-daemon.sh hypr/toggle-wofi.sh; do
    curl -sL "$DOTFILES/.config/$f" -o "/etc/skel/.config/$f"
done
curl -sL "$DOTFILES/.config/waybar/config"           -o /etc/skel/.config/waybar/config
curl -sL "$DOTFILES/.config/waybar/style.css"        -o /etc/skel/.config/waybar/style.css
curl -sL "$DOTFILES/.config/foot/foot.ini"           -o /etc/skel/.config/foot/foot.ini
curl -sL "$DOTFILES/.config/wofi/style.css"          -o /etc/skel/.config/wofi/style.css
curl -sL "$DOTFILES/.config/mako/config"             -o /etc/skel/.config/mako/config
curl -sL "$DOTFILES/.config/neofetch/config.conf"    -o /etc/skel/.config/neofetch/config.conf
curl -sL "$DOTFILES/.config/neofetch/bee.txt"        -o /etc/skel/.config/neofetch/bee.txt

# ── FIX HARDCODED PATHS ───────────────────────────────────────────────────────
sed -i 's|/home/dd|$HOME|g' /etc/skel/.config/neofetch/config.conf
sed -i 's|/home/dd|$HOME|g' /etc/skel/.config/hypr/hyprland.conf

# ── WALLPAPERS ────────────────────────────────────────────────────────────────
curl -sL "$DOTFILES/assets/wallpaper.png"        -o /etc/skel/Pictures/Wallpapers/wallpaper.png
curl -sL "$DOTFILES/assets/defaultwallpaper.png" -o /etc/skel/Pictures/Wallpapers/defaultwallpaper.png
curl -sL "$DOTFILES/assets/beelogo.png"          -o /etc/skel/Pictures/beelogo.png
cp /etc/skel/Pictures/Wallpapers/defaultwallpaper.png /usr/share/backgrounds/tecbee-default.png

# ── PERMISSIONS ───────────────────────────────────────────────────────────────
chmod +x /etc/skel/.config/hypr/*.sh 2>/dev/null || true

# ── AUTO-START HYPRLAND ON TTY1 ───────────────────────────────────────────────
cat >> /etc/skel/.profile << 'PROFILE'
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi
PROFILE

# ── DISABLE DISPLAY MANAGERS ─────────────────────────────────────────────────
systemctl disable sddm lightdm gdm 2>/dev/null || true

# ── GRUB: RAW BOOT LOGS ───────────────────────────────────────────────────────
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
update-grub 2>/dev/null || true

echo ""
echo "✅ TecBee OS chroot setup complete!"
echo "   Click Next in Cubic to build the ISO."
