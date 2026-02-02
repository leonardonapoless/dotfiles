return {
    'L3MON4D3/LuaSnip',
    dependencies = {
        'saadparwaiz1/cmp_luasnip',
    },
    config = function()
        local ls = require('luasnip')


        require('luasnip.loaders.from_lua').lazy_load({
            paths = vim.fn.stdpath('config') .. '/lua/luasnippets'
        })


        require('luasnip.loaders.from_vscode').lazy_load({
            paths = vim.fn.stdpath('config') .. '/snippets'
        })


        vim.keymap.set({ "i", "s" }, "<C-k>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true, desc = "Snippet: Expand or jump forward" })

        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true, desc = "Snippet: Jump backward" })

        vim.keymap.set("i", "<C-l>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true, desc = "Snippet: Cycle through choices" })


        ls.config.set_config({
            history = true,                            -- Keep around last snippet for easy navigation
            updateevents = "TextChanged,TextChangedI", -- Update dynamic nodes as you type
            enable_autosnippets = true,
            store_selection_keys = "<Tab>",            -- For visual placeholder selection
        })
    end,
}
