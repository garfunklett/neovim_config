return {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        local aerial = require("aerial")
        aerial.setup({
            -- optionally use on_attach to set keymaps when aerial has attached to a buffer
            on_attach = function(bufnr)
                -- Jump forwards/backwards with '{' and '}'
                vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
            end,

            layout = {
                -- These control the width of the aerial window.
                -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_width and max_width can be a list of mixed types.
                -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
                max_width = { 0.5 },
                width = nil,
                min_width = 20,
            },
        })
        -- You probably also want to set a keymap to toggle aerial
        vim.keymap.set("n", "<leader>et", "<cmd>AerialToggle!<CR>")
        vim.keymap.set("n", "<leader>en", "<cmd>AerialNavToggle<CR>")

        local lualine = require("lualine")
        lualine.setup({
            sections = {
                lualine_x = {
                    {
                        "aerial",
                        -- The separator to be used to separate symbols in status line.
                        sep = " ) ",

                        -- The number of symbols to render top-down. In order to render only 'N' last
                        -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
                        -- be used in order to render only current symbol.
                        depth = nil,

                        -- When 'dense' mode is on, icons are not rendered near their symbols. Only
                        -- a single icon that represents the kind of current symbol is rendered at
                        -- the beginning of status line.
                        dense = true,

                        -- The separator to be used to separate symbols in dense mode.
                        dense_sep = ".",

                        -- Color the symbol icons.
                        colored = true,
                    },
                    "encoding",
                    "fileformat",
                    "filetype"
                },
            },
        })
    end
}
