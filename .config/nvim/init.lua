
function openTerminal(path)
	vim.cmd('silent! !warp --working-directory "'..path..'" & disown') end

function openNeovim(path)
	vim.cmd('silent! !warp --working-directory "'..path..'" -e bash -c "nvim ." & disown') end

local km = vim.keymap.set
local cmd = vim.cmd


require('buffer_settings')
require('remap_tools')
require('remaps')

require("lazy_bootstrap")
require("lazy").setup({
	require('plugin._snacks'),
	require('colorscheme.gruvbox'),
	require('plugin.surround'),
	require('plugin._leap'),
	require('plugin._flash'),
	require('ui.treesitter'),
	-- require('ui._treesitter_context'),
	require('lsp.lsp_config'),
	require('lsp.cmp'),
	require('lsp._lazydev'),
	require('plugin._telescope'),
	require('plugin.oil'),
	require('plugin.neo_tree'),
	require('plugin.harpoon2'),
	require('plugin.undotree'),
	require('plugin.wilder'),
	require('plugin.diffview'),
	require('plugin._neogit'),
	require('plugin.treesitter_textobjects'),
	require('plugin.trouble'),
	require('plugin.whichkey'),
	require('plugin.dap'),
	require('plugin.react'),
	require('ui._tabby'),
	require('ui._gitsigns'),
	require('ui.nvim_web_devicons'),
	require('ui.rainbow_delimiters'),
    require('plugin.notify'),
	require('plugin.noice'),
	require('plugin.lualine'),
    -- require('ui.lua-line'),
})

require('checks')
