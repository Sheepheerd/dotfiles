local set = vim.opt

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.cmd([[filetype plugin on]])
-- vim.g.mapleader = ""

-- Setup persistent undo
if vim.fn.has("persistent_undo") == 1 then
	local target_path = vim.fn.expand("~/.undodir")
	if vim.fn.isdirectory(target_path) == 0 then
		vim.fn.mkdir(target_path, "p", 0700)
	end
	vim.o.undodir = target_path
	vim.o.undofile = true
end
vim.opt.swapfile = false

-- Set highlight on search
set.hlsearch = false
set.incsearch = true

-- Enable mouse mode
set.mouse = "a"

-- Enable Keyboard
vim.o.clipboard = "unnamedplus"

-- Case insensitive searching UNLESS /C or capital in search (:set noic to enable case sensitive search)
set.ignorecase = true
set.smartcase = true

-- Set completeopt to have a better completion experience
-- set.completeopt = 'menuone,noselect'
set.completeopt = "noinsert,menuone,noselect"

-- Create a Telescope command for configuration files
vim.api.nvim_create_user_command("Config", function()
	require("telescope.builtin").find_files({ cwd = "~/.config/nvim" })
end, {})

-- Color Scheme
--vim.o.background = "dark"

vim.opt.pumblend = 0
set.termguicolors = true
vim.cmd("colorscheme rose-pine")

-- Enable Keyboard
vim.o.clipboard = "unnamedplus"

-- Create another Telescope command for configuration files (if needed)
vim.api.nvim_create_user_command("Config", function()
	require("telescope.builtin").find_files({ cwd = "~/.config/nvim" })
end, {})

vim.opt.updatetime = 50

set.shortmess = a
set.cmdheight = 0

-- Markdown view config
vim.g.mkdp_auto_start = 1
vim.g.mkdp_preview_options = { disable_filename = 1 }
