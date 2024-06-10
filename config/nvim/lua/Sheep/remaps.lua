-- Map Ctrl+Shift+c to copy the current line to the system clipboard
vim.keymap.set("v", "<leader>y", '"+y<CR>')
vim.keymap.set("n", "<leader>y", '"+y<CR>')

-- Optionally, you can create keybindings to open Telescope:
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")

-- Toggle the file explorer with <leader>f
-- vim.keymap.set('n', '<leader>f', ':Ex<CR>')

-- Undo Tree Toggle
vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle)

-- Exit Terminal Mode
vim.keymap.set("n", "<leader>t", ":terminal<CR>")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>")

-- Black Hole Delete
vim.keymap.set("v", "<leader>d", '"_d<CR>')

-- nvim-dap-ui
vim.keymap.set("n", "<leader>o", ':lua require("dapui").toggle()<CR> ')

-- source
vim.keymap.set("n", "<leader><Ctrl>s ", ":source $HOME/.config/nvim/init.lua<CR>")

-- navigate windows
-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })


-- Ollama
vim.keymap.set("n", "<leader>]", ":Gen<CR>")
vim.keymap.set("v", "<leader>]", ":Gen<CR>")

-- Neovim File Explorer Built init
vim.keymap.set("n", "<leader>e", ":Explore<CR>")

vim.g.codeium_disable_bindings = 1
