local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

require("core")

local augroup = vim.api.nvim_create_augroup
local SheepGroup = augroup("Sheep", {})
local autocmd = vim.api.nvim_create_autocmd

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

vim.diagnostic.config({
	virtual_text = false,
})

local ns = vim.api.nvim_create_namespace("CurlineDiag")
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = args.buf,
			callback = function()
				pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
				local hi = { "Error", "Warn", "Info", "Hint" }
				local curline = vim.api.nvim_win_get_cursor(0)[1]
				local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
				local virt_texts = { { (" "):rep(4) } }
				for _, diag in ipairs(diagnostics) do
					virt_texts[#virt_texts + 1] = { diag.message, "Diagnostic" .. hi[diag.severity] }
				end
				vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
					virt_text = virt_texts,
					hl_mode = "combine",
				})
			end,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = SheepGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = SheepGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", ":Lspsaga goto_definition<CR>", opts)
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration()
		end, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", opts)
		vim.keymap.set("n", "<leader>wa", function()
			vim.lsp.buf.add_workspace_folder()
		end, opts)
		vim.keymap.set("n", "<leader>wr", function()
			vim.lsp.buf.remove_workspace_folder()
		end, opts)
		vim.keymap.set("n", "<leader>D", ":Lspsaga goto_type_definition<CR>", opts)
		vim.keymap.set("n", "<leader>rn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("n", "[d", ":Lspsaga diagnostic_jump_next<CR>", opts)
		vim.keymap.set("n", "]d", ":Lspsaga diagnostic_jump_prev<CR>", opts)
		vim.keymap.set("n", "<leader>ca", ":Lspsaga code_action<CR>", opts)
		vim.keymap.set("n", "gr", function()
			vim.lsp.buf.references()
		end, opts)
	end,
})

--- Signature
vim.keymap.set({ "n" }, "<C-k>", function()
	require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "toggle signature" })

vim.keymap.set({ "n" }, "<Leader>k", function()
	vim.lsp.buf.signature_help()
end, { silent = true, noremap = true, desc = "toggle signature" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })

	require("lsp_signature").on_attach({
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		handler_opts = {
			border = "rounded",
		},
		hint_prefix = "󱄑 ",
	}, bufnr)
end
--
local servers = {
	--C
	-- clangd = {},

	--Python
	--Required NodeJs > 18

	pyright = {},

	--Bash
	bashls = {},

	--Lua
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},

	--Java
	jdtls = {},

	--XML
	-- lemminx = {},
}

local function setup_lsp(server_name, config)
	config.on_attach = function(_, bufnr) end
	require("lspconfig")[server_name].setup(config)
end

-- Setup neovim lua configuration
require("lazydev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- -- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
	if server_name ~= "jdtls" then
		local config = {
			capabilities = capabilities,
			settings = servers[server_name],
		}
		setup_lsp(server_name, config)
	end
end

require("lspconfig").pyright.setup({})

-- INFO: Mason END

-- INFO: nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-e>"] = cmp.mapping.abort(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = nil,
		["<S-Tab>"] = nil,
	}),
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "treesitter" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "nvim_lua" },
		{ name = "cmp_tabnine" },
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { "menu", "abbr", "kind" },
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = "[LSP]",
				luasnip = "[SNIP]",
				treesitter = "[TS]",
				buffer = "[BUF]",
				path = "[PATH]",
				nvim_lua = "[LUA]",
				cmp_tabnine = "[TN]",
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
})

local jdtls_lsp = vim.api.nvim_create_augroup("JdtlsGroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		require("custom.lsp.jdtls.setup").setup()
	end,
	group = jdtls_lsp,
	pattern = "java",
})

require("lspconfig").gdscript.setup({})
