return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            -- offsets = {{filetype = "NvimTree", text = "", padding = 1}},
            -- separator_style = "thin",
            offsets = {{filetype = "NvimTree", text = "NvimTree", padding = 1}},
            separator_style = "slant",
        },
    },
}
