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


        icons = {
            breadcrumb = '»',
            separator = '➜',
            group = '+',
        },

        delay = 300,

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


        wk.add({
            -- Leader key groups
            { '<leader>f', group = 'Find/Files' },
            { '<leader>l', group = 'LSP' },
            { '<leader>h', group = 'Harpoon/Here' },
            { '<leader>h', group = 'Harpoon/Here' },
            { '<leader>g', group = 'Git' },
            { '<leader>t', group = 'Tab/Terminal' },
            { '<leader>t', group = 'Tab/Terminal' },
            { '<leader>w', group = 'Write/Workspace' },
            { '<leader>c', group = 'Code/Comments' },
            { '<leader>a', group = 'Register A' },
            { '<leader>b', group = 'Buffer' },
            { '<leader>s', group = 'Spell/Search' },
            { '<leader>r', group = 'Run/Execute' },
            { '<leader>d', group = 'Debug' },
            { '<leader>j', group = 'Java' },
            { '<leader>u', group = 'UI/Toggle' },
            { '<leader>y', group = 'Yank' },

            -- g prefix
            { 'g',         group = 'Go to...' },
            { 'gd',        desc = 'Definition' },
            { 'gD',        desc = 'Declaration' },
            { 'gi',        desc = 'Implementation' },
            { 'gr',        desc = 'References' },
            { 'gt',        desc = 'Type definition' },

            -- [ and ] prefix (diagnostic navigation)
            { '[',         group = 'Previous...' },
            { '[d',        desc = 'Previous diagnostic' },
            { '[q',        desc = 'Previous quickfix' },
            { ']',         group = 'Next...' },
            { ']d',        desc = 'Next diagnostic' },
            { ']q',        desc = 'Next quickfix' },

            -- z prefix
            { 'z',         group = 'Fold/Scroll/Spell' },
        })
    end,
}
