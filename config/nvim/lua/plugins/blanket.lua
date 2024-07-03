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

		-- Get the root directory
		local root = find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

		-- Check if jacoco.xml exists in the expected path
		local jacoco_xml_path = root and root .. "/target/site/jacoco/jacoco.xml"
		if not jacoco_xml_path or not path:new(jacoco_xml_path):exists() then
			return
		end

		-- Configure blanket.nvim
		require("blanket").setup({
			report_path = jacoco_xml_path,
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

		-- Refresh the plugin
		vim.keymap.set({ "n" }, "<leader>br", ":Lazy reload blanket.nvim<CR>")
	end,
}
