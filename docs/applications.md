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
