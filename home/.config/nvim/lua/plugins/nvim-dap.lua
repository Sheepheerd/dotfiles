-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Creates a beautiful debugger UI
		{
			"rcarriga/nvim-dap-ui",
			keys = {
				{
					"<leader>ds",
					function()
						require("dap").terminate()
					end,
					desc = "Dap terminate",
				},
				{
					"<C-l>",
					function()
						require("dap").step_over()
					end,
					desc = "Dap step over",
				},
				{
					"<leader>dr",
					function()
						require("dap").repl.toggle()
					end,
					desc = "Toggle Repl",
				},
				{
					"<leader>du",
					function()
						require("dapui").toggle({})
					end,
					desc = "Dap UI",
				},
				{
					"<leader>de",
					function()
						require("dapui").eval()
					end,
					desc = "Eval",
					mode = { "n" },
				},
				{
					"<leader>dc",
					function()
						require("dap").continue()
					end,
					desc = "Dap Continue",
					mode = { "n" },
				},
				{
					"<leader>dx",
					function()
						require("dap").toggle_breakpoint()
					end,
					desc = "Dap Toggle Breakpoint",
					mode = { "n", "v" },
				},
			},
		},

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap-python",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		"leoluz/nvim-dap-go",
	},
	lazy = true,
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,
			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},
			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"jdtls",
				"debugpy",
			},
		})

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
		})

		-- Open and close dap-ui automatically when running debug session
		--dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		--dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		--dap.listeners.before.event_exited["dapui_config"] = dapui.close

		local python_path = table
			.concat({ vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv", "bin", "python" }, "/")
			:gsub("//+", "/")

		require("dap-python").setup(python_path)

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
	end,
}
