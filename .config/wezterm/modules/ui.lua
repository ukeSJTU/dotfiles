local M = {}

local function tab_title(tab)
  if tab.tab_title and #tab.tab_title > 0 then
    return tab.tab_title
  end
  return tab.active_pane.title
end

function M.setup(wezterm, titlebar)
  wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, hover, max_width)
    local background = titlebar.inactive_bg
    local foreground = titlebar.inactive_fg
    local marker = ' '

    if tab.is_active then
      background = titlebar.active_bg
      foreground = titlebar.active_fg
      marker = '▎'
    elseif hover then
      background = titlebar.hover_bg
      foreground = titlebar.hover_fg
    end

    local index = tostring(tab.tab_index + 1)
    local zoomed = tab.active_pane.is_zoomed and ' Z' or ''
    local title = wezterm.truncate_right(tab_title(tab), math.max(1, max_width - 7))

    return {
      { Background = { Color = background } },
      { Foreground = { Color = tab.is_active and titlebar.accent or background } },
      { Text = marker },
      { Foreground = { Color = foreground } },
      { Attribute = { Intensity = tab.is_active and 'Bold' or 'Normal' } },
      { Text = ' ' .. index .. zoomed .. '  ' .. title .. ' ' },
    }
  end)

  wezterm.on('update-status', function(window, _pane)
    local cells = {}
    local ok, active_key_table = pcall(function()
      return window:active_key_table()
    end)
    if not ok then
      return
    end

    local leader_ok, leader_active = pcall(function()
      return window:leader_is_active()
    end)
    if not leader_ok then
      return
    end

    if leader_active then
      table.insert(cells, { Background = { Color = titlebar.accent } })
      table.insert(cells, { Foreground = { Color = titlebar.tag_fg } })
      table.insert(cells, { Attribute = { Intensity = 'Bold' } })
      table.insert(cells, { Text = ' LEADER ' })
    elseif active_key_table then
      table.insert(cells, { Background = { Color = titlebar.mode } })
      table.insert(cells, { Foreground = { Color = titlebar.tag_fg } })
      table.insert(cells, { Attribute = { Intensity = 'Bold' } })
      table.insert(cells, { Text = ' ' .. active_key_table:upper() .. ' ' })
    end

    local workspace_ok, workspace = pcall(function()
      return window:active_workspace()
    end)
    if not workspace_ok then
      return
    end

    table.insert(cells, { Background = { Color = titlebar.background } })
    table.insert(cells, { Foreground = { Color = titlebar.workspace } })
    table.insert(cells, { Attribute = { Intensity = 'Bold' } })
    table.insert(cells, { Text = '  ' .. workspace .. ' ' })
    table.insert(cells, { Foreground = { Color = titlebar.muted_fg } })
    table.insert(cells, { Attribute = { Intensity = 'Normal' } })
    table.insert(cells, { Text = '│' })
    table.insert(cells, { Foreground = { Color = titlebar.status_fg } })
    table.insert(cells, { Text = wezterm.strftime ' %H:%M  ' })

    window:set_right_status(wezterm.format(cells))
  end)
end

return M
