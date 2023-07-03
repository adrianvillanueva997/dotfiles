local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

config.color_scheme = 'Tokyo Night (Gogh)'

config.font = wezterm.font 'FiraCode Nerd Font'

return config
