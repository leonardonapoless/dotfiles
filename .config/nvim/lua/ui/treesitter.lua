
return {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
    lazy = false,
    dependencies = {},
    priority = 100,
    config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = {
                -- Existing
                "javascript", "html", "css", "python", "go", "c", "lua", 
                "vim", "vimdoc", "query", "bash", "json",
                -- New: TypeScript/React
                "typescript", "tsx",
                -- New: Swift (iOS/macOS development)
                "swift",
                -- New: C++ (systems programming)
                "cpp",
                -- New: Odin (game dev / systems)
                "odin",
                -- New: Java
                "java",
                -- New: CSS preprocessors
                "scss",
                -- New: Better markdown
                "markdown", "markdown_inline",
                -- New: Config files
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

    end -- END Config function 
}
