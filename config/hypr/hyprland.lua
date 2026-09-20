hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        layout = "dwindle",
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

require("input")
require("appearance")
require("keybindings")
require("rules")
require("startup")

