return {
  {
    'mikavilpas/yazi.nvim',
    version = '*',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
    keys = {
      {
        '<leader>e',
        '<cmd>Yazi<cr>',
        mode = { 'n', 'v' },
        desc = 'Open file manager at current file',
      },
      {
        '<leader>E',
        '<cmd>Yazi cwd<cr>',
        desc = 'Open file manager at working directory',
      },
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        copy_relative_path_to_selected_files = false,
      },
    },
  },
}
