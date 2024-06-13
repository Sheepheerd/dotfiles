return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("trouble").setup({})

		vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics<CR>")
		vim.keymap.set("n", "<leader>xX", ":Trouble diagnostics filter.buf=0<CR>")
		vim.keymap.set("n", "<leader>xs", ":Trouble symbols focus=false<CR>")
		vim.keymap.set("n", "<leader>xl", ":Trouble lsp focus=false win.position=right<CR>")
		vim.keymap.set("n", "<leader>xL", ":Trouble loclist<CR>")
		vim.keymap.set("n", "<leader>xQ", ":Trouble qflist<CR>")
	end,
}
