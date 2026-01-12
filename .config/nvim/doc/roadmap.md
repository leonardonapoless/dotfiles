# To-Start

- Fix: <leader>Y for "+Y
- Fix: Block_indent()
- Fix: Lua lsp on nixos
    - more about it (3rd answer): https://stackoverflow.com/questions/75880481/cant-use-lua-lsp-in-neovim
    - perhaps find a way to use system-installed lsp servers together with mason?
    - perhaps switching to the nixos unstable branch might fix it?

- Experiment: nvim-ufo
- Experiment: nvim-treesitter-context
- Experiment: LuaSnip
    - https://www.youtube.com/watch?v=FmHhonPjvvA

- Feature: Which key
    - add descriptions for every single remap
    - makes it so the plugin only loads if its set to
- Feature: Configure Neovim LSP integration without lsp0 (its currently deprecated)
- Feature: Add DAP debugger support

------
# In-progress

- Fix: neogit commit tab close behaviour

------
# Done
- Explore treesitter text objects for more useful motions
- ~Feat: add lualine~
    - ~https://github.com/nvim-lualine/lualine.nvim~
- Continue experimenting with snacks.nvim
- refactor: lazy load all possible plugins
- Feat: checks for linux install
- snacks.notify: add message title support; create custom notify function
- Fix: wilder.nvim python error
- ~Feat: better command mode autocomplete~
- Try: snacks.nvim
- Feature: install rainbow
    - https://github.com/luochen1990/rainbow
- Feature: indentation markers
    - Used snacks.nvim for this
- Feat: nvim-web-devicons
- Feat: keybind: serch across all files with ripgrep using telescope
- Feat: trouble.nvim
- Feature: terminal mode clear buffer function
- Fix: htew not working as expected on oil buffers. opening terminals at /tmp

