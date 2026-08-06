return {
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      local bufremove = require 'mini.bufremove'
      bufremove.setup()
      require('mini.pairs').setup()
      require('mini.splitjoin').setup()
      require('mini.surround').setup()

      vim.keymap.set('n', '<leader>bd', function()
        bufremove.delete(0, false)
      end, { desc = '[D]elete current buffer' })

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
