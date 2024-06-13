return {
	"vim-test/vim-test",
	config = function()
		-- Reference config: https://github.com/skbolton/titan/blob/main/nvim/nvim/lua/testing.lua
		vim.g["test#strategy"] = {
			nearest = "basic",
			file = "basic",
			suite = "basic",
		}
	end,
}
