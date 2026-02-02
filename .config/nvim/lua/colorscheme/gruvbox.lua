return {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_background = 'hard'

        vim.g.gruvbox_material_better_performance = 1

        vim.g.gruvbox_material_transparent_background = 1

        vim.g.gruvbox_material_foreground = 'material'

        vim.g.gruvbox_material_enable_italic = 1

        vim.cmd("colorscheme gruvbox-material")

        -- Prevents "green code" and blends strings with normal text.
        vim.api.nvim_set_hl(0, "String", { fg = "#ebdbb2" })

        -- Override Function/Method highlights to Off-White (remove "green code" for functions)
        vim.api.nvim_set_hl(0, "Function", { fg = "#ebdbb2" })
        vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })
        vim.api.nvim_set_hl(0, "@method.call", { link = "Function" })
    end,
}
