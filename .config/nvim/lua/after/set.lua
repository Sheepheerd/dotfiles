vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.cmd [[filetype plugin on]]
-- vim.g.mapleader = ""


vim.cmd[[
if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif
]]

-- Color Scheme
vim.o.background = "dark"
vim.cmd.colorscheme("catppuccin")

-- Enable Keyboard
vim.o.clipboard = "unnamedplus"

vim.api.nvim_create_user_command("Config", function()
	require("telescope.builtin").find_files({ cwd = "~/.config/nvim" })
end, {})

-- Color Scheme
vim.o.background = "dark"
vim.cmd.colorscheme("catppuccin")

-- Enable Keyboard
vim.o.clipboard = "unnamedplus"

vim.api.nvim_create_user_command("Config", function()
	require("telescope.builtin").find_files({ cwd = "~/.config/nvim" })
end, {})


-- Peek for md files
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
