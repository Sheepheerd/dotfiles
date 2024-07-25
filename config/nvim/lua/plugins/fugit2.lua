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
	opts = (function()
		local local_libgit2_path = vim.fn.glob(os.getenv("HOME") .. "/.local/lib/libgit2.so.1.*")
		if local_libgit2_path == "" then
			return {
				libgit2_path = nil, -- or leave this out to use the global system's libgit2
				width = 70,
			}
		else
			return {
				libgit2_path = local_libgit2_path,
				width = 70,
			}
		end
	end)(),
}
