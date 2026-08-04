local wezterm = require 'wezterm'
local act = wezterm.action

-- Config is split by concern: appearance (fonts/colors/window chrome),
-- behavior (pane/scroll/mouse/input handling), keybindings (leader-key
-- bindings), and ui (tab-bar/status-bar rendering callbacks).
local appearance = require 'modules.appearance'
local behavior = require 'modules.behavior'
local keybindings = require 'modules.keybindings'
local ui = require 'modules.ui'

local config = wezterm.config_builder()
-- Fail loudly on unknown/misspelled config keys instead of silently ignoring them.
config:set_strict_mode(true)

-- appearance.apply builds the color palette used for the window titlebar and
-- returns it so ui.setup can reuse the exact same colors when rendering the
-- tab bar and status bar.
local titlebar = appearance.apply(wezterm, config)
behavior.apply(config, act)
keybindings.apply(config, act)
ui.setup(wezterm, titlebar)

return config
