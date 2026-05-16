return {
	'nvim-treesitter/nvim-treesitter-context',
	lazy = false,
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	config = function()
		require('treesitter-context').setup {
			enable = true,
			multiwindow = false,
			max_lines = 0,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = 'outer',
			mode = 'cursor',
		}
	end
}
