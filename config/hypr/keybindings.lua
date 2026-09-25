-- Shunya Core keybindings
local mod = "SUPER"


local terminal = "kitty"
local browser = "brave"
local file_manager = "dolphin"
local music_player = "strawberry"
local office = "libreoffice"

-- Applications

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + T", 	    hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + W",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("qutebrowser"))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(file_manager))
hl.bind(mod .. " + M", hl.dsp.exec_cmd(music_player))
hl.bind(mod .. " + O", hl.dsp.exec_cmd(office))

-- ---------------------------------------------------------------------------
-- Launcher: short left-Super press
--
-- Toggle launcher only when:
--   - left Super is pressed by itself
--   - no other key is pressed while Super is held
--   - Super is released within 1000 ms
-- ---------------------------------------------------------------------------

local launcher_super_keycode = 133
local launcher_press_time = nil
local launcher_armed = false

hl.on("input.keyboard.key", function(keycode, timestamp, state)
    -- state:
    --   0 = released
    --   1 = pressed
    --   2 = repeated

    -- Left Super
    if keycode == launcher_super_keycode then
        if state == 1 then
            launcher_press_time = timestamp
            launcher_armed = true

        elseif state == 0 then
            local should_toggle = false

            if launcher_armed and launcher_press_time then
                local held_ms = timestamp - launcher_press_time
                should_toggle = held_ms >= 0 and held_ms <= 1000
            end

            launcher_press_time = nil
            launcher_armed = false

            if should_toggle then
                hl.exec_cmd(
                    [[pkill -u "$USER" -fx 'quickshell -c shunya' || quickshell -c shunya]]
                )
            end
        end

        return
    end

    -- Any other key pressed while Super is down cancels launcher activation.
    if launcher_press_time and state == 1 then
        launcher_armed = false
    end
end)

-- Window and session controls
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit())

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

hl.bind(mod .. " + LEFT",  hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + DOWN",  hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + UP",    hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + RIGHT", hl.dsp.focus({ direction = "r" }))

hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind(mod .. " + SHIFT + LEFT",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + DOWN",  hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + UP",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "r" }))

-- Resize windows: SUPER + CTRL + H/J/K/L
hl.bind(mod .. " + CTRL + H",
    hl.dsp.window.resize({ x = -40, y = 0, relative = true }),
    { repeating = true })

hl.bind(mod .. " + CTRL + L",
    hl.dsp.window.resize({ x = 40, y = 0, relative = true }),
    { repeating = true })

hl.bind(mod .. " + CTRL + K",
    hl.dsp.window.resize({ x = 0, y = -40, relative = true }),
    { repeating = true })

hl.bind(mod .. " + CTRL + J",
    hl.dsp.window.resize({ x = 0, y = 40, relative = true }),
    { repeating = true })


-- Resize windows: SUPER + CTRL + arrows
hl.bind(mod .. " + CTRL + LEFT",
    hl.dsp.window.resize({ x = -40, y = 0, relative = true }),
    { repeating = true })

hl.bind(mod .. " + CTRL + RIGHT",
    hl.dsp.window.resize({ x = 40, y = 0, relative = true }),
    { repeating = true })

hl.bind(mod .. " + CTRL + UP",
    hl.dsp.window.resize({ x = 0, y = -40, relative = true }),
    { repeating = true })

hl.bind(mod .. " + CTRL + DOWN",
    hl.dsp.window.resize({ x = 0, y = 40, relative = true }),
    { repeating = true })

hl.bind(
    mod .. " + F",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
    })
)

hl.bind(
    mod .. " + SHIFT + Space",
    hl.dsp.window.float({ action = "toggle" })
)

-- Move and resize windows with the mouse
hl.bind(
    mod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    mod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

-- Save a selected screen area
hl.bind(
    "Print",
    hl.dsp.exec_cmd(
        [[sh -c 'area=$(slurp) || exit; mkdir -p "$HOME/Pictures/Screenshots" && grim -g "$area" "$HOME/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S-%N).png"']]
    ),
    { release = true }
)

-- Save the entire screen
hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(
        [[sh -c 'mkdir -p "$HOME/Pictures/Screenshots" && grim "$HOME/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S-%N).png"']]
    ),
    { release = true }
)

hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))
hl.bind(
    mod .. " + SHIFT + Escape",
    hl.dsp.exec_cmd(
        [[pkill -u "$USER" -fx 'quickshell -c shunya-power' || quickshell -c shunya-power]]
    )
)

-- Multimedia and Brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/bin/brightness up")
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/bin/brightness down")
)

hl.bind("SUPER + P", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/bin/phone"))

for i = 1, 9 do
    local ws = tostring(i)

    hl.bind(
        "SUPER + " .. ws,
        hl.dsp.focus({ workspace = ws })
    )
    hl.bind(
        "SUPER + SHIFT + " .. ws,
        hl.dsp.window.move({
            workspace = ws,
            follow = true,
        })
    )
end
