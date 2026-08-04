local M = {}

function M.apply(config, act)
  -- tmux-style leader key: press Ctrl-A, release, then press the bound key
  -- within 1s. Almost every binding below is expressed as `LEADER` + a key
  -- rather than a raw modifier combo, to avoid clashing with app/shell shortcuts.
  config.leader = {
    key = 'a',
    mods = 'CTRL',
    timeout_milliseconds = 1000,
  }

  config.keys = {
    -- CTRL-A, CTRL-A sends the original CTRL-A through to the shell/application.
    {
      key = 'a',
      mods = 'LEADER|CTRL',
      action = act.SendKey { key = 'a', mods = 'CTRL' },
    },

    -- Panes: place new panes explicitly to the right or below.
    {
      key = '|',
      mods = 'LEADER|SHIFT',
      action = act.SplitPane {
        direction = 'Right',
        size = { Percent = 50 },
        command = { domain = 'CurrentPaneDomain' },
      },
    },
    {
      key = '-',
      mods = 'LEADER',
      action = act.SplitPane {
        direction = 'Down',
        size = { Percent = 50 },
        command = { domain = 'CurrentPaneDomain' },
      },
    },
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
    {
      key = 'r',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'resize_pane',
        one_shot = false,
        timeout_milliseconds = 5000,
      },
    },

    -- Tabs and navigation.
    { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'Tab', mods = 'LEADER', action = act.ActivateLastTab },
    {
      key = 'w',
      mods = 'LEADER',
      action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|WORKSPACES' },
    },

    -- Scrollback tools.
    { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
    { key = '/', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'f', mods = 'LEADER', action = act.QuickSelect },

    -- Configuration maintenance.
    { key = 'R', mods = 'LEADER|SHIFT', action = act.ReloadConfiguration },
  }

  -- LEADER+1..9 jumps directly to tab index 0..8 (ActivateTab is 0-indexed).
  for index = 1, 9 do
    table.insert(config.keys, {
      key = tostring(index),
      mods = 'LEADER',
      action = act.ActivateTab(index - 1),
    })
  end

  -- Modal key table: after LEADER+r, plain h/j/k/l (or arrow keys) resize the
  -- current pane repeatedly without needing to re-press LEADER each time,
  -- until Escape/Enter (or the 5s timeout above) pops back to normal mode.
  config.key_tables = {
    resize_pane = {
      { key = 'h', action = act.AdjustPaneSize { 'Left', 2 } },
      { key = 'j', action = act.AdjustPaneSize { 'Down', 2 } },
      { key = 'k', action = act.AdjustPaneSize { 'Up', 2 } },
      { key = 'l', action = act.AdjustPaneSize { 'Right', 2 } },
      { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 2 } },
      { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 2 } },
      { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 2 } },
      { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 2 } },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'Enter', action = 'PopKeyTable' },
    },
  }
end

return M
