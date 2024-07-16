return {

	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
	},
	config = true,
	keys = {
		{
			"<leader>ng",
			":Neogit<CR>",
			desc = " Open the status buffer in a new tab",
		},
		{
			"<leader>ngc",
			":Neogit cwd=<cwd><CR>",
			desc = "Use a different repository path",
		},
		{
			"<leader>ngr",
			":Neogit cwd=%:p:h<CR>",
			desc = "Uses the repository of the current file",
		},
		{
			"<leader>ngp",
			":Neogit kind=<kind><CR>",
			desc = "Open specified popup directly",
		},
		{
			"<leader>ngc",
			":Neogit commit<CR>      ",
			desc = "Open commit popup",
		},
	},
}
