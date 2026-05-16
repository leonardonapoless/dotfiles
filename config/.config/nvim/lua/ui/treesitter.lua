return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    lazy = false,
    dependencies = {},
    priority = 100,
    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = {
                "javascript", "html", "css", "python", "go", "c", "lua",
                "vim", "vimdoc", "query", "bash", "json",
                "typescript", "tsx",
                -- "swift", -- Requires tree-sitter CLI > 0.26.8 (--no-bindings flag). Re-enable after `cargo install tree-sitter-cli`.
                "cpp",
                "odin",
                "java",
                "scss",
                "markdown", "markdown_inline",
                "toml", "yaml",
                "glsl",
                "rust",
                "asm",
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
