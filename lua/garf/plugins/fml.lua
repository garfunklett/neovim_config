return {
    "eandrju/cellular-automaton.nvim",
    event = "VeryLazy",
    config = function ()
        vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
        vim.keymap.set("n", "<leader>fyl", "<cmd>CellularAutomaton game_of_life<CR>")
    end,
}
