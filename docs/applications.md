# SHUNYA Applications

Application-specific integration and appearance decisions are documented here.
These settings are separate from the base installation and generated manual
setup workflow.

## Strawberry

Package:

    strawberry

Additional GStreamer codec support:

    gst-libav
    gst-plugins-bad
    gst-plugins-ugly

SHUNYA integration:

- Uses the system Qt/Kvantum theme.
- No Strawberry-specific custom palette.
- Playlist background artwork disabled.
- Alternating playlist rows disabled.
- Main playlist keeps only useful metadata columns.
- Window opacity is 0.85 for the frosted SHUNYA appearance.
- Opens on workspace 3.
- `SUPER + M` launches Strawberry.

Hyprland window class:

    org.strawberrymusicplayer.strawberry

Relevant configuration:

    config/hypr/rules.lua
    config/hypr/keybindings.lua

## LibreOffice

Package:

    libreoffice-fresh

Appearance:

- Uses LibreOffice's automatic/system appearance.
- Dark application chrome follows the desktop.
- Document canvas remains white.
- No custom SHUNYA palette is forced.
- Window opacity remains 1.0 for maximum document readability.

SHUNYA integration:

- Opens on workspace 4.
- Opens maximized rather than fullscreen so the SHUNYA bar remains visible.
- `SUPER + O` launches LibreOffice.

Relevant configuration:

    config/hypr/rules.lua
    config/hypr/keybindings.lua

## Image Viewing

Packages:

    swayimg
    gthumb

### swayimg

SHUNYA integration:

- swayimg is the default lightweight image viewer.
- swayimg opens as a centered floating popup.
- `Space` toggles fullscreen.

swayimg is the default lightweight image viewer.

SHUNYA custom controls:

- `h j k l` — Vim-style pan/navigation
- `r` — rotate 90° clockwise
- `Shift + r` — rotate 90° counter-clockwise
- `0` — reset zoom and position
- `g` — open gallery
- `Space` — toggle fullscreen
- `q` — quit

Configuration:

    config/swayimg/init.lua

swayimg is registered as the default handler for common image formats.

### gThumb

gThumb is used for browsing and organising image collections.
It complements swayimg rather than replacing the lightweight viewer.

SHUNYA integration:
- gThumb is the image organiser.
- `SUPER + I` opens gThumb at `~/Pictures`.
- gThumb opens maximized on workspace 5.

## KeePassXC

Package:

    keepassxc

SHUNYA integration:

- Uses the system Qt/Kvantum theme.
- Existing local KDBX database is used.
- Browser integration is enabled through KeePassXC-Browser.
- No dedicated workspace rule.
- No SHUNYA keybinding.
- No autostart; KeePassXC is launched only when needed.
- Window opacity remains 1.0.


