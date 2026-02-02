return {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
        {

            "<leader>lE",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {

            "<leader>le",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {

            "<leader>ls",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {

            "<leader>ld",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {

            "<leader>lo",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {

            "<leader>q",
            "<cmd>Trouble qflist toggle<cr>",
            -- function() vim.cmd("Trouble qflist toggle"); vim.api.nvim_feedkeys([[j]],"t",false) end
            desc = "Quickfix List (Trouble)",

        },
    },
}
