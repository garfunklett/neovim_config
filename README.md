# Neovim Configuration and Keybinding Cheatsheet

A personal Neovim 0.12 configuration focused on C/C++, Python, and Lua development. This document reflects the current Lua configuration; commented examples and plugins that have not been installed are not described as active features.

## Contents

- [Configuration Structure](#configuration-structure)
- [Plugin Summary](#plugin-summary)
- [Keybinding Notation](#keybinding-notation)
- [Basic Editing and Windows](#basic-editing-and-windows)
- [File Search and Management](#file-search-and-management)
- [Code Outline and Syntax Selection](#code-outline-and-syntax-selection)
- [LSP and Diagnostics](#lsp-and-diagnostics)
- [Completion and Snippets](#completion-and-snippets)
- [Git Operations](#git-operations)
- [Debugging](#debugging)
- [Comments and Surrounding Characters](#comments-and-surrounding-characters)
- [Tasks and Other Features](#tasks-and-other-features)
- [Plugin Maintenance and Troubleshooting](#plugin-maintenance-and-troubleshooting)
- [Current Limitations and Notes](#current-limitations-and-notes)

## Configuration Structure

| Path | Purpose |
| --- | --- |
| `init.lua` | Entry point; loads the core configuration and lazy.nvim |
| `lua/garf/core/options.lua` | Editor options, display, indentation, search, and related settings |
| `lua/garf/core/keymaps.lua` | Global keybindings and leader definitions |
| `lua/garf/lazy.lua` | Plugin manager setup and plugin directory imports |
| `lua/garf/plugins/` | Completion, search, Treesitter, themes, and editing tools |
| `lua/garf/plugins/sidebar/` | File tree, outline, statusline, and tabline |
| `lua/garf/plugins/lsp/` | LSP, Mason, and language server configuration |
| `lua/garf/plugins/dap/` | Debug adapters and debugging UI configuration |
| `lua/garf/plugins/cvs/` | Git plugins; the directory name follows the existing configuration |
| `lazy-lock.json` | Exact plugin commits for restoring versions and reproducing the setup on other machines |
| `launch.json.sample` | Example C/C++ launch configuration; paths must be adapted to each project |
| `tmux.conf`, `wezterm.lua` | Companion terminal configurations; not loaded automatically by Neovim |

The configuration uses Catppuccin Mocha, four-space indentation, relative line numbers, persistent undo, and line wrapping. Swap and backup files are disabled. bufferline displays **tabpages**, rather than a list of buffers.

## Plugin Summary

The following tables cover directly configured plugins and their dependencies, including libraries without their own keybindings.

### Plugin Management, Appearance, and General Editing

| Plugin | Purpose and Current Setup |
| --- | --- |
| `folke/lazy.nvim` | Manages plugins, checks for updates, and maintains the lockfile; globally prefers the latest stable release tag |
| `catppuccin/nvim` (`catppuccin`) | Uses the `catppuccin-mocha` colorscheme |
| `nvim-lualine/lualine.nvim` | Bottom statusline using the `iceberg` theme; the Aerial configuration adds a symbol breadcrumb |
| `akinsho/bufferline.nvim` | Top tabline using `mode = "tabs"`, with an offset for NvimTree |
| `nvim-tree/nvim-web-devicons` | File icons for the tree, search lists, and other UI components; the terminal font must support the glyphs |
| `lukas-reineke/indent-blankline.nvim` | Indentation guides through the `ibl` module, using default options |
| `stevearc/dressing.nvim` | Improves `vim.ui.input` and `vim.ui.select` for renaming, selection menus, and similar interactions |
| `numToStr/Comment.nvim` | Line comments, block comments, and comment insertion with default keybindings |
| `tpope/vim-surround` | Adds, removes, and changes surrounding quotes, brackets, tags, and similar delimiters |
| `tpope/vim-repeat` | Helps compatible plugin operations support repetition with `.`; also a dependency of Leap |
| `christoomey/vim-tmux-navigator` | Navigation between Neovim splits and tmux panes |
| `ggandor/leap.nvim` | Character-target navigation within the current window; the full default mapping set is not enabled |
| `eandrju/cellular-automaton.nvim` | Visual effects such as falling code and Game of Life |
| `nvim-lua/plenary.nvim` | General Lua utilities for files, asynchronous tasks, and other operations used by Telescope and other plugins |

### Files, Search, and Code Structure

| Plugin | Purpose and Current Setup |
| --- | --- |
| `nvim-telescope/telescope.nvim` | File search, project text search, recent files, and LSP result pickers; ignores `.git/` and `node_modules` |
| `nvim-telescope/telescope-fzf-native.nvim` | Native fuzzy sorter for Telescope; built with `make` during installation and loaded as the `fzf` extension |
| `nvim-tree/nvim-tree.lua` | Left-side file tree showing Git status and diagnostics; follows the current file and filters selected paths |
| `stevearc/oil.nvim` | Edits directories as buffers; uses default settings without a custom global opening shortcut |
| `stevearc/aerial.nvim` | Symbol outline, floating navigation, and symbol breadcrumbs in the statusline |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting, indentation, and incremental syntax-node selection; still uses the `nvim-treesitter.configs` interface |
| `nvim-treesitter/nvim-treesitter-textobjects` | Declared as a dependency, but function, parameter, and other text-object operations have not been configured or enabled |
| `windwp/nvim-ts-autotag` | Automatically closes and renames tags; enabled through the legacy Treesitter `autotag` configuration |

Explicitly requested Treesitter parsers: `c`, `cpp`, `python`, `lua`, `bash`, `cmake`, `json`, `markdown`, `markdown_inline`, and `gitignore`. `auto_install` is also enabled; installation depends on parser availability and the build environment. Treesitter highlighting and indentation are explicitly disabled for CSS.

### Language Services and Completion

| Plugin | Purpose and Current Setup |
| --- | --- |
| `neovim/nvim-lspconfig` | Provides language server defaults; custom settings use `vim.lsp.config()` and `vim.lsp.enable()` |
| `williamboman/mason.nvim` | Installs and manages external language tools; open its interface with `:Mason` |
| `williamboman/mason-lspconfig.nvim` | Connects Mason and LSP, automatically installs requested servers, and enables installed servers |
| `antosha417/nvim-lsp-file-operations` | Integrates LSP file operations, such as renaming files, with supported file managers and servers |
| `hrsh7th/nvim-cmp` | Completion menu; loads on the first `InsertEnter` event |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source and completion capability declarations |
| `hrsh7th/cmp-buffer` | Completion from buffer text |
| `hrsh7th/cmp-path` | File path completion |
| `hrsh7th/cmp-cmdline` | Completion for the `:` command line |
| `hrsh7th/cmp-nvim-lua` | Declared as a dependency, but `nvim_lua` is not currently included in completion sources |
| `L3MON4D3/LuaSnip` | Snippet engine for expansion and placeholder navigation |
| `saadparwaiz1/cmp_luasnip` | Adds LuaSnip snippets to the completion menu |
| `rafamadriz/friendly-snippets` | VS Code-format snippet collection, loaded lazily through LuaSnip |
| `folke/neodev.nvim` | Explicitly disabled with `enabled = false` |

Mason's automatic installation list contains `clangd`, `lua_ls`, `pyright`, `bashls`, `jsonls`, and `yamlls`. Only `clangd`, `pyright`, and `lua_ls` explicitly receive the completion capabilities and custom LSP keybindings listed below; the other automatically enabled servers do not share this `on_attach` callback.

### Git, Tasks, and Debugging

| Plugin | Purpose and Current Setup |
| --- | --- |
| `lewis6991/gitsigns.nvim` | Line-level change indicators, hunk previews, blame, and diffs; skips files longer than 40,000 lines |
| `tpope/vim-fugitive` | Git status, staging, commits, and other operations through `:Git`; no additional global shortcuts are configured |
| `sindrets/diffview.nvim` | Working-tree diffs and file history, using default settings |
| `stevearc/overseer.nvim` | Runs build, test, and other tasks and displays the task list; uses default task settings |
| `mfussenegger/nvim-dap` | Debugging client; currently only a C/C++ adapter named `cppdbg` is configured |
| `rcarriga/nvim-dap-ui` | Debugging sidebar, watches, stack, REPL, and console; currently follows `master` as an exception to the release policy |
| `nvim-neotest/nvim-nio` | Asynchronous IO library required by the debugging UI; its name does not mean a test-running plugin is installed |

`dap/json.lua` and `dap/json5.lua` currently return empty configurations, so their JSON plugins are not installed. The Tokyonight configuration is entirely commented out and is not active.

## Keybinding Notation

| Notation | Meaning |
| --- | --- |
| `<leader>` | Space; for example, `<leader>ff` means Space, then `f`, then `f` |
| `<localleader>` | Comma; no custom bindings starting with it are explicitly defined here |
| `<C-x>` | Ctrl + x |
| `<S-x>` | Shift + x; letters are usually written in uppercase, such as `H`, `L`, and `Q` |
| `<CR>` / `<Esc>` / `<BS>` | Enter / Escape / Backspace |
| N / I / V / S / C | Normal / Insert / Visual / Select / Command-line mode |

Unless marked as plugin defaults, the bindings below are explicitly defined by this configuration. Local mappings in plugin windows may override global mappings. Plugin defaults can also change after updates; use the relevant window's help for its complete mapping list.

## Basic Editing and Windows

Source: `lua/garf/core/keymaps.lua`.

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `\c` | Copy the current window into a new tabpage (`:tab split`) |
| N | `\[` / `\]` | Previous / next tabpage |
| N | `H` / `L` | Previous / next buffer; separate from the tabpages shown in the top tabline |
| N | `Q` | Force-delete the current buffer (`:bdelete!`), discarding unsaved changes |
| N | `<C-Up>` / `<C-Down>` | Decrease / increase window height by two lines |
| N | `<C-Left>` / `<C-Right>` | Decrease / increase window width by two columns |
| N | `<leader>co` / `<leader>cc` | Open / close the quickfix window |
| N | `<leader>cn` / `<leader>cp` | Next / previous quickfix entry |
| N | `<leader>h` | Clear search highlighting |
| V | `p` | Replace the selection by pasting without putting the replaced text into the usual deletion register |
| V | `<` / `>` | Decrease / increase indentation and retain the selection |

Default vim-tmux-navigator bindings in Normal mode: `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>` move left, down, up, and right; `<C-\>` returns to the previous window/pane. Navigation across tmux panes also requires loading the corresponding tmux configuration.

`F12` is mapped to `:TagbarToggle`, but Tagbar is not declared as a plugin, so this is not a working outline shortcut. Aerial provides the configured outline functionality.

## File Search and Management

### Telescope

Source: `lua/garf/plugins/telescope.lua`.

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `<leader>ff` | Find files |
| N | `<leader>fr` | Find recently opened files |
| N | `<leader>fg` | Search project text with live grep; requires `rg` |
| N | `<leader>fs` | Search for the word/string under the cursor; requires `rg` |
| Prompt I | `<C-j>` / `<C-k>` | Select the next / previous result |
| Prompt I | `<Down>` / `<Up>` | Next / previous search history entry; overrides the usual result navigation |
| Prompt I | `<C-q>` | Send results to quickfix and open the quickfix window |

Common plugin defaults: `<CR>` opens the selected entry, `<C-x>` opens a horizontal split, `<C-v>` opens a vertical split, and `<C-t>` opens a new tab. `<C-c>` closes the picker in Insert mode; `q` or `<Esc>` closes it in Normal mode. Pressing `<Esc>` in the prompt normally switches from Insert to Normal mode first.

### NvimTree

Source: `lua/garf/plugins/sidebar/nvim-tree.lua`.

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `<leader>ee` | Toggle the file tree |
| N | `<leader>ef` | Locate the current file and toggle the tree |
| N | `<leader>ec` | Collapse tree directories |
| N | `<leader>er` | Refresh the file tree |

Plugin defaults inside the file tree:

| Shortcut | Action |
| --- | --- |
| `<CR>` | Open a file or expand/collapse a directory |
| `<C-v>` / `<C-x>` / `<C-t>` | Open in a vertical split / horizontal split / new tab |
| `<Tab>` | Preview a file |
| `a` / `r` / `d` | Create / rename / delete a file or directory |
| `c` / `x` / `p` | Copy / cut / paste a file or directory |
| `H` | Toggle hidden files |
| `R` | Refresh |
| `-` | Change the tree root to the parent directory |
| `g?` / `q` | Show help / close the tree |

Custom filters include `.DS_Store`, paths starting with `.git`, `.cache`, and `compile_commands.json`. These rules can hide entries even when dotfiles are otherwise visible.

### Oil

No global shortcut is configured to open Oil; run `:Oil` to open the directory editor. Edit filenames or delete entries directly in the buffer, then use `:w` to apply the file operations. These modify the actual filesystem, not just the displayed list.

Plugin defaults inside an Oil buffer:

| Shortcut | Action |
| --- | --- |
| `<CR>` | Open a file or directory |
| `<C-s>` / `<C-h>` / `<C-t>` | Open in a vertical split / horizontal split / new tab |
| `<C-p>` | Preview |
| `-` / `_` | Open the parent directory / current working directory |
| `<C-l>` | Refresh |
| `g.` | Toggle hidden files |
| `gs` | Change sorting |
| `gx` | Open with an external application |
| `g?` / `<C-c>` | Show help / close Oil |

Oil's local `<C-h>` and `<C-l>` bindings perform different actions from the global tmux navigation bindings.

## Code Outline and Syntax Selection

| Mode / Context | Shortcut | Action |
| --- | --- | --- |
| N | `<leader>et` | Toggle the Aerial outline |
| N | `<leader>en` | Toggle Aerial floating navigation |
| N, buffer attached to Aerial | `{` / `}` | Previous / next symbol; overrides paragraph movement in that buffer |
| N / V | `<C-n>` | Leap to a target in the current window; V includes characterwise, linewise, and blockwise Visual modes, not Select mode |
| N, buffer supported by Treesitter | `<Tab>` | Start syntax-node selection |
| V, Treesitter node selection | `<Tab>` / `<S-Tab>` | Expand / shrink syntax-node selection |

Aerial outline window defaults: `<CR>` jumps to a symbol, `?` shows help, and `q` closes the window. Treesitter text-object operations for selecting or swapping functions, classes, or parameters have not been configured.

## LSP and Diagnostics

Source: `lua/garf/plugins/lsp/lspconfig.lua`. These custom bindings become available after `clangd`, `pyright`, or `lua_ls` attaches to a buffer. Individual features also require server support.

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `K` | Hover documentation |
| N | `gD` | Go to declaration |
| N | `gd` | Telescope: definitions |
| N | `gr` | Telescope: references |
| N | `gi` | Telescope: implementations |
| N | `gt` | Telescope: type definitions; overrides the default next-tabpage action in that buffer |
| N / V | `<leader>la` | Code actions |
| N | `<leader>lD` | Telescope: diagnostics for the current buffer |
| N | `<leader>ld` | Diagnostics float for the current line |
| N | `<leader>lj` / `<leader>lk` | Previous / next diagnostic, following the current configuration's direction assignments |
| N | `<leader>ls` | Search workspace symbols |
| N | `<leader>lh` | Signature help |
| N | `<leader>lrn` | Rename a symbol |
| N | `<leader>lrs` | Restart LSP (`:LspRestart`) |
| N | `<leader>li` | LSP information (`:LspInfo`) |
| N | `<leader>lI` | Mason tool manager; the last character is uppercase `I` |

Diagnostics use virtual text, underlines, severity sorting, and updates in Insert mode. clangd enables background indexing and clang-tidy and receives a fixed `--compile-commands-dir=.` argument; projects need a matching compilation database. LuaLS is configured for LuaJIT, the `vim` global, and the Neovim runtime library.

## Completion and Snippets

Source: `lua/garf/plugins/nvim-cmp.lua`. Code completion sources are LSP, LuaSnip, buffer, and path.

| Mode | Shortcut | Action |
| --- | --- | --- |
| I | `<C-Space>` | Trigger completion |
| I | `<C-j>` / `<C-k>` | Next / previous candidate |
| I | `<C-b>` / `<C-f>` | Scroll completion documentation up / down by four lines |
| I | `<C-e>` | Cancel completion |
| I | `<CR>` | Confirm the selected candidate; does not automatically accept the first item when none is selected |
| I / S | `<Tab>` | Expand or jump through a LuaSnip snippet when possible; otherwise fall back to the original behavior |
| I / S | `<S-Tab>` | Jump to the previous snippet placeholder when possible; otherwise fall back |

`<Tab>` is **not** configured to select the next completion candidate; its main role here is snippet navigation. Tab behavior depends on mode: Treesitter in Normal/Visual mode, LuaSnip in Insert/Select mode, and the completion preset in Command-line mode.

Inherited nvim-cmp Insert-mode presets: `<Up>` / `<Down>` select candidates; `<C-n>` / `<C-p>` select and insert the next / previous candidate when the menu is visible, or trigger completion otherwise; `<C-y>` confirms the selected candidate.

### Command-line Completion

- `/` and `?` complete from buffer text.
- `:` completes paths and commands.
- The plugin loads on the first entry into Insert mode, so this command-line completion setup is not initialized immediately after startup if Insert mode has not yet been entered.

Inherited from `cmp.mapping.preset.cmdline()`:

| Mode | Shortcut | Action |
| --- | --- | --- |
| C | `<Tab>` / `<C-z>` | Select the next item when the menu is visible; otherwise trigger completion |
| C | `<S-Tab>` | Select the previous item when the menu is visible; otherwise trigger completion |
| C | `<C-n>` / `<C-p>` | Select the next / previous item when the menu is visible; otherwise fall back |
| C | `<C-y>` / `<C-e>` | Confirm the selected candidate / cancel completion |

## Git Operations

Source: `lua/garf/plugins/cvs/gitsigns.lua`. These custom bindings become available after Gitsigns attaches to a buffer.

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `]c` / `[c` | Next / previous hunk in a regular editing window |
| N | `<leader>hb` | Full blame information for the current line |
| N | `<leader>hB` | Toggle inline blame |
| N | `<leader>hd` | Diff against the index version |
| N | `<leader>hD` | Diff against `~`, normally `HEAD~` |
| N | `<leader>hp` | Preview the current hunk |

Hunk staging and reset shortcuts are commented out and are not listed as active bindings. The following commands remain available:

| Command | Action |
| --- | --- |
| `:Gitsigns stage_hunk` | Stage the current hunk |
| `:Gitsigns reset_hunk` | Reset the current hunk, discarding the corresponding working-tree changes |
| `:Git` | Fugitive Git status interface; common buffer-local keys are `s` to stage, `u` to unstage, and `cc` to commit |
| `:Git blame` | Fugitive blame view |
| `:DiffviewOpen` / `:DiffviewClose` | Open / close the working-tree diff |
| `:DiffviewFileHistory %` | History of the current file |
| `:DiffviewFileHistory` | File history for the current project |

## Debugging

Sources: `lua/garf/plugins/dap/nvim-dap.lua` and `nvim-dap-ui.lua`. These bindings become available after the debugging plugins load on `VeryLazy`.

The current chain is `nvim-dap → cppdbg/OpenDebugAD7 → underlying debugger`. Before use, install an executable `OpenDebugAD7` and provide a project `.vscode/launch.json`; `launch.json.sample` is not loaded automatically.

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `<leader>dl` | Load `.vscode/launch.json` from the current working directory and map `cppdbg` to C/C++ |
| N | `<leader>db` | Toggle a breakpoint |
| N | `<leader>dB` | Enter a condition and set a conditional breakpoint |
| N | `<leader>dc` | Start / continue debugging |
| N | `<leader>dr` | Run to cursor |
| N | `<leader>di` | Step into |
| N | `<leader>do` | Step over |
| N | `<leader>dO` | Step out; the last character is uppercase `O` |
| N | `<leader>du` / `<leader>dd` | Move up / down the call stack |
| N | `<leader>dt` | Terminate the debugging session |
| N | `<leader>dg` | Toggle dap-ui and reset its layout |
| N / V | `<leader>de` | Evaluate the expression under the cursor / selected expression |

`<leader>de` is defined in Normal mode both in the DAP configuration and in dap-ui's `keys`, but both invoke `dapui.eval()`. Its Visual-mode mapping is defined in the DAP configuration. `<leader>dl` does **not** rerun the last session, and `<leader>dr` does **not** toggle the REPL; those alternative mappings only appear in comments.

### dap-ui Panels

- Right side, 40 columns wide: Scopes, Breakpoints, Stacks, and Watches, each taking one quarter of the space.
- Bottom, 10 lines high: REPL and Console, each taking half of the space.
- Opens automatically after session initialization and closes before session termination or exit.

The following panel-local bindings are explicitly configured here. Available actions depend on the panel:

| Shortcut | Action |
| --- | --- |
| `<CR>` / double-click | Expand an entry |
| `e` | Edit a variable or expression |
| `o` | Open the location associated with an entry |
| `d` | Remove an entry, such as a watch expression or breakpoint |
| `r` | Perform the entry's REPL action |
| `t` | Toggle an entry's state |
| `q` / `<Esc>` | Close a dap-ui floating window; not a universal close binding for all regular panels |

## Comments and Surrounding Characters

These are default bindings from enabled plugins; this configuration does not redefine them.

### Comment.nvim

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `gcc` / `gbc` | Toggle a line / block comment on the current line |
| N | `gc{motion}` / `gb{motion}` | Toggle line / block comments over a motion, for example `gcip` |
| V | `gc` / `gb` | Toggle line / block comments for the selection |
| N | `gco` / `gcO` | Insert a comment below / above and enter Insert mode |
| N | `gcA` | Insert a comment at the end of the line and enter Insert mode |

### vim-surround

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `ys{motion}{char}` | Surround a range; for example, `ysiw"` adds double quotes around the current word |
| N | `yss{char}` | Surround the whole line |
| N | `cs{old}{new}` | Change surrounding characters; for example, `cs"'` changes double quotes to single quotes |
| N | `ds{char}` | Delete surrounding characters; for example, `ds"` |
| V | `S{char}` | Surround the selection |
| N | `.` | Repeat a compatible previous change, with support from vim-repeat |

## Tasks and Other Features

| Mode | Shortcut | Action |
| --- | --- | --- |
| N | `<leader>tr` | Overseer: select and run a task |
| N | `<leader>tt` | Overseer: toggle the task list |
| N | `<leader>fml` | Cellular Automaton: falling code (`make_it_rain`) |
| N | `<leader>fyl` | Cellular Automaton: Game of Life (`game_of_life`) |

Overseer's ability to discover build and test tasks depends on project files and task templates. No dedicated test runner is configured in this project.

## Plugin Maintenance and Troubleshooting

| Command | Purpose |
| --- | --- |
| `:Lazy` | View plugin status |
| `:Lazy update` | Update plugins according to their version policies and record installed revisions in the lockfile |
| `:Lazy update LuaSnip` | Update one plugin; substitute other names as shown in the Lazy interface |
| `:Lazy restore` | Restore plugin versions from `lazy-lock.json` |
| `:Mason` | Manage language servers and other external tools |
| `:TSUpdate` | Update Treesitter parsers |
| `:checkhealth` | Check the environment and plugin health |
| `:checkhealth vim.lsp` | Inspect native LSP configuration and connection status |
| `:checkhealth vim.deprecated` | Locate callers of deprecated APIs |
| `:messages` | View recent errors and messages |
| `:verbose nmap <Space>ff` | Inspect a Normal-mode mapping and its definition source |
| `:verbose imap <Tab>` | Inspect the current Insert-mode Tab mapping |
| `:echo executable('OpenDebugAD7')` | Check whether Neovim can execute the configured debug adapter |

The global `version = "*"` policy selects the latest stable tag matching semantic version rules, rather than the latest commit on the main development branch. If there is no suitable tag, it falls back to a branch. dap-ui is currently the only plugin explicitly overriding this policy, with `version = false` and `branch = "master"`. Telescope's `0.1.x` restriction has been removed.

Keep `lazy-lock.json` under version control. `nvim.log` is ignored and should not be committed as configuration. A leftover lockfile entry does not mean a plugin is enabled; neodev is one example of a disabled plugin.

## Current Limitations and Notes

1. **The debug adapter is not connected.** During troubleshooting, `executable('OpenDebugAD7')` returned `0`. The Mac toolchain's `lldb-dap` was found, but the configuration has not been switched to it; locating the executable does not complete its integration.
2. **No unified formatting or standalone lint setup.** LSP diagnostics remain available, and clangd enables clang-tidy. Conform, Ruff, and nvim-lint are not configured, so their features are not active.
3. **Automatic bracket pairing is not active.** The Treesitter table's `autopairs.enable = true` has no corresponding plugin; nvim-autopairs is not installed.
4. **Treesitter still uses the legacy interface.** Moving to the incompatible new development branch requires corresponding configuration changes, not just changing the branch. autotag also uses the old integration, while textobjects are not enabled.
5. **Custom LSP mappings do not cover every server.** Bash, JSON, YAML, and other servers automatically enabled by Mason do not use the `on_attach` callback configured for the three main servers.
6. **Some mappings depend on scope and loading time.** Aerial's `{` and `}` and LSP's `gt` override native navigation. Plugin windows such as Oil also have local mappings. Use `:verbose ...map` to inspect the current context.
7. **The search-highlight shortcut shares a prefix with Git bindings.** `<leader>h` is a complete mapping and also a prefix of `<leader>hb`, `<leader>hd`, and others. With `timeoutlen = 1000`, it may wait for further input.
8. **Hunk navigation in native diff windows needs adjustment.** The Gitsigns callbacks for `]c` and `[c` only return strings in diff mode, but their mappings do not set `expr = true`, so they may not fall back to native diff navigation.
9. **Some configuration is duplicated or has inactive entry points.** lualine calls `.setup()` in two files; `F12` points to undeclared Tagbar; `cmp-nvim-lua` is not included in completion sources. This document records the current state without changing those settings.
