-- vim.cmd('lua require("dapui").setup()')
local dap, dapui = require("dap"), require("dapui")

dap.adapters.python = {
	type = "executable",
	-- command = os.getenv("HOME") .. '/.virtenv/debug_vert/bin/python',
	command = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
	args = { "-m", "debugpy.adapter" },
}

dap.adapters.godot = { type = "server", host = "127.0.0.1", port = 6006 }

dap.configurations.gdscript = {
	{
		type = "godot",
		request = "launch",
		name = "Launch scene",
		project = "${workspaceFolder}",
		launch_scene = true,
	},
}
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		pythonPath = function()
			return "/usr/bin/python"
		end,
	},
}

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/codelldb/codelldb",
		args = { "--port", "${port}" },
	},
}
dap.configurations.cpp = {
	{
		name = "Launch",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dapui.setup({
	force_buffers = false,
	element_mappings = { scopes = { edit = "l" } },
	layouts = {
		{
			elements = { "scopes", "breakpoints", "stacks", "watches" },
			size = 80,
			position = "left",
		},
		{ elements = { "repl", "console" }, size = 0.25, position = "bottom" },
	},
	render = { max_value_lines = 3 },
	floating = { max_width = 0.9, max_height = 0.5, border = vim.g.border_chars },
})
require("mason-nvim-dap").setup({
	ensure_installed = { "codelldb" },
})
local mappings = {
	["<M-c>"] = dap.continue,
	["<M-right>"] = dap.step_over,
	["<M-down>"] = dap.step_into,
	["<M-up>"] = dap.step_out,
	["<M-x>"] = dap.toggle_breakpoint,
	["<M-t>"] = function()
		dapui.toggle({ reset = true })
	end,
	["<M-k>"] = dapui.eval,
	["<M-w>"] = dapui.elements.watches.add,
	["<M-m>"] = dapui.float_element,
	["<M-v>"] = function()
		dapui.float_element("scopes")
	end,
	["<M-r>"] = function()
		dapui.float_element("repl")
	end,
	["<M-q>"] = dap.terminate,
}
for keys, mapping in pairs(mappings) do
	vim.api.nvim_set_keymap("n", keys, "", { callback = mapping, noremap = true })
end
