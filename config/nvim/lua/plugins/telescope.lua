return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	-- or                              , branch = '0.1.x',
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		require("telescope").setup({})

		local builtin = require("telescope.builtin")

		-- Setup which-key integration
		local wk = require("which-key")
		wk.setup({
			-- your which-key setup options here
		})

		-- Define key mappings with descriptions for which-key
		local mappings = {
			["<leader>pf"] = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find files" },
			["<C-p>"] = { "<cmd>lua require('telescope.builtin').git_files()<cr>", "Git files" },
			["<leader>pws"] = {
				"<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })<cr>",
				"Grep string under cursor",
			},
			["<leader>pWs"] = {
				"<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cWORD>') })<cr>",
				"Grep WORD under cursor",
			},
			["<leader>ps"] = {
				"<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep > ') })<cr>",
				"Grep string with user input",
			},
			["<leader>vh"] = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help tags" },

			["<leader>gc"] = { "<cmd>Telescope git_commits<CR>", "Show git commits" },
			["<leader>gb"] = { "<cmd>Telescope git_branches<CR>", "Show git branches" },
			["<leader>gs"] = { "<cmd>Telescope git_status<CR>", "Show git status" },

			["<leader>dg"] = { "<cmd>Telescope dap frames<CR>", "Dap Frames" },
			["<leader>dc"] = { "<cmd>Telescope dap commands<CR>", "Dap Commands" },
			["<leader>db"] = { "<cmd>Telescope dap list_breakpoints<CR>", "Dap List BPs" },
		}

		-- Register the mappings with which-key
		for key, mapping in pairs(mappings) do
			wk.register({ [key] = mapping })
		end
	end,
}
