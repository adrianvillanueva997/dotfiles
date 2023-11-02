local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end
config.font = wezterm.font("FiraCode Nerd Font")
config.enable_scroll_bar = true
config.disable_default_key_bindings = false
config.color_scheme = "Catppuccin Mocha (Gogh)"

config.inactive_pane_hsb = {
    hue = 1.0,
    saturation = 1.0,
    brightness = 1.0
}
config.launch_menu = {}

leader = {
    key = "b",
    mods = "CMD",
    timeout_milliseconds = 2000
}

return config
