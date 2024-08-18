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
        })
        -- You probably also want to set a keymap to toggle aerial
        vim.keymap.set("n", "<leader>et", "<cmd>AerialToggle!<CR>")

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
