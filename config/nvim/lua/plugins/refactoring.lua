return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup({
			prompt_func_return_type = {
				go = false,
				java = true,

				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			prompt_func_param_type = {
				go = false,
				java = true,

				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			printf_statements = {},
			print_var_statements = {},
			show_success_message = true,
		})
		vim.keymap.set("x", "<leader>re", ":Refactor extract ")
		vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")

		vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")

		vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

		vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

		vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
		vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
	end,
}
