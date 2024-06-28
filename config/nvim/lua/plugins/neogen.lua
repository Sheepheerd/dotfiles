return {
	"danymat/neogen",
	config = function()
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
		require("neogen").setup({ snippet_engine = "luasnip" })
		local opts = { noremap = true, silent = true }
		vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
	end,
}
