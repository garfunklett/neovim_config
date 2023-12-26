return {
    "preservim/tagbar",
    config = function ()
        vim.keymap.set("n", "<leader>et", "<cmd>TagbarToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    end,
}
