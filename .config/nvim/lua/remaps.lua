--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                    NEOVIM KEYBINDINGS - macOS OPTIMIZED                   ║
    ╠═══════════════════════════════════════════════════════════════════════════╣
    ║  Optimized for MacBook keyboard layout and Warp terminal emulator.       ║
    ║                                                                           ║
    ║  KEY PHILOSOPHY:                                                          ║
    ║  • <Leader> (Space) for most operations                                   ║
    ║  • <C-...> (Control) for Vim-native and movement operations              ║
    ║  • <M-...> (Option) for window management (when terminal allows)          ║
    ║  • Original vim motions preserved                                         ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
    
    WARP TERMINAL NOTE:
    Warp captures some Option key combinations. If keybindings don't work:
    1. Open Warp Settings → Keyboard Shortcuts
    2. Disable conflicting shortcuts, or
    3. Use the Control-based alternatives provided
]]--

--  << Leader Key Definition >> --
vim.g.mapleader = " "
local km = vim.keymap.set


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                           EXTERNAL APPLICATIONS                           ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function terminal_and_fileEx()
    -- Open Warp terminal at project root
    km("n", "<leader>tew", function() openTerminal(vim.fn.getcwd()) end,
        { desc = "Open Warp at project root" })
    
    -- Open Finder at project location (macOS)
    km("n", "<leader>ex", function()
        vim.cmd('silent! !open "' .. vim.fn.getcwd() .. '"')
    end, { desc = "Open Finder at project root" })
    
    -- Open new Neovim instance in Warp
    km("n", "<leader>new", function() openNeovim(vim.fn.getcwd()) end,
        { desc = "New Neovim instance in Warp" })
    
    -- Open Finder at current file location
    vim.keymap.set("n", "<leader>hex", function()
        local path = vim.fn.expand('%:p:h')
        path = vim.fn.substitute(path, "^oil:[/][/]", "", "g")
        vim.cmd('silent! !open "' .. path .. '"')
    end, { desc = "Open Finder at file location" })
    
    -- Open Warp at current file location
    vim.keymap.set("n", "<leader>htew", function()
        local path = vim.fn.expand('%:p:h')
        path = vim.fn.substitute(path, "^oil:[/][/]", "", "g")
        openTerminal(path)
    end, { desc = "Open Warp at file location" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                              TAB NAVIGATION                                ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function tabs()
    km("n", "<leader><Right>", ":tabnext<CR>",     { desc = "Next tab" })
    km("n", "<leader><Left>",  ":tabprevious<CR>", { desc = "Previous tab" })
    km("n", "<leader>tn",      ":tabnew<CR>",      { desc = "New tab" })
    km("n", "<leader>tc",      ":tabclose<CR>",    { desc = "Close tab" })
    
    -- Quick tab switching with <leader>1-9
    for i = 1, 9 do
        km("n", "<leader>" .. i, i .. "gt", { desc = "Go to tab " .. i })
    end
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                              LINE INDENTATION                              ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function indent()
    -- Quick blank line operations using Control key (more reliable on macOS)
    km("n", '<C-;>',  "mzo<cr><cr><cr><Esc>'z",  { desc = "Insert 3 blank lines below" })
    km("n", "<C-'>",  "mzo<cr><Esc>'z",          { desc = "Insert blank line below" })
    km("n", "<C-\\>", "i<tab><esc>l",            { desc = "Insert tab at cursor" })
    km("n", "<C-CR>", "o<Esc>k",                 { desc = "New line below, stay in place" })
    
    -- Block indent helper
    km("v", "<leader>bi", function() Block_indent() end, { desc = "Block indent" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                                 COMMENTS                                   ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function comments()
    -- Comment prefix insertion (prompts for comment char)
    km({"v","n"}, "<leader>cc", ":s$^\\(\\s\\| \\)*\\zs\\(.\\)$\\2$g|noh<Left><Left><Left><Left><Left><Left><Left><Left>",
        { desc = "Add comment prefix" })
    -- Comment removal (prompts for comment char)
    km({"v","n"}, "<leader>cr", ':s$^\\(\\s\\| \\)*\\zs$$g|noh<Left><Left><Left><Left><Left><Left><Left>',
        { desc = "Remove comment prefix" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                                 SURROUND                                   ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function surround_basic()
    km({"v","n"}, "<leader>x", function() Manual_surround() end, { desc = "Surround selection" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                                MOVEMENT                                    ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function movement()
    -- Move lines in visual mode
    km("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
    km("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
    
    -- Keep cursor centered during operations
    km("n", "J",     "mzJ`z",      { desc = "Join lines (cursor stays)" })
    km("n", "<C-d>", "<C-d>zz",    { desc = "Half page down (centered)" })
    km("n", "<C-u>", "<C-u>zz",    { desc = "Half page up (centered)" })
    km("n", "<C-o>", "<C-o>zz",    { desc = "Jump back (centered)" })
    km("n", "n",     "nzzzv",      { desc = "Next search (centered)" })
    km("n", "N",     "Nzzzv",      { desc = "Prev search (centered)" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                              COMMAND MODE                                  ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function cmd_mode_edit()
    -- NOTE: Disabled - was causing Lazy dashboard freeze
    -- km({"n","c","i"}, "<C- >", function() Cmdline_buff_control() end,
    --     { desc = "Toggle command line buffer" })
    km({"n","c"}, "<C-;>", "<C-c><C-c><C-c>q:k", { desc = "Open command history" })
    -- km("v", "<C- >", ":", { desc = "Enter command mode" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                              TERMINAL MODE                                 ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function terminal_mode_related()
    km("t", "<C- >", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    km("n", "<leader>ter", "<C-w>v<C-w>l:term<CR><C-w>h",
        { desc = "Open terminal in vertical split" })
    km('t', '<C-l><C-l>', [[<C-\><C-N>:lua ClearTerm(0)<CR>]],
        { desc = "Clear terminal screen" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                            QUALITY OF LIFE                                 ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function quality_of_life()
    -- Disable jump after * search
    km('n', '*', '*N', { noremap = true, desc = "Search word (no jump)" })
    km('v', '*', 'y/\\V<C-r>"<Cr>N', { noremap = true, desc = "Search selection" })
    
    -- Search and replace last search
    km({'v'}, '<leader>/', [[q:is/\(<C-r>/\)//g<Esc>F/i]], { desc = "Replace last search (visual)" })
    km({'n'}, '<leader>/', [[q:i%s/\(<C-r>/\)//g<Esc>F/i]], { desc = "Replace last search (buffer)" })
    
    -- Select all (ga is normally "show char info", but this is more useful)
    km({'v','n'}, 'ga', '<Esc>ggVG', { desc = "Select all" })

    
    -- Remove trailing whitespace
    km("n", "<leader>rr", [[:%s/\v(^[ \t]+$)|([ \t]+$)//g|noh<CR>]], { desc = "Remove trailing spaces" })
    km("v", "<leader>rr", [[<Esc>:'<,'>s/[ \t]\+$//g|noh<CR>]], { desc = "Remove trailing spaces (selection)" })
    
    -- Escape alternatives
    -- km({'n','v','i'}, "<C-[>", function() vim.api.nvim_feedkeys("\x1b", "t", false) end,
    --     { desc = "Escape" })
    
    -- Quick session save
    km("n", "<leader>mk", ":mksession!<CR>", { desc = "Save session" })
    
    -- Visual mode colon fix
    km("v", ":", ":<C-u>", { desc = "Command mode (fix range)" })
    
    -- Scrolling in visual mode keeps selection
    km("v", "zt", "<Esc>ztgv", { desc = "Scroll top (keep selection)" })
    km("v", "zz", "<Esc>zzgv", { desc = "Center scroll (keep selection)" })
    km("v", "zb", "<Esc>zbgv", { desc = "Scroll bottom (keep selection)" })
    
    -- Control+hjkl as arrow keys in command mode
    km("c", "<C-h>", "<Left>",    { desc = "Move left" })
    km("c", "<C-j>", "<Down>",    { desc = "Move down" })
    km("c", "<C-k>", "<Up>",      { desc = "Move up" })
    km("c", "<C-l>", "<Right>",   { desc = "Move right" })
    km("c", "<C-b>", "<C-Left>",  { desc = "Word left" })
    km("c", "<C-e>", "<C-Right>", { desc = "Word right" })
    
    -- Toggle relative line numbers
    km("n", "<leader>rnu", ":set rnu! nu<CR>", { desc = "Toggle relative numbers" })
    
    -- Quick save
    km("n", "<leader>w",  ":w<CR>",  { desc = "Save file" })
    km("n", "<leader>W",  ":wa<CR>", { desc = "Save all files" })
    
    -- File explorer
    km("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })
    
    -- Clear search highlight
    km("n", "<leader><space>", ":noh<CR>", { desc = "Clear search highlight" })
    
    -- Backspace as @ (play macro)
    km("n", "<BS>", "@", { desc = "Play macro" })
    
    -- Quit commands
    vim.api.nvim_create_user_command('QA', function() vim.cmd('qa!') end, { desc = "Quit all" })
    vim.api.nvim_create_user_command('Qa', function() vim.cmd('qa!') end, { desc = "Quit all" })
    vim.api.nvim_create_user_command('QQ', function() Exit_to_file_path() end, { desc = "Quit to file path" })
    vim.api.nvim_create_user_command('Qq', function() Exit_to_file_path() end, { desc = "Quit to file path" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                           SPLIT WINDOW CONTROLS                            ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function split_window_controls()
    -- Window resizing with Control+W prefix
    km("n", "<C-w>,", "<C-w>7<", { desc = "Decrease window width" })
    km("n", "<C-w>.", "<C-w>7>", { desc = "Increase window width" })
    km("n", "<C-w>=", "<C-w>7+", { desc = "Increase window height" })
    km("n", "<C-w>-", "<C-w>7-", { desc = "Decrease window height" })
    
    -- Option key alternatives (if terminal supports it)
    km("n", "<M-w>", "<C-w>",    { desc = "Window command prefix" })
    km("n", "<M-,>", "<C-w>7<",  { desc = "Decrease window width" })
    km("n", "<M-.>", "<C-w>7>",  { desc = "Increase window width" })
    km("n", "<M-=>", "<C-w>7+",  { desc = "Increase window height" })
    km("n", "<M-->", "<C-w>7-",  { desc = "Decrease window height" })
    
    -- Quick window navigation with Option+hjkl
    km("n", "<M-h>", function() vim.cmd.wincmd('h') end, { desc = "Window left" })
    km("n", "<M-j>", function() vim.cmd.wincmd('j') end, { desc = "Window down" })
    km("n", "<M-k>", function() vim.cmd.wincmd('k') end, { desc = "Window up" })
    km("n", "<M-l>", function() vim.cmd.wincmd('l') end, { desc = "Window right" })
    
    -- Control key alternatives for window navigation (guaranteed to work)
    km("n", "<C-w>h", function() vim.cmd.wincmd('h') end, { desc = "Window left" })
    km("n", "<C-w>j", function() vim.cmd.wincmd('j') end, { desc = "Window down" })
    km("n", "<C-w>k", function() vim.cmd.wincmd('k') end, { desc = "Window up" })
    km("n", "<C-w>l", function() vim.cmd.wincmd('l') end, { desc = "Window right" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                            CLIPBOARD UTILITIES                             ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function clipboard_utilities()
    -- System clipboard operations (macOS uses pbcopy/pbpaste)
    km("v", "<leader>y",  '"+y',  { desc = "Yank to clipboard" })
    km("v", "<leader>d",  '"+d',  { desc = "Cut to clipboard" })
    km({"v", "n"}, "<leader>p", '"+p', { desc = "Paste from clipboard" })
    
    -- Quick clipboard shortcuts
    km({"v", "n"}, "P", '"+p', { desc = "Paste from clipboard" })
    km("v", "Y", '"+y',        { desc = "Yank to clipboard" })
    km("v", "D", '"+d',        { desc = "Cut to clipboard" })
    
    -- Line operations to clipboard
    km("n", "<leader>yy", '"+yy', { desc = "Yank line to clipboard" })
    km("n", "<leader>dd", '"+dd', { desc = "Cut line to clipboard" })
    km("n", "<leader>Y",  [[v$"+y]], { desc = "Yank to EOL to clipboard" })
    
    -- Paste in insert mode
    km("i", "<C-v>", '<C-r>+', { desc = "Paste clipboard in insert" })
    km("i", "<C-V>", '<C-r>"', { desc = "Paste register in insert" })
    
    -- Register 'a' shortcuts for secondary clipboard
    km("n", "<leader>ayy", '"ayy', { desc = "Yank line to reg a" })
    km("n", "<leader>add", '"add', { desc = "Cut line to reg a" })
    km("v", "<leader>ay",  '"ay',  { desc = "Yank to reg a" })
    km("v", "<leader>ad",  '"ad',  { desc = "Cut to reg a" })
    km({"v", "n"}, "<leader>ap", '"ap', { desc = "Paste from reg a" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                           BUFFER MANIPULATION                              ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function default_buffer_manipulation()
    km("n", "<leader>bd", ":bd!<CR>",      { desc = "Delete buffer" })
    km("n", "<leader>bn", ":bnext<CR>",    { desc = "Next buffer" })
    km("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
    km("n", "<leader>bl", ":buffers<CR>",  { desc = "List buffers" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                               SCRIPTING                                    ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function scripting()
    km('n', "<leader><F5>", ":!%:p<CR>",   { desc = "Execute current script" })
    km("n", "<leader>bash", ":w !bash",    { desc = "Pipe buffer to bash" })
    km("n", "<leader>lua",  ":source %<CR>", { desc = "Source current lua file" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                              SPELL CHECKING                                ║
--╚═══════════════════════════════════════════════════════════════════════════╝

local function spell_settings()
    km("n", "<leader>ss", ":set spell!<CR>",    { desc = "Toggle spell check" })
    km("n", "<leader>sl", ":set spelllang=",    { desc = "Set spell language" })
    km("n", "<leader>se", ":set spelllang=en_us<CR>", { desc = "English spelling" })
    km("n", "<leader>sp", ":set spelllang=pt_br<CR>", { desc = "Portuguese spelling" })
end

local function spell_navigation()
    km("n", "z;",       "]s",  { desc = "Next spelling error" })
    km("n", "z,",       "[s",  { desc = "Previous spelling error" })
    km("n", "z<leader>", "z=", { desc = "Spelling suggestions" })
end


--╔═══════════════════════════════════════════════════════════════════════════╗
--║                          ENABLE ALL KEYBINDINGS                            ║
--╚═══════════════════════════════════════════════════════════════════════════╝

quality_of_life()
spell_settings()
spell_navigation()
scripting()
clipboard_utilities()
split_window_controls()
movement()
indent()
default_buffer_manipulation()
cmd_mode_edit()
tabs()
terminal_mode_related()
comments()
surround_basic()
terminal_and_fileEx()
