

local snacks_autocmd_group = vim.api.nvim_create_augroup("snacks_custom", {clear = true})
vim.api.nvim_create_autocmd(
    { "FileType", "BufFilePost"},
    {
		group = snacks_autocmd_group,
        pattern = '*',
        callback = function(args)

            local ignore = {
                markdown = true,
            }

            if(ignore[vim.bo[args.buf].filetype] == true) then
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
                    only_scope = false, -- only show indent guides of the scope
                    only_current = false, -- only show indent guides in the current window
                    hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
                },
                animate = {
                    enabled = false,
                    style = "out",
                    easing = "linear",
                    duration = {
                        step = 20, -- ms per step
                        total = 500, -- maximum duration
                    },
                },
                scope = {
                    enabled = true, -- enable highlighting the current scope
                    priority = 200,
                    char = "▏",
                    underline = false, -- underline the start of the scope
                    only_current = false, -- only show scope in the current window
                    hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
                },
                chunk = {
                    enabled = false,
                    only_current = false,
                    priority = 200,
                    hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
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
                        delay = 70, -- delay in ms before using the repeat animation
                        duration = { step = 5, total = 50 },
                        easing = "linear",
                    },
                },
            })

            -- Replaces global Notify function
            -- check out how to add a title to those messages
            Notify = function(string, priority, opts)
                opts = (type(opts)=='table') and opts or {}
                priority = priority or 6
                opts['title'] = opts['title'] or 'Notify'

                --fun(msg: string, level?: snacks.notifier.level|number, opts?: snacks.notifier.Notif.opts): number|string
                snacks.notifier(string, priority, opts)
            end

        end

    }

