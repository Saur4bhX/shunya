-- SHUNYA Core appearance configuration
--
-- Dynamic colours are owned by shunya-theme.
-- This file defines stable compositor appearance policy.

hl.config({
    decoration = {
        -- Keep geometry consistent with SHUNYA surfaces and Hyprlock.
        rounding = 8,
        rounding_power = 2,

        -- SHUNYA does not dim unfocused applications.
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        -- Restrained depth rather than heavy effects.
        shadow = {
            enabled = true,
            range = 8,
            render_power = 2,
            color = 0x55000000,
        },

        -- Mild blur for surfaces that deliberately use transparency.
        -- Opaque applications remain visually solid.
    blur = {
    enabled = true,

    -- Diffuse the wallpaper enough that it reads as glass,
    -- not simple transparency.
    size = 9,
    passes = 2,

    ignore_opacity = true,
    new_optimizations = true,

    -- Fine grain gives the surface a frosted texture.
    noise = 0.025,

    -- Flatten the background slightly for a milky glass look.
    contrast = 0.82,
    brightness = 0.94,

    -- Preserve some wallpaper colour without becoming vivid.
    vibrancy = 0.10,
    vibrancy_darkness = 0.06,

    -- Blur translucent application popup/context menus.
    popups = true,
    popups_ignorealpha = 0.12,
},
    },

})

-- ------------------------------------------------------------
-- SHUNYA motion
-- ------------------------------------------------------------

hl.config({
    animations = {
        enabled = true,
    },
})

-- Fast response with a soft landing.
-- No overshoot or bounce.
hl.curve("shunyaEase", {
    type = "bezier",
    points = {
        { 0.16, 1.0 },
        { 0.30, 1.0 },
    },
})

-- Focus / border state
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 1.2,
    bezier = "shunyaEase",
})

-- Windows
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 1.8,
    bezier = "shunyaEase",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 1.7,
    bezier = "shunyaEase",
    style = "popin 96%",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.4,
    bezier = "shunyaEase",
    style = "popin 98%",
})

hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 1.6,
    bezier = "shunyaEase",
})

-- Opacity changes
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 1.5,
    bezier = "shunyaEase",
})

-- Quickshell / layer surfaces
hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 1.6,
    bezier = "shunyaEase",
    style = "fade",
})

-- Workspace movement:
-- enough motion to preserve spatial context without large sweeping movement.
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 2.0,
    bezier = "shunyaEase",
    style = "slidefade 12%",
})
