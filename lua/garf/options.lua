-- file related
vim.opt.autoread = true
vim.opt.fileformat = "unix"
vim.opt.fileencoding = "utf-8"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.writebackup = false

-- about input
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = "indent,eol,start"
vim.opt.timeoutlen = 1000
vim.opt.updatetime = 300

-- about tab
local tabspaces = 4
vim.opt.expandtab = true
vim.opt.tabstop = tabspaces
vim.opt.softtabstop = tabspaces
vim.opt.shiftwidth = tabspaces

-- about display
vim.opt.background = "dark"
vim.opt.showmatch = true
vim.opt.visualbell = true
vim.opt.laststatus = 3
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cmdheight = 2
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.showtabline = 2
vim.opt.termguicolors = true
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.fillchars.eob="~"
vim.opt.wrap = false
-- don't want vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.guifont = "monospace:h17"
-- vim.opt.t_Co = 256

-- about search
vim.opt.wrapscan = false
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- don't want vim.opt.ignorecase = true
-- don't want vim.opt.smartcase = true

-- about mouse
vim.opt.mouse = "a"
vim.opt.mousehide = true

-- misc
vim.opt.completeopt = { "menu", "menuone", "noselect", "longest", "preview" }
vim.opt.shortmess:append("c")
vim.opt.conceallevel = 0
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")
-- question vim.opt.clipboard = "unnamedplus"

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

