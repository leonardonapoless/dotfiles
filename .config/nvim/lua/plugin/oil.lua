
return {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()

        Exit_to_file_path = function()
            local current_file_path = vim.fn.expand('%:p:h')

            if current_file_path == '' or current_file_path == nil then return end
            current_file_path = vim.fn.substitute(current_file_path, "^oil:[/][/]","","g")

            local file_nvim_quit = io.open(os.getenv("HOME") .. "/.file_nvim_quit", "w")
            if file_nvim_quit then
                file_nvim_quit:write(current_file_path)
                file_nvim_quit:close()
            end

            vim.cmd('qa!')
        end

        local function pwc()
            local current_file_path = vim.fn.expand('%:p:h')
            current_file_path = vim.fn.substitute(current_file_path, "^oil:[/][/]","","g")
            vim.fn.setreg('+', current_file_path)
            print("Current folder path copied to clipboard")
        end

        local function pg()
            -- get current clipboard contents
            -- oil cd to that directory if on oil buffer
            local clipboard = vim.fn.getreg('+')
            clipboard = vim.fn.substitute(clipboard, [[\_s$]],"","g")
            require("oil").open(clipboard)
        end


        local function telescope_goto_folder()
            local cwd 			= vim.fn.getcwd()
            local actions 		= require("telescope.actions")
            local action_state 	= require("telescope.actions.state")
            local pickers 		= require("telescope.pickers")
            local finders 		= require("telescope.finders")
            local config 		= require("telescope.config").values


            pickers.new({}, {
                prompt_title = "Go to folder",
                finder = finders.new_oneshot_job({ "fd", "-t", "d", "--hidden", "--exclude", ".git"}, { cwd = vim.fn.getcwd() }),
                sorter = config.generic_sorter({}),

                attach_mappings = function(prompt_bufnr, _)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local results = vim.fn.getcwd().."/"..action_state.get_selected_entry()[1]
                        require("oil").open(results)
                    end)
                    print(vim.inspect(action_state.get_selected_entry()))
                    return true
                end,
            }):find()
        end


        local function telescope_goto_file_folder()
            local cwd 			= vim.fn.getcwd()
            local actions 		= require("telescope.actions")
            local action_state 	= require("telescope.actions.state")
            local pickers 		= require("telescope.pickers")
            local finders 		= require("telescope.finders")
            local config 		= require("telescope.config").values


            pickers.new({}, {
                prompt_title = "Go to file folder",
                finder = finders.new_oneshot_job({ "fd", "--hidden", "--exclude", ".git" }, { cwd = vim.fn.getcwd() }),
                sorter = config.generic_sorter({}),

                -- s/[/][^/]\+$//g
                attach_mappings = function(prompt_bufnr, _)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)

                        local pick = action_state.get_selected_entry()[1]
                        pick = vim.fn.substitute(pick, [[[/][^/]\+$]], "", "g" )

                        local results = vim.fn.getcwd().."/"..pick
                        require("oil").open(results)
                    end)
                    print(vim.inspect(action_state.get_selected_entry()))
                    return true
                end,
            }):find()
        end

        vim.g.oil_toggle = false
        local function oil_toggle_full_view()

            local oil = require('oil')
            if not vim.g.oil_toggle then
                oil.set_columns({ "icon", "permissions", "size", "mtime" })
                vim.g.oil_toggle=true
                return
            end
            oil.set_columns({ "icon" })
            vim.g.oil_toggle=false

        end


        require("oil").setup({
            default_file_explorer = true,

            columns = { -- all possible options are listed below
                "icon",
                --'size',
                --'mtime',
                --'ctime',
                --'atime',
                --'birthtime',
                --'permissions',
            },
            buf_options = {
                buflisted = false,
                bufhidden = "hide",
            },
            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
            delete_to_trash = false,
            skip_confirm_for_simple_edits = false,
            prompt_save_on_select_new_entry = true,
            cleanup_delay_ms = 2000,
            lsp_file_methods = {
                enabled = true,
                timeout_ms = 1000,
                autosave_changes = false,
            },
            constrain_cursor = "editable",
            -- attention: might cause problems
            watch_for_changes = true,
            keymaps = {
                ["<leader>pg"] = function() pg() end,
                ["<leader>pwc"] = function() pwc() end,
                ["<leader>="] = function() telescope_goto_folder() end,
                ["<leader>-"] = function() telescope_goto_file_folder() end,
                ["<CR>"] = "actions.select",
                ["<C-s>"] = function() oil_toggle_full_view() end,

                -- Opens the file in a external program (system default for filetype)
                ----- this is huge
                ["<C-CR>"] = "actions.open_external", 

                --["<C-s>"] = "actions.select_vsplit",
                --["<C-h>"] = "actions.select_split",
                --["<C-t>"] = "actions.select_tab",
                --["<C-p>"] = "actions.preview",
                ["g?"] = "actions.show_help",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd", -- Goes to the dir saved by "="
                ["="] = "actions.cd",		-- Saves a dir
                ["+"] = "actions.tcd",
                ["~"] = false,
                ["`"] = false,
                ["gs"] = "actions.change_sort",


                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            use_default_keymaps = true,
            view_options = {
                show_hidden = true,
                is_hidden_file = function(name, bufnr)
                    return vim.startswith(name, ".")
                end,
                is_always_hidden = function(name, bufnr)
                    return false
                end,
                natural_order = true,
                sort = {
                    { "type", "asc" },
                    { "name", "asc" },
                },
            },
            extra_scp_args = {},
            git = {
                add = function(path)
                    return false
                end,
                mv = function(src_path, dest_path)
                    return false
                end,
                rm = function(path)
                    return false
                end,
            },
            float = {
                padding = 2,
                max_width = 0,
                max_height = 0,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
                override = function(conf)
                    return conf
                end,
            },
            preview = {
                max_width = 0.9,
                min_width = { 40, 0.4 },
                width = nil,
                max_height = 0.9,
                min_height = { 5, 0.1 },
                height = nil,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
                update_on_cursor_moved = true,
            },
            progress = {
                max_width = 0.9,
                min_width = { 40, 0.4 },
                width = nil,
                max_height = { 10, 0.9 },
                min_height = { 5, 0.1 },
                height = nil,
                border = "rounded",
                minimized_border = "none",
                win_options = {
                    winblend = 0,
                },
            },
            ssh = {
                border = "rounded",
            },
            keymaps_help = {
                border = "rounded",
            },
        })



        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        vim.keymap.set("n", "<leader>vp", "<CMD>Oil<CR>", { desc = "Open parent directory" })

    end
}
