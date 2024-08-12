return {
	"https://gitlab.com/schrieveslaach/sonarlint.nvim",
	ft = { "java", "python", "cpp", "typescript", "typescriptreact", "html" },
	dependencies = { "mfussenegger/nvim-jdtls" },
	opts = {
		handlers = {},
	},
	config = function()
		require("sonarlint").setup({
			server = {
				root_dir = require("jdtls.setup").find_root({ "gradlew", ".git", "pom.xml", "mvnw" }),
				autostart = true,
				cmd = {
					"sonarlint-language-server",
					-- Ensure that sonarlint-language-server uses stdio channel
					"-stdio",
					"-analyzers",
					-- paths to the analyzers you need, using those for python and java in this example
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
				},
				settings = {
					sonarlint = {
						pathToCompileCommands = vim.fn.getcwd() .. "/compile_commands.json",
					},
				},
			},
			filetypes = {
				-- Tested and working
				"python",
				"cpp",
				"java",
				"typescript",
				"html",
			},
		})
	end,
}
