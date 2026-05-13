return {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false,    -- This plugin is already lazy
    ft = { 'rust' },
    config = function()
        vim.g.rustaceanvim = {
            -- LSP configuration
            server = {
                on_attach = function(client, bufnr)
                    -- You can add extra keymaps here
                    -- rustaceanvim already sets up most things
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ['rust-analyzer'] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
                        },
                        -- Add clippy lints for Rust.
                        checkOnSave = {
                            allFeatures = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["nom"] = { "ivec" },
                            },
                        },
                    },
                },
            },
            -- Debugging configuration
            dap = {
            },
        }
    end
}
