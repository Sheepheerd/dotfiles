-- Map Ctrl+Shift+c to copy the current line to the system clipboard
vim.keymap.set("v", "<leader>y", '"+y<CR>')
vim.keymap.set("n", "<leader>y", '"+y<CR>')

-- Toggle the file explorer with <leader>f
-- vim.keymap.set('n', '<leader>f', ':Ex<CR>')

-- Enter Terminal Mode
vim.keymap.set("n", "<leader>t", ":terminal<CR>")

-- Exit Terminal Mode and into Normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Black Hole Delete (Does not delete to your paste register)
vim.keymap.set("v", "<leader>d", '"_d<CR>')

-- source
vim.keymap.set("n", "<leader><Ctrl>s ", ":source $HOME/.config/nvim/init.lua<CR>")

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Neovim File Explorer Built init
vim.keymap.set("n", "<leader>e", ":Explore<CR>")
