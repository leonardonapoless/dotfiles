
--[[		<<Attention>>
	Any remaps with the Alt modifier key (<A-..>) wont work on windows terminal.
	To make it work, you got to access WT's settings, go to keybinds,
	and remove every single keybing that uses Alt.

	I'm unsure how well those keybinds would work on MacOS
]]--


--  << Leader Key Definition >> --
vim.g.mapleader = " "


-- << Remaps by topic >> --
local function terminal_and_fileEx()
	km("n","<leader>tew", function() openTerminal(vim.fn.getcwd()) end)

	-- Opens file explorer (dolphin) at project location
	km("n","<leader>ex", ':!dolphin "'..vim.fn.getcwd()..'" & disown<cr><cr>')

	-- Opens terminal emulator and opens neo vim at the current directory
	km("n","<leader>new", function() openNeovim(vim.fn.getcwd()) end)

	vim.keymap.set("n","<leader>hex", function()
			local path = vim.fn.expand('%:p:h')
			path = vim.fn.substitute(path, "^oil:[/][/]","","g")
			vim.cmd('silent! !dolphin "'..path..'" & disown')
	end)
	vim.keymap.set("n","<leader>htew", function()
			local path = vim.fn.expand('%:p:h')
			path = vim.fn.substitute(path, "^oil:[/][/]","","g")
			openTerminal(path)
	end)
end
local function tabs()
    km("n", "<leader><Right>", ":tabnext<CR>", { desc = "Next tab" })
    km("n", "<leader><Left>", ":tabprevious<CR>", { desc = "Previous tab" })

    km("n", "<leader>tan", ":tabnew<CR>", 	{ desc = "New tab" })
    km("n", "<leader>tad", ":tabclose<CR>", { desc = "Close tab" })
    km("n", "<leader>1", "1gt", { desc = "Go to tab 1" })
    km("n", "<leader>2", "2gt", { desc = "Go to tab 2" })
    km("n", "<leader>3", "3gt", { desc = "Go to tab 3" })
    km("n", "<leader>4", "4gt", { desc = "Go to tab 4" })
    km("n", "<leader>5", "5gt", { desc = "Go to tab 5" })
    km("n", "<leader>6", "6gt", { desc = "Go to tab 6" })
    km("n", "<leader>7", "7gt", { desc = "Go to tab 7" })
    km("n", "<leader>8", "8gt", { desc = "Go to tab 8" })
    km("n", "<leader>9", "9gt", { desc = "Go to tab 9" })
end
local function indent()
	km("n", '<A-;>', "mzo<cr><cr><cr><Esc>'z")
	km("n", "<A-'>", "mzo<cr><Esc>'z")
	km("n", "<A-\\>", "i<tab><esc>l")
	km("n", "<A-cr>", "o<Esc>k")
	-- TODO: fix Block_indent()
	km("v", "<leader>bi", function() Block_indent() end)
end
local function comments()
	km({"v","n"},"<leader>cc",":s$^\\(\\s\\| \\)*\\zs\\(.\\)$\\2$g|noh<Left><Left><Left><Left><Left><Left><Left><Left>")
	km({"v","n"},"<leader>cr",':s$^\\(\\s\\| \\)*\\zs$$g|noh<Left><Left><Left><Left><Left><Left><Left>')
	-- wasted 20min of my life for this lmao
end
local function surround_basic()
		km({"v","n"},"<leader>x", function() Manual_surround() end)
end
local function movement()
	km("v", "J", ":m '>+1<CR>gv=gv")
	km("v", "K", ":m '<-2<CR>gv=gv")

	km("n","J", "mzJ`z")
	km("n","<C-d>", "<C-d>zz")
	km("n","<C-u>", "<C-u>zz")
	km("n","<C-o>", "<C-o>zz")
end
local function cmd_mode_edit()
	km({"n","c","i"}, "<c- >", function() Cmdline_buff_control() end )
	km({"n","c"}, "<c-;>", "<c-c><c-c><c-c>q:k")
	km("v","<c- >", ":")
end
local function terminal_mode_related()
    km("t", "<C- >", "<C-\\><C-n>",
	{ desc = "Escape terminal mode" })

    km("n", "<leader>ter", "<c-w>v<c-w>l:term<CR><c-w>h",
	{ desc = "Open terminal in vertical split" })

    km('t', '<C-l><C-l>', [[<C-\><C-N>:lua ClearTerm(0)<CR>]],
	{ desc = "Clear terminal screen" })
end
local function quality_of_life()

	-- Disables jumps after searching with *
	km('n', '*', '*N', { noremap = true })
	km('v', '*', 'y/\\V<C-r>"<Cr>N', { noremap = true }) -- "*N" does not work directly

	-- Search and replace last search
	-- This "nests" search groups if used more than once; not sure if this will be a problem or not
	km({'v'}, '<leader>/', [[q:is/\(<C-r>/\)//g<Esc>F/i]])
	km({'n'}, '<leader>/', [[q:i%s/\(<C-r>/\)//g<Esc>F/i]])

	-- This substitutes a vim feature that shows the hex to the character under the cursor
	km({'v','n'},'ga','<Esc>ggVG')

	-- Gets rid of "line with trailing spaces"
	km("n","<leader>rr",[[:%s/\v(^[ \t]+$)|([ \t]+$)//g|noh]])
	km("v","<leader>rr",[[<Esc>:'<,'>s/[ \t]\+$//g|noh]])

	-- By using nvim_feedkeys on "t" mode, <A- > now works with every single plugin,
	-- since the keys are sent as if typed.
	km({'n','v','i'}	,"<A- >", function() vim.api.nvim_feedkeys("", "t", false) end)
	km({'c'}			,"<A- >", function() vim.api.nvim_feedkeys("", "t", false) end)

	km("n","<leader>mk", ":mksession!<cr>")

	km("v",":", ":<C-u>")

	-- zz zt zb in visual selection mode
	km("v","zt", "<Esc>ztgv")
	km("v","zz", "<Esc>zzgv")
	km("v","zb", "<Esc>zbgv")

	-- control+hjkl as arrow keys in command mode
	km("c","<c-h>", "<Left>")
	km("c","<c-j>", "<Down>")
	km("c","<c-k>", "<Up>")
	km("c","<c-l>", "<Right>")
	km("c","<c-b>", "<c-Left>")
	km("c","<c-e>", "<c-Right>")

	-- Toggle relative line number on/of
	km("n","<leader>rnu", ":set rnu! nu<cr>")

	-- Write(save) file from shortcut
	km("n","<leader>ww", ":w<cr>")
	km("n","<leader>wa", ":wa<cr>")

	-- Opens Explorer (newtr)
	km("n", "<leader>pv", vim.cmd.Ex)

	-- :noh (no highlight) remap
	km("n", "<leader><space>", ":noh<CR>")

	-- Normal mode Backspace is now @
	km("n","<BS>", "@")

	-- quit without saving
	-- if oil is active, it will quit at file path
	vim.api.nvim_create_user_command( 'QA', function() vim.cmd('qa!') end, {})
	vim.api.nvim_create_user_command( 'Qa', function() vim.cmd('qa!') end, {})
	vim.api.nvim_create_user_command( 'QQ', function() Exit_to_file_path() end, {})
	vim.api.nvim_create_user_command( 'Qq', function() Exit_to_file_path() end, {})
end
local function split_window_controls()
    km("n", "<c-w>,", "<c-w>7<", { desc = "Decrease window width" })
    km("n", "<c-w>.", "<c-w>7>", { desc = "Increase window width" })
    km("n", "<c-w>=", "<c-w>7+", { desc = "Increase window height" })
    km("n", "<c-w>-", "<c-w>7-", { desc = "Decrease window height" })

    km("n", "<M-w>", "<c-w>", 	{ desc = "Window command prefix" })
    km("n", "<M-,>", "<c-w>7<", { desc = "Decrease window width" })
    km("n", "<M-.>", "<c-w>7>", { desc = "Increase window width" })
    km("n", "<M-=>", "<c-w>7+", { desc = "Increase window height" })
    km("n", "<M-->", "<c-w>7-", { desc = "Decrease window height" })

    km("n", "<M-h>", function() vim.cmd.wincmd('h') end, { desc = "Move to window left" })
    km("n", "<M-j>", function() vim.cmd.wincmd('j') end, { desc = "Move to window below" })
    km("n", "<M-k>", function() vim.cmd.wincmd('k') end, { desc = "Move to window above" })
    km("n", "<M-l>", function() vim.cmd.wincmd('l') end, { desc = "Move to window right" })
end
local function clipboard_utilities()
    km("v", "<leader>y", '"+y', 		{ desc = "Yank to system clipboard" })
    km("v", "<leader>d", '"+d', 		{ desc = "Cut to system clipboard" })
    km({"v", "n"}, "<leader>p", '"+p', 	{ desc = "Paste from system clipboard" })
    km({"v", "n"}, "P", '"+p', 			{ desc = "Paste from system clipboard" })
    km("v", "Y", '"+y', 				{ desc = "Yank to system clipboard" })
    km("v", "D", '"+d', 				{ desc = "Cut to system clipboard" })

    km("n", "<leader>yy", '"+yy', { desc = "Yank line to system clipboard" })
    km("n", "<leader>dd", '"+dd', { desc = "Cut line to system clipboard" })

    km("n", "<leader>Y", [[v$"+y]], { desc = "Yank from cursor to end of line to system clipboard" })

    km("i", "<A-P>", '<C-r>"', { desc = "Paste from default register in insert mode" })
    km("i", "<A-p>", "<C-r>+", { desc = "Paste from system clipboard in insert mode" })

    km("n", "<leader>ayy", '"ayy', 			{ desc = "Yank line to register 'a'" })
    km("n", "<leader>add", '"add', 			{ desc = "Cut line to register 'a'" })
    km("v", "<leader>ay", '"ay', 			{ desc = "Yank selection to register 'a'" })
    km("v", "<leader>ad", '"ad', 			{ desc = "Cut selection to register 'a'" })
    km({"v", "n"}, "<leader>ap", '"ap', 	{ desc = "Paste from register 'a'" })
end
local function default_buffer_manipulation()
	km("n", "<leader>bd", ":bd!<CR>")
end
local function scripting()
	km('n', "<leader><F5>", ":!%:p<cr>",	{ desc = "Execute current script" })
	km("n", "<leader>bash", ":w !bash", 	{ desc = "Save and pipe buffer to bash" })
end
local function set_spell()
	km("n", "<leader>ss", ":set spell!<cr>", { desc = "Toggle spell checking" })
    km("n", "<leader>sl", ":set spelllang=", { desc = "Set spell language" })
end
local function spell_check()
	km("n", "z;", "]s", 		{ desc = "Next spelling error" })
    km("n", "z,", "[s", 		{ desc = "Previous spelling error" })
    km("n", "z<leader>", "z=", 	{ desc = "Suggest spelling correction" })
end



--
-- << Enabled Remaps by Topic >>
--
quality_of_life()
set_spell()
scripting()
clipboard_utilities()
spell_check()
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

