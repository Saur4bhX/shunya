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
