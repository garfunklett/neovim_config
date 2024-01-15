return {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    -- tag = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {
                    config = {
                        folds = false,
                    },
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            life = "~/Neorg/life",
                            work = "~/Neorg/work",
                            tech = "~/Neorg/tech",
                            proj = "~/Neorg/proj",
                        },
                        default_workspace = "work",
                    },
                },
                ["core.integrations.treesitter"] = {},
                ["core.summary"] = {},
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp",
                    },
                },
                -- ["core.tempus"] = {},
                -- ["core.ui.calendar"] = {},
            },
        }
    end,
}
