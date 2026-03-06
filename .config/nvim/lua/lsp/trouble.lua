return {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
        {
            -- trouble diagnostics
            "<leader>lE",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            -- trouble diagnostics here
            "<leader>le",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            -- trouble symbols
            "<leader>ls",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            -- trouble definitions
            "<leader>ld",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            -- trouble loclist
            "<leader>lo",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            -- trouble quickfix
            "<leader>q",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
        {
            "grr",
            function()
                vim.lsp.buf.references(nil, {
                    on_list = function(options)
                        vim.fn.setqflist({}, ' ', options)
                        vim.cmd("Trouble qflist open")
                    end
                })
            end,
            desc = "Opens Lsp references with Trouble.nvim",
        }
    },
}
