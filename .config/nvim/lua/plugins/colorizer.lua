return {
	"norcalli/nvim-colorizer.lua",
	event = "VeryLazy",
	opts = {
		"java",
		"css",
		"javascript",
		"xml",
		"vue",
		css = { rgb_fn = true, names = true, RGB = true, RRGGBB = true },
		-- css = false,
		xml = { rgb_fn = true },
		html = {
			mode = "foreground",
		},
	},
	-- Neovim Substitute of 'ap/vim-css-color'
	-- :ColorizerAttachToBuffer for running on current buffer
	-- :ColorizerToggle to toggle colorizer
}
