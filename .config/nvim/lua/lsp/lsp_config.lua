return {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        -- Progress indicator
        {
            'j-hui/fidget.nvim',
            opts = {
                progress = {
                    suppress_on_insert = true,
                    ignore_done_already = true,
                    ignore = { 'null-ls' },
                },
                notification = {
                    window = {
                        winblend = 0,
                        y_padding = 1,
                    },
                },
            },
            config = function(_, opts)
                require("fidget").setup(opts)

                -- Force transparent background for Fidget
                vim.api.nvim_set_hl(0, "FidgetTitle", { link = "Title" })
                vim.api.nvim_set_hl(0, "FidgetTask", { link = "Normal" })


                vim.api.nvim_create_autocmd("ColorScheme", {
                    pattern = "*",
                    callback = function()
                        vim.api.nvim_set_hl(0, "FidgetTitle", { bg = "NONE", fg = "#d3869b" })
                        vim.api.nvim_set_hl(0, "FidgetTask", { bg = "NONE", fg = "#ebdbb2" })
                    end,
                })
            end
        },
    },
    config = function()
        local lspconfig = require('lspconfig')
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')

        mason.setup({})

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
        if has_cmp then
            capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
        end
        -- Explicitly enable snippet support
        capabilities.textDocument.completion.completionItem.snippetSupport = true


        local servers = {
            "lua_ls",
            "pyright",
            "html",
            "cssls",
            "ts_ls",
            "emmet_ls",
            "angularls",
            "tailwindcss",
            "bashls",
            "clangd",
            "jdtls",
            "glsl_analyzer",
        }

        mason_lspconfig.setup({
            ensure_installed = servers,
            handlers = {
                function(server_name)
                    -- Skip clangd and deprecated framework
                    if server_name == 'clangd' or server_name == 'framework' then return end
                    -- Default handler

                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                -- Specific handlers for servers that need custom config
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = { globals = { 'vim' } },
                            },
                        },
                    })
                end,

                ["clangd"] = function()
                    lspconfig.clangd.setup({
                        capabilities = capabilities,
                        cmd = {
                            'clangd',
                            '--background-index',
                            '--clang-tidy',
                            '--header-insertion=iwyu',
                            '--completion-style=detailed',
                            '--function-arg-placeholders',
                            '--fallback-style=llvm',
                        },
                        init_options = {
                            usePlaceholders = true,
                            completeUnimported = true,
                            clangdFileStatus = true,
                        },
                    })
                end,

                ["ts_ls"] = function()
                    lspconfig.ts_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            typescript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = 'all',
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                },
                            },
                            javascript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = 'all',
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                },
                            },
                        },
                    })
                end,

                ["angularls"] = function()
                    lspconfig.angularls.setup({
                        capabilities = capabilities,
                        filetypes = { 'typescript', 'html' },
                        root_dir = function(fname)
                            return vim.fs.root(fname, { 'angular.json' }) or vim.fn.getcwd()
                        end,
                    })
                end,
            },
        })

        -- Enhanced capabilities from nvim-cmp
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
        if has_cmp then
            capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
        end
        -- Explicitly enable snippet support
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        -- Override default capabilities for all servers -- REMOVED
        -- lspconfig.util.default_config = ...

        -- Diagnostic configuration for better visibility
        vim.diagnostic.config({
            virtual_text = {
                spacing = 4,
                prefix = '●',
                source = 'if_many',
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = ' ',
                    [vim.diagnostic.severity.WARN] = ' ',
                    [vim.diagnostic.severity.INFO] = ' ',
                    [vim.diagnostic.severity.HINT] = '󰌵 ',
                },
            },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = 'rounded',
                source = true,
                header = '',
                prefix = '',
            },
        })

        -- Rounded borders for hover and signature help
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover, { border = 'rounded' }
        )
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help, { border = 'rounded' }
        )

        -- On LSP attach
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                -- Navigation
                map('gd', vim.lsp.buf.definition, 'Go to Definition')
                map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
                map('gi', vim.lsp.buf.implementation, 'Go to Implementation')
                map('gr', vim.lsp.buf.references, 'Find References')
                map('gt', vim.lsp.buf.type_definition, 'Go to Type Definition')

                -- Documentation
                map('K', vim.lsp.buf.hover, 'Hover Documentation')
                map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')

                -- Actions
                map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
                map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', 'v')
                map('<leader>rn', vim.lsp.buf.rename, 'Rename Symbol')
                map('<leader>cf', function() vim.lsp.buf.format({ async = true }) end, 'Format Buffer')
                map('<leader>cl', vim.lsp.codelens.run, 'Run Code Lens')

                -- Diagnostics
                map('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
                map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
                map('<leader>ld', vim.diagnostic.open_float, 'Show Diagnostic')

                -- Workspace
                map('<leader>ws', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')
                map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
                map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
                map('<leader>li', '<cmd>LspInfo<cr>', 'LSP Info')

                -- Inlay hints toggle
                if vim.lsp.inlay_hint then
                    map('<leader>lh', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, 'Toggle Inlay Hints')
                end

                -- Highlight references under cursor (DISABLED: Debugging crash)
                -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                -- if client and client.server_capabilities.documentHighlightProvider then
                --     local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                --     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                --         buffer = event.buf,
                --         group = highlight_group,
                --         callback = vim.lsp.buf.document_highlight,
                --     })
                --     vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                --         buffer = event.buf,
                --         group = highlight_group,
                --         callback = vim.lsp.buf.clear_references,
                --     })
                -- end
            end,
        })

        -- Swift (Native LSP setup to avoid lspconfig framework issues)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "swift", "objective-c", "objective-cpp" },
            callback = function(ev)
                local root = vim.fs.root(ev.match, {
                    'Package.swift',
                    '.git',
                    'compile_commands.json',
                }) or vim.fn.getcwd()

                vim.lsp.start({
                    name = 'sourcekit-lsp',
                    cmd = { 'sourcekit-lsp' },
                    root_dir = root,
                    capabilities = capabilities,
                })
            end,
        })

        -- Odin (Native LSP setup)
        local ols_path = vim.fn.expand('~/ols/ols')
        if vim.fn.executable(ols_path) == 1 or vim.fn.executable('ols') == 1 then
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "odin",
                callback = function(ev)
                    local root = vim.fs.root(ev.match, { 'ols.json', '.git' }) or vim.fn.getcwd()
                    vim.lsp.start({
                        name = 'ols',
                        cmd = { vim.fn.executable('ols') == 1 and 'ols' or ols_path },
                        root_dir = root,
                        capabilities = capabilities,
                    })
                end,
            })
        end
    end,
}
