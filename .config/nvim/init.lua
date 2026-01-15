--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

What is this config?

  This is a modular Neovim configuration based on kickstart.nvim.
  The goal is that you can read every line of code, understand
  what your configuration is doing, and modify it to suit your needs.

  The configuration is split into:
    - lua/config/    : Basic Neovim settings (options, keymaps, autocmds)
    - lua/plugins/   : Plugin configurations (one file per plugin/feature)

  Once you've understood the basics, you can start exploring and
  configuring additional plugins for your needs.

  If you don't know anything about Lua, I recommend:
    - https://learnxinyminutes.com/docs/lua/
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

  Once you've completed that, you can continue working through **AND READING** the rest
  of the configuration files in lua/config/ and lua/plugins/.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

  MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
  which is very useful when you're not exactly sure of what you're looking for.

If you experience any errors while trying to install, run `:checkhealth` for more info.

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
--  All plugin configurations are in lua/plugins/
--  You can configure plugins by editing the files in that directory
--  or by creating new files for new plugins.
require('lazy').setup({
  -- Import all plugin configurations from lua/plugins/
  { import = 'plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- [[ Load basic configuration ]]
-- Options, keymaps, and autocommands are in separate files
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
