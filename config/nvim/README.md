# NeoVim

![Neovim](./Neovim.png)
## Dependencies

- [neovim](https://wiki.archlinux.org/title/Neovim)
- [neovim-older-but-new](https://github.com/neovim/neovim-releases)

## Why?

Neovim is a lighter and faster alternative to other IDEs. This setup aims at creating an IDE that is easily customizable, out of the box, and simple to use.

## How To Install

Install [vim-plug](https://github.com/junegunn/vim-plug)

Place the `nvim` folder in the `~/.config` folder. Open up neovim, skip through the errors, and execute `:PlugInstall`

## Mason

[Mason](https://github.com/williamboman/mason.nvim) is a package manager for Neovim. Using the [Masontools](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) we can auto
install certain languages, linters, and debuggers.

<details/>
    <summary>Auto Installed Packages</summary>

### Packages
- vim-language-server
- shellcheck
- beautysh
- lua-language-server
- stylua
- luacheck
- clang-format
- clangd
- codelldb
- checkstyle
- jdtls

</details>

## Plugins Installed

<details/>
    <Summary>Plugins</summary>

### Plugins
- [harpoon](https://github.com/ThePrimeagen/harpoon)
- [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [codeium](https://github.com/Exafunction/codeium.nvim)
- [masontools](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)
- [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim)
- [lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [formatter](https://github.com/mhartington/formatter.nvim)
- [dashboard](https://github.com/nvimdev/dashboard-nvim)
- [leap](https://github.com/ggandor/leap.nvim)
- [signature](https://github.com/ray-x/lsp_signature.nvim)
- [lualine](https://github.com/nvim-lualine/lualine.nvim)
- [wilder](https://github.com/gelguy/wilder.nvim)
- [illuminate](https://github.com/RRethy/vim-illuminate)
- [linter](https://github.com/mfussenegger/nvim-lint)
- [indentscope](https://github.com/echasnovski/mini.indentscope)
- [trouble](https://github.com/folke/trouble.nvim)
- [neoscroll](https://github.com/karb94/neoscroll.nvim)
<!--- [peek](https://github.com/toppair/peek.nvim)-->
</details>

## Keymaps

[link](KEYMAPS.md)

## LSP
The java lsp (language-server-protocol) is set up with lsp-zero. To add a language server, download the package with mason and add it to the lsp.lua config file.
