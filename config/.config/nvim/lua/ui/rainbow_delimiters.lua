
return {
	'HiPhish/rainbow-delimiters.nvim',
	lazy = false,
	config = function()
		local rainbow_delimiters = require 'rainbow-delimiters'

		vim.g.rainbow_delimiters = {
			strategy = {
				[''] = rainbow_delimiters.strategy['global'],
				vim = rainbow_delimiters.strategy['local'],
			},
			query = {
				[''] = 'rainbow-delimiters',
				lua = 'rainbow-blocks',
			},
			blacklist = {
				'oil',
				'noice',
				'msg',
				'prompt',
				'terminal',
				'quickfix',
				'toggleterm',
				'snacks_dashboard',
				'snacks_notif',
				'neo-tree',
				'help',
				'lazy',
				'mason',
				'notify',
				'trouble',
				'DressingInput',
				'TelescopePrompt',
				'neogit',
			},
			condition = function(bufnr)
				-- Guard: reject non-code buffers that lack a treesitter parser
				local filetype = vim.bo[bufnr].filetype
				if not filetype or filetype == '' then
					return false
				end
				if filetype:match('^snacks_') then
					return false
				end

				-- Critical: only attach if treesitter can actually parse this buffer
				local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
				if not ok or parser == nil then
					return false
				end

				return true
			end,
		}
	end
}
