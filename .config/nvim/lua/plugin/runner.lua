return {
    'akinsho/toggleterm.nvim',
    version = '*',
    lazy = false, -- Load immediately for F5 to work

    config = function()
        local toggleterm = require('toggleterm')

        -- Auto-enter insert mode when entering a terminal window
        vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter", "BufEnter" }, {
            pattern = "term://*",
            callback = function()
                vim.schedule(function()
                    if vim.bo.buftype == "terminal" then
                        vim.cmd("startinsert")
                    end
                end)
            end,
        })

        toggleterm.setup({
            size = 12,
            -- open_mapping = [[<C-\>]], -- Disabled to prevent conflict with custom runner logic
            shade_terminals = false,
            start_in_insert = true,
            direction = 'horizontal',
            close_on_exit = false,
            shell = vim.o.shell,
            auto_scroll = true,
            highlights = {
                StatusLine = { guibg = 'NONE', guifg = 'NONE' },
                StatusLineNC = { guibg = 'NONE', guifg = 'NONE' },
            },
        })

        local Terminal = require('toggleterm.terminal').Terminal
        local runner = Terminal:new({
            hidden = true,
            direction = 'horizontal',
            close_on_exit = false,
            on_open = function(term)
                vim.cmd('startinsert!')
                -- Hide statusline in terminal
                vim.opt_local.laststatus = 0
                vim.opt_local.statusline = ' '
                -- Focus the terminal
                vim.api.nvim_set_current_win(term.window)
            end,
        })

        local last_cmd = nil

        -- Simple run command
        local function run_cmd(cmd, msg)
            last_cmd = cmd
            if msg then vim.notify(msg, vim.log.levels.INFO) end

            -- Ensure we always spawn in the current directory if re-created
            runner.dir = vim.fn.getcwd()

            if not runner:is_open() then
                runner:open()
            end

            -- Send command and focus the terminal window
            vim.defer_fn(function()
                runner:send('clear && ' .. cmd, true)
                vim.defer_fn(function()
                    if runner.window and vim.api.nvim_win_is_valid(runner.window) then
                        vim.api.nvim_set_current_win(runner.window)
                        vim.cmd('startinsert!')
                    end
                end, 50)
            end, 100)
        end

        -- Kill/Reset the runner terminal
        local function kill_runner()
            if runner then
                runner:shutdown() -- Fully kills the buffer
                vim.notify('Runner terminal killed 💀', vim.log.levels.INFO)
            end
        end

        -- Helper to find project root from current file
        local function find_project_root()
            local current_file = vim.fn.expand('%:p')
            if current_file == '' then return vim.fn.getcwd() end

            local current_dir = vim.fn.fnamemodify(current_file, ':h')
            local root = vim.fs.find({
                'CMakeLists.txt', 'Makefile', 'makefile', 'Cargo.toml',
                'pom.xml', 'build.gradle', 'gradlew', '.git'
            }, { path = current_dir, upward = true })[1]

            if root then
                return vim.fn.fnamemodify(root, ':h')
            end
            return vim.fn.getcwd()
        end

        -- Run detection
        local function run()
            -- Use detected project root instead of just getcwd() (fixes running wrong project)
            local cwd = find_project_root()

            local file = vim.fn.expand('%:p')   -- Full path
            local name = vim.fn.expand('%:t')   -- Filename
            local stem = vim.fn.expand('%:t:r') -- Filename without extension
            local dir = vim.fn.expand('%:p:h')  -- Directory
            local ext = vim.fn.expand('%:e'):lower()

            -- Save before running (if it's a real file)
            if vim.bo.modified and vim.bo.buftype == '' then
                vim.cmd('silent write')
            end

            -- Project detection
            local has_cmake = vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1
            local has_makefile = vim.fn.filereadable(cwd .. '/Makefile') == 1 or
                vim.fn.filereadable(cwd .. '/makefile') == 1
            local has_cargo = vim.fn.filereadable(cwd .. '/Cargo.toml') == 1
            local has_package_json = vim.fn.filereadable(cwd .. '/package.json') == 1
            local has_swift_pkg = vim.fn.filereadable(cwd .. '/Package.swift') == 1
            local has_gradle = vim.fn.filereadable(cwd .. '/build.gradle') == 1 or
                vim.fn.filereadable(cwd .. '/build.gradle.kts') == 1
            local has_pom = vim.fn.filereadable(cwd .. '/pom.xml') == 1
            local has_build_dir = vim.fn.isdirectory(cwd .. '/build') == 1

            -- CMake project
            if has_cmake then
                -- Create a robust runner script to avoid quoting issues in terminal
                local script_content = {
                    '#!/bin/bash',
                    'set -e', -- Exit on error
                    'cd "' .. cwd .. '"',
                    'echo "Configuring..."',
                    'if [ ! -f "build/CMakeCache.txt" ]; then',
                    '  cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
                    'fi',
                    '',
                    'echo "Building..."',
                    'cmake --build build --parallel',
                    '',
                    'echo "Attempting to run..."',
                    '# Try to find a likely executable (ignoring cmake internal files)',
                    'EXE=$(find build -maxdepth 3 -type f -perm +111 2>/dev/null | grep -vE "CMake|cmake|make|test|Compiler|/\\." | head -n 1)',
                    '',
                    '# Check for MacOS .app bundle',
                    'APP=$(find build -maxdepth 3 -type d -name "*.app" 2>/dev/null | head -n 1)',
                    '',
                    'if [ -n "$APP" ]; then',
                    '  echo "Running Bundle: $APP"',
                    '  open "$APP"',
                    'elif [ -n "$EXE" ]; then',
                    '  echo "Running: $EXE"',
                    '  "$EXE"',
                    'else',
                    '  echo "Build complete (no standalone executable found to run)"',
                    'fi'
                }

                local script_path = '/tmp/nvim_cmake_runner.sh'
                vim.fn.writefile(script_content, script_path)
                run_cmd('cd "' .. cwd .. '" && bash ' .. script_path, 'CMake Quick Run')
                return
            end

            -- Makefile project
            if has_makefile then
                -- Try 'make run' first, otherwise build and try to find executable
                local script_content = {
                    '#!/bin/bash',
                    'set -e',
                    'echo "Building..."',
                    '# Try "make run" first if available',
                    'if grep -q "^run:" Makefile 2>/dev/null || grep -q "^run:" makefile 2>/dev/null; then',
                    '  source ~/.zshrc >/dev/null 2>&1 # source env just in case',
                    '  make run',
                    'else',
                    '  make -j$(sysctl -n hw.ncpu 2>/dev/null || nproc)',
                    '  echo "Attempting to run..."',
                    '  EXE=$(find . -maxdepth 2 -type f -perm +111 2>/dev/null | grep -vE "Makefile|makefile|/\\." | head -n 1)',
                    '  if [ -n "$EXE" ]; then',
                    '    "$EXE"',
                    '  else',
                    '    echo "Build complete (no run target or executable found)"',
                    '  fi',
                    'fi'
                }
                local script_path = '/tmp/nvim_makefile_runner.sh'
                vim.fn.writefile(script_content, script_path)
                run_cmd('cd "' .. cwd .. '" && bash ' .. script_path, 'Make Build & Run')
                return
            end

            -- Cargo/Rust project
            if has_cargo then
                run_cmd('cd "' .. cwd .. '" && cargo run', 'Cargo Run')
                return
            end

            -- Gradle project
            if has_gradle then
                local gradlew = vim.fn.filereadable(cwd .. '/gradlew') == 1 and './gradlew' or 'gradle'
                run_cmd('cd "' .. cwd .. '" && ' .. gradlew .. ' run', 'Gradle Run')
                return
            end

            -- Maven project
            if has_pom then
                run_cmd('cd "' .. cwd .. '" && mvn compile exec:java', 'Maven Run')
                return
            end

            -- Swift Package project
            if has_swift_pkg then
                run_cmd('cd "' .. cwd .. '" && swift run', 'Swift Package Run')
                return
            end

            -- Web project
            if has_package_json then
                local is_bun = vim.fn.filereadable(cwd .. '/bun.lockb') == 1 or
                    vim.fn.filereadable(cwd .. '/bun.lock') == 1
                local pm = is_bun and 'bun' or
                    (vim.fn.filereadable(cwd .. '/pnpm-lock.yaml') == 1 and 'pnpm' or 'npm')

                -- Smart port detection
                local function detect_web_port()
                    local port = 3000
                    if vim.fn.glob(cwd .. '/vite.config.*') ~= '' then
                        port = 5173
                        local content = vim.fn.readfile(vim.fn.glob(cwd .. '/vite.config.*'))
                        for _, line in ipairs(content) do
                            local p = line:match('port:%s*(%d+)')
                            if p then return p end
                        end
                    end
                    if vim.fn.filereadable(cwd .. '/angular.json') == 1 then
                        port = 4200
                    end
                    if vim.fn.filereadable(cwd .. '/package.json') == 1 then
                        local content = vim.fn.readfile(cwd .. '/package.json')
                        for _, line in ipairs(content) do
                            local p_env = line:match('PORT=(%d+)')
                            local p_flag = line:match('%-%-port%s+(%d+)')
                            if p_env then return p_env end
                            if p_flag then return p_flag end
                        end
                    end
                    return port
                end

                local port = detect_web_port()

                vim.ui.select({ 'Google Chrome', 'Safari', 'Do not open' }, {
                    prompt = 'Open localhost:' .. port .. '?',
                }, function(choice)
                    if not choice then return end -- Cancelled

                    local open_cmd = ""
                    local separator = " && "
                    if choice == 'Google Chrome' then
                        open_cmd = ' && (sleep 2 && open -a "Google Chrome" http://localhost:' .. port .. ') &'
                        separator = " "
                    elseif choice == 'Safari' then
                        open_cmd = ' && (sleep 2 && open -a "Safari" http://localhost:' .. port .. ') &'
                        separator = " "
                    end

                    run_cmd(
                        'cd "' ..
                        cwd ..
                        '" && echo "Using ' ..
                        pm .. '"' .. open_cmd .. separator .. '(' .. pm .. ' run dev || ' .. pm .. ' start)',
                        pm .. ' run')
                end)
                return
            end

            -- Single file mode

            -- Java
            if ext == 'java' then
                run_cmd(
                    'cd "' .. dir .. '" && javac "' .. name .. '" && java "' .. stem .. '"',
                    'Running ' .. name
                )

                -- Swift
            elseif ext == 'swift' then
                run_cmd('swift "' .. file .. '"', 'Running ' .. name)

                -- C/C++
            elseif ext == 'c' or ext == 'cpp' or ext == 'cc' or ext == 'cxx' or ext == 'mm' then
                local cmd_compiler = (ext == 'c') and 'clang' or 'clang++'
                local std = (ext == 'c') and '-std=c11' or '-std=c++17'

                -- Detect frameworks by scanning head of file
                local lines = vim.fn.readfile(file, '', 50)
                local content = table.concat(lines, '\n')
                local compile_flags = { '-O3', '-march=native', '-ffast-math', '-I/opt/homebrew/include' } -- Performance!
                local link_flags = { '-L/opt/homebrew/lib' }

                -- Math is almost always needed
                table.insert(link_flags, '-lm')

                -- MacOS Frameworks & LIbs
                if string.find(content, 'Metal/Metal.h') or string.find(content, 'MetalKit/MetalKit.h') then
                    table.insert(link_flags,
                        '-framework Metal -framework MetalKit -framework Cocoa -framework QuartzCore')
                    table.insert(compile_flags, '-ObjC -fobjc-arc')
                end

                if string.find(content, 'GLFW/glfw3.h') then
                    table.insert(link_flags, '-lglfw -framework IOKit -framework Cocoa -framework OpenGL')
                end

                if string.find(content, 'SDL2/SDL.h') then
                    table.insert(link_flags, '-lSDL2')
                    if string.find(content, 'SDL2/SDL_image.h') then
                        table.insert(link_flags, '-lSDL2_image')
                    end
                end

                if string.find(content, '<GLUT/glut.h>') or string.find(content, '<GL/glut.h>') then
                    table.insert(link_flags, '-framework GLUT -framework OpenGL')
                    table.insert(compile_flags, '-Wno-deprecated')
                end

                if string.find(content, '<OpenGL/') and not string.find(content, 'GLUT') then
                    table.insert(link_flags, '-framework OpenGL')
                end

                -- stb_image (Header-only image loader)
                if string.find(content, 'stb_image.h') then
                    table.insert(compile_flags, '-DSTB_IMAGE_IMPLEMENTATION')
                end

                local all_flags = table.concat(compile_flags, ' ') .. ' ' .. table.concat(link_flags, ' ')
                run_cmd(cmd_compiler .. ' ' .. std .. ' -o /tmp/out "' .. file .. '" ' .. all_flags .. ' && /tmp/out',
                    'Running ' .. name)

                -- Typescript
            elseif ext == 'ts' or ext == 'tsx' then
                if vim.fn.executable('bun') == 1 then
                    run_cmd('bun "' .. file .. '"', 'Running ' .. name)
                else
                    run_cmd('npx tsx "' .. file .. '"', 'Running ' .. name)
                end

                -- Javascript
            elseif ext == 'js' or ext == 'jsx' or ext == 'mjs' then
                if vim.fn.executable('bun') == 1 then
                    run_cmd('bun "' .. file .. '"', 'Running ' .. name)
                else
                    run_cmd('node "' .. file .. '"', 'Running ' .. name)
                end

                -- Python
            elseif ext == 'py' then
                local py = vim.fn.executable('python3') == 1 and 'python3' or 'python'
                run_cmd(py .. ' "' .. file .. '"', 'Running ' .. name)

                -- Rust
            elseif ext == 'rs' then
                run_cmd(
                    'rustc -o /tmp/out "' .. file .. '" && /tmp/out',
                    'Running ' .. name
                )

                -- Go
            elseif ext == 'go' then
                run_cmd('go run "' .. file .. '"', 'Running ' .. name)

                -- Lua
            elseif ext == 'lua' then
                run_cmd('lua "' .. file .. '"', ' Running ' .. name)

                -- Shell
            elseif ext == 'sh' or ext == 'bash' or ext == 'zsh' then
                run_cmd('bash "' .. file .. '"', ' Running ' .. name)

                -- Ruby
            elseif ext == 'rb' then
                run_cmd('ruby "' .. file .. '"', ' Running ' .. name)

                -- PHP
            elseif ext == 'php' then
                run_cmd('php "' .. file .. '"', ' Running ' .. name)

                -- HTML
            elseif ext == 'html' or ext == 'htm' then
                run_cmd('open "' .. file .. '"', 'Opening ' .. name)
            else
                -- Fallback
                -- If I'm in a directory (file explorer) but no project was found
                -- Try to find a standard entry point file in the current directory
                if ext == '' or vim.bo.filetype == 'oil' or vim.bo.filetype == 'netrw' then
                    local ents = {
                        ['main.swift'] = 'swift',
                        ['main.c'] = 'clang -o /tmp/out main.c && /tmp/out',
                        ['main.cpp'] = 'clang++ -std=c++17 -o /tmp/out main.cpp && /tmp/out',
                        ['main.py'] = 'python3',
                        ['index.js'] = 'node',
                        ['index.ts'] = 'bun'
                    }

                    for f, cmd in pairs(ents) do
                        if vim.fn.filereadable(cwd .. '/' .. f) == 1 then
                            local run_str = cmd
                            -- If command is simple interpreter, append filename
                            if not string.find(cmd, '&&') then
                                run_str = cmd .. ' "' .. f .. '"'
                            end

                            run_cmd('cd "' .. cwd .. '" && ' .. run_str, 'Running ' .. f)
                            return
                        end
                    end
                end

                -- If we get here, no project was found AND file type is unknown
                vim.notify('No runner configured. CWD: ' .. cwd, vim.log.levels.WARN)
            end
        end

        -- Project run
        local function run_project()
            local cwd = vim.fn.getcwd()
            local has = function(f) return vim.fn.filereadable(cwd .. '/' .. f) == 1 end

            -- Save all
            vim.cmd('silent wall')

            -- Detect and run project
            if has('gradlew') then
                run_cmd('./gradlew run --console=plain', 'Gradle run')
            elseif has('pom.xml') then
                run_cmd('mvn -q compile exec:java', 'Maven run')
            elseif has('Package.swift') then
                run_cmd('swift run', 'Swift Package')
            elseif has('Cargo.toml') then
                run_cmd('cargo run --quiet', 'Cargo run')
            elseif has('go.mod') then
                run_cmd('go run .', 'Go run')
            elseif has('package.json') then
                local pm = (has('bun.lockb') or has('bun.lock')) and 'bun' or (has('pnpm-lock.yaml') and 'pnpm' or 'npm')
                run_cmd(pm .. ' run dev || ' .. pm .. ' start', pm .. ' dev')
            elseif has('CMakeLists.txt') then
                run_cmd('cmake --build build && ./build/*', 'CMake')
            elseif has('Makefile') then
                run_cmd('make && ./main', 'Make')
            else
                -- Fallback to single file
                run()
            end
        end

        -- Stop
        local function stop()
            runner:send('\x03', false)
            vim.defer_fn(function()
                runner:send('\x03', false)
            end, 100)
            vim.notify('Stopped', vim.log.levels.INFO)
        end

        -- Repeat
        local function repeat_last()
            if last_cmd then
                run_cmd(last_cmd, 'Repeat')
            else
                vim.notify('Nothing to repeat', vim.log.levels.WARN)
            end
        end

        -- Toggle terminal and focus
        local function toggle_terminal()
            local was_open = runner:is_open()
            runner:toggle()
            -- Only focus if we're opening (wasn't open before)
            if not was_open then
                vim.defer_fn(function()
                    if runner.window and vim.api.nvim_win_is_valid(runner.window) then
                        vim.api.nvim_set_current_win(runner.window)
                        vim.cmd('startinsert!')
                    end
                end, 50)
            end
        end

        -- Resize logic
        local function resize_runner(delta)
            if runner:is_open() and runner.window and vim.api.nvim_win_is_valid(runner.window) then
                local current_height = vim.api.nvim_win_get_height(runner.window)
                local new_height = current_height + delta
                if new_height < 5 then new_height = 5 end -- Minimum height
                vim.api.nvim_win_set_height(runner.window, new_height)
            end
        end

        -- Keymaps
        local km = vim.keymap.set

        -- F5 = Run (like every IDE) - works from anywhere!
        km({ 'n', 't' }, '<F5>', function()
            vim.cmd('stopinsert')
            run()
        end, { desc = 'Run file', silent = true })
        km({ 'n', 't' }, '<S-F5>', stop, { desc = 'Stop', silent = true })
        km({ 'n', 't' }, '<C-F5>', repeat_last, { desc = 'Repeat last', silent = true })

        -- Leader+tr: Reset/Kill Terminal (Useful if stuck or changing projects)
        km({ 'n', 't' }, '<leader>tr', kill_runner, { desc = 'Kill/Reset Runner', silent = true })

        km('n', '<F6>', run_project, { desc = 'Run project', silent = true })

        -- Resize Runner
        km({ 'n', 't' }, '<C-Up>', function() resize_runner(2) end, { desc = 'Increase Runner Height', silent = true })
        km({ 'n', 't' }, '<C-Down>', function() resize_runner(-2) end, { desc = 'Decrease Runner Height', silent = true })

        -- Leader keymaps
        km('n', '<leader>rr', run, { desc = 'Run file', silent = true })
        km('n', '<leader>rp', run_project, { desc = 'Run project', silent = true })
        km('n', '<leader>rs', stop, { desc = 'Stop', silent = true })
        km('n', '<leader>rl', repeat_last, { desc = 'Repeat last', silent = true })
        km('n', '<leader>ro', toggle_terminal, { desc = 'Toggle output', silent = true })

        -- Toggle terminal (works in normal and terminal mode)
        km({ 'n', 't' }, '<C-`>', toggle_terminal, { desc = 'Toggle terminal', silent = true })
        km({ 'n', 't' }, '<C-\\>', toggle_terminal, { desc = 'Toggle terminal', silent = true })

        -- From terminal: escape to normal mode, then Ctrl+k to go to code
        km('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
        km('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Go to code above' })

        -- From code: Ctrl+j to go to terminal
        km('n', '<C-j>', function()
            if runner:is_open() and runner.window and vim.api.nvim_win_is_valid(runner.window) then
                vim.api.nvim_set_current_win(runner.window)
                vim.cmd('startinsert!')
            end
        end, { desc = 'Go to terminal', silent = true })
    end,
}
