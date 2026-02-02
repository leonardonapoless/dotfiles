-- Global utilities
function openTerminal(path)
	vim.cmd('silent! !warp --working-directory "' .. path .. '" & disown')
end

function openNeovim(path)
	vim.cmd('silent! !warp --working-directory "' .. path .. '" -e bash -c "nvim ." & disown')
end

-- Core config
require('buffer_settings')
require('remap_tools')
require('remaps')

-- Plugin manager
require("lazy_bootstrap")
require("lazy").setup({
	-- Core
	require('plugin._snacks'),
	require('colorscheme.gruvbox'),

	-- Navigation
	require('plugin.surround'),
	require('plugin._leap'),
	require('plugin._flash'),
	require('plugin._telescope'),
	require('plugin.oil'),
	require('plugin.neo_tree'),
	require('plugin.harpoon2'),

	-- Editing
	require('plugin.undotree'),
	require('plugin.treesitter_textobjects'),
	{ 'numToStr/Comment.nvim', opts = {}, lazy = false }, -- gcc/gc for commenting

	-- Syntax
	require('ui.treesitter'),

	-- LSP
	require('lsp.lsp_config'),
	require('lsp.cmp'),
	require('lsp._lazydev'),
	require('plugin.java'), -- nvim-jdtls

	-- Git
	require('plugin.diffview'),
	require('plugin._neogit'),
	require('ui._gitsigns'),
	require('plugin.octo'),

	-- UI
	require('plugin.wilder'),
	require('plugin.trouble'),
	require('plugin.whichkey'),
	require('ui._tabby'),
	require('ui.nvim_web_devicons'),
	require('ui.rainbow_delimiters'),
	require('plugin.notify'),
	require('plugin.noice'),
	require('plugin.lualine'),

	-- Debug
	require('plugin.dap'),

	-- Languages
	require('plugin.react'),
	require('plugin.juce'),
	require('plugin.runner'),
	require('ui._treesitter_context'),
})

require('checks')
