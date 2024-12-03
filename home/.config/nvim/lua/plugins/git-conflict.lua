return {
	"akinsho/git-conflict.nvim",
	version = "*",
	config = function()
		require("git-conflict").setup({})
		vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)")
		vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)")
		vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)")
		vim.keymap.set("n", "<leader>cn", "<Plug>(git-conflict-none)")
		vim.keymap.set("n", "<leader>[x", "<Plug>(git-conflict-prev-conflict)")
		vim.keymap.set("n", "<leader>]x", "<Plug>(git-conflict-next-conflict)")
	end,
}
