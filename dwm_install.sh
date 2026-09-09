#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# Detect real user and home directory
# (works correctly even when run with sudo)
# ==========================================
if [ -n "${SUDO_USER:-}" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    REAL_USER="$SUDO_USER"
else
    USER_HOME="$HOME"
    REAL_USER="$(whoami)"
fi

DOTFILES_DIR="$USER_HOME/DWM-setup"
INSTALL_DIR="$USER_HOME/.config/suckless"

echo "=== DWM Install Script for Arch Minimal ==="
echo "Target user : $REAL_USER"
echo "Home        : $USER_HOME"
echo

# ==========================================
# 1. Install required packages
# ==========================================
echo "[1/8] Installing required packages..."
sudo pacman -Syu --needed --noconfirm \
    xorg \
    xorg-server \
    xorg-xinit \
    xorg-xrandr \
    xorg-xset \
    xorg-xsetroot \
    libx11 \
    libxft \
    libxcb \
    libxinerama \
    libpng \
    libjpeg-turbo \
    libxml2 \
    libpulse \
    libnotify \
    harfbuzz \
    fribidi \
    fontconfig \
    freetype2 \
    cairo \
    pixman \
    mesa \
    git \
    make \
    gcc \
    cmake \
    polkit \
    polkit-gnome \
    blueman \
    network-manager-applet \
    dunst \
    feh \
    nitrogen \
    alsa-utils \
    pipewire \
    pipewire-alsa \
    pipewire-jack \
    pulseaudio \
    pulseaudio-alsa \
    rofi \
    flameshot \
    thunar \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    thunar-volman \
    networkmanager \
    cmus \
    mpd \
    ncmpcpp \
    terminus-font \
    ttf-jetbrains-mono-nerd \
    ttf-nerd-fonts-symbols \
    ttf-dejavu \
    ttf-liberation \
    libxrender \
    imlib2 \
    zsh \
    curl \
    wget

# Note: greenclip is in the AUR. Install it later with:
# yay -S greenclip   or   paru -S greenclip

# ==========================================
# 2. Install Oh My Zsh
# ==========================================
echo "[2/8] Installing Oh My Zsh..."
if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
    # Run as the real user so files are owned correctly
    sudo -u "$REAL_USER" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ==========================================
# 3. Copy dotfiles
# ==========================================
echo "[3/8] Copying dotfiles..."
for file in .dwm .aliases .functions; do
    if [ -e "$DOTFILES_DIR/$file" ]; then
        cp -r "$DOTFILES_DIR/$file" "$USER_HOME/"
        chown -R "$REAL_USER:$REAL_USER" "$USER_HOME/$file"
    fi
done

# Copy .zshrc with backup
if [ -f "$USER_HOME/.zshrc" ]; then
    mv "$USER_HOME/.zshrc" "$USER_HOME/.zshrc.backup"
fi
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    cp "$DOTFILES_DIR/.zshrc" "$USER_HOME/"
    chown "$REAL_USER:$REAL_USER" "$USER_HOME/.zshrc"
fi

# ==========================================
# 4. Setup shell
# ==========================================
echo "[4/8] Setting up Zsh..."
if ! grep -q "source ~/.aliases" "$USER_HOME/.zshrc" 2>/dev/null; then
    cat >> "$USER_HOME/.zshrc" << 'EOF'

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
EOF
    chown "$REAL_USER:$REAL_USER" "$USER_HOME/.zshrc"
fi

# Change default shell (only if needed)
if [ "$(getent passwd "$REAL_USER" | cut -d: -f7)" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh "$REAL_USER"
fi

# ==========================================
# 5. Create directory structure
# ==========================================
echo "[5/8] Creating directory structure..."
mkdir -p "$INSTALL_DIR"/{dwm,dwmblocks-async}
mkdir -p "$USER_HOME"/.local/bin
mkdir -p "$USER_HOME"/.config/{eww,rofi}
chown -R "$REAL_USER:$REAL_USER" "$INSTALL_DIR" "$USER_HOME/.local" "$USER_HOME/.config"

# ==========================================
# 6. Copy suckless source files
# ==========================================
echo "[6/8] Copying suckless source files..."

copy_suckless() {
    local name="$1"
    if [ -d "$DOTFILES_DIR/.config/suckless/$name" ]; then
        cp -r "$DOTFILES_DIR/.config/suckless/$name/"* "$INSTALL_DIR/$name/"
        chown -R "$REAL_USER:$REAL_USER" "$INSTALL_DIR/$name"
        echo "  → $name copied"
    else
        echo "  → No $name files found (skipping)"
    fi
}

copy_suckless dwm
copy_suckless dwmblocks-async

# ==========================================
# 7. Compile and install
# ==========================================
echo "[7/8] Compiling and installing..."

# dwm
if [ -f "$INSTALL_DIR/dwm/Makefile" ]; then
    echo "  → Building dwm..."
    cd "$INSTALL_DIR/dwm"
    sudo make clean install
    cd - > /dev/null
fi

# dwmblocks-async
if [ -f "$INSTALL_DIR/dwmblocks-async/Makefile" ]; then
    echo "  → Building dwmblocks-async..."
    cd "$INSTALL_DIR/dwmblocks-async"
    make
    sudo make install
    cd - > /dev/null
fi

# ==========================================
# 8. Done
# ==========================================
echo
echo "[8/8] Done!"
echo
echo "Next steps:"
echo "  1. Log out and log back in (or reboot) so the new shell takes effect."
echo "  2. Make sure you have a proper ~/.xinitrc that starts dwm."
echo "  3. Install greenclip from the AUR if you need it:  yay -S greenclip"
echo
echo "Happy ricing!"