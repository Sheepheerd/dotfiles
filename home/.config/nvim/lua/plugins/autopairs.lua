return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true,
		ts_config = {
			lua = { "string" },
			java = { "string" },
		},
	},
	config = function()
		require("nvim-autopairs").setup({})
	end,
}
