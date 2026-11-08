# Neovim 配置与快捷键速查

面向 Neovim 0.12 的个人配置，主要覆盖 C/C++、Python、Lua 开发。本文依据当前 Lua 配置整理，不将注释中的示例或尚未安装的插件当作已启用功能。

## 目录

- [配置结构](#配置结构)
- [插件总结](#插件总结)
- [快捷键记法](#快捷键记法)
- [基础编辑与窗口](#基础编辑与窗口)
- [文件查找与管理](#文件查找与管理)
- [代码大纲与语法选择](#代码大纲与语法选择)
- [LSP 与诊断](#lsp-与诊断)
- [补全与代码片段](#补全与代码片段)
- [Git 操作](#git-操作)
- [调试](#调试)
- [注释与包围字符](#注释与包围字符)
- [任务与其他功能](#任务与其他功能)
- [插件维护与排错](#插件维护与排错)
- [当前限制与注意事项](#当前限制与注意事项)

## 配置结构

| 路径 | 用途 |
| --- | --- |
| `init.lua` | 入口；加载基础配置与 lazy.nvim |
| `lua/garf/core/options.lua` | 编辑器选项、显示、缩进、搜索等 |
| `lua/garf/core/keymaps.lua` | 全局快捷键与 leader 定义 |
| `lua/garf/lazy.lua` | 插件管理器及插件目录导入 |
| `lua/garf/plugins/` | 补全、搜索、Treesitter、主题、编辑工具等 |
| `lua/garf/plugins/sidebar/` | 文件树、大纲、状态栏和标签栏 |
| `lua/garf/plugins/lsp/` | LSP、Mason、语言服务器配置 |
| `lua/garf/plugins/dap/` | 调试适配器、调试界面配置 |
| `lua/garf/plugins/cvs/` | Git 相关插件；目录名沿用当前配置 |
| `lazy-lock.json` | 插件的精确提交版本，供版本恢复和多机器复现 |
| `launch.json.sample` | C/C++ 调试配置示例；路径需要按项目修改 |
| `tmux.conf`、`wezterm.lua` | 配套终端配置，不由 Neovim 入口自动加载 |

当前使用 Catppuccin Mocha 配色，4 空格缩进，开启相对行号、持久撤销和自动折行；关闭 swap 和备份文件。bufferline 显示的是 **tabpage**，不是 buffer 列表。

## 插件总结

下表按用途列出直接配置的插件及依赖。没有独立快捷键的工具库也列在其中。

### 插件管理、外观与通用编辑

| 插件 | 用途与当前配置 |
| --- | --- |
| `folke/lazy.nvim` | 管理插件、检查更新和维护锁文件；全局优先选择最新稳定 release 标签 |
| `catppuccin/nvim`（`catppuccin`） | 当前配色为 `catppuccin-mocha` |
| `nvim-lualine/lualine.nvim` | 底部状态栏；指定 `iceberg` 状态栏主题，并在 Aerial 配置中加入符号路径 |
| `akinsho/bufferline.nvim` | 顶部标签栏，使用 `mode = "tabs"`，为 NvimTree 预留位置 |
| `nvim-tree/nvim-web-devicons` | 给文件树、搜索列表等提供图标；终端字体需要支持相应字形 |
| `lukas-reineke/indent-blankline.nvim` | 以 `ibl` 模块显示缩进参考线，使用默认选项 |
| `stevearc/dressing.nvim` | 改善 `vim.ui.input` 和 `vim.ui.select`，用于重命名、选择菜单等 |
| `numToStr/Comment.nvim` | 行注释、块注释及插入注释，采用默认快捷键 |
| `tpope/vim-surround` | 添加、删除、替换引号、括号、标签等包围字符 |
| `tpope/vim-repeat` | 支持通过 `.` 重复兼容插件的操作，也是 Leap 的依赖 |
| `christoomey/vim-tmux-navigator` | 在 Neovim 分屏和 tmux pane 之间导航 |
| `ggandor/leap.nvim` | 当前窗口内的字符目标跳转；未启用整套默认映射 |
| `eandrju/cellular-automaton.nvim` | 代码雨、生命游戏等视觉效果 |
| `nvim-lua/plenary.nvim` | 文件、异步任务等通用 Lua 工具库，供 Telescope 等插件使用 |

### 文件、搜索与代码结构

| 插件 | 用途与当前配置 |
| --- | --- |
| `nvim-telescope/telescope.nvim` | 文件查找、全文搜索、最近文件、LSP 结果选择；忽略 `.git/` 和 `node_modules` |
| `nvim-telescope/telescope-fzf-native.nvim` | Telescope 的原生模糊排序器；安装时通过 `make` 构建，并加载 `fzf` 扩展 |
| `nvim-tree/nvim-tree.lua` | 左侧文件树，显示 Git 状态和诊断；跟随当前文件；隐藏部分自定义路径 |
| `stevearc/oil.nvim` | 将目录作为可编辑缓冲区操作；使用默认配置，没有单独配置入口快捷键 |
| `stevearc/aerial.nvim` | 代码符号大纲、浮动导航，并将符号路径接入状态栏 |
| `nvim-treesitter/nvim-treesitter` | 语法高亮、缩进、语法节点增量选择；当前仍采用 `nvim-treesitter.configs` 接口 |
| `nvim-treesitter/nvim-treesitter-textobjects` | 已声明依赖，但尚未配置启用函数、参数等文本对象操作 |
| `windwp/nvim-ts-autotag` | 自动闭合与重命名标签；当前通过旧式 Treesitter `autotag` 配置启用 |

Treesitter 显式安装的解析器：`c`、`cpp`、`python`、`lua`、`bash`、`cmake`、`json`、`markdown`、`markdown_inline`、`gitignore`。另开启了 `auto_install`；是否可安装还取决于解析器和构建环境。CSS 的 Treesitter 高亮及缩进被显式禁用。

### 语言服务与补全

| 插件 | 用途与当前配置 |
| --- | --- |
| `neovim/nvim-lspconfig` | 提供语言服务器默认配置；自定义设置使用 `vim.lsp.config()` 和 `vim.lsp.enable()` |
| `williamboman/mason.nvim` | 安装、管理外部语言工具；可通过 `:Mason` 查看 |
| `williamboman/mason-lspconfig.nvim` | 连接 Mason 与 LSP，自动安装指定服务器并启用已安装服务器 |
| `antosha417/nvim-lsp-file-operations` | 为支持的文件管理器和语言服务器接入文件重命名等 LSP 文件操作 |
| `hrsh7th/nvim-cmp` | 补全菜单；在首次 `InsertEnter` 时加载 |
| `hrsh7th/cmp-nvim-lsp` | LSP 补全源及补全能力声明 |
| `hrsh7th/cmp-buffer` | 从缓冲区文本补全 |
| `hrsh7th/cmp-path` | 文件路径补全 |
| `hrsh7th/cmp-cmdline` | `:` 命令行补全 |
| `hrsh7th/cmp-nvim-lua` | 已声明依赖，但当前没有把 `nvim_lua` 加入补全 sources |
| `L3MON4D3/LuaSnip` | 代码片段引擎，负责展开片段和跳转占位符 |
| `saadparwaiz1/cmp_luasnip` | 将 LuaSnip 片段接入补全菜单 |
| `rafamadriz/friendly-snippets` | VS Code 格式的片段集合，通过 LuaSnip 懒加载 |
| `folke/neodev.nvim` | 配置中明确 `enabled = false`，当前不启用 |

Mason 的自动安装列表为 `clangd`、`lua_ls`、`pyright`、`bashls`、`jsonls`、`yamlls`。其中 `clangd`、`pyright`、`lua_ls` 显式配置了补全能力和下文的自定义 LSP 快捷键；其他自动启用的服务器没有共享这段 `on_attach`。

### Git、任务与调试

| 插件 | 用途与当前配置 |
| --- | --- |
| `lewis6991/gitsigns.nvim` | 显示行级改动，预览 hunk、查看 blame 和 diff；超过 40,000 行的文件被跳过 |
| `tpope/vim-fugitive` | `:Git` 状态、暂存、提交等 Git 操作；没有配置额外全局快捷键 |
| `sindrets/diffview.nvim` | 查看工作区 diff 和文件历史；使用默认配置 |
| `stevearc/overseer.nvim` | 运行构建、测试等任务，查看任务列表；使用默认任务设置 |
| `mfussenegger/nvim-dap` | 调试客户端；当前仅配置名为 `cppdbg` 的 C/C++ 适配器 |
| `rcarriga/nvim-dap-ui` | 调试侧栏、监视、调用栈、REPL 和控制台；当前例外跟随 `master` |
| `nvim-neotest/nvim-nio` | 调试界面所需的异步 IO 库；名字中有 neotest 不代表已安装测试运行插件 |

`dap/json.lua`、`dap/json5.lua` 当前返回空配置，未安装相应 JSON 插件。Tokyonight 的配置整段被注释，当前不启用。

## 快捷键记法

| 记法 | 含义 |
| --- | --- |
| `<leader>` | 空格；例如 `<leader>ff` 是依次按空格、`f`、`f` |
| `<localleader>` | 逗号；本配置没有显式定义以它开头的自定义快捷键 |
| `<C-x>` | Ctrl + x |
| `<S-x>` | Shift + x；字母通常直接写大写，例如 `H`、`L`、`Q` |
| `<CR>` / `<Esc>` / `<BS>` | 回车 / Escape / Backspace |
| N / I / V / S / C | 普通 / 插入 / 可视 / 选择 / 命令行模式 |

除单独标注“插件默认”外，下文列出本工程显式定义的绑定。插件窗口中的局部绑定可能覆盖同名全局绑定；插件默认项也可能随更新变化，可用对应窗口的帮助查看完整列表。

## 基础编辑与窗口

来源：`lua/garf/core/keymaps.lua`。

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `\c` | 将当前窗口复制到新 tabpage（`:tab split`） |
| N | `\[` / `\]` | 上一个 / 下一个 tabpage |
| N | `H` / `L` | 上一个 / 下一个 buffer，和顶部 tabpage 栏不是同一概念 |
| N | `Q` | 强制删除当前 buffer（`:bdelete!`），会丢弃未保存修改 |
| N | `<C-Up>` / `<C-Down>` | 减少 / 增加窗口高度 2 行 |
| N | `<C-Left>` / `<C-Right>` | 减少 / 增加窗口宽度 2 列 |
| N | `<leader>co` / `<leader>cc` | 打开 / 关闭 quickfix 窗口 |
| N | `<leader>cn` / `<leader>cp` | 下一个 / 上一个 quickfix 条目 |
| N | `<leader>h` | 清除搜索高亮 |
| V | `p` | 粘贴替换选区，不把被替换内容写入普通删除寄存器 |
| V | `<` / `>` | 左移 / 右移缩进，并保留选区 |

vim-tmux-navigator 的插件默认键：普通模式 `<C-h>`、`<C-j>`、`<C-k>`、`<C-l>` 分别移向左、下、上、右；`<C-\>` 返回之前的窗口/pane。跨 tmux pane 还需要终端实际加载对应 tmux 配置。

`F12` 虽然绑定了 `:TagbarToggle`，但当前没有声明 Tagbar 插件，不能将它视为可用的大纲入口。实际大纲功能由 Aerial 提供。

## 文件查找与管理

### Telescope

来源：`lua/garf/plugins/telescope.lua`。

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `<leader>ff` | 查找文件 |
| N | `<leader>fr` | 查找最近打开的文件 |
| N | `<leader>fg` | 全文搜索（live grep，需要 `rg`） |
| N | `<leader>fs` | 搜索光标下的单词/字符串（需要 `rg`） |
| 搜索框 I | `<C-j>` / `<C-k>` | 选择下一个 / 上一个结果 |
| 搜索框 I | `<Down>` / `<Up>` | 下一条 / 上一条搜索历史；这里覆盖了通常的结果导航 |
| 搜索框 I | `<C-q>` | 将结果发送到 quickfix 并打开 quickfix 窗口 |

插件默认常用键：`<CR>` 打开选中项，`<C-x>` 水平分屏打开，`<C-v>` 垂直分屏打开，`<C-t>` 新标签打开；插入模式 `<C-c>` 关闭，普通模式 `q` 或 `<Esc>` 关闭。搜索列表中按 `<Esc>` 通常先从插入模式切换到普通模式。

### NvimTree

来源：`lua/garf/plugins/sidebar/nvim-tree.lua`。

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `<leader>ee` | 开关文件树 |
| N | `<leader>ef` | 定位当前文件并切换文件树 |
| N | `<leader>ec` | 折叠文件树目录 |
| N | `<leader>er` | 刷新文件树 |

以下为文件树窗口中的插件默认键：

| 快捷键 | 功能 |
| --- | --- |
| `<CR>` | 打开文件或展开/收起目录 |
| `<C-v>` / `<C-x>` / `<C-t>` | 垂直分屏 / 水平分屏 / 新标签打开 |
| `<Tab>` | 预览文件 |
| `a` / `r` / `d` | 新建 / 重命名 / 删除文件或目录 |
| `c` / `x` / `p` | 复制 / 剪切 / 粘贴文件或目录 |
| `H` | 切换隐藏文件显示 |
| `R` | 刷新 |
| `-` | 将文件树根目录切换到父目录 |
| `g?` / `q` | 显示帮助 / 关闭文件树 |

当前自定义过滤规则包括 `.DS_Store`、以 `.git` 开头的路径、`.cache` 和 `compile_commands.json`，即使没有隐藏所有点文件，也可能被这些规则过滤。

### Oil

当前没有配置 Oil 的全局入口快捷键，可运行 `:Oil` 打开目录编辑器。在目录中直接编辑文件名或删除条目，再用 `:w` 提交文件操作；这些是实际文件系统操作，不只是修改列表显示。

以下为 Oil 缓冲区内的插件默认键：

| 快捷键 | 功能 |
| --- | --- |
| `<CR>` | 打开文件或目录 |
| `<C-s>` / `<C-h>` / `<C-t>` | 垂直分屏 / 水平分屏 / 新标签打开 |
| `<C-p>` | 预览 |
| `-` / `_` | 父目录 / 当前工作目录 |
| `<C-l>` | 刷新 |
| `g.` | 切换隐藏文件显示 |
| `gs` | 修改排序方式 |
| `gx` | 使用外部程序打开 |
| `g?` / `<C-c>` | 显示帮助 / 关闭 Oil |

Oil 的局部 `<C-h>`、`<C-l>` 与全局 tmux 导航不是同一功能。

## 代码大纲与语法选择

| 模式/上下文 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `<leader>et` | 开关 Aerial 大纲 |
| N | `<leader>en` | 开关 Aerial 浮动导航 |
| N，Aerial 已附加的 buffer | `{` / `}` | 上一个 / 下一个符号；覆盖该 buffer 中原本的段落移动 |
| N / V | `<C-n>` | Leap：在当前窗口内进行目标跳转（V 仅字符/行/块可视模式，不含选择模式） |
| N，Treesitter 可用的 buffer | `<Tab>` | 开始语法节点选择 |
| V，Treesitter 节点选择 | `<Tab>` / `<S-Tab>` | 扩大 / 缩小语法节点选择 |

Aerial 大纲窗口的插件默认键：`<CR>` 跳转到符号，`?` 查看帮助，`q` 关闭。Treesitter 尚未配置按函数、类或参数选择/交换的 textobjects 功能。

## LSP 与诊断

来源：`lua/garf/plugins/lsp/lspconfig.lua`。下列自定义键在 `clangd`、`pyright` 或 `lua_ls` 附加到 buffer 后生效；功能还取决于服务器是否支持。

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `K` | 悬浮文档 |
| N | `gD` | 跳到声明 |
| N | `gd` | Telescope：定义 |
| N | `gr` | Telescope：引用 |
| N | `gi` | Telescope：实现 |
| N | `gt` | Telescope：类型定义；覆盖该 buffer 中默认的下一个 tabpage 操作 |
| N / V | `<leader>la` | 代码操作 |
| N | `<leader>lD` | Telescope：当前 buffer 的诊断列表 |
| N | `<leader>ld` | 当前行诊断浮窗 |
| N | `<leader>lj` / `<leader>lk` | 上一个 / 下一个诊断，方向按当前配置记录 |
| N | `<leader>ls` | 搜索工作区符号 |
| N | `<leader>lh` | 函数签名帮助 |
| N | `<leader>lrn` | 符号重命名 |
| N | `<leader>lrs` | 重启 LSP（`:LspRestart`） |
| N | `<leader>li` | LSP 信息（`:LspInfo`） |
| N | `<leader>lI` | Mason 工具管理界面；末尾为大写 `I` |

诊断开启虚拟文本、下划线、按严重程度排序，并在插入模式更新。clangd 开启后台索引与 clang-tidy，并固定传入 `--compile-commands-dir=.`；项目需要提供匹配的编译数据库。LuaLS 配置了 LuaJIT、`vim` 全局变量及 Neovim runtime 库。

## 补全与代码片段

来源：`lua/garf/plugins/nvim-cmp.lua`。普通代码补全源为 LSP、LuaSnip、buffer 和 path。

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| I | `<C-Space>` | 主动触发补全 |
| I | `<C-j>` / `<C-k>` | 下一个 / 上一个候选 |
| I | `<C-b>` / `<C-f>` | 补全文档向上 / 向下滚动 4 行 |
| I | `<C-e>` | 取消补全 |
| I | `<CR>` | 确认已选候选；未选择时不自动接受第一项 |
| I / S | `<Tab>` | 可以展开或跳转片段时执行 LuaSnip 操作，否则回退原行为 |
| I / S | `<S-Tab>` | 跳到片段上一个占位符，否则回退原行为 |

`<Tab>` **没有**配置为下一个补全候选；它主要服务于片段。不同模式的 Tab 分工：普通/可视模式为 Treesitter，插入/选择模式为 LuaSnip，命令行模式为补全预设。

继承的 nvim-cmp 插入模式预设：`<Up>` / `<Down>` 选择候选；`<C-n>` / `<C-p>` 在显示菜单时向下/向上选择并插入候选，否则触发补全；`<C-y>` 确认已选候选。

### 命令行补全

- `/`、`?` 使用 buffer 内容补全。
- `:` 使用路径和命令补全。
- 插件在首次进入插入模式后加载，因此刚启动且尚未进入插入模式时，这套命令行补全还没有初始化。

以下继承 `cmp.mapping.preset.cmdline()`：

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| C | `<Tab>` / `<C-z>` | 菜单可见时选下一项，否则触发补全 |
| C | `<S-Tab>` | 菜单可见时选上一项，否则触发补全 |
| C | `<C-n>` / `<C-p>` | 菜单可见时选下一项 / 上一项，否则回退原行为 |
| C | `<C-y>` / `<C-e>` | 确认已选候选 / 取消补全 |

## Git 操作

来源：`lua/garf/plugins/cvs/gitsigns.lua`。以下自定义键在 Gitsigns 附加到 buffer 后生效。

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `]c` / `[c` | 下一个 / 上一个改动块（普通编辑窗口） |
| N | `<leader>hb` | 当前行完整 blame 信息 |
| N | `<leader>hB` | 开关行内 blame |
| N | `<leader>hd` | 与索引版本进行 diff |
| N | `<leader>hD` | 与 `~`（通常为 `HEAD~`）版本进行 diff |
| N | `<leader>hp` | 预览当前改动块 |

暂存、重置改动块的快捷键目前均被注释，不在此列为已启用项。需要时可以使用插件命令：

| 命令 | 功能 |
| --- | --- |
| `:Gitsigns stage_hunk` | 暂存当前改动块 |
| `:Gitsigns reset_hunk` | 重置当前改动块，会丢弃对应工作区修改 |
| `:Git` | Fugitive Git 状态界面；其 buffer 中常用 `s` 暂存、`u` 取消暂存、`cc` 提交 |
| `:Git blame` | Fugitive blame 视图 |
| `:DiffviewOpen` / `:DiffviewClose` | 打开 / 关闭工作区 diff |
| `:DiffviewFileHistory %` | 当前文件历史 |
| `:DiffviewFileHistory` | 当前项目文件历史 |

## 调试

来源：`lua/garf/plugins/dap/nvim-dap.lua` 与 `nvim-dap-ui.lua`。这些绑定在 `VeryLazy` 加载调试插件后可用。

当前链路为 `nvim-dap → cppdbg/OpenDebugAD7 → 底层调试器`。使用前必须安装可执行的 `OpenDebugAD7`，并提供项目的 `.vscode/launch.json`；`launch.json.sample` 不是自动加载的配置。

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `<leader>dl` | 从当前工作目录加载 `.vscode/launch.json`，将 `cppdbg` 映射到 C/C++ |
| N | `<leader>db` | 开关断点 |
| N | `<leader>dB` | 输入条件并设置条件断点 |
| N | `<leader>dc` | 启动 / 继续调试 |
| N | `<leader>dr` | 运行到光标位置 |
| N | `<leader>di` | 单步进入 |
| N | `<leader>do` | 单步跳过 |
| N | `<leader>dO` | 单步跳出；末尾为大写 `O` |
| N | `<leader>du` / `<leader>dd` | 调用栈上一层 / 下一层 |
| N | `<leader>dt` | 终止调试会话 |
| N | `<leader>dg` | 开关 dap-ui，并重置布局 |
| N / V | `<leader>de` | 求值光标表达式 / 选中表达式 |

`<leader>de` 在 DAP 配置和 dap-ui 的 `keys` 中均有普通模式定义，但两处都调用 `dapui.eval()`；可视模式定义在 DAP 配置中。`<leader>dl` **不是**重新运行上次会话，`<leader>dr` **不是**开关 REPL；这两个替代绑定仅存在于注释里。

### dap-ui 面板

- 右侧宽 40 列：Scopes、Breakpoints、Stacks、Watches，各占四分之一。
- 底部高 10 行：REPL 与 Console，各占二分之一。
- 会话初始化后自动打开；会话终止或退出前自动关闭。

以下为本工程显式设置的面板内绑定；具体操作是否可用取决于所在面板：

| 快捷键 | 操作 |
| --- | --- |
| `<CR>` / 双击 | 展开条目 |
| `e` | 编辑变量或表达式 |
| `o` | 打开条目对应位置 |
| `d` | 移除条目，例如监视表达式或断点 |
| `r` | 将条目接入 REPL 操作 |
| `t` | 切换条目状态 |
| `q` / `<Esc>` | 关闭 dap-ui 浮窗（不是所有普通面板的通用关闭键） |

## 注释与包围字符

以下为已启用插件的默认绑定，本工程没有重新指定。

### Comment.nvim

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `gcc` / `gbc` | 切换当前行的行注释 / 块注释 |
| N | `gc{motion}` / `gb{motion}` | 对动作范围切换行注释 / 块注释，例如 `gcip` |
| V | `gc` / `gb` | 对选区切换行注释 / 块注释 |
| N | `gco` / `gcO` | 在下方 / 上方插入注释并进入插入模式 |
| N | `gcA` | 在行末插入注释并进入插入模式 |

### vim-surround

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `ys{motion}{char}` | 给范围添加包围字符，例如 `ysiw"` 给当前词加双引号 |
| N | `yss{char}` | 给整行添加包围字符 |
| N | `cs{old}{new}` | 替换包围字符，例如 `cs"'` 将双引号换成单引号 |
| N | `ds{char}` | 删除包围字符，例如 `ds"` |
| V | `S{char}` | 给选区添加包围字符 |
| N | `.` | 重复兼容的上次修改，由 vim-repeat 协助支持 |

## 任务与其他功能

| 模式 | 快捷键 | 功能 |
| --- | --- | --- |
| N | `<leader>tr` | Overseer：选择并运行任务 |
| N | `<leader>tt` | Overseer：开关任务列表 |
| N | `<leader>fml` | Cellular Automaton：代码雨（`make_it_rain`） |
| N | `<leader>fyl` | Cellular Automaton：生命游戏（`game_of_life`） |

Overseer 是否能发现构建、测试任务取决于项目文件及任务模板；本工程没有配置专门的测试运行器。

## 插件维护与排错

| 命令 | 用途 |
| --- | --- |
| `:Lazy` | 查看插件状态 |
| `:Lazy update` | 按版本策略更新插件，并记录实际版本到锁文件 |
| `:Lazy update LuaSnip` | 只更新指定插件；其他插件名可按 Lazy 界面显示替换 |
| `:Lazy restore` | 根据 `lazy-lock.json` 恢复插件版本 |
| `:Mason` | 管理语言服务器等外部工具 |
| `:TSUpdate` | 更新 Treesitter 解析器 |
| `:checkhealth` | 检查环境及插件健康状态 |
| `:checkhealth vim.lsp` | 查看原生 LSP 配置与连接状态 |
| `:checkhealth vim.deprecated` | 定位弃用 API 的调用来源 |
| `:messages` | 查看近期错误与提示 |
| `:verbose nmap <Space>ff` | 查看某个普通模式映射和定义来源 |
| `:verbose imap <Tab>` | 查看插入模式 Tab 的实际绑定 |
| `:echo executable('OpenDebugAD7')` | 检查当前 Neovim 是否能执行所配置的调试适配器 |

全局 `version = "*"` 表示选择符合语义版本规则的最新稳定标签，而非主分支最新提交；无合适标签时回退到分支。当前唯一主动覆盖该策略的插件是 dap-ui：`version = false`、`branch = "master"`。Telescope 已移除 `0.1.x` 限制。

`lazy-lock.json` 应纳入版本控制；`nvim.log` 已忽略，不应作为配置提交。锁文件中残留某个插件的条目不代表当前配置仍启用它，例如已禁用的 neodev。

## 当前限制与注意事项

1. **调试适配器未接通。** 本次排查中 `executable('OpenDebugAD7')` 返回 `0`。Mac 上虽然找到了工具链的 `lldb-dap`，但配置尚未切换到它；不能把程序存在当作已完成接入。
2. **没有统一格式化或独立 lint 配置。** LSP 自带诊断仍可用，clangd 开启了 clang-tidy；Conform、Ruff 和 nvim-lint 均未配置，不能将相关功能视为已启用。
3. **自动括号配置不生效。** Treesitter 表中的 `autopairs.enable = true` 没有对应插件；当前没有安装 nvim-autopairs。
4. **Treesitter 仍使用旧接口。** 迁移到不兼容的新主分支需要同步修改配置，不能仅更换分支。autotag 也仍使用旧集成方式，textobjects 则未启用。
5. **LSP 快捷键并非覆盖所有服务器。** Bash、JSON、YAML 等 Mason 自动启用的服务器没有使用这里为三个主要服务器设置的 `on_attach`。
6. **部分快捷键受作用域或加载时机影响。** Aerial 的 `{`、`}` 和 LSP 的 `gt` 会覆盖原生移动；Oil 等插件窗口也有局部映射。使用 `:verbose ...map` 检查当前上下文。
7. **搜索高亮键与 Git 键有前缀重叠。** `<leader>h` 本身是完整映射，同时也是 `<leader>hb`、`<leader>hd` 等键的前缀；当前 `timeoutlen = 1000`，按下前缀后可能等待后续输入。
8. **原生 diff 窗口中的改动跳转有待修正。** Gitsigns 的 `]c`、`[c` 回调在 diff 模式中只返回字符串，但映射没有设置 `expr = true`，因此不保证回退到原生 diff 跳转。
9. **部分配置有重复或失效入口。** lualine 在两个文件中调用 `.setup()`；`F12` 指向未声明的 Tagbar；`cmp-nvim-lua` 未接入 sources。本文只记录现状，没有修改这些配置。
