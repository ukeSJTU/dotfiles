-- Code Radio - Stream music while coding
return {
  -- Use local development path
  dir = "/Volumes/External/coderadio.nvim",
  name = "coderadio.nvim",

  lazy = false, -- Load on startup in dev mode

  -- Optional: Load only when commands are called (lazy loading)
  cmd = {
    "CodeRadioPlay",
    "CodeRadioPause",
    "CodeRadioToggle",
    "CodeRadioStop",
    "CodeRadioInfo",
    "CodeRadioVolumeUp",
    "CodeRadioVolumeDown",
    "CodeRadioVolume",
  },

  -- Use config instead of opts for explicit setup call
  config = function()
    require("coderadio").setup({
      -- Player settings
      volume = 90,
      quality = "normal", -- "normal" or "low"

      -- UI settings
      ui = {
        notifications = {
          enabled = true,
          on_song_change = true,
          on_play = false,
          on_pause = false,
        },
        floating_window = {
          enabled = true,
          show_on_play = false,
          show_on_song_change = false,
          auto_close_delay = 0,
          width = 50,
          border = "rounded",
        },
      },

      -- Enable keymaps (disabled by default)
      keymaps = {
        enable = true, -- Set to true for automatic keybinds
        toggle = "<leader>mt", -- [m]usic [t]oggle
        pause = "<leader>mp", -- [m]usic [p]ause
        stop = "<leader>ms", -- [m]usic [s]top
        info = "<leader>mi", -- [m]usic [i]nfo
        volume_up = "<leader>m+",
        volume_down = "<leader>m-",
      },
    })

    -- Debug: Print registered keymaps
    vim.notify("CodeRadio setup complete", vim.log.levels.INFO)
  end,

  -- Alternative: Manual keymaps (uncomment if you prefer custom bindings)
  -- keys = {
  --   { "<leader>mt", "<cmd>CodeRadioToggle<cr>", desc = "Toggle Code Radio" },
  --   { "<leader>mi", "<cmd>CodeRadioInfo<cr>", desc = "Code Radio Info" },
  --   { "<leader>ms", "<cmd>CodeRadioStop<cr>", desc = "Stop Code Radio" },
  -- },
}
