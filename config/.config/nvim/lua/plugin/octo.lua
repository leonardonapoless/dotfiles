return {
    'pwntester/octo.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    cmd = { "Octo" },
    keys = {
        { "<leader>gi", "<cmd>Octo issue list<cr>", mode = "n", desc = "GitHub: List Issues" },
        { "<leader>gp", "<cmd>Octo pr list<cr>",    mode = "n", desc = "GitHub: List PRs" },
        { "<leader>gr", "<cmd>Octo search<cr>",     mode = "n", desc = "GitHub: Search" },
    },
    config = function()
        require("octo").setup({
            suppress_missing_scope = {
                projects_v2 = true,
            }
        })
    end
}
