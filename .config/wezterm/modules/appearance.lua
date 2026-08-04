local M = {}

-- Previous light/dark Monokai switching, kept here for reference.
-- local function get_appearance(wezterm)
--   -- wezterm.gui is unavailable when the config is evaluated by the mux server.
--   if wezterm.gui then
--     return wezterm.gui.get_appearance()
--   end
--   return 'Dark'
-- end
--
-- local function scheme_for_appearance(appearance)
--   if appearance:find 'Dark' then
--     return 'Monokai (dark) (terminal.sexy)'
--   end
--   return 'Monokai (light) (terminal.sexy)'
-- end

function M.apply(wezterm, config)
  -- Font and text rendering.
  config.font = wezterm.font_with_fallback {
    {
      family = 'JetBrainsMono Nerd Font Mono',
      weight = 'Regular',
    },
    {
      family = 'PingFang SC',
      scale = 1.08,
    },
  }
  config.font_size = 13.5
  config.line_height = 1.04
  config.cell_width = 1.0
  config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

  -- Color and window appearance.
  -- local appearance = get_appearance(wezterm)
  -- local is_dark = appearance:find 'Dark' ~= nil
  -- config.color_scheme = scheme_for_appearance(appearance)
  config.color_scheme = 'Catppuccin Mocha'
  config.window_background_opacity = 0.94
  config.macos_window_background_blur = 20
  config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
  config.integrated_title_button_style = 'MacOsNative'
  config.integrated_title_button_alignment = 'Left'
  config.integrated_title_buttons = { 'Close', 'Hide', 'Maximize' }
  config.integrated_title_button_color = 'Auto'

  config.initial_cols = 120
  config.initial_rows = 32
  config.adjust_window_size_when_changing_font_size = false
  config.window_padding = {
    left = 12,
    right = 12,
    top = 10,
    bottom = 10,
  }

  config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.82,
  }

  -- Tab bar appearance.
  config.enable_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false
  config.tab_max_width = 32
  config.show_new_tab_button_in_tab_bar = false
  config.show_tab_index_in_tab_bar = false

  -- Previous Monokai titlebar palettes (dark/light), kept for reference.
  -- local titlebar = is_dark and {
  --   background = '#1e1f1c',
  --   active_bg = '#3b3c35',
  --   active_fg = '#f8f8f2',
  --   inactive_bg = '#272822',
  --   inactive_fg = '#a9a89d',
  --   hover_bg = '#34352f',
  --   hover_fg = '#f8f8f2',
  --   status_fg = '#b8b7ae',
  --   muted_fg = '#75715e',
  --   accent = '#f92672',
  --   workspace = '#a6e22e',
  --   mode = '#f4bf75',
  --   tag_fg = '#272822',
  --   split = '#75715e',
  -- } or {
  --   background = '#e6e5e1',
  --   active_bg = '#f9f8f5',
  --   active_fg = '#272822',
  --   inactive_bg = '#ecebe7',
  --   inactive_fg = '#68675e',
  --   hover_bg = '#deddd8',
  --   hover_fg = '#272822',
  --   status_fg = '#49483e',
  --   muted_fg = '#8a8981',
  --   accent = '#f92672',
  --   workspace = '#4f6500',
  --   mode = '#f4bf75',
  --   tag_fg = '#272822',
  --   split = '#aaa99f',
  -- }

  local titlebar = {
    background = '#181825',
    active_bg = '#313244',
    active_fg = '#cdd6f4',
    inactive_bg = '#1e1e2e',
    inactive_fg = '#a6adc8',
    hover_bg = '#45475a',
    hover_fg = '#cdd6f4',
    status_fg = '#bac2de',
    muted_fg = '#6c7086',
    accent = '#cba6f7',
    workspace = '#a6e3a1',
    mode = '#f9e2af',
    tag_fg = '#1e1e2e',
    split = '#585b70',
  }

  config.colors = {
    split = titlebar.split,
    tab_bar = {
      background = titlebar.background,
      active_tab = {
        bg_color = titlebar.active_bg,
        fg_color = titlebar.active_fg,
        intensity = 'Bold',
      },
      inactive_tab = {
        bg_color = titlebar.inactive_bg,
        fg_color = titlebar.inactive_fg,
      },
      inactive_tab_hover = {
        bg_color = titlebar.hover_bg,
        fg_color = titlebar.hover_fg,
      },
      new_tab = {
        bg_color = titlebar.background,
        fg_color = titlebar.inactive_fg,
      },
      new_tab_hover = {
        bg_color = titlebar.hover_bg,
        fg_color = titlebar.hover_fg,
      },
    },
  }

  return titlebar
end

return M
