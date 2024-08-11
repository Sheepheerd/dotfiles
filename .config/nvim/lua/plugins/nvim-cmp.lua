return {
	-- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lua",
		{
			"L3MON4D3/LuaSnip",
			dependencies = { "rafamadriz/friendly-snippets" },
			event = "InsertEnter",
			build = "make install_jsregexp",
		},
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"honza/vim-snippets",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"ray-x/cmp-treesitter",
		-- {
		-- 	"tzachar/cmp-tabnine",
		-- 	build = "./install.sh",
		-- },
	},
	config = function()
		local luasnip = require("luasnip")
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered({
					border = "rounded",
				}),
				documentation = cmp.config.window.bordered({ border = "single" }),
			},
		})
	end,
}
