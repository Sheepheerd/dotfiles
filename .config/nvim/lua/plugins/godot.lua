return {
	"lommix/godot.nvim",
	config = function()
		local ok, godot = pcall(require, "godot")
		if not ok then
			return
		end

		-- default config
		local config = {
			-- 	bin = "godot",
			-- 	gui = {
			-- 		console_config = @config for vim.api.nvim_open_win
			-- 	},
		}

		godot.setup(config)

		local function map(m, k, v)
			vim.keymap.set(m, k, v, { silent = true })
		end

		map("n", "<leader>dr", godot.debugger.debug)
		map("n", "<leader>dd", godot.debugger.debug_at_cursor)
		map("n", "<leader>dq", godot.debugger.quit)
		map("n", "<leader>dc", godot.debugger.continue)
		map("n", "<leader>ds", godot.debugger.step)
	end,
}
