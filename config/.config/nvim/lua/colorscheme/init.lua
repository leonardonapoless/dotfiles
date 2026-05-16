-- Theme Switcher: toggle between noir (B&W) and gruvbox-material
-- Persists choice to ~/.cache/nvim/theme_choice

local M = {}

M.themes = { "noir", "gruvbox-material" }
M.cache_file = vim.fn.stdpath("cache") .. "/theme_choice"

function M.get_saved_theme()
    local ok, content = pcall(vim.fn.readfile, M.cache_file)
    if ok and content[1] and vim.tbl_contains(M.themes, content[1]) then
        return content[1]
    end
    -- return "noir" -- default
    return "gruvbox-material"

    -- use this command to clear the cache file: rm ~/.cache/nvim/theme_choice
    -- :lua vim.fn.delete(vim.fn.stdpath("cache") .. "/theme_choice")
end

function M.save_theme(name)
    local cache_dir = vim.fn.stdpath("cache")
    vim.fn.mkdir(cache_dir, "p")
    vim.fn.writefile({ name }, M.cache_file)
end

local function configure_gruvbox()
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_transparent_background = 1
    vim.g.gruvbox_material_foreground = 'material'
    vim.g.gruvbox_material_enable_italic = 1
end

local function gruvbox_overrides()
    vim.api.nvim_set_hl(0, "String", { fg = "#ebdbb2" })
    vim.api.nvim_set_hl(0, "Function", { fg = "#ebdbb2" })
    vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })
    vim.api.nvim_set_hl(0, "@method.call", { link = "Function" })
end

function M.apply_theme(name)
    if name == "gruvbox-material" then
        configure_gruvbox()
        vim.cmd("colorscheme gruvbox-material")
        gruvbox_overrides()
    else
        -- noir doesn't need pre-config, just load it
        require("colorscheme.noir").setup()
        vim.g.colors_name = "noir"
    end
    M.save_theme(name)
end

function M.apply_saved_theme()
    M.apply_theme(M.get_saved_theme())
end

function M.toggle()
    local current = M.get_saved_theme()
    local idx = 1
    for i, t in ipairs(M.themes) do
        if t == current then
            idx = i
            break
        end
    end
    local next_idx = (idx % #M.themes) + 1
    local next_theme = M.themes[next_idx]
    M.apply_theme(next_theme)
    vim.notify("Theme: " .. next_theme, vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>tt", function()
    require("colorscheme").toggle()
end, { desc = "Toggle Theme (noir ↔ gruvbox)" })

return M
