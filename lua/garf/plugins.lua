local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
    git = {
        clone_timeout = 300, -- Timeout, in seconds, for git clones
    },
}

-- Install your plugins here
return packer.startup(function(use)
    -- basic plugins
    use { "wbthomason/packer.nvim"}
    use { "nvim-lua/plenary.nvim"}
    use { "nvim-tree/nvim-web-devicons" }

    -- color scheme
    use { "folke/tokyonight.nvim"}
    use { "morhetz/gruvbox"}

    -- cmp plugins
    use { "hrsh7th/nvim-cmp"}
    use { "hrsh7th/cmp-nvim-lsp"}
    use { "hrsh7th/cmp-nvim-lua"}
    use { "saadparwaiz1/cmp_luasnip"}
    use { "hrsh7th/cmp-buffer"}
    use { "hrsh7th/cmp-path"}
    use { "hrsh7th/cmp-cmdline"}

    -- snippets
    use { "L3MON4D3/LuaSnip"}
    use { "rafamadriz/friendly-snippets"}

    -- LSP
    use { "neovim/nvim-lspconfig" }
    use { "williamboman/mason.nvim" }
    use { "williamboman/mason-lspconfig.nvim" }
    use { "jose-elias-alvarez/null-ls.nvim" }
    use { "RRethy/vim-illuminate" }

    -- DAP
    use { "mfussenegger/nvim-dap" }

    -- Telescope
    use { "nvim-telescope/telescope.nvim" }

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter" }

    -- explore
    use { "nvim-tree/nvim-tree.lua" }

    -- git
    use { "lewis6991/gitsigns.nvim" }

    -- terminal
    use {"akinsho/toggleterm.nvim", tag = 'v2.2.1' }

    -- status line
    use { "nvim-lualine/lualine.nvim" }

    -- indent visualization
    use { "lukas-reineke/indent-blankline.nvim" }
    use { "rcarriga/nvim-dap-ui" }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
