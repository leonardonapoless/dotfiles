

--
-- # Default status line
--

StatusLine = {
	path_relative = function()

		local full_path = vim.fn.expand('%:p')
		if full_path == '' or full_path == nil then return '[Unnamed]' end

		local buff_name = vim.fn.expand('%:t')
		local buff_path = vim.fn.expand('%:p:h')
		local cwd = vim.fn.getcwd()

		if string.find(buff_path, '^'..cwd) then
			local res = string.sub(buff_path, #cwd + 1)
			res = (res == '' or nil) and './'..buff_name or '.'..res..'/'..buff_name
			return res
		end

		if vim.b.current_syntax == 'oil' then
			local res = vim.fn.substitute(buff_path, [[^oil:[/]\?[/]\?]],"","g") -- I dont think vim regex is needed here
			res = vim.fn.substitute(res, "^"..vim.fn.expand('~'),'~','g')
			return res
		end

		return full_path
		--return buff_name
	end,

	lsp = function()
		local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
		local clients = vim.lsp.get_clients()

		if next(clients) == nil then return '' end

		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return client.name
				--return ' '..client.name
			end
		end

		return ''
	end,
}
--:help statusline
vim.opt.statusline = "%{v:lua.StatusLine.path_relative()} %w%h%m%r%= %{v:lua.StatusLine.lsp()} %l:%c %P "



--
-- # Buffer Settings
--

vim.g.netrw_bufsettings='noma nomod nu nobl nowrap ro'
-- Relative line numbers in netrw
-- what the hell is this even supposed to mean?

vim.opt.termguicolors=true
vim.opt.rnu = true
vim.opt.nu = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.signcolumn = "no"
vim.opt.tabstop = 4 -- Defines indent spacing
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 4
vim.opt.updatetime = 50

-- When a tab is closed, go to previous tab
-- (overrides default behaviour: go to next tab)
--local group = vim.api.nvim_create_augroup('__temp', { clear = true })
--vim.api.nvim_create_autocmd(
	--{
		--"TabClosed"
	--},
	--{
		--group = group,
		--pattern = "*",
		--command = "tabprevious",
	--}
--)

