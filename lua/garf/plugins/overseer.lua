return {
    'stevearc/overseer.nvim',
    config = function ()
        local overseer = require("overseer")
        overseer.setup()

        -- keymap
        local opts = { silent = true }
        vim.keymap.set("n", "<leader>tr", "<cmd>OverseerRun<CR>", opts)
        vim.keymap.set("n", "<leader>tt", "<cmd>OverseerToggle<CR>", opts)
    end
}
