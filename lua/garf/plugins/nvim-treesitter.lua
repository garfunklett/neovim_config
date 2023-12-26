return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")

        -- configure treesitter
        treesitter.setup(
            {
                -- -- these 2 were reported by LSP, but I don't know what do they do
                modules = {},

                auto_install = true,

                -- ensure these language parsers are installed
                sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
                ensure_installed = {
                    "c",
                    "cpp",
                    "python",
                    "lua",
                    "bash",
                    "cmake",
                    "json",
                    "markdown",
                    "markdown_inline",
                    "gitignore",
                    -- "html",
                    -- "css",
                    -- "query",
                    -- "javascript",
                    -- "dockerfile",
                    -- "typescript",
                    -- "tsx",
                    -- "yaml",
                    -- "prisma",
                    -- "svelte",
                    -- "graphql",
                    -- "vim",
                },
                ignore_install = { "" }, -- List of parsers to ignore installing

                -- enable autotagging (w/ nvim-ts-autotag plugin)
                autotag = {
                    enable = true,
                },
                -- enable syntax highlighting
                highlight = {
                    enable = true,
                    disable = { "css" },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        -- init_selection = "<C-space>",
                        -- node_incremental = "<C-space>",
                        init_selection = "<TAB>",
                        node_incremental = "<TAB>",
                        scope_incremental = false,
                        node_decremental = "<S-TAB>",
                    },
                },
                -- enable indentation
                indent = {
                    enable = true,
                    disable = { "css" },
                },
                autopairs = {
                    enable = true,
                },
                -- going to use the plugin to make textobjects
                -- text_objects = {
                --     enable = true,
                -- },
            }
        )
    end,
}
