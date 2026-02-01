--[[
    Which-Key Configuration
    
    Shows available keybindings in a popup when you press a key and wait.
    Essential for discovering and remembering keybindings.
    
    Press <leader> and wait to see all leader key mappings.
    Press any incomplete binding and wait to see completions.
]]--

return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 20,
            },
            presets = {
                operators = true,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        
        win = {
            border = 'rounded',
            padding = { 2, 2, 2, 2 },
        },
        
        -- Icons
        icons = {
            breadcrumb = '»',
            separator = '➜',
            group = '+',
        },
        
        -- Delay before showing popup (ms)
        delay = 300,
        
        -- Popup layout
        layout = {
            height = { min = 4, max = 25 },
            width = { min = 20, max = 50 },
            spacing = 3,
            align = 'left',
        },
    },
    
    config = function(_, opts)
        local wk = require('which-key')
        wk.setup(opts)
        
        -- Register key group labels
        wk.add({
            -- Leader key groups
            { '<leader>f',  group = 'Find/Files' },
            { '<leader>l',  group = 'LSP' },
            { '<leader>h',  group = 'Harpoon/Here' },
            { '<leader>g',  group = 'Git' },
            { '<leader>t',  group = 'Tab/Terminal' },
            { '<leader>w',  group = 'Write/Workspace' },
            { '<leader>c',  group = 'Code/Comments' },
            { '<leader>a',  group = 'Register A' },
            { '<leader>b',  group = 'Buffer' },
            { '<leader>s',  group = 'Spell' },
            { '<leader>r',  group = 'Rename/Remove' },
            
            -- g prefix
            { 'g',          group = 'Go to...' },
            { 'gd',         desc = 'Definition' },
            { 'gD',         desc = 'Declaration' },
            { 'gi',         desc = 'Implementation' },
            { 'gr',         desc = 'References' },
            { 'gt',         desc = 'Type definition' },
            
            -- [ and ] prefix (diagnostic navigation)
            { '[',          group = 'Previous...' },
            { '[d',         desc = 'Previous diagnostic' },
            { ']',          group = 'Next...' },
            { ']d',         desc = 'Next diagnostic' },
            
            -- z prefix
            { 'z',          group = 'Fold/Scroll/Spell' },
        })
    end,
}
