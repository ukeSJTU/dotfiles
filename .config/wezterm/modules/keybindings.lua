local M = {}

function M.apply(config, act)
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

  for index = 1, 9 do
    table.insert(config.keys, {
      key = tostring(index),
      mods = 'LEADER',
      action = act.ActivateTab(index - 1),
    })
  end

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
