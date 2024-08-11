return {
	"f-person/git-blame.nvim",
	config = function()
		require("gitblame").setup({
			--Note how the `gitblame_` prefix is omitted in `setup`
			enabled = false,
		})
	end,
}
