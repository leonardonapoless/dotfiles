return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        {
            'L3MON4D3/LuaSnip',
            version = 'v2.*',
            dependencies = { 'rafamadriz/friendly-snippets' },
        },
        'saadparwaiz1/cmp_luasnip',
        'onsails/lspkind.nvim',
    },

    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local lspkind = require('lspkind')

        require('luasnip.loaders.from_vscode').lazy_load()
        -- Load custom JUCE snippets
        require('luasnip.loaders.from_vscode').lazy_load({
            paths = { vim.fn.stdpath('config') .. '/snippets' }
        })

        -- Custom Snippets (Manual definitions to ensure availability)
        local ls = require('luasnip')
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local fmt = require("luasnip.extras.fmt").fmt

        ls.add_snippets("swift", {
            -- Protocol
            s("protocol", fmt(
                [[
protocol {} {{
    {}
}}
                ]], { i(1, "Name"), i(0) }
            )),

            -- Extension
            s("ext", fmt(
                [[
extension {} {{
    {}
}}
                ]], { i(1, "Type"), i(0) }
            )),

            -- Class
            s("class", fmt(
                [[
class {} {{
    {}
}}
                ]], { i(1, "Name"), i(0) }
            )),

            -- Struct
            s("struct", fmt(
                [[
struct {} {{
    {}
}}
                ]], { i(1, "Name"), i(0) }
            )),

            -- Guard
            s("guard", fmt(
                [[
guard {} else {{ return {} }}
                ]], { i(1, "condition"), i(0) }
            )),
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer',  keyword_length = 3 },
                { name = 'path' },
            }),

            mapping = cmp.mapping.preset.insert({
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Auto-select first item
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),

            formatting = {
                format = function(entry, vim_item)
                    local kind_icons = {
                        Text = "",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "",
                        Field = "󰇽",
                        Variable = "󰂡",
                        Class = "󰠱",
                        Interface = "",
                        Module = "",
                        Property = "󰜢",
                        Unit = "",
                        Value = "󰎠",
                        Enum = "",
                        Keyword = "󰌋",
                        Snippet = "",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "",
                        Folder = "󰉋",
                        EnumMember = "",
                        Constant = "󰏿",
                        Struct = "",
                        Event = "",
                        Operator = "󰆕",
                        TypeParameter = "󰅲",
                    }
                    -- Kind icons
                    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
                    -- Source
                    vim_item.menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[LaTeX]",
                    })[entry.source.name]
                    return vim_item
                end,
            },

            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
        })
    end,
}
