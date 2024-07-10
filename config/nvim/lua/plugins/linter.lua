return {
	"mfussenegger/nvim-lint",
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			--java = { "checkstyle" },
			python = { "ruff" },
		},
	},
	config = function(_, opts)
		local lint = require("lint")

		-- Ensure opts is not nil and has the expected structure
		opts = opts or {}
		opts.events = opts.events or { "BufWritePost", "BufReadPost", "InsertLeave" }
		opts.linters_by_ft = opts.linters_by_ft or { java = { "checkstyle" } }

		-- Setup linters by file type
		lint.linters_by_ft = opts.linters_by_ft

		-- Debounce function to delay lint execution
		local function debounce(ms, fn)
			local timer = vim.loop.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end

		-- Function to run linting
		local function lint_files()
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)

			-- Add fallback and global linters if no linters are found
			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["_"] or {})
			end
			vim.list_extend(names, lint.linters_by_ft["*"] or {})

			-- Filter linters
			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				return linter and (not linter.condition or linter.condition(ctx))
			end, names)

			-- Run linters
			if #names > 0 then
				lint.try_lint(names)
			end
		end

		-- Setup autocmd for linting events
		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = debounce(100, lint_files),
		})
	end,
}
