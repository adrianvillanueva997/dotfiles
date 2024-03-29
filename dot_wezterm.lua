local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local is_windows = function()
	return wezterm.target_triple:find("windows") ~= nil
end

if is_windows() then
	config.default_prog = { "pwsh" }
end

if is_windows() then
	config.font_size = 11
else
	config.font_size = 11
end

local act = wezterm.action

config.font = wezterm.font("Iosevka Nerd Font")
config.enable_scroll_bar = true
config.disable_default_key_bindings = false
config.color_scheme = "Material Darker (base16)"
config.default_cursor_style = "BlinkingBar"
config.freetype_load_target = "HorizontalLcd"
config.window_background_opacity = 0.95
config.inactive_pane_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 1.0,
}

function trimString(str, len)
	if string.len(str) > len then
		return string.sub(str, 1, len - 3) .. "..."
	else
		return str
	end
end

function formatDomain(input)
	local map = {
		["WSL"] = function()
			return " Debian"
		end,
	}

	if is_windows() then
		map["local"] = function()
			return " PowerShell"
		end
	elseif is_linux() then
		map["local"] = function()
			return " zsh"
		end
	elseif is_darwin() then
		map["local"] = function()
			return " zsh"
		end
	end

	local prefix, name = string.match(input, "(%w+)(.*)")

	if map[prefix] then
		return map[prefix](name)
	else
		return input
	end
end

config.launch_menu = {}

leader = {
	key = "b",
	mods = "CMD",
	timeout_milliseconds = 2000,
}

wezterm.on("format-tab-title", function(tab)
	local pane = tab.active_pane
	local title = pane.title
	if pane.domain_name then
		-- title = formatDomain(pane.domain_name) .. ' ' .. trimString(title, 10)
		title = formatDomain(pane.domain_name)
	end
	return title
end)

return config
