return {
	"akinsho/git-conflict.nvim",
	version = "*",
	config = function()
		require("git-conflict").setup({
			disable_diagnostics = true,
			list_opener = "copen",
			highlights = {
				incoming = "DiffAdd",
				current = "DiffText",
			},
		})
		keys = {
			{
				"co",
				"GitConflictChooseOurs<CR>",
				desc = "Choose Ours Conflict",
			},
			{
				"ct",
				"GitConflictChooseTheirs<CR>",
				desc = "Choose Theirs Conflict",
			},
			{
				"cb",
				"GitConflictChooseBoth<CR>",
				desc = "Choose Both Conflict",
			},
			{
				"cn",
				"GitConflictChooseNone<CR>",
				desc = "Choose None Conflict",
			},
			{
				"[x",
				"GitConflictPrevConflict<CR>",
				desc = "Prev Conflict",
			},
			{
				"]x",
				"GitConflictNextConflict<CR>",
				desc = "Next Conflict",
			},
			{
				"cq",
				"GitConflictListQF<CR>",
				desc = "Get all conflict to quickfix",
			},
		}
	end,
}
