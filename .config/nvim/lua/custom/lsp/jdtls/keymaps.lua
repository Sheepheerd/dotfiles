-- NOTE: Java specific keymaps with which key
vim.cmd(
	"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
)
vim.cmd(
	"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
)
vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
vim.cmd("command! -buffer JdtJol lua require('jdtls').jol()")
vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	{ "<leader>J", group = "Java", nowait = true, remap = false },
	{
		"<leader>Jc",
		"<Cmd>lua require('jdtls').extract_constant()<CR>",
		desc = "Extract Constant",
		nowait = true,
		remap = false,
	},
	{
		"<leader>Jm",
		"<Cmd>lua require('jdtls').extract_method(true)<CR>",
		desc = "Extract Method",
		nowait = true,
		remap = false,
	},
	{
		"<leader>Jo",
		"<Cmd>lua require'jdtls'.organize_imports()<CR>",
		desc = "Organize Imports",
		nowait = true,
		remap = false,
	},
	{ "<leader>Ju", "<Cmd>JdtUpdateConfig<CR>", desc = "Update Config", nowait = true, remap = false },
	{
		"<leader>Jv",
		"<Cmd>lua require('jdtls').extract_variable()<CR>",
		desc = "Extract Variable",
		nowait = true,
		remap = false,
	},
}

local vmappings = {
	{
		mode = { "v" },
		{ "<leader>J", group = "Java", nowait = true, remap = false },
		{
			"<leader>Jc",
			"<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
			desc = "Extract Constant",
			nowait = true,
			remap = false,
		},
		{
			"<leader>Jm",
			"<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
			desc = "Extract Method",
			nowait = true,
			remap = false,
		},
		{
			"<leader>Jv",
			"<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
			desc = "Extract Variable",
			nowait = true,
			remap = false,
		},
	},
}

which_key.add(mappings, opts)
which_key.add(vmappings, vopts)
