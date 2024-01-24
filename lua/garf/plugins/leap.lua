return {
    'ggandor/leap.nvim',
    dependencies = { "tpope/vim-repeat" },
    config = function ()
        -- require('leap').create_default_mappings()
        -- vim.keymap.set({'n','x'}, '<CR>', function ()
        vim.keymap.set({'n','x'}, '<C-j>', function ()
            local current_window = vim.fn.win_getid()
            require('leap').leap { target_windows = { current_window } }
        end)
    end,
}
