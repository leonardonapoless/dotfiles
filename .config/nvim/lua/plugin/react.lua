--[[
    React/JSX Enhancement Plugins
    
    Provides:
    - Auto-close JSX tags (<div> → <div></div>)
    - Auto-rename tags (change opening tag, closing updates)
    - Emmet support in JSX (div.container → <div className="container">)
]]--

return {
    -- Auto-close and auto-rename HTML/JSX tags
    {
        'windwp/nvim-ts-autotag',
        event = 'InsertEnter',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('nvim-ts-autotag').setup({
                opts = {
                    enable_close = true,          -- Auto close tags
                    enable_rename = true,         -- Auto rename pairs
                    enable_close_on_slash = true, -- Auto close on </
                },
                filetypes = {
                    'html', 'xml',
                    'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
                    'svelte', 'vue', 'tsx', 'jsx',
                    'markdown',
                    'php',
                    'astro', 'glimmer', 'handlebars',
                },
            })
        end,
    },
    
    -- Auto pairs for brackets, quotes, etc.
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        dependencies = { 'hrsh7th/nvim-cmp' },
        config = function()
            local autopairs = require('nvim-autopairs')
            autopairs.setup({
                check_ts = true,  -- Use treesitter
                ts_config = {
                    lua = { 'string' },
                    javascript = { 'template_string' },
                    javascriptreact = { 'template_string', 'jsx_element' },
                    typescriptreact = { 'template_string', 'jsx_element' },
                },
                fast_wrap = {
                    map = '<M-e>',  -- Option+e to wrap with pair
                    chars = { '{', '[', '(', '"', "'" },
                    pattern = [=[[%'%"%>%]%)%}%,]]=],
                    end_key = '$',
                    keys = 'qwertyuiopzxcvbnmasdfghjkl',
                    check_comma = true,
                    manual_position = true,
                    highlight = 'Search',
                    highlight_grey = 'Comment',
                },
            })
            
            -- Integrate with nvim-cmp
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },
    
    -- Emmet support for HTML/CSS/JSX expansion
    -- Example: div.container>ul>li*3 → expands to full HTML
    {
        'mattn/emmet-vim',
        ft = { 
            'html', 'css', 'scss', 'less',
            'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
            'vue', 'svelte', 'astro',
        },
        init = function()
            -- Enable emmet only in insert mode
            vim.g.user_emmet_mode = 'i'
            
            -- Leader key for emmet (default is Ctrl+y)
            vim.g.user_emmet_leader_key = '<C-z>'
            
            -- Enable JSX support
            vim.g.user_emmet_settings = {
                javascript = { extends = 'jsx' },
                javascriptreact = { extends = 'jsx' },
                typescript = { extends = 'jsx' },
                typescriptreact = { extends = 'jsx' },
            }
        end,
    },
}
