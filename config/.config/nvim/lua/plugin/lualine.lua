return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',

    config = function()
        local colors = {
            bg = '#282828',
            fg = '#ebdbb2',
            yellow = '#d79921',
            cyan = '#689d6a',
            green = '#98971a',
            orange = '#d65d0e',
            magenta = '#b16286',
            blue = '#458588',
            red = '#cc241d',
        }


        local function diff_source()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
                return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed
                }
            end
        end

        local function lsp_client_names()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return '' end

            local names = {}
            for _, client in ipairs(clients) do
                table.insert(names, client.name)
            end
            return ' ' .. table.concat(names, ', ')
        end

        local function macro_recording()
            local reg = vim.fn.reg_recording()
            if reg ~= '' then
                return '󰑋 @' .. reg
            end
            return ''
        end

        local function cwd_path_relative()
            local cwd = vim.fn.getcwd()
            local buff_path = vim.fn.expand('%:h')
            local buff_name = vim.fn.expand('%:t')

            -- if oil buffer, display full buffer path
            if string.find(buff_path, '^' .. cwd) then
                local res = string.sub(buff_path, #cwd + 1)
                res = (res ~= '') and res .. '/' .. buff_name or buff_name
                return res
            end

            if vim.b.current_syntax == 'oil' then
                local res = vim.fn.substitute(buff_path, "^oil:[/][/]", "", "g")
                return res
            end

            return buff_name
        end

        require('lualine').setup({
            options = {
                theme = 'gruvbox',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { 'dashboard', 'alpha', 'snacks_dashboard' },
                },
            },

            sections = {
                lualine_a = {
                    { 'mode', separator = { left = '' }, right_padding = 2 },
                },

                lualine_b = {
                    { 'branch', icon = '' },
                    {
                        'diff',
                        source = diff_source,
                        symbols = { added = ' ', modified = ' ', removed = ' ' },
                        colored = true,
                    },
                },

                lualine_c = {
                    { cwd_path_relative },
                    { macro_recording,  color = { fg = colors.orange } },
                },

                lualine_x = {
                    {
                        'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        symbols = {
                            error = ' ',
                            warn = ' ',
                            info = ' ',
                            hint = '󰌵 ',
                        },
                    },
                    { lsp_client_names, color = { fg = colors.cyan } },
                    { 'filetype',       icon_only = true },
                },

                lualine_y = {
                    { 'encoding',   show_bomb = true },
                    { 'fileformat', symbols = { unix = '', dos = '', mac = '' } },
                    { 'progress' },
                },

                lualine_z = {
                    { 'location', separator = { right = '' }, left_padding = 2 },
                },
            },

            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },

            extensions = { 'neo-tree', 'fugitive', 'trouble', 'lazy', 'oil' },
        })
    end,
}
