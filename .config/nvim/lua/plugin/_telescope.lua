return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy =  false,
    priority = 100,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()

        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')
        require('telescope').setup{

            defaults = {
                mappings = {

                    i = {
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
            } -- End

        }

        km("n", "<leader>ff", 	":Telescope find_files<CR>") 	-- finds a file and opens it
        km("n", "<leader>fl", 	":Telescope live_grep<CR>") 	-- finds files that contain the search
        km("n", "<leader>fm", 	":Telescope marks<CR>") 		-- finds <<MARKS>>
        km("n", "<leader>fr", 	":Telescope registers<CR>") 	-- lets you select a register
        km("n", "<leader>fb", 	":Telescope buffers<CR>") 		-- finds and opens a buffer

        km("n", "<leader>fh", 	":Telescope current_buffer_fuzzy_find<CR>") 		-- finds files that contain a ripgrep match

    end
}
