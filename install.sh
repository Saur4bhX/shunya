#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MANUAL_SETUP_DIR="$REPO/docs/manual-setup"
MANUAL_SETUP_FILE="$REPO/MANUAL_SETUP.md"

declare -a manual_setup_steps=()

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

add_manual_setup() {
    local name="$1"
    local path="$MANUAL_SETUP_DIR/$name"
    local existing

    # Do not add the same guide twice.
    for existing in "${manual_setup_steps[@]}"; do
        [[ "$existing" == "$name" ]] && return 0
    done

    if [[ -f "$path" ]]; then
        manual_setup_steps+=("$name")
    else
        printf 'WARNING: manual setup guide missing: %s\n' \
            "$path" >&2
    fi
}

generate_manual_setup_guide() {
    {
        cat <<EOF
# SHUNYA Manual Setup

This file was generated automatically by the SHUNYA installer.

Generated: $(date --iso-8601=seconds)
Host: $(hostname)
User: $(id -un)

Complete the unchecked sections below after automatic installation.

This file is machine-specific and must not be committed to Git.

The permanent setup reference is:

    SETUP.md

---

EOF

        if (( ${#manual_setup_steps[@]} == 0 )); then
            cat <<'EOF'
## No manual setup detected

SHUNYA did not detect any remaining manual configuration.

You can still consult `SETUP.md` for the complete setup reference.
EOF
            return 0
        fi

        local step

        for step in "${manual_setup_steps[@]}"; do
            cat "$MANUAL_SETUP_DIR/$step"

            # Include useful machine-specific information for NTFS setup.
            if [[ "$step" == "ntfs.md" ]]; then
                cat <<EOF

### Detected filesystems

\`\`\`text
$(lsblk -f)
\`\`\`

### Current user

\`\`\`text
username: $(id -un)
UID:      $(id -u)
GID:      $(id -g)
\`\`\`
EOF
            fi

            printf '\n\n---\n\n'
        done

        cat <<'EOF'
## Final verification

After completing every applicable section above, verify SHUNYA.

Check Hyprland:

    hyprctl configerrors

Check the repository:

    git status

If `/etc/fstab` or another system-level configuration was changed,
reboot once and verify that the expected devices, services and
filesystems work after startup.

When all checks pass, SHUNYA manual setup is complete.
EOF

    } > "$MANUAL_SETUP_FILE"
}

# ------------------------------------------------------------
# Start
# ------------------------------------------------------------

echo "==> SHUNYA installer"

# ------------------------------------------------------------
# 1. Official Arch packages
# ------------------------------------------------------------

if [[ -f "$REPO/packages/pacman-explicit.txt" ]]; then
    echo "==> Installing official packages..."

    sudo pacman -S --needed - \
        < "$REPO/packages/pacman-explicit.txt"
fi

# ------------------------------------------------------------
# 2. AUR packages
# ------------------------------------------------------------

if [[ -f "$REPO/packages/aur-explicit.txt" ]]; then
    if command -v paru >/dev/null 2>&1; then
        echo "==> Installing AUR packages..."

        paru -S --needed - \
            < "$REPO/packages/aur-explicit.txt"
    else
        echo "ERROR: Install paru, then rerun this installer." >&2
        exit 1
    fi
fi

# ------------------------------------------------------------
# 3. User directories
# ------------------------------------------------------------

echo "==> Preparing user directories..."

xdg-user-dirs-update

mkdir -p \
    "$HOME/.config" \
    "$HOME/Pictures/Screenshots" \
    "$HOME/Pictures/Wallpapers"

# ------------------------------------------------------------
# 4. Restore SHUNYA configuration
# ------------------------------------------------------------

echo "==> Restoring SHUNYA configuration..."

if [[ -d "$REPO/config" ]]; then
    cp -a --backup=numbered -- \
        "$REPO/config/." \
        "$HOME/.config/"
else
    echo "ERROR: SHUNYA config directory is missing." >&2
    exit 1
fi

# Ensure SHUNYA utility scripts are executable.

if [[ -d "$HOME/.config/bin" ]]; then
    find "$HOME/.config/bin" \
        -maxdepth 1 \
        -type f \
        -exec chmod +x {} +
fi

# ------------------------------------------------------------
# 5. Font cache
# ------------------------------------------------------------

if command -v fc-cache >/dev/null 2>&1; then
    echo "==> Rebuilding font cache..."
    fc-cache -f
fi

# ------------------------------------------------------------
# 6. Reapply SHUNYA theme
# ------------------------------------------------------------

# Reapply the state stored in theme.json without forcing a new
# dark/light mode or generating a different accent.
#
# shunya-theme regenerates live GTK, Qt, Kvantum, Kitty,
# Hyprlock and Hyprland theme state.

if [[ -x "$HOME/.config/bin/shunya-theme" ]]; then
    echo "==> Applying SHUNYA theme..."

    "$HOME/.config/bin/shunya-theme" apply
fi

# ------------------------------------------------------------
# 7. System services
# ------------------------------------------------------------

echo "==> Enabling system services..."

for service in \
    bluetooth.service \
    sshd.service
do
    load_state="$(
        systemctl show \
            "$service" \
            --property=LoadState \
            --value \
            2>/dev/null || true
    )"

    if [[ "$load_state" == "loaded" ]]; then
        sudo systemctl enable --now "$service"
    else
        printf 'ERROR: %s is not loaded (%s).\n' \
            "$service" \
            "${load_state:-unknown}" >&2

        exit 1
    fi
done

# ------------------------------------------------------------
# 8. User services
# ------------------------------------------------------------

systemctl --user daemon-reload

# Static portal services must NOT be manually enabled.
# Hyprland/DBus activates them when required.
#
# Quickshell components are started by the Hyprland configuration.

# ------------------------------------------------------------
# 9. Verify required components
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
    "hyprpaper"
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
    "fc-cache"
    "fastfetch"
    "starship"
)

for cmd in "${required_commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf '  [OK] %s\n' "$cmd"
    else
        printf '  [MISSING] %s\n' "$cmd"
        missing=1
    fi
done

if (( missing )); then
    echo
    echo "ERROR: Required SHUNYA components are missing." >&2
    exit 1
fi

# ------------------------------------------------------------
# 10. Detect manual post-installation work
# ------------------------------------------------------------

echo
echo "==> Detecting manual setup requirements..."

# KDE Connect pairing is intentionally machine-specific.

if command -v kdeconnect-cli >/dev/null 2>&1; then
    add_manual_setup "kde-connect.md"
fi

# Android authorization / ADB TCP initialization requires
# interaction with the physical phone.

if command -v adb >/dev/null 2>&1; then
    add_manual_setup "android-debugging.md"
fi

# Bluetooth service configuration is automatic, but actual
# device pairing is intentionally manual.

if systemctl show bluetooth.service \
    --property=LoadState \
    --value \
    2>/dev/null |
    grep -qx "loaded"
then
    add_manual_setup "bluetooth.md"
fi

# Browser profiles, accounts, sync chains and private state
# must not be stored in Git.

if command -v brave >/dev/null 2>&1; then
    add_manual_setup "browser.md"
fi

# SSH/SFTP credentials and client authorization are private
# machine-specific state.

if systemctl show sshd.service \
    --property=LoadState \
    --value \
    2>/dev/null |
    grep -qx "loaded"
then
    add_manual_setup "ssh-sftp.md"
fi

# Only show the NTFS setup guide when this machine actually
# contains at least one NTFS filesystem.

if lsblk -nr -o FSTYPE 2>/dev/null |
    grep -qx "ntfs"
then
    add_manual_setup "ntfs.md"
fi

# ------------------------------------------------------------
# 11. Generate machine-specific manual setup guide
# ------------------------------------------------------------

echo "==> Generating MANUAL_SETUP.md..."

generate_manual_setup_guide

# ------------------------------------------------------------
# 12. Completion
# ------------------------------------------------------------

echo
echo "==> Automatic SHUNYA restoration complete."
echo

if (( ${#manual_setup_steps[@]} > 0 )); then
    printf 'Manual setup sections detected: %d\n' \
        "${#manual_setup_steps[@]}"

    echo
    echo "Follow the generated step-by-step guide:"
    echo
    echo "  $MANUAL_SETUP_FILE"
    echo
    echo "Open it with:"
    echo
    echo "  less \"$MANUAL_SETUP_FILE\""
else
    echo "No additional manual setup was detected."
fi

echo
echo "Permanent setup reference:"
echo
echo "  $REPO/SETUP.md"
echo
echo "SHUNYA installation finished."
