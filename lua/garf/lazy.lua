-- lazy bootstrap code
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

require("lazy").setup(
    {
        { import = "garf.plugins" },
        { import = "garf.plugins.sidebar" },
        { import = "garf.plugins.cvs" },
        { import = "garf.plugins.lsp" },
        { import = "garf.plugins.dap" },
    },
    {
        defaults = {
            version = "*",
        },
        install = {
            colorscheme = { "nightfly" },
        },
        checker = {
            enabled = true,
            notify = false,
        },
        change_detection = {
            notify = false,
        },
    }
)
