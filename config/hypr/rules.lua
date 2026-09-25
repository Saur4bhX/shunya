-- Shunya Core window rules
--
hl.window_rule({
    match = { class = "brave-browser" },
    workspace = "2",
})

hl.window_rule({
    name = "picture-in-picture",

    match = {
        initial_title = "^Picture in picture$",
    },

    float = true,

    size = {
        "monitor_w*0.33",
        "monitor_w*0.33*0.5625",
    },

    move = {
        "monitor_w*0.67-5",
        "monitor_h-(monitor_w*0.33*0.5625)-5",
    },

    pin = true,
})

hl.window_rule({
    name = "brave-save-dialog",

    match = {
        class = "^brave$",
        title = "^Save File$",
    },

    float = true,
    center = true,
})

hl.window_rule {
    match = { class = "scrcpy" },
    float = true,
    center = true,
}

hl.layer_rule({
    match = {
        namespace = "shunya-osd",
    },

    blur = true,
    ignore_alpha = 0.15,
})

hl.window_rule({
    name = "strawberry",

    match = {
        class = "^org[.]strawberrymusicplayer[.]strawberry$",
    },

    workspace = "3",
    opacity = "0.87 override 0.85 override 1.0 override",
})

hl.window_rule({
    name = "libreoffice",

    match = {
        class = "^libreoffice.*$",
    },

    workspace = "4",
    maximize = true,
})


