return {
	"danymat/neogen",
	config = function()
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
		require("neogen").setup({ snippet_engine = "luasnip" })
		local opts = { noremap = true, silent = true }
	end,
	keys = {
		{
			"<leader>cd",
			":lua require('neogen').generate()<CR>",
			desc = "Add code doc",
		},
	},
}
