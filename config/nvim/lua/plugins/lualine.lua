return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	opts = {

		-- require("lualine").setup({

		options = {
			icons_enabled = true,
			theme = "nightfly",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {},
			always_divide_middle = true,
			globalstatus = false,
			refresh = {
				statusline = 250,
				tabline = 1000,
			},
		},
		sections = {
			lualine_a = {
				"mode",
			},
			lualine_b = {
				"branch",
				"diff",
				"diagnostics",
			},
			lualine_c = {
				{
					"filename",
					path = 1,
					file_status = true,
					symbols = {
						-- modified = "[+]", -- Text to show when the file is modified.
						modified = "[$]", -- Text to show when the file is modified.
						readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
						unnamed = "[No Name]", -- Text to show for unnamed buffers.
						newfile = "[New]", -- Text to show for newly created file before first write
					},
				},
			},
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
			},
			lualine_y = {
				"progress",
			},
			lualine_z = {
				"location",
			},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				{
					"filename",
					path = 1,
				},
			},
			lualine_x = {
				"location",
			},
			lualine_y = {},
			lualine_z = {},
		},
		extensions = {},
	},

	-- )
}
