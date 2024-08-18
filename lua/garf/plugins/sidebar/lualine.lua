return {
    "nvim-lualine/lualine.nvim",
    config = function ()
        local lualine = require("lualine")
        lualine.setup({
            options = {
                -- theme = "gruvbox",
                theme = "iceberg",

                -- extensions = {"aerial"},

                -- winbar = {
                --     lualine_a = {"filename"},
                --     lualine_b = {"branch"},
                --     lualine_c = {"aerial"},
                -- },

                -- tabline = {
                --     lualine_a = {'tabs'},
                --     lualine_b = {'buffers'},
                -- },
            }
        })
    end
}
