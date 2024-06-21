return {
	-- NOTE: First, some plugins that don't require any configuration
	{
		--		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		-- event = "VeryLazy",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	--  NOTE: Surrounding (e.g: surround 1 word with '()': ysw), surround 2 lines with '{}' ys2j} )
	--  ysw( : surround 1 word with '(   )' with heading and trailing spaces
	--  cs"' - Change "hello" to 'hello'
	-- "https://vimawesome.com/plugin/surround-vim
	-- "tpope/vim-surround",

	-- NOTE: Database Explorer ()
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
		},
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-ui",
		},
	},
	"junegunn/vim-easy-align",
	opts = {
		autotag = {
			enable = true,
		},
	},

	--"christoomey/vim-tmux-navigator",
	"junegunn/fzf",
	"junegunn/fzf.vim",
	"mbbill/undotree",
	"mfussenegger/nvim-jdtls",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,

		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
