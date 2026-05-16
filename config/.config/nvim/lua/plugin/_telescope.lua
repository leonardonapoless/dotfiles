local km = vim.keymap.set

return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = false,
    priority = 100,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')
        local telescope = require('telescope')

        telescope.setup {
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-y>"] = function(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            vim.api.nvim_command('let @" = @' .. selection.value)
                        end,
                        ["<M-q>"] = 'send_selected_to_qflist',
                        ["<C-Q>"] = 'send_to_qflist',
                    },
                    n = {
                        ["<M-q>"] = 'send_selected_to_qflist',
                        ["<C-Q>"] = 'send_to_qflist',
                    }
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        initial_mode = "normal",
                    }
                }
            }
        }

        telescope.load_extension("ui-select")

        -- Transparency
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                local hl = vim.api.nvim_set_hl
                hl(0, "TelescopeNormal", { bg = "none" })
                hl(0, "TelescopeBorder", { bg = "none" })
                hl(0, "TelescopePromptNormal", { bg = "none" })
                hl(0, "TelescopePromptBorder", { bg = "none" })
                hl(0, "TelescopeResultsNormal", { bg = "none" })
                hl(0, "TelescopeResultsBorder", { bg = "none" })
                hl(0, "TelescopePreviewNormal", { bg = "none" })
                hl(0, "TelescopePreviewBorder", { bg = "none" })
            end,
        })

        km("n", "<leader>ff", ":Telescope find_files<CR>")
        km("n", "<leader>fl", ":Telescope live_grep<CR>")
        km("n", "<leader>fm", ":Telescope marks<CR>")
        km("n", "<leader>fr", ":Telescope registers<CR>")
        km("n", "<leader>fb", ":Telescope buffers<CR>")

        km("n", "<leader>gb", ":Telescope git_branches<CR>")
        km("n", "<leader>gc", ":Telescope git_commits<CR>")
        km("n", "<leader>gs", ":Telescope git_status<CR>")

        km("n", "<leader>fh", ":Telescope current_buffer_fuzzy_find<CR>")
    end
}
