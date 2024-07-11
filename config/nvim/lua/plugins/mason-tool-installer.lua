return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = {
				--				"clang-format",
				"clangd",
				"codelldb",
				"java-debug-adapter",
				"java-test",
				"jdtls",
				"lua-language-server",
				--				"luacheck",
				"stylua",
				"xmlformatter",
				"lemminx",
				"gdtoolkit",
			},
		})
	end,
}
