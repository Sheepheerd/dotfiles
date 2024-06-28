return {
	"dsych/blanket.nvim",
	config = function()
		local api = vim.api
		local path = require("plenary.path")

		-- Define find_root function
		local function find_root(markers)
			local source = api.nvim_buf_get_name(api.nvim_get_current_buf())
			local dirname = vim.fn.fnamemodify(source, ":p:h")
			local getparent = function(p)
				return vim.fn.fnamemodify(p, ":h")
			end
			while getparent(dirname) ~= dirname do
				for _, marker in ipairs(markers) do
					if path:new(dirname, marker):exists() then
						return dirname
					end
				end
				dirname = getparent(dirname)
			end
			return nil -- Handle case where no root is found
		end

		-- Configure blanket.nvim
		require("blanket").setup({
			report_path = find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
				.. "/target/site/jacoco/jacoco.xml",
			filetypes = "java",
			silent = true,
			signs = {
				priority = 10,
				incomplete_branch = "█",
				uncovered = "█",
				covered = "█",
				sign_group = "Blanket",
				incomplete_branch_color = "WarningMsg",
				covered_color = "Statement",
				uncovered_color = "Error",
			},
		})
	end,
}
