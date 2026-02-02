return {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
    lazy = false,
    dependencies = {},
    priority = 100,
    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = {
                "javascript", "html", "css", "python", "go", "c", "lua",
                "vim", "vimdoc", "query", "bash", "json",
                "typescript", "tsx",
                "swift",
                "cpp",
                "odin",
                "java",
                "scss",
                "markdown", "markdown_inline",
                "toml", "yaml",
            },

            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }

        vim.o.foldmethod = 'expr'
        vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
        vim.o.foldlevelstart = 99
    end
}
