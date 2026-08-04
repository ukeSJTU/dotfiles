local M = {}

function M.apply(config, act)
  -- Pane and tab behavior.
  config.pane_focus_follows_mouse = false
  config.unzoom_on_switch_pane = true
  config.switch_to_last_active_tab_when_closing_tab = true

  -- Terminal behavior.
  config.scrollback_lines = 20000
  config.scroll_to_bottom_on_input = true
  config.alternate_buffer_wheel_scroll_speed = 1
  config.default_cursor_style = 'BlinkingBar'
  config.cursor_blink_rate = 600
  config.audible_bell = 'Disabled'
  config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 60,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 120,
    target = 'CursorColor',
  }

  -- Pick up config file edits without restarting WezTerm.
  config.automatically_reload_config = true
  -- Characters that end a double-click word selection, so paths/brackets/quotes
  -- don't get swallowed into the selected word.
  config.selection_word_boundary = ' \t\n{}[]()"\'`,;:'

  -- Keep regular clicks focused on selection and require Command-click to open
  -- hyperlinks, reducing accidental navigation while selecting terminal output.
  config.mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection 'Clipboard',
    },
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'SUPER',
      action = act.Nop,
    },
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'SUPER',
      action = act.OpenLinkAtMouseCursor,
    },
  }

  -- Left Option behaves as Alt/Meta in terminal programs. Right Option remains
  -- available for macOS composed characters and special input.
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = true
end

return M
