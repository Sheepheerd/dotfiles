return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    opts = {
        -- make sure mason installs the server
        servers = {
            jdtls = {},
        },
        setup = {
            jdtls = function()
                return true -- avoid duplicate servers
            end,
        },
    },
    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "clangd", "jdtls" },
            handlers = {
                lua_ls = function()
                    require("lspconfig").lua_ls.setup({})
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
                --jdtls = lsp_zero.noop,
            },
        })

        require("mason-tool-installer").setup({

            ensure_installed = {

                "lua-language-server",
                "vim-language-server",
                "stylua",
                "shellcheck",
                "luacheck",
                "beautysh",
                "clang-format",
                "clangd",
                "codelldb",
                "checkstyle",
                "jdtls",
            },

            auto_update = false,
            run_on_start = true,

            start_delay = 3000, -- 3 second delay
            debounce_hours = 5, -- at least 5 hours between attempts to install/update
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
            }, {
                { name = "buffer" },
            }),
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}

-- Enable completion triggered by <c-x><c-o>
--vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vd", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vrr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>vrn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
--	vim.api.nvim_buf_set_keymap(bufnr, "n", ",f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
