local vim = vim
local Plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.config/nvim/plugged")

Plug("morhetz/gruvbox")
Plug("nvim-lua/popup.nvim")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-tree/nvim-web-devicons")
Plug("nvim-tree/nvim-tree.lua")
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
Plug("nvim-treesitter/playground")
Plug("ThePrimeagen/harpoon")

--LSP Support
Plug("neovim/nvim-lspconfig") -- Required
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim") -- Optional
Plug("WhoIsSethDaniel/mason-tool-installer.nvim")

--Autocompletion
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/nvim-cmp") -- Required
Plug("hrsh7th/cmp-nvim-lsp") -- Required

--Plug('L3MON4D3/LuaSnip'     -- Required
Plug("L3MON4D3/LuaSnip", { ["tag"] = "v2.*", ["do"] = "make install_jsregexp" }) -- Replace <CurrentMajor> by the latest released major (first number of latest release)
Plug("rafamadriz/friendly-snippets")
Plug("VonHeikemen/lsp-zero.nvim", { ["branch"] = "v2.x" })
Plug("ray-x/lsp_signature.nvim")

--Undo Tree
Plug("mbbill/undotree")

--nvim-dap & jdtls
Plug("mfussenegger/nvim-jdtls")
Plug("mfussenegger/nvim-dap")
Plug("jay-babu/mason-nvim-dap.nvim")
Plug("nvim-neotest/nvim-nio")

--nvim linter
Plug("mfussenegger/nvim-lint")

--Nvim Testing
Plug("rcarriga/nvim-dap-ui")
--Plug('klen/nvim-test')
--Plug('vim-test/vim-test')

--Neodev
Plug("folke/neodev.nvim")

--vim-move
Plug("matze/vim-move")

--vim-prettier
Plug("prettier/vim-prettier", { ["do"] = "yarn install --frozen-lockfile --production" })

--Formatter
Plug("mhartington/formatter.nvim")

--Color Scheme
Plug("catppuccin/nvim", { ["as"] = "catppuccin" })

--Vim Leap
Plug("ggandor/leap.nvim")

--lualine
Plug("nvim-lualine/lualine.nvim")

--wilder
Plug("gelguy/wilder.nvim")

--Auto Pairs
Plug("jiangmiao/auto-pairs")

--Commenter
Plug("preservim/nerdcommenter")

--Codeium
Plug("nvim-lua/plenary.nvim")
--Plug("Exafunction/codeium.vim", { ["branch"] = "main" })

--RRethy/vim-illuminate
Plug("RRethy/vim-illuminate")

--Spectre
Plug("nvim-pack/nvim-spectre")

--Mini Indentscope
Plug("echasnovski/mini.indentscope")

--Blankline
Plug("lukas-reineke/indent-blankline.nvim")
--Dashboard
Plug("nvimdev/dashboard-nvim")

--Trouble
Plug("folke/trouble.nvim")

--Godot
--Plug('habamax/vim-godot'

--  Ollama
--Plug('David-Kunz/gen.nvim')

-- Markdown Preview
Plug("toppair/peek.nvim", { ["do"] = "deno task --quiet build:fast" })

-- Vim-Fugitive
Plug("tpope/vim-fugitive")

-- Smooth Scrolling
Plug("karb94/neoscroll.nvim")

vim.call("plug#end")
