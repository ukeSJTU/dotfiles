local wezterm = require 'wezterm'
local act = wezterm.action

local appearance = require 'modules.appearance'
local behavior = require 'modules.behavior'
local keybindings = require 'modules.keybindings'
local ui = require 'modules.ui'

local config = wezterm.config_builder()
config:set_strict_mode(true)

local titlebar = appearance.apply(wezterm, config)
behavior.apply(config, act)
keybindings.apply(config, act)
ui.setup(wezterm, titlebar)

return config
