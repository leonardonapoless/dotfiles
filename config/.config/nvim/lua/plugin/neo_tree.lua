
return {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'stevearc/oil.nvim'
    },
    keys = {
        {"<leader>pv", ":Neotree toggle<cr>", mode = 'n'}
    },
    cmd = {
        'Neotree'
    },
    config = function()
        require("neo-tree").setup({
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(arg) vim.cmd [[ setlocal relativenumber ]] end,
                }
            },
            window = {
                position = "left",
                width = 40,
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                mappings = {
                    ["<space>"] = {
                        "toggle_node",
                        nowait = false,
                    },
                    ["<2-LeftMouse>"] = "open",
                    ["<cr>"] = "open",
                    ["<esc>"] = "cancel",
                    ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                    ["l"] = "focus_preview",

                    ["S"] = function() require('leap').leap { backward = true } end,
                    ["s"] = function() require('leap').leap { backward = false } end,
                    ["t"] = "open_tabnew",
                    ["w"] = "open_with_window_picker",
                    ["C"] = "close_node",
                    ["z"] = "close_all_nodes",
                    ["a"] = {
                        "add",
                        config = {
                            show_path = "none",
                        },
                    },
                    ["A"] = "add_directory",
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["b"] = "rename_basename",
                    ["y"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["c"] = "copy",
                    ["m"] = "move",
                    ["q"] = "close_window",
                    ["R"] = "refresh",
                    ["?"] = "show_help",
                    ["<"] = "prev_source",
                    [">"] = "next_source",
                    ["i"] = "show_file_details",
                },
            },

        })

    end
}
