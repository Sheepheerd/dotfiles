return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ "williamboman/mason.nvim", config = true },
		-- { "williamboman/mason.nvim"},
		"williamboman/mason-lspconfig.nvim",

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		-- NOTE: fidget.nvim will soon be completely rewritten. In the meantime, please pin your plugin config to the legacy tag to avoid breaking changes.

		-- Additional lua configuration, makes nvim stuff amazing!
		{
			"folke/lazydev.nvim",
			ft = {
				"lua",
				"vim",
			},
			opts = {},
		},
		"ray-x/lsp_signature.nvim",
	},
	event = "BufReadPre",
}
