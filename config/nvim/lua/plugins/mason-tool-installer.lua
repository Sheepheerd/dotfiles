return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = {
				"checkstyle",
				"clang-format",
				"clangd",
				"codelldb",
				"google-java-format",
				"java-debug-adapter",
				"java-test",
				"jdtls",
				"lua-language-server",
				"luacheck",
				"pyright",
				"shellcheck",
				"stylua",
				"vim-language-server",
			},
		})
	end,
}
