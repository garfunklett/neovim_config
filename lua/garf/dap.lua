local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
    return
end

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    -- command = '/Users/garf/.local/share/nvim/mason/bin/OpenDebugAD7',
    command = 'OpenDebugAD7',
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        args = {},
        runInTerminal = false,
        miDebuggerPath = "/Users/garf/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/lldb-mi/bin/lldb-mi",
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description =  'enable pretty printing',
                ignoreFailures = false,
            },
        },
    },
    -- {
    --     name = 'Attach to gdbserver :1234',
    --     type = 'cppdbg',
    --     request = 'launch',
    --     MIMode = 'gdb',
    --     miDebuggerServerAddress = 'localhost:1234',
    --     miDebuggerPath = '/usr/bin/gdb',
    --     cwd = '${workspaceFolder}',
    --     program = function()
    --         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --     end,
    --     setupCommands = {
    --         {
    --             text = '-enable-pretty-printing',
    --             description =  'enable pretty printing',
    --             ignoreFailures = false,
    --         },
    --     },
    -- },
}

dap.configurations.c = dap.configurations.cpp

-- keymap
local opts = { silent = true }
vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
vim.keymap.set("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
vim.keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
vim.keymap.set("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
vim.keymap.set("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
vim.keymap.set("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)

-- dap ui
local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
    return
end

dapui.setup({
    expand_lines = true,
    icons = { expanded = "", collapsed = "", circular = "" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.33 },
                { id = "breakpoints", size = 0.17 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 0.33,
            position = "right",
        },
        {
            elements = {
                { id = "repl", size = 0.45 },
                { id = "console", size = 0.55 },
            },
            size = 0.27,
            position = "bottom",
        },
    },
    floating = {
        max_height = 0.9,
        max_width = 0.5, -- Floats will be treated as percentage of your screen.
        border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

