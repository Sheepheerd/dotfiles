return {
	"SuperBo/fugit2.nvim",
	opts = {
		width = 70,
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
		{
			"chrisgrieser/nvim-tinygit", -- optional: for Github PR view
			dependencies = { "stevearc/dressing.nvim" },
		},
	},
	cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
	keys = {
		{ "<leader>FG", mode = "n", "<cmd>Fugit2<cr>" },
	},
	opts = {

		libgit2_path = vim.fn.glob(os.getenv("HOME") .. "/.local/lib/libgit2.so.1.*"),
	},
}
