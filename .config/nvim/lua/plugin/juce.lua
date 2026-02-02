return {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    dependencies = { 'neovim/nvim-lspconfig' },

    config = function()
        local clangd_ext = require('clangd_extensions')

        -- JUCE install locations
        local juce_paths = {
            os.getenv('JUCE_PATH'),
            vim.fn.expand('~/JUCE'),
            '/Applications/JUCE',
            '/usr/local/JUCE',
            vim.fn.expand('~/Library/JUCE'),
        }

        -- Find JUCE
        local juce_root = nil
        for _, path in ipairs(juce_paths) do
            if path and vim.fn.isdirectory(path) == 1 then
                juce_root = path
                break
            end
        end

        -- Clangd arguments
        local clangd_cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
            '-j=4',
            '--pch-storage=memory',
            '--query-driver=/usr/bin/clang++,/usr/bin/g++,/Applications/Xcode.app/**/clang++',
        }

        -- JUCE include paths
        if juce_root then
            table.insert(clangd_cmd, '--compile-commands-dir=build')
            vim.notify('JUCE found: ' .. juce_root, vim.log.levels.DEBUG)
        end

        -- Setup clangd
        clangd_ext.setup({
            server = {
                cmd = clangd_cmd,
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                on_attach = function(client, bufnr)
                    -- Inlay hints
                    if vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
                end,
            },

            extensions = {
                autoSetHints = true,
                inlay_hints = {
                    inline = vim.fn.has('nvim-0.10') == 1,
                    only_current_line = false,
                    show_parameter_hints = true,
                    parameter_hints_prefix = '← ',
                    other_hints_prefix = '→ ',
                    highlight = 'Comment',
                },
                ast = {
                    role_icons = {
                        type = 'T',
                        declaration = 'D',
                        expression = 'E',
                        statement = ';',
                        specifier = 'S',
                        ['template argument'] = 't',
                    },
                    kind_icons = {
                        Compound = 'C',
                        Recovery = 'R',
                        TranslationUnit = 'U',
                        PackExpansion = 'P',
                        TemplateTypeParm = 'T',
                        TemplateTemplateParm = 'T',
                        TemplateParamObject = 'T',
                    },
                },
                memory_usage = { border = 'rounded' },
                symbol_info = { border = 'rounded' },
            },
        })

        -- JUCE file type detection
        vim.filetype.add({
            extension = { jucer = 'xml' },
            pattern = {
                ['.*JUCE.*%.h'] = 'cpp',
                ['.*JUCE.*%.cpp'] = 'cpp',
                ['JuceHeader.h'] = 'cpp',
            },
        })

        -- JUCE keymaps
        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'cpp', 'c' },
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }
                local km = vim.keymap.set

                -- clangd_extensions commands
                km('n', '<leader>Jh', '<cmd>ClangdSwitchSourceHeader<cr>',
                    vim.tbl_extend('force', opts, { desc = 'Switch header/source' }))
                km('n', '<leader>Ja', '<cmd>ClangdAST<cr>',
                    vim.tbl_extend('force', opts, { desc = 'View AST' }))
                km('n', '<leader>Ji', '<cmd>ClangdToggleInlayHints<cr>',
                    vim.tbl_extend('force', opts, { desc = 'Toggle inlay hints' }))
                km('n', '<leader>Jm', '<cmd>ClangdMemoryUsage<cr>',
                    vim.tbl_extend('force', opts, { desc = 'Memory usage' }))
                km('n', '<leader>Jt', '<cmd>ClangdTypeHierarchy<cr>',
                    vim.tbl_extend('force', opts, { desc = 'Type hierarchy' }))
                km('n', '<leader>Js', '<cmd>ClangdSymbolInfo<cr>',
                    vim.tbl_extend('force', opts, { desc = 'Symbol info' }))

                -- Build commands
                km('n', '<leader>Jb', function()
                    local root = vim.fn.getcwd()
                    if vim.fn.filereadable(root .. '/CMakeLists.txt') == 1 then
                        vim.cmd('!cmake --build build --config Release -j4')
                    elseif vim.fn.isdirectory(root .. '/Builds/MacOSX') == 1 then
                        vim.cmd('!xcodebuild -project Builds/MacOSX/*.xcodeproj -configuration Release -jobs 4')
                    else
                        vim.notify('No CMake or Xcode project found', vim.log.levels.WARN)
                    end
                end, vim.tbl_extend('force', opts, { desc = 'JUCE: Build' }))

                km('n', '<leader>Jg', function()
                    local root = vim.fn.getcwd()
                    if vim.fn.filereadable(root .. '/CMakeLists.txt') == 1 then
                        -- Use Ninja for faster builds
                        local generator = vim.fn.executable('ninja') == 1 and 'Ninja' or 'Unix Makefiles'
                        vim.cmd('!cmake -B build -G "' ..
                            generator .. '" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release')
                        -- Symlink for clangd
                        vim.fn.system('ln -sf build/compile_commands.json ' .. root)
                        vim.notify('Generated compile_commands.json', vim.log.levels.INFO)
                        vim.cmd('LspRestart clangd')
                    else
                        vim.notify('No CMakeLists.txt found', vim.log.levels.WARN)
                    end
                end, vim.tbl_extend('force', opts, { desc = 'JUCE: Generate & restart LSP' }))

                km('n', '<leader>Jr', function()
                    local standalone = vim.fn.glob(vim.fn.getcwd() .. '/build/**/*_Standalone', true, true)
                    if #standalone > 0 then
                        vim.cmd('!' .. standalone[1] .. ' &')
                    else
                        vim.notify('No standalone build found. Build first with <leader>Jb', vim.log.levels.WARN)
                    end
                end, vim.tbl_extend('force', opts, { desc = 'JUCE: Run standalone' }))

                km('n', '<leader>Jc', '<cmd>!cmake --build build --target clean<cr>',
                    vim.tbl_extend('force', opts, { desc = 'JUCE: Clean' }))

                km('n', '<leader>Jd', function()
                    vim.ui.open('https://docs.juce.com/master/classes.html')
                end, vim.tbl_extend('force', opts, { desc = 'JUCE: Docs' }))

                km('n', '<leader>Jp', function()
                    local jucer = vim.fn.glob('*.jucer')
                    if jucer ~= '' then
                        vim.fn.system('open -a Projucer ' .. jucer)
                    else
                        vim.notify('No .jucer file found', vim.log.levels.WARN)
                    end
                end, vim.tbl_extend('force', opts, { desc = 'JUCE: Projucer' }))

                km('n', '<leader>Jv', function()
                    local vst3 = vim.fn.glob(vim.fn.getcwd() .. '/build/**/*.vst3', true, true)
                    if #vst3 > 0 then
                        vim.cmd('!pluginval --validate "' .. vst3[1] .. '"')
                    else
                        vim.notify('No VST3 found to validate', vim.log.levels.WARN)
                    end
                end, vim.tbl_extend('force', opts, { desc = 'JUCE: Validate plugin' }))
            end,
        })
    end,
}
