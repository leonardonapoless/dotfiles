return {
    'mfussenegger/nvim-jdtls',
    ft = 'java',

    config = function()
        local jdtls = require('jdtls')

        -- Find project root
        local root_markers = { 'gradlew', 'mvnw', 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git' }
        local root_dir = require('jdtls.setup').find_root(root_markers)

        -- If no project found, use file's directory
        local is_single_file = false
        if not root_dir then
            root_dir = vim.fn.expand('%:p:h')
            is_single_file = true
        end

        -- Workspace directory
        local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
        local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

        -- Find Mason-installed JDTLS
        local mason_registry = require('mason-registry')
        local jdtls_pkg = mason_registry.get_package('jdtls')
        local jdtls_path = jdtls_pkg:get_install_path()

        local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

        -- Determine config based on OS
        local config_dir
        if vim.fn.has('mac') == 1 then
            config_dir = jdtls_path .. '/config_mac'
        elseif vim.fn.has('unix') == 1 then
            config_dir = jdtls_path .. '/config_linux'
        else
            config_dir = jdtls_path .. '/config_win'
        end

        -- Lombok support
        local lombok_jar = jdtls_path .. '/lombok.jar'
        local lombok_agent = vim.fn.filereadable(lombok_jar) == 1
            and { '-javaagent:' .. lombok_jar }
            or {}

        -- Extended capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
        if has_cmp then
            capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
        end

        -- Configuration
        local config = {
            cmd = vim.list_extend({
                'java',
                '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                '-Dosgi.bundles.defaultStartLevel=4',
                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                '-Dlog.protocol=true',
                '-Dlog.level=ALL',
                '-Xmx2g',
                '--add-modules=ALL-SYSTEM',
                '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
            }, lombok_agent),

            root_dir = root_dir,

            settings = {
                java = {
                    signatureHelp = { enabled = true },
                    contentProvider = { preferred = 'fernflower' },
                    completion = {
                        favoriteStaticMembers = {
                            'org.junit.Assert.*',
                            'org.junit.jupiter.api.Assertions.*',
                            'org.hamcrest.MatcherAssert.assertThat',
                            'org.hamcrest.Matchers.*',
                            'org.hamcrest.CoreMatchers.*',
                            'org.mockito.Mockito.*',
                            'java.util.Objects.requireNonNull',
                            'java.util.Objects.requireNonNullElse',
                            'java.util.Collections.*',
                            'java.util.stream.Collectors.*',
                        },
                        filteredTypes = {
                            'com.sun.*',
                            'io.micrometer.shaded.*',
                            'java.awt.*',
                            'jdk.*',
                            'sun.*',
                        },
                        importOrder = {
                            'java',
                            'javax',
                            'org',
                            'com',
                        },
                        -- IntelliJ-style completion
                        maxResults = 0,
                        enabled = true,
                        guessMethodArguments = true,
                        chainCompletion = {
                            enabled = true,
                        },
                        postfix = {
                            enabled = true,
                        },
                    },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    codeGeneration = {
                        toString = {
                            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                        },
                        hashCodeEquals = {
                            useJava7Objects = true,
                        },
                        useBlocks = true,
                    },
                    configuration = {
                        updateBuildConfiguration = 'interactive',
                        runtimes = {
                            -- Add Java runtimes here if needed
                        }
                    },
                    format = {
                        enabled = true,
                        settings = {
                            url = vim.fn.stdpath('config') .. '/java-formatter.xml',
                            profile = 'GoogleStyle',
                        },
                    },
                    implementationsCodeLens = {
                        enabled = true,
                    },
                    referencesCodeLens = {
                        enabled = true,
                    },
                    saveActions = {
                        organizeImports = true,
                    },
                },
            },

            capabilities = capabilities,

            init_options = {
                bundles = {},
                extendedClientCapabilities = {
                    progressReportProvider = true,
                },
            },

            on_attach = function(client, bufnr)
                -- Java-specific keymaps
                local opts = { buffer = bufnr }

                -- Refactoring
                vim.keymap.set('n', '<leader>jo', function()
                    vim.cmd('w')
                    jdtls.organize_imports()
                end, vim.tbl_extend('force', opts, { desc = 'Java: Organize imports' }))

                vim.keymap.set('n', '<leader>jv', jdtls.extract_variable,
                    vim.tbl_extend('force', opts, { desc = 'Java: Extract variable' }))
                vim.keymap.set('v', '<leader>jv', function() jdtls.extract_variable(true) end,
                    vim.tbl_extend('force', opts, { desc = 'Java: Extract variable' }))

                vim.keymap.set('n', '<leader>jc', jdtls.extract_constant,
                    vim.tbl_extend('force', opts, { desc = 'Java: Extract constant' }))
                vim.keymap.set('v', '<leader>jc', function() jdtls.extract_constant(true) end,
                    vim.tbl_extend('force', opts, { desc = 'Java: Extract constant' }))

                vim.keymap.set('v', '<leader>jm', function() jdtls.extract_method(true) end,
                    vim.tbl_extend('force', opts, { desc = 'Java: Extract method' }))

                -- Test runner
                vim.keymap.set('n', '<leader>jt', jdtls.test_class,
                    vim.tbl_extend('force', opts, { desc = 'Java: Test class' }))
                vim.keymap.set('n', '<leader>jT', jdtls.test_nearest_method,
                    vim.tbl_extend('force', opts, { desc = 'Java: Test nearest method' }))

                -- Code actions
                vim.keymap.set('n', '<leader>jr', vim.lsp.buf.rename,
                    vim.tbl_extend('force', opts, { desc = 'Java: Rename symbol' }))
                vim.keymap.set('n', '<leader>jf', function()
                    vim.lsp.buf.format({ async = true })
                end, vim.tbl_extend('force', opts, { desc = 'Java: Format code' }))

                -- Generate code
                vim.keymap.set('n', '<leader>jg', function()
                    vim.lsp.buf.code_action({
                        filter = function(action)
                            return string.match(action.title, '^Generate')
                        end,
                        apply = true,
                    })
                end, vim.tbl_extend('force', opts, { desc = 'Java: Generate code' }))

                -- Notify when LSP is ready
                vim.notify('☕ Java LSP ready', vim.log.levels.INFO)
            end,
        }

        -- Extend cmd with launcher and config
        vim.list_extend(config.cmd, {
            '-jar', launcher_jar,
            '-configuration', config_dir,
            '-data', workspace_dir,
        })

        -- Start or attach JDTLS
        jdtls.start_or_attach(config)
    end,
}
