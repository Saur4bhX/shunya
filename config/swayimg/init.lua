-- SHUNYA custom keybinds for swayimg

local pan_step = 80

local function pan(dx, dy)
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(pos.x + dx, pos.y + dy)
end

-- ----------------------------
-- Viewer mode
-- ----------------------------

-- Vim-style movement
swayimg.viewer.on_key("h", function() pan(-pan_step, 0) end)
swayimg.viewer.on_key("j", function() pan(0,  pan_step) end)
swayimg.viewer.on_key("k", function() pan(0, -pan_step) end)
swayimg.viewer.on_key("l", function() pan( pan_step, 0) end)

-- Open gallery
swayimg.viewer.on_key("g", function()
  swayimg.mode = "gallery"
end)

-- Rotate clockwise
swayimg.viewer.on_key("r", function()
  swayimg.viewer.rotate(90)
end)

-- Optional: rotate anti-clockwise
swayimg.viewer.on_key("Shift-r", function()
  swayimg.viewer.rotate(270)
end)

-- Reset zoom + position
swayimg.viewer.on_key("0", function()
  swayimg.viewer.reset()
end)

-- Fullscreen toggle
swayimg.viewer.on_key("space", function()
  swayimg.fullscreen = not swayimg.fullscreen
end)

swayimg.viewer.on_key("q", function()
  swayimg.exit()
end)

-- ----------------------------
-- Gallery mode
-- ----------------------------

-- Vim-style movement in gallery
swayimg.gallery.on_key("h", function() swayimg.gallery.select("left") end)
swayimg.gallery.on_key("j", function() swayimg.gallery.select("down") end)
swayimg.gallery.on_key("k", function() swayimg.gallery.select("up") end)
swayimg.gallery.on_key("l", function() swayimg.gallery.select("right") end)

-- Open selected image
swayimg.gallery.on_key("Return", function()
  swayimg.mode = "viewer"
end)

-- Fullscreen toggle in gallery too
swayimg.gallery.on_key("space", function()
  swayimg.fullscreen = not swayimg.fullscreen
end)

swayimg.gallery.on_key("q", function()
  swayimg.exit()
end)
