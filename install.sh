#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> SHUNYA installer"

# ------------------------------------------------------------
# 1. Official Arch packages
# ------------------------------------------------------------

if [[ -f "$REPO/packages/pacman-explicit.txt" ]]; then
    echo "==> Installing official packages..."
    sudo pacman -S --needed - < "$REPO/packages/pacman-explicit.txt"
fi

# ------------------------------------------------------------
# 2. AUR packages
# ------------------------------------------------------------

if [[ -f "$REPO/packages/aur-explicit.txt" ]]; then
    if command -v paru >/dev/null 2>&1; then
        echo "==> Installing AUR packages..."
        paru -S --needed - < "$REPO/packages/aur-explicit.txt"
    else
        echo "==> paru not installed."
        echo "    Install paru, then rerun this installer."
    fi
fi

# ------------------------------------------------------------
# 3. Configuration
# ------------------------------------------------------------

echo "==> Restoring configuration..."
xdg-user-dirs-update
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p \
    "$HOME/.config/hypr" \
    "$HOME/.config/bin" \
    "$HOME/.config/fish"

if [[ -d "$REPO/config/hypr" ]]; then
    cp -a "$REPO/config/hypr/." "$HOME/.config/hypr/"
fi

if [[ -d "$REPO/config/bin" ]]; then
    cp -a "$REPO/config/bin/." "$HOME/.config/bin/"
    chmod +x "$HOME/.config/bin/"*
fi

if [[ -f "$REPO/config/fish/config.fish" ]]; then
    cp "$REPO/config/fish/config.fish" \
       "$HOME/.config/fish/config.fish"
fi

# Restore additional tracked application configuration.
# Preserve replaced files as numbered backups.
for relative_path in \
    kitty/kitty.conf \
    dolphinrc \
    qutebrowser/bookmarks/urls \
    qutebrowser/quickmarks \
    quickshell/shunya/shell.qml \
    quickshell/shunya-bar/shell.qml \
    quickshell/shunya-bar/Volume.qml \
    quickshell/shunya-bar/VolumeOsd.qml \
    quickshell/shunya-bar/BrightnessOsd.qml \
    quickshell/shunya-bar/NetworkStatus.qml \
    quickshell/shunya-bar/Battery.qml \
    quickshell/shunya-notifications/shell.qml \
    quickshell/shunya-bar/Tray.qml \
    quickshell/shunya-power/shell.qml \
    xdg-desktop-portal/portals.conf
do
    source_file="$REPO/config/$relative_path"
    target_file="$HOME/.config/$relative_path"

    [[ -f "$source_file" ]] || continue

    if [[ -f "$target_file" ]] && cmp -s "$source_file" "$target_file"; then
        continue
    fi

    mkdir -p "$(dirname "$target_file")"
    cp -a --backup=numbered -- "$source_file" "$target_file"
done

# ------------------------------------------------------------
# 4. System services
# ------------------------------------------------------------

echo "==> Enabling services..."

if systemctl list-unit-files bluetooth.service \
    >/dev/null 2>&1; then
    sudo systemctl enable --now bluetooth.service
fi

if systemctl list-unit-files sshd.service \
    >/dev/null 2>&1; then
    sudo systemctl enable --now sshd.service
fi

# ------------------------------------------------------------
# 5. User services
# ------------------------------------------------------------

systemctl --user daemon-reload

# Static portal services should NOT be enabled manually.
# Hyprland/DBus will activate them when required.
# The Quickshell launcher is started by its Hyprland keybinding.

# ------------------------------------------------------------
# 6. Verification
# ------------------------------------------------------------

echo
echo "==> Checking SHUNYA components..."

for cmd in \
    hyprctl \
    fish \
    dolphin \
    quickshell \
    scrcpy \
    adb \
    kdeconnect-cli \
    ssh
do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf "  [OK] %s\n" "$cmd"
    else
        printf "  [MISSING] %s\n" "$cmd"
    fi
done

echo
echo "==> Automatic restoration complete."
echo
echo "Manual setup still required for:"
echo "  - KDE Connect pairing"
echo "  - Android USB authorization and classic ADB TCP initialization"
echo "  - Bluetooth device pairing"
echo "  - Browser accounts/profiles"
echo "  - SSH/SFTP credentials"
echo
echo "See SETUP.md for details."

