

function Parse_termc(key) return vim.api.nvim_replace_termcodes(key, true, false, true) end
local tab = Parse_termc("<Tab>")
local esc = Parse_termc("<Esc>")
local cr = Parse_termc("<Cr>")
local cc = Parse_termc("<c-c>")
local up = Parse_termc("<Up>")


-- restart all lsp servers
function RestartLspServers()
	local lsp_clients = vim.lsp.get_active_clients()
	for _, client in pairs(lsp_clients) do vim.cmd("LspRestart "..client.id); end
	print("All lsp clients restarted")
end
vim.api.nvim_create_user_command("RestartLspServers", function() RestartLspServers() end, {})

-- The command line buffer does not have a name.
-- This is the best way I found to check if the buffer is the command line buffer
-- If its just one line, yy, else, 0Y
local function is_commandline_buf()

	local bufname =	(function()
		local bufname = vim.api.nvim_buf_get_name(0)
		return (bufname == ""
		or bufname == nil
		or vim.fn.match(bufname, '[[]Command Line[]]$') ~= -1)
	end)()

	local undo_ftplugin	= (function()
		local success, undo_plug_var = pcall(function() return vim.api.nvim_buf_get_var(0, "undo_ftplugin") end)
		if not success then return false end
		return undo_plug_var == "call VimFtpluginUndo()"
	end)()

	local filetype = (vim.bo[0].filetype == "vim")

	return (filetype and bufname and undo_ftplugin)

end

function ClearTerm(reset)
	vim.opt_local.scrollback = 1

	vim.api.nvim_command("startinsert")
	if reset == 1 then
		vim.api.nvim_feedkeys("reset", 't', false)
	else
		vim.api.nvim_feedkeys("clear", 't', false)
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<cr>', true, false, true), 't', true)

	-- defines maximum amount of lines
	-- neovim's terminal mode will store in its buffer
	vim.opt_local.scrollback = 10000
end

Exit_to_file_path = function() vim.cmd('qa!') end

local cmdline_toggle = false
function Cmdline_buff_control()
	local is_commandline 	= is_commandline_buf()
	local mode 				= vim.api.nvim_get_mode().mode

	if mode == "n" and not is_commandline then
		vim.api.nvim_feedkeys(":"..up,"t",false)
		cmdline_toggle = false
		return
	end
	if mode == "c" and not is_commandline then
		if cmdline_toggle then
			vim.api.nvim_feedkeys(esc,"t",false)
			cmdline_toggle = false
			return
		end
		vim.api.nvim_feedkeys(esc.."q:k","t",false)
		return
	end
	if mode == "n" and is_commandline then
		vim.api.nvim_feedkeys(cc..cc..":"..up,"t",false)
		cmdline_toggle = true
		return
	end
	if mode == "i" and is_commandline then
		vim.api.nvim_feedkeys(cc..cc,"t",false)
		return
	end

end

function Manual_surround()

	local function invert_simple(input_end)
		input_end = string.gsub(input_end,'%[',']')
		input_end = string.gsub(input_end,'%(',')')
		input_end = string.gsub(input_end,'%{','}')
		return input_end
	end
	-- TODO: Add tag detection with vim regex and handle it

	local function invert_vimscript()
		-- TODO: remake invert_simple using vim regex
	end

	local input 		= vim.fn.input('>')
	local input_end 	= invert_simple(input)
	local expression 	= esc.."`>a"..input_end..esc.."`<i"..input..esc.."lm<".."`>"..#input.."lm>"

	vim.api.nvim_feedkeys(expression, "xn", false)
end


-- # Block indent
--
-- [ ] 	check if the search match is after the pivot
-- 		if so, de-indent it untill it reaches the pivot
--
-- [ ] 	also check if the match is on the pivot and solve that also
--
-- [ ]  find a way to add more caracters to the end of all selected lines 
-- 		to make it easier to select on block selection mode
--
function Block_indent()
	-- This function is made to be executed with expandtab turned off
	if vim.o.expandtab then vim.o.expandtab = false end
	-- only executes the function if visual block mode is the active mode
	if vim.api.nvim_get_mode().mode ~= "\22" then return end

	-- local indent_size = vim.o.shiftwidth
	local function reach_back(input)
		if #input == 1 then input = "["..input.."]" end
		vim.api.nvim_feedkeys(esc..[[:silent g/\v%.l((]]..input..[[)|(^))/]]..cr.."N","xn", false)
		-- silent g/\v%.l(([(])|(^.))/
		vim.cmd("noh")
	end

	local function create_target_col_table()

		local out_positions= {}
		local search = vim.fn.searchcount().total

		for i = 1, search do
			table.insert( out_positions, {vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[2]})
			vim.api.nvim_feedkeys(esc.."n","xn", false)
		end

		return out_positions

	end

	local function calc_tabs_amount(col_cursor, col_pivot)
		if col_cursor >= col_pivot then return 0 end

		local first_tab_spaces = 4-(col_cursor%4)
		local new_position=col_cursor+first_tab_spaces

		if new_position >= col_pivot then return 1 end

		local tabs_to_input = 1
		while true do
			new_position=new_position+4
			tabs_to_input=tabs_to_input+1
			if new_position >= col_pivot then return tabs_to_input end
		end
	end


	-- --
	-- Code
	-- --
	vim.api.nvim_feedkeys(esc..[[:silent '<,'>g/\%V.\+/]]..cr..cr.."n","xn",false)
	local positions = create_target_col_table()
	local input = vim.fn.input('>')
	-- vim.api.nvim_feedkeys(esc..[[:silent g/\v%.l((]]..input..[[)|(^))/]]..cr.."N","xn", false)

	for _, cordinates in pairs(positions) do

		vim.api.nvim_win_set_cursor(0,{cordinates[1],cordinates[2]}) -- move the cursor the the col_pivot
		reach_back(input) -- use reach back

		local col_pivot = cordinates[2]
		local col_cursor = vim.api.nvim_win_get_cursor(0)[2]

		local tabs_amount = calc_tabs_amount(col_cursor, col_pivot)

		local tabs = ""
		for i=1, tabs_amount do tabs=tabs..tab end

		vim.api.nvim_feedkeys("i"..tabs..esc.."l","xn", false)

	end

	vim.cmd("noh")
end




