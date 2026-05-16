-- UI Display
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.shortmess:append("sI")

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Text display
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.wrap = false

-- Scrolling & Performance
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Persistent undo
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Search behavior
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard (macOS integration via pbcopy/pbpaste)
vim.opt.clipboard = "unnamedplus"

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10

-- File handling
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.fileencoding = "utf-8"

-- Netrw settings
vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

-- Disable some built-in plugins for performance
local disabled_built_ins = {
	"gzip", "zip", "zipPlugin", "tar", "tarPlugin",
	"getscript", "getscriptPlugin", "vimball", "vimballPlugin",
	"2html_plugin", "logipat", "rrhelper", "spellfile_plugin",
}
for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end
