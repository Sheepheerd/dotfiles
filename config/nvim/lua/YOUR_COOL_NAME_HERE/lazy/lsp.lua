return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls" },

			-- Auto enable lsp with (vim.lsp.enable()) if the lsp was installed with mason. Version 0.11 neovim
			automatic_enable = {
				"lua_ls",
			},
		})

		require("mason-tool-installer").setup({

			ensure_installed = {
				-- Installs packages on boot. Some may fail because your are missing unzip or other cli programs
				"lua-language-server",
				"stylua",
				"luacheck",
			},

			auto_update = false,
			run_on_start = true,

			start_delay = 3000,
			debounce_hours = 5,
		})
	end,
}
