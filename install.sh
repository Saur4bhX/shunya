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
echo "ERROR: Install paru, then rerun this installer." >&2
exit 1
fi
fi

# ------------------------------------------------------------

# 3. Configuration

# ------------------------------------------------------------

echo "==> Restoring configuration..."

xdg-user-dirs-update
mkdir -p "$HOME/Pictures/Screenshots"

mkdir -p
"$HOME/.config/hypr"
"$HOME/.config/bin"
"$HOME/.config/fish"

# Hyprland

if [[ -d "$REPO/config/hypr" ]]; then
cp -a --backup=numbered --
"$REPO/config/hypr/."
"$HOME/.config/hypr/"
fi

# SHUNYA scripts

if [[ -d "$REPO/config/bin" ]]; then
cp -a --backup=numbered --
"$REPO/config/bin/."
"$HOME/.config/bin/"
fi

# Fish

if [[ -f "$REPO/config/fish/config.fish" ]]; then
cp -a --backup=numbered --
"$REPO/config/fish/config.fish"
"$HOME/.config/fish/config.fish"
fi

# Additional tracked application configuration.

# Replaced files are preserved as numbered backups.

# Additional tracked application configuration.
# Replaced files are preserved as numbered backups.

relative_paths=(
    "kitty/kitty.conf"
    "dolphinrc"
    "qutebrowser/bookmarks/urls"
    "qutebrowser/quickmarks"
    "quickshell/shunya/shell.qml"
    "quickshell/shunya-bar/shell.qml"
    "quickshell/shunya-bar/Volume.qml"
    "quickshell/shunya-bar/VolumeOsd.qml"
    "quickshell/shunya-bar/BrightnessOsd.qml"
    "quickshell/shunya-bar/NetworkStatus.qml"
    "quickshell/shunya-bar/Battery.qml"
    "quickshell/shunya-bar/Tray.qml"
    "quickshell/shunya-notifications/shell.qml"
    "quickshell/shunya-power/shell.qml"
    "qt6ct/qt6ct.conf"
    "qt5ct/qt5ct.conf"
    "shunya/theme.json"
    "xdg-desktop-portal/portals.conf"
)

for relative_path in "${relative_paths[@]}"; do
    source_file="$REPO/config/$relative_path"
    target_file="$HOME/.config/$relative_path"

    [[ -f "$source_file" ]] || continue

    if [[ -f "$target_file" ]] &&
       cmp -s "$source_file" "$target_file"; then
        continue
    fi

    mkdir -p "$(dirname "$target_file")"

    cp -a --backup=numbered -- \
        "$source_file" \
        "$target_file"
done

# Kvantum templates

if [[ -d "$REPO/config/Kvantum" ]]; then
mkdir -p "$HOME/.config/Kvantum"

```
cp -a --backup=numbered -- \
    "$REPO/config/Kvantum/." \
    "$HOME/.config/Kvantum/"
```

fi

# Reapply the state stored in theme.json without forcing a new mode.

#

# This regenerates the live GTK, Qt, Kvantum, Kitty and Hyprlock theme

# files and applies runtime integrations where available.

if [[ -x "$HOME/.config/bin/shunya-theme" ]]; then
echo "==> Applying SHUNYA theme..."
"$HOME/.config/bin/shunya-theme" apply
fi

# ------------------------------------------------------------

# 4. System services

# ------------------------------------------------------------

echo "==> Enabling services..."

for service in bluetooth.service sshd.service; do
load_state=$(
systemctl show
"$service"
--property=LoadState
--value
)

```
if [[ "$load_state" == "loaded" ]]; then
    sudo systemctl enable --now "$service"
else
    printf 'ERROR: %s is not loaded (%s).\n' \
        "$service" \
        "$load_state" >&2
    exit 1
fi
```

done

# ------------------------------------------------------------

# 5. User services

# ------------------------------------------------------------

systemctl --user daemon-reload

# Static portal services should NOT be enabled manually.

# Hyprland/DBus activates them when required.

#

# Quickshell components are started by the Hyprland configuration.

# ------------------------------------------------------------

# 6. Verification

# ------------------------------------------------------------

echo
echo "==> Checking SHUNYA components..."

missing=0

required_commands=(
    "hyprctl"
    "fish"
    "kitty"
    "brave"
    "qutebrowser"
    "dolphin"
    "quickshell"
    "hyprlock"
    "hypridle"
    "scrcpy"
    "adb"
    "kdeconnect-cli"
    "ssh"
    "wpctl"
    "brightnessctl"
    "grim"
    "slurp"
    "notify-send"
    "xdg-user-dirs-update"
    "matugen"
    "kvantummanager"
    "qt5ct"
    "qt6ct"
    "kwriteconfig6"
    "gsettings"
    "pavucontrol"
    "python3"
)

for cmd in "${required_commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf "  [OK] %s\n" "$cmd"
    else
        printf "  [MISSING] %s\n" "$cmd"
        missing=1
    fi
done

if (( missing )); then
echo "ERROR: Required components are missing." >&2
exit 1
fi

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

