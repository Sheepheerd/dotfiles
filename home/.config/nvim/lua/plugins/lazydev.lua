return {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
        library = {
            { path = "LazyVim",   words = { "LazyVim" } },
            { path = "lazy.nvim", words = { "LazyVim" } },
        },
    },
}
