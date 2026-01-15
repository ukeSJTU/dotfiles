-- Typst support: syntax highlighting, LSP, and live preview
--
-- This file adds support for a new language to Neovim.
-- For Typst, we need 3 components:
--   1. Syntax highlighting (tree-sitter)[./core.lua]
--   2. Language server (LSP - Tinymist)[https://github.com/Myriad-Dreamin/tinymist]
--   3. Live preview (typst-preview.nvim)[https://github.com/chomosuke/typst-preview.nvim]

return {
  --[[ ============================================================================
       COMPONENT 1: Syntax Highlighting (Tree-sitter)
       ============================================================================

       Tree-sitter provides advanced syntax highlighting and code parsing.

       ✅ Already configured in lua/plugins/core.lua
       ✅ Has auto_install = true, so the typst parser will install automatically

       How it works:
       - When you open a .typ file, nvim-treesitter detects it
       - If the parser isn't installed, it auto-downloads it
       - You can manually install: :TSInstall typst
       - Check installed parsers: :TSModuleInfo

       Learn more:
       - :help nvim-treesitter
       - Look at lua/plugins/core.lua lines 5-17 to see the config

       No action needed here! Move on to Component 2.
  ]]

  --[[ ============================================================================
       COMPONENT 2: Language Server (Tinymist LSP)
       ============================================================================

       The LSP provides intelligent features like:
       - Code completion
       - Error diagnostics
       - Hover documentation
       - Go to definition
       - etc.

       How to add Tinymist:

       Option A - Let it install automatically (try this first!):
       1. Just open a .typ file
       2. Run :LspInfo to see if tinymist attached
       3. If not, proceed to Option B

       Option B - Manually add to lsp.lua:
       1. Open lua/plugins/lsp.lua
       2. Find the `servers` table (around line 210)
       3. Add this entry:

          tinymist = {},

       4. Save and restart Neovim
       5. Mason will auto-install tinymist
       6. Verify with :Mason

       For custom configuration later:
       - Read: https://myriad-dreamin.github.io/tinymist/frontend/neovim.html
       - Check: :help lspconfig-all
       - Pattern: Look at the lua_ls entry in lsp.lua as an example

       Example with custom settings:

       tinymist = {
         settings = {
           -- Your custom settings here
           -- See Tinymist docs for available options
         }
       },
  ]]

  --[[ ============================================================================
       COMPONENT 3: Live Preview
       ============================================================================

       This is the only plugin we need to explicitly add in this file!

       chomosuke/typst-preview.nvim provides:
       - Low-latency live preview
       - Cursor position sync
       - Click to jump between code and preview

       Below is the MINIMAL configuration - just enough to get it working.
  ]]

  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst', -- Only load when opening .typ files (lazy loading)
    version = '1.*', -- Use stable 1.x version
    opts = {}, -- Empty = use default settings

    --[[ Customization Guide:

         To customize, replace `opts = {}` with actual options.

         How to find options:
         1. Visit: https://github.com/chomosuke/typst-preview.nvim
         2. Read the "Configuration" section
         3. Look for the setup() example

         How to translate README to your config:
         - README shows: require('typst-preview').setup({ option = value })
         - In lazy.nvim: Put inside opts = { option = value }

         Example customizations:

         opts = {
           follow_cursor = true,  -- Preview follows your cursor position
           -- Add more options as you discover them in the README
         },

         Common lazy.nvim plugin keys you can use:
         - ft: File type trigger (we're using this)
         - cmd: Command trigger (e.g., cmd = 'TypstPreview')
         - keys: Keymap trigger (e.g., keys = { '<leader>tp' })
         - config: Custom setup function (for complex configuration)
         - dependencies: Other plugins this needs

         Learn more about lazy.nvim: :help lazy.nvim
    ]]
  },

  --[[ ============================================================================
       TESTING YOUR SETUP
       ============================================================================

       After saving this file and restarting Neovim:

       1. Check plugin status:
          :Lazy
          (Look for typst-preview.nvim)

       2. Create a test file:
          :e test.typ

       3. Add some Typst content:
          = Hello Typst
          This is a test.

       4. Check what's working:
          :TSModuleInfo    (Is typst parser installed?)
          :LspInfo         (Is tinymist attached?)
          :TypstPreview    (Does preview window open?)

       5. If something doesn't work:
          :checkhealth lazy
          :checkhealth nvim-treesitter
          :Mason           (Check if tinymist is installed)

       Debugging tips:
       - If tree-sitter isn't working: :TSInstall typst
       - If LSP isn't working: Add tinymist to lsp.lua (see Component 2 above)
       - If preview isn't working: Check the plugin's GitHub issues
  ]]

  --[[ ============================================================================
       NEXT STEPS - ITERATION AND LEARNING
       ============================================================================

       Now that you have basic Typst support, here's how to improve it:

       1. Read the plugin documentation
          - Visit the GitHub README
          - Look for "Configuration" or "Usage" sections
          - Check for example configurations

       2. Look at existing patterns in your config
          - Browse other files in lua/plugins/
          - See how they configure similar features
          - Copy patterns that make sense

       3. Test incrementally
          - Add ONE option at a time
          - Restart Neovim
          - Test if it works
          - Repeat

       4. Use Neovim's help system
          - :help <plugin-name>
          - :help lspconfig
          - :help lazy.nvim
          - Press K on a function to see its docs

       5. Common customizations to explore:
          - Add custom keymaps for :TypstPreview
          - Configure preview appearance/behavior
          - Add more LSP servers for other languages
          - Customize tree-sitter highlighting

       This is how you learn Neovim - one plugin at a time! 🚀
  ]]
}
