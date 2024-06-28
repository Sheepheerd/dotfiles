return {
	"simaxme/java.nvim",
	config = function()
		require("java").setup({
			rename = {
				enable = true, -- enable the functionality for renaming java files
				nvimtree = true, -- enable nvimtree integration
				write_and_close = false, -- automatically write and close modified (previously unopened) files after refactoring a java file
			},
			snippets = {
				enable = true, -- enable the functionality for java snippets
			},
			root_markers = { -- markers for detecting the package path (the package path should start *after* the marker)
				"main/java/",
				"test/java/",
			},
		})
	end,
}
