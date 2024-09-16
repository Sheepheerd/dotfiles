-- Map Ctrl+Shift+c to copy the current line to the system clipboard
vim.keymap.set("v", "<leader>y", '"+y<CR>')
vim.keymap.set("n", "<leader>y", '"+y<CR>')

-- Set No Text Wrap
vim.opt.wrap = false

-- Undo Tree Toggle
vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle)

-- Exit Terminal Mode
vim.keymap.set("n", "<leader>t", ":terminal<CR>")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Nvim Tree
vim.keymap.set("n", "<leader>nf", ":Neotree toggle<CR>")

-- Black Hole Delete
vim.keymap.set("v", "<leader>0", '"_d<CR>')

-- source
vim.keymap.set("n", "<leader><C-s>", ":source $HOME/.config/nvim/init.lua<CR>")

-- Neovim File Explorer Built init
vim.keymap.set("n", "<leader>e", ":Explore<CR>")

-- Nvim-treehopper
vim.keymap.set("n", "m", "<cmd>lua require('tsht').nodes()<CR>")

-- SPELL TOGGLE
-- Pressing ,ss will toggle and untoggle spell checking
vim.keymap.set("n", "<leader>ss", "<cmd>setlocal spell!<cr>", { desc = "Toggle Spell Checking" })

-- Close buffer without losing split
vim.keymap.set("n", "<leader>0", "<cmd>bp|bd #<CR>", { desc = "Close Buffer; Retain Split" })

-- Paste not into buffer
vim.keymap.set("v", "p", '"_dP')

-- Format all blank lines to single blank lines
vim.keymap.set("n", "<leader>fl", ":g/^$/,/./-j<CR>", { desc = "Format blank lines" })
