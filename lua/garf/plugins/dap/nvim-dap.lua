return {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",

    config = function ()
        local dap = require("dap")

        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = 'OpenDebugAD7',
            attach = {
                pidProperty = "pid",
                pidSelect = "ask",
            },
            env = {
                -- LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
            },
        }

        local launch_file = ".vscode/launch.json"
        local function load_launch_json_func ()
            if vim.fn.filereadable(launch_file) ~= 0 then
                dap.configurations.cpp = {}
            end

            local ext_vscode = require("dap.ext.vscode")
            -- old lua_json5 config
            -- local json5 = require("json5")
            -- ext_vscode.json_decode = json5.parse
            -- new lua_json5 config, which might not work
            -- local json_reader = require("json")
            -- ext_vscode.json_decode = json_reader.decode
            local ljs_status_ok, _ = pcall(ext_vscode.load_launchjs, nil, {cppdbg = {'c', 'cpp'}})
            if not ljs_status_ok then
                vim.notify("no launch.js detected.")
            end
            dap.configurations.c = dap.configurations.cpp
            -- require("dap").continue()
        end

        -- keymap
        local opts = { silent = true }
        vim.keymap.set("n", "<leader>dl", "", { silent = true, callback = load_launch_json_func })
        vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
        vim.keymap.set("n", "<leader>dB", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Condition: '))<cr>", opts)
        vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
        vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.run_to_cursor()<cr>", opts)
        vim.keymap.set("n", "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", opts)
        vim.keymap.set("v", "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", opts)
        vim.keymap.set("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
        vim.keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
        vim.keymap.set("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
        vim.keymap.set("n", "<leader>du", "<cmd>lua require'dap'.up()<cr>", opts)
        vim.keymap.set("n", "<leader>dd", "<cmd>lua require'dap'.down()<cr>", opts)
        vim.keymap.set("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)
        -- vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
        -- vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
    end
}
