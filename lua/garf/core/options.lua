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

--[=[
let s:prevtabfocus=tabpagenr()
let s:prevtabnum=tabpagenr('$')
augroup TabClosedGroup
    autocmd!
    autocmd TabEnter * :if tabpagenr('$')<s:prevtabnum && s:prevtabfocus>1 && s:prevtabfocus<s:prevtabnum
                \       |   tabprevious
                \       |endif
                \       |let s:prevtabfocus=tabpagenr()
                \       |let s:prevtabnum=tabpagenr('$')
augroup END
--]=]

local prevTabFocusNum = vim.api.nvim_tabpage_get_number(0)
local prevTabTotalNum = #(vim.api.nvim_list_tabpages())
local tabCloseToLeft = function ()
    local currentTabTotalNum = #(vim.api.nvim_list_tabpages())
    if currentTabTotalNum < prevTabTotalNum and prevTabFocusNum > 1 and prevTabFocusNum < prevTabTotalNum then
        local currentTabFocusNum = vim.api.nvim_tabpage_get_number(0)
        local targetTabFocusHandle = vim.api.nvim_list_tabpages()[currentTabFocusNum - 1]
        vim.api.nvim_set_current_tabpage(targetTabFocusHandle)
    end
    prevTabFocusNum = vim.api.nvim_tabpage_get_number(0)
    prevTabTotalNum = #(vim.api.nvim_list_tabpages())
end
local tabGroup = vim.api.nvim_create_augroup("tabGroup", { clear = true })
vim.api.nvim_create_autocmd("TabEnter", {
    callback = tabCloseToLeft,
    group = tabGroup
})

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
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.guifont = "monospace:h17"
-- vim.opt.t_Co = 256
vim.cmd [[au FileType qf setlocal norelativenumber]]

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
-- vim.opt.completeopt = { "menu", "menuone", "noselect", "longest", "preview" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
vim.opt.conceallevel = 0
-- doesn't work well with c++ pointer arrow vim.opt.iskeyword:append("-")
-- don't want vim.opt.whichwrap:append("<,>,[,],h,l")
-- question vim.opt.clipboard = "unnamedplus"

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true
