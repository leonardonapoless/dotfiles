
--
-- If you need a tutorial, watch this video
-- https://www.youtube.com/watch?v=FuYQ7M73bC0&t=58s
--

-- Overall, i think all motions implemented in this
-- plugin are extremely unreliable. They might work in
-- on language but not on another. Or worse, they may have
-- very different behaviours from one language to another.

return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = false,
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    priority = 100,
    config = function()
        require'nvim-treesitter.configs'.setup {
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['ap'] = '@parameter.outer',
                        ['ip'] = '@parameter.inner',

                        ['ii'] = '@conditional.inner',
                        ['ai'] = '@conditional.outer',

                        ['as'] = '@block.outer',
                        ['is'] = '@block.inner',
                        --["as"] = { query = "@local.scope.inner", query_group = "locals", desc = "Select language scope" },

                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",

                        ["ac"] = "@class.outer",
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },

                        -- ["iz"] = { query = "@fold.inner", query_group = "folds"},
                        ["az"] = { query = "@fold", query_group = "folds"},


						-- unreliable
						-- for instance, it doesn't work in assignments inside lua tables
						["a="] = { query = "@assignment.outer" },
						["i="] = { query = "@assignment.inner" },
						["l="] = { query = "@assignment.lhs" },
						["r="] = { query = "@assignment.rhs" },
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    include_surrounding_whitespace = false, -- currently experimenting with it
                },

                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        -- ["]m"] = "@function.outer",
                        -- ["]]"] = { query = "@class.outer", desc = "Next class start" },
                        -- ["]o"] = "@loop.*",
                        -- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                        -- ["[s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
						["[z"] = { query = "@fold", query_group = "folds"},
                        ["[s"] = { query = "@block.outer"},
                        ["[f"] = "@function.outer",
                        ["[i"] = "@conditional",
                    },
					goto_previous_start = {
						["]z"] = { query = "@fold", query_group = "folds"},
						["]s"] = { query = "@block.outer"},
						["]f"] = "@function.outer",
						["]i"] = "@conditional",
						-- ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Previous scope" },
						-- ["[f"] = "@function.outer",
						-- ["[["] = "@class.outer",
					},
                    goto_next_end = {
                        -- ["]S"] = { query = "@local.scope", query_group = "locals", desc = "Previous scope" },
                        -- ["]f"] = "@function.outer",
                        -- ["]["] = "@class.outer",
                    },
                    goto_previous_end = {
                        -- ["]S"] = { query = "@local.scope", query_group = "locals", desc = "Previous scope" },
                        -- ["[M"] = "@function.outer",
                        -- ["[]"] = "@class.outer",
                    },
                    goto_next = {
                        --["[f"] = "@function.outer",
                        --["[c"] = "@conditional",
                    },
					goto_previous = {
						--["]f"] = "@function.outer",
						--["]c"] = "@conditional",
					}
                },
            },
        }
    end
}
