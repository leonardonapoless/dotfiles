
-- TODO: Lazy load this
return {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    init = function() vim.o.signcolumn = "yes" end,
    dependencies = {},
    config = function()
        local gitsings = require('gitsigns')
        gitsings.setup()


        require('gitsigns').setup{
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({']c', bang = true})
                    else
                        gitsigns.nav_hunk('next')
                    end
                end)

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({'[c', bang = true})
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end)

                -- Actions
                map('n', '<leader>ghs', gitsigns.stage_hunk)
                map('n', '<leader>ghr', gitsigns.reset_hunk)
                map('n', '<leader>ghu', gitsigns.undo_stage_hunk)
                map('v', '<leader>ghs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                map('v', '<leader>ghr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                map('n', '<leader>ghp', gitsigns.preview_hunk_inline)
                -- map('n', '<leader>gph', gitsigns.preview_hunk)

                map('n', '<leader>gsb', gitsigns.stage_buffer)
                map('n', '<leader>grb', gitsigns.reset_buffer)

                map('n', '<leader>gB', function() gitsigns.blame_line{full=true} end)
                map('n', '<leader>gb', gitsigns.toggle_current_line_blame)
                -- map('n', '<leader>ghd', gitsigns.diffthis)
                -- map('n', '<leader>ghD', function() gitsigns.diffthis('~') end)
                -- map('n', '<leader>gtd', gitsigns.toggle_deleted)

                -- Text object
                map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        }


    end -- END Config function 
}
