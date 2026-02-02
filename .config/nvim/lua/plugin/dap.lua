return {
    'mfussenegger/nvim-dap',
    dependencies = {
        -- DAP UI
        {
            'rcarriga/nvim-dap-ui',
            dependencies = { 'nvim-neotest/nvim-nio' },
        },
        -- Virtual text
        'theHamsta/nvim-dap-virtual-text',
        -- Mason integration
        'jay-babu/mason-nvim-dap.nvim',
    },

    keys = {
        -- Debug keys
        { '<leader>dc', function() require('dap').continue() end,          desc = 'Debug: Start/Continue' },
        { '<leader>dn', function() require('dap').step_over() end,         desc = 'Debug: Step Next (over)' },
        { '<leader>di', function() require('dap').step_into() end,         desc = 'Debug: Step Into' },
        { '<leader>do', function() require('dap').step_out() end,          desc = 'Debug: Step Out' },

        -- Breakpoints
        { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
        {
            '<leader>dB',
            function()
                require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end,
            desc = 'Debug: Conditional Breakpoint'
        },

        -- Other debug commands
        { '<leader>dr', function() require('dap').repl.open() end, desc = 'Debug: Open REPL' },
        { '<leader>dl', function() require('dap').run_last() end,  desc = 'Debug: Run Last' },
        { '<leader>ds', function() require('dap').terminate() end, desc = 'Debug: Stop' },
        { '<leader>du', function() require('dapui').toggle() end,  desc = 'Debug: Toggle UI' },
        { '<leader>dp', function() require('dap').pause() end,     desc = 'Debug: Pause' },
    },

    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

        -- Mason DAP setup
        require('mason-nvim-dap').setup({
            automatic_installation = true,
            ensure_installed = {
                'codelldb', -- C, C++, Rust, Swift
                'js',
            },
            handlers = {},
        })

        -- DAP UI setup
        dapui.setup({
            icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏',
                },
            },
            layouts = {
                {
                    elements = {
                        { id = 'scopes',      size = 0.25 },
                        { id = 'breakpoints', size = 0.25 },
                        { id = 'stacks',      size = 0.25 },
                        { id = 'watches',     size = 0.25 },
                    },
                    size = 40,
                    position = 'left',
                },
                {
                    elements = {
                        { id = 'repl',    size = 0.5 },
                        { id = 'console', size = 0.5 },
                    },
                    size = 0.25,
                    position = 'bottom',
                },
            },
        })

        -- Virtual text setup
        require('nvim-dap-virtual-text').setup({
            enabled = true,
            commented = true,
        })

        -- Toggle DAP UI
        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Breakpoint icons
        vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointCondition',
            { text = '◆', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
        vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })
        vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })
        vim.fn.sign_define('DapBreakpointRejected',
            { text = '○', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })

        -- C/C++ Config
        dap.adapters.codelldb = {
            type = 'server',
            port = '${port}',
            executable = {
                command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
                args = { '--port', '${port}' },
            },
        }

        dap.configurations.c = {
            {
                name = 'Launch file',
                type = 'codelldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }
        dap.configurations.cpp = dap.configurations.c

        -- Swift Config
        dap.configurations.swift = {
            {
                name = 'Launch Swift',
                type = 'codelldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/.build/debug/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }

        -- JS/TS Config
        dap.adapters['pwa-node'] = {
            type = 'server',
            host = 'localhost',
            port = '${port}',
            executable = {
                command = 'node',
                args = {
                    vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
                    '${port}',
                },
            },
        }

        dap.configurations.javascript = {
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
            },
        }
        dap.configurations.typescript = dap.configurations.javascript
    end,
}
