return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})

      vim.keymap.set("n", "<leader>xx", ":TroubleToggle diagnostics<CR>")
      vim.keymap.set("n", "<leader>xX", ":TroubleToggle diagnostics filter.buf=0<CR>")
      vim.keymap.set("n", "<leader>xs", ":TroubleToggle symbols focus=false<CR>")
      vim.keymap.set("n", "<leader>xl", ":TroubleToggle lsp focus=false win.position=right<CR>")
      vim.keymap.set("n", "<leader>xL", ":TroubleToggle loclist<CR>")
      vim.keymap.set("n", "<leader>xQ", ":TroubleToggle qflist<CR>")
    end
  }


