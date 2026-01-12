
local lsp_servers = {
	"lua_ls",
	"pyright",
	"html",
	"bashls",
	"cssls",
	"clangd"
}

return {
	'williamboman/mason.nvim',
	lazy = false,
	dependencies = {
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
	},
	config = function()
		require('mason').setup({})
		require('mason-lspconfig').setup({
			ensure_installed = lsp_servers,
			handlers = {
				function(server_name)
					require('lspconfig')[server_name].setup({})
				end,
			},
		})
	end
}

