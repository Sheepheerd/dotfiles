return {
	-- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
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
}
