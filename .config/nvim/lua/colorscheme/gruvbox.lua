 return {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
        -- Set contrast to 'hard' for a deeper, less muddy dark
        vim.g.gruvbox_material_background = 'hard'
        
        -- Enable better performance
        vim.g.gruvbox_material_better_performance = 1
        
        -- Transparent background as requested for polish
        vim.g.gruvbox_material_transparent_background = 1
        
        -- Disable the green-heavy original palette in favor of the 'material' one
        vim.g.gruvbox_material_foreground = 'material'
        
        -- Enable italics
        vim.g.gruvbox_material_enable_italic = 1
        
        vim.cmd("colorscheme gruvbox-material")
        
        -- Override String highlight to Off-White (Neutral Beige)
        -- Prevents "green code" and blends strings with normal text.
        vim.api.nvim_set_hl(0, "String", { fg = "#ebdbb2" })
        
        -- Override Function/Method highlights to Off-White (remove "green code" for functions)
        vim.api.nvim_set_hl(0, "Function", { fg = "#ebdbb2" })
        vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })
        vim.api.nvim_set_hl(0, "@method.call", { link = "Function" })
    end,
}
