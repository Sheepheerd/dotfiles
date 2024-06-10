local lsp_zero = require("lsp-zero")

local opts = { noremap = true, silent = true }
local on_attach = lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	--

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vd", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vrr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vrn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", ",f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md

local lsp_flags = { debounce_text_changes = 150 }
require("lspconfig").gdscript.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	filetypes = { "gd", "gdscript", "gdscript3" },
})
--lsp_zero.skip_server_setup({'jdtls'})
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "jdtls", "clangd" },
	handlers = {
		lua_ls = function()
			require("lspconfig").lua_ls.setup({})
		end,
		bashls = function()
			require("lspconfig").bashls.setup({})
		end,
		clangd = function()
			require("lspconfig").clangd.setup({
				capabilities = capabilities,
				--server_capabilities.signatureHelpProvider == false
			})
		end,
		--yamlls = function()
		--require('lspconfig').yamlls.setup({
		--capabilities = capabilities
		--})
		--end,
		ansiblels = function()
			require("lspconfig").ansiblels.setup({})
		end,
		jdtls = lsp_zero.noop,
	},
})
