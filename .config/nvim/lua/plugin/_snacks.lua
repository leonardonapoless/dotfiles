local km = vim.keymap.set

local snacks_autocmd_group = vim.api.nvim_create_augroup("snacks_custom", { clear = true })
vim.api.nvim_create_autocmd(
    { "FileType", "BufFilePost" },
    {
        group = snacks_autocmd_group,
        pattern = '*',
        callback = function(args)
            local ignore = {
                markdown = true,
            }

            if (ignore[vim.bo[args.buf].filetype] == true) then
                vim.b[args.buf].snacks_indent = false
            end

            -- vim.notify('callback: '..args.buf..'  -   '..vim.bo[args.buf].filetype)
        end,
    })

km('n', '<leader><CR>', function() require('snacks').notifier.show_history() end)
-- vim.cmd('set scrolloff=0')

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        local snacks = require('snacks')
        snacks.setup({
            indent = {
                priority = 1,
                enabled = true,
                char = "▏",
                only_scope = false,
                only_current = false,
                hl = "SnacksIndent",
            },
            animate = {
                enabled = false,
                style = "out",
                easing = "linear",
                duration = {
                    step = 20,
                    total = 500,
                },
            },
            scope = {
                enabled = true,
                priority = 200,
                char = "▏",
                underline = false,
                only_current = false,
                hl = "SnacksIndentScope",
            },
            chunk = {
                enabled = false,
                only_current = false,
                priority = 200,
                hl = "SnacksIndentChunk",
                char = {
                    corner_top = "┌",
                    corner_bottom = "└",
                    horizontal = "─",
                    vertical = "│",
                    arrow = ">",
                },
            },
            notifier = {
                enabled = true,
            },
            scroll = {
                enabled = false,
                animate = {
                    duration = { step = 100, total = 200 },
                    easing = "linear",
                },
                -- faster animation when repeating scroll after delay
                animate_repeat = {
                    delay = 70,
                    duration = { step = 5, total = 50 },
                    easing = "linear",
                },
            },
            dashboard = {
                enabled = true,
                preset = {
                    header = [[
       NEVIM 

      Think Different.
                        ]],
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
        })

        -- Replaces global Notify function
        Notify = function(string, priority, opts)
            opts = (type(opts) == 'table') and opts or {}
            priority = priority or 6
            opts['title'] = opts['title'] or 'Notify'

            snacks.notifier(string, priority, opts)
        end
    end

}
