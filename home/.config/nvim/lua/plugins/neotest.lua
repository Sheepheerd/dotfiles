return {
	"nvim-neotest/neotest",
	dependencies = {
		"vim-test/vim-test",
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-plenary",
		"nvim-neotest/neotest-vim-test",
		"rouge8/neotest-rust",
		"nvim-neotest/nvim-nio",
		"rcasia/neotest-java",
	},
	event = "BufReadPre",
	config = function()
		local opts = {
			adapters = {
				require("neotest-python")({
					dap = { justMyCode = false },
					runner = "unittest",
				}),
				require("neotest-plenary"),
				require("neotest-vim-test")({
					ignore_file_types = { "python", "vim", "lua" },
				}),
				require("neotest-rust")({
					args = { "--no-capture" },
				}),
				require("neotest-java")({}),
			},
		}

		-- get neotest namespace (api call creates or returns namespace)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)
		require("neotest").setup(opts)
	end,

	keys = {
		{
			"<leader>ntr",
			":lua require('neotest').run.run()<CR>",
			desc = "Neotest run nearest test",
		},
		{
			"<leader>ntc",
			":lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
			desc = "Neotest run current file",
		},
		{
			"<leader>ntd",
			":lua require('neotest').run.run({strategy = 'dap'})<CR>",
			desc = "Neotest run with debug",
		},
		{
			"<leader>ntx",
			":lua require('neotest').run.stop()<CR>",
			desc = "Neotest stop",
		},
		{
			"<leader>nta",
			":lua require('neotest').run.attach()<CR>",
			desc = "Neotest attach",
		},
		{
			"<leader>nto",
			":Neotest output-panel<CR>",
			desc = "Neotest output panel",
		},
		{
			"<leader>nts",
			":Neotest summary<CR>",
			desc = "Neotest summary panel",
		},
		{
			"<leader>ntw",
			":lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>",
			desc = "Neotest watch",
		},
	},
}
