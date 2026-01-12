
return {
	'tpope/vim-surround',
	dependencies = {'tpope/vim-repeat'},
	init = function() 
		vim.g.surround_no_mappings = true
	end,

	keys = {
		{ "ds",        "<Plug>Dsurround",  mode = "n", desc = "Delete surrounding" },
		{ "cs",        "<Plug>Csurround",  mode = "n", desc = "Change surrounding" },
		{ "cS",        "<Plug>CSurround",  mode = "n", desc = "Change surrounding (add on new lines)" },
		{ "ys",        "<Plug>Ysurround",  mode = "n", desc = "Add surrounding" },
		{ "yS",        "<Plug>YSurround",  mode = "n", desc = "Add surrounding (add on new lines)" },
		{ "yss",       "<Plug>Yssurround", mode = "n", desc = "Add surrounding on current line" },
		{ "ySs",       "<Plug>YSsurround", mode = "n", desc = "Add surrounding on current line & move down" },
		{ "ySS",       "<Plug>YSsurround", mode = "n", desc = "Add surrounding on current line & move down" },
		{ "<leader>s", "<Plug>VSurround",  mode = "v", desc = "Surround selection" },
	},
}
