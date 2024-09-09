return {
	"ggandor/leap.nvim",
	dependencies = {
		"tpope/vim-repeat",
	},
	config = function()
		vim.keymap.set({ "n", "x", "o" }, "<Tab>", "<Plug>(leap-forward)")
		vim.keymap.set({ "n", "x", "o" }, "<S-Tab>", "<Plug>(leap-backward)")
		vim.keymap.set({ "n", "x", "o" }, "<leader><Tab>", "<Plug>(leap-from-window)")
	end,
}
