# Hyprland Dotfiles — Minimalist Vintage Retro

> **ThinkPad X13 Gen 1 (AMD) — Linux Mint 22.3 — Hyprland 0.56**

A clean, minimalist vintage retro Hyprland setup with a monochrome charcoal/white palette, sharp 1px borders, and a snappy tiling workflow.

---

## 📸 Setup Overview

- **WM**: Hyprland 0.56
- **Bar**: Waybar (dual monitor, independent workspaces)
- **Terminal**: Foot (Tokyo Night theme, JetBrainsMono Nerd Font)
- **Launcher**: Wofi
- **Wallpaper**: swaybg
- **Notifications**: Mako
- **Lock Screen**: Swaylock
- **Font**: JetBrainsMono Nerd Font

---

## 🖥️ Features

- **Dual Monitor Support** — Independent workspace bars for laptop (1–5) and external monitor (6–10)
- **120Hz External Monitor** — Philips 27" @ 1920x1080@120Hz
- **Auto Power Management** — Switches between `performance` (AC) and `power-saver` (battery) automatically
- **Retro Monochrome Theme** — Dark `#121212` background, `#cccccc` text, sharp 1px borders
- **Sleep Wake Fix** — No screen freeze on resume from suspend
- **Neofetch on terminal open**

---

## ⌨️ Keybindings

| Key | Action |
|-----|--------|
| `SUPER + Enter` | Open terminal |
| `SUPER + C` | Close window |
| `SUPER + Space` | App launcher |
| `SUPER + F` | Fullscreen |
| `SUPER + V` | Toggle floating |
| `SUPER + L` | Lock screen |
| `SUPER + M` | Exit Hyprland |
| `SUPER + Tab` | Switch monitor focus |
| `SUPER + 1–5` | Switch workspace (laptop) |
| `SUPER + 6–10` | Switch workspace (monitor) |
| `SUPER + Shift + 1–10` | Move window to workspace |
| `SUPER + Arrow Keys` | Move window focus |
| `Print` | Screenshot (save) |
| `SUPER + Shift + S` | Screenshot region (clipboard) |

---

## 📁 Structure

```
~/.config/
├── hypr/
│   ├── hyprland.conf       # Main Hyprland config
│   ├── hyprlock.conf       # Lock screen config
│   ├── hyprpaper.conf      # Wallpaper config
│   ├── fix-socket.sh       # Waybar IPC socket fix
│   ├── power-daemon.sh     # Auto AC/Battery power switcher
│   └── toggle-wofi.sh      # App launcher toggle
├── waybar/
│   ├── config              # Dual monitor bar config
│   └── style.css           # Vintage monochrome bar styles
├── foot/
│   └── foot.ini            # Terminal config (Tokyo Night theme)
├── wofi/
│   └── style.css           # Launcher styles
└── mako/
    └── config              # Notification daemon config
```

---

## 🚀 Install

```bash
# Clone
git clone https://github.com/gothssmy-design/hyprland-dotfiles ~/.dotfiles

# Copy configs
cp -r ~/.dotfiles/.config/* ~/.config/

# Make scripts executable
chmod +x ~/.config/hypr/*.sh

# Reload Hyprland
hyprctl reload
```

---

## 📦 Dependencies

```bash
sudo apt install hyprland waybar foot wofi mako swaybg swaylock grim slurp wl-clipboard brightnessctl pipewire wireplumber
```
