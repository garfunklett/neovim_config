return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "folke/neodev.nvim", opts = {} },
        { "antosha417/nvim-lsp-file-operations", config = true },
        "nvim-telescope/telescope.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- "nvimdev/lspsaga.nvim"
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        require("neodev").setup({})

        vim.diagnostic.config({
            virtual_text = true,
            update_in_insert = true,
            underline = true,
            severity_sort = true,
            float = {
                focusable = true,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        local keymap = vim.keymap -- for conciseness
        local opts = { noremap = true, silent = true }
        -- local on_attach = function(client, bufnr)
        local on_attach = function(_, bufnr)
            opts.buffer = bufnr

            -- set keybinds
            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

            opts.desc = "Go to declaration"
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

            opts.desc = "Show LSP references"
            keymap.set("n", "gr", "<cmd>Telescope lsp_references show_line=false<CR>", opts) -- show definition, references

            opts.desc = "Show LSP definitions"
            keymap.set("n", "gd", "<cmd>Telescope lsp_definitions show_line=false<CR>", opts) -- show lsp definitions

            opts.desc = "Show LSP implementations"
            keymap.set("n", "gi", "<cmd>Telescope lsp_implementations show_line=false<CR>", opts) -- show lsp implementations

            opts.desc = "Show LSP type definitions"
            keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions show_line=false<CR>", opts) -- show lsp type definitions

            opts.desc = "See available code actions"
            keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

            opts.desc = "Show line diagnostics"
            keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line

            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "<leader>lj", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

            opts.desc = "Go to next diagnostic"
            keymap.set("n", "<leader>lk", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

            opts.desc = "Show workspace symbols"
            keymap.set("n", "<leader>ls", vim.lsp.buf.workspace_symbol, opts) -- jump to next diagnostic in buffer

            opts.desc = "show signature help"
            keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, opts) -- mapping to restart lsp if necessary

            opts.desc = "Smart rename"
            keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts) -- smart rename

            opts.desc = "Restart LSP"
            keymap.set("n", "<leader>lrs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

            opts.desc = "Show LSP Info"
            keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", opts) -- mapping to restart lsp if necessary

            opts.desc = "Show Mason interface"
            keymap.set("n", "<leader>lI", "<cmd>Mason<cr>", opts) -- mapping to restart lsp if necessary
        end

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- -- Change the Diagnostic symbols in the sign column (gutter)
        -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        -- for type, icon in pairs(signs) do
        --     local hl = "DiagnosticSign" .. type
        --     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        -- end

        -- configure clangd server
        lspconfig["clangd"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = {
                "clangd",
                "--log=verbose",
                "--pretty",
                "--background-index",
                "--compile-commands-dir=.",
                "--pch-storage=memory",
                "--clang-tidy",
                "--completion-style=detailed",
            },
            init_options = {
                clangdFileStatus = true,
                usePlaceholders = true,
                completeUnimported = true,
                semanticHighlighting = true,
            }
        })

        -- configure python server
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure lua server (with special settings)
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace"
                    }
                }
            }
        })
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { -- custom settings for lua
                Lua = {
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                    completion = {
                        callSnippet = "Replace"
                    },
                },
            },
        })
    end,
}
