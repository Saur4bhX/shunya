# SHUNYA Setup Guide

This repository reproduces the SHUNYA Arch Linux + Hyprland environment.

## 1. Base System

Install Arch Linux and ensure networking and Git are available.

Clone this repository:

    git clone <SHUNYA-REPOSITORY-URL> ~/shunya
    cd ~/shunya

## 2. Packages

Official Arch packages are recorded in:

    packages/pacman-explicit.txt

Install them with:

    sudo pacman -S --needed - < packages/pacman-explicit.txt

AUR packages are recorded in:

    packages/aur-explicit.txt

After installing paru:

    paru -S --needed - < packages/aur-explicit.txt

Debug split packages are intentionally excluded from the AUR manifest.

## 3. Hyprland Configuration

The Hyprland configuration is stored in:

    config/hypr/

Restore it with:

    mkdir -p ~/.config/hypr
    cp -a config/hypr/. ~/.config/hypr/

SHUNYA uses Lua-based Hyprland configuration rather than a conventional
hyprland.conf-only setup.

## 4. Custom Scripts

Scripts are stored in:

    config/bin/

Restore them with:

    mkdir -p ~/.config/bin
    cp -a config/bin/. ~/.config/bin/
    chmod +x ~/.config/bin/*

Ensure ~/.config/bin is in PATH.

## 5. Theme System

SHUNYA uses a unified light/dark theme across Quickshell, Hyprlock, GTK and Qt6/Kvantum.

Theme state is stored in:

    ~/.config/shunya/theme.json

Theme switching is handled by:

    ~/.config/bin/shunya-theme

Usage:

    shunya-theme dark
    shunya-theme light
    shunya-theme toggle

Tracked Kvantum themes:

    config/Kvantum/SHUNYA/
    config/Kvantum/SHUNYA-Light/

GTK3 and GTK4 follow the selected SHUNYA mode.

Qt6 uses qt6ct with Kvantum. Qt5 support is intentionally not installed unless a Qt5 application requires it.

The current visual style is Catppuccin-inspired but uses SHUNYA's own palette and design language.

When accentMode is auto, shunya-theme regenerates dark and light accent colours from the configured wallpaper using Matugen. sourceColorIndex selects the wallpaper colour candidate.

## 6. Fish

Fish configuration is stored in:

    config/fish/config.fish

Restore with:

    mkdir -p ~/.config/fish
    cp config/fish/config.fish ~/.config/fish/config.fish

## 7. Phone Integration

SHUNYA uses:

- KDE Connect
- scrcpy
- Android Debug Bridge
- SSH/SFTP
- Motorola Edge 60 Pro integration

The launcher is:

    ~/.config/bin/phone

### Office Wi-Fi and Motorola Hotspot

Both networks use classic ADB TCP on port 5555.
Android Wireless Debugging and mDNS are not used.

After a phone reboot or ADB reset, connect an authorized USB
cable and initialize TCP mode:

    /usr/bin/adb -d tcpip 5555

Disconnect USB, then run:

    phone

The current launcher tries office IP 192.168.1.39 first,
then the laptop's default gateway for Motorola hotspot access.

Automatic detection of changed office DHCP addresses is pending.

### scrcpy Audio

The working SHUNYA configuration uses:

    scrcpy --audio-source=playback --audio-dup

## 8. KDE Connect

Install KDE Connect on both devices.

Pair the phone and computer while they are reachable on the same
network.

Pairing information and private device identity are NOT stored in this
Git repository. Pairing must therefore be performed once on a fresh
installation.

## 9. SFTP

OpenSSH is used on the laptop.

Enable the SSH server:

    sudo systemctl enable --now sshd

The Android file manager can connect to the laptop using SFTP.

Passwords, SSH private keys and host-specific credentials must never be
committed to this repository.

## 10. Bluetooth

Enable Bluetooth:

    sudo systemctl enable --now bluetooth

Device pairing is intentionally not reproduced through Git. Pair
Bluetooth devices again on a fresh installation.

## 11. File Manager and Browser

SHUNYA uses:

- Dolphin as the file manager
- Brave as the primary cross-device browser
- qutebrowser as the keyboard-first browser

Application profiles, browser data, login credentials and other private
state are not stored in Git.

## 12. Machine-Specific State

Do not commit:

- passwords
- SSH private keys
- ADB private keys
- Syncthing certificates/private keys
- browser profiles
- phone.env
- temporary files
- machine-specific secrets

These are excluded intentionally and must be recreated or paired on a
new machine.

## 13. Volume and brightness OSD

The shunya-bar Quickshell process provides both popups.

- Volume and mute changes are detected through PipeWire.
- Brightness keys run ~/.config/bin/brightness, which updates
  intel_backlight through brightnessctl and signals Quickshell.
- Popups close automatically after 1.5 seconds.
- On different hardware, update the backlight device in the
  brightness script using the output of brightnessctl -l.

## 14. Verification

After restoring SHUNYA, verify:

    git status
    adb devices
    kdeconnect-cli -l
    systemctl status bluetooth
    systemctl status sshd

Test the phone integration with:

    phone

The goal is that everything reproducible is restored from Git while
credentials, cryptographic identities and device-specific secrets remain
outside the repository.
