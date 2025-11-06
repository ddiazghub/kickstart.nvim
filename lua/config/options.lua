-- [[ Options ]]
-- See `:help vim.o`
--
-- Globals
vim.g.mapleader = ' ' -- Set <space> as the leader key
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.o.number = true -- Make line numbers default
vim.o.relativenumber = true -- Set line numbers relative to current line

vim.o.showmode = false -- Don't show the mode, since it's already in the status line

vim.o.signcolumn = 'yes' -- Keep signcolumn on by default

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split' -- Preview substitutions live, as you type!

vim.o.cursorline = true -- Show which line your cursor is on

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
vim.o.sidescrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

vim.o.wrap = false

-- Indentation
vim.o.tabstop = 2 -- 2 space tab
vim.o.shiftwidth = 0 -- Use tab stop as shift (>) width
vim.o.softtabstop = 2 -- 2 space soft tab sstop
vim.o.expandtab = true -- Expand tabs to spaces
vim.o.smartindent = true -- Indent automatically
vim.o.autoindent = true

-- Search
vim.o.ignorecase = true -- Case insensitive searching
vim.o.smartcase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.incsearch = true -- Show search results while typing

-- UI
vim.o.termguicolors = true -- Enable 24 Bit RGB colors
vim.o.showmatch = true -- Highlight matching brackets
vim.o.winborder = 'rounded' -- Round borders for floating windows
vim.o.winblend = 0 -- Set floating window transparency to 0
vim.o.pumblend = 0 -- Set popup menu transparency to 0
vim.o.lazyredraw = true -- Do not redraw UI while executing macros
vim.o.synmaxcol = 300 -- Syntax highlight up to 300 characters in a single line

-- Files
vim.o.backup = false -- Don't create backup files
vim.o.writebackup = false -- Don't create backup files before writing
vim.o.swapfile = false -- Don't create swap files
vim.o.undofile = true -- Save undo history
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.o.ttimeoutlen = 0 -- Decrease mapped sequence wait time
vim.o.autoread = true -- Auto reload files changed outside neovim
vim.o.autowrite = false -- Don't auto save

-- Behavior
vim.opt.backspace = 'indent,eol,start' -- Better backspace behavior
vim.opt.autochdir = false -- Don't auto change directory
vim.opt.iskeyword:append '-' -- Treat dash as part of word
-- vim.opt.selection = 'exclusive' -- Make selection exclusive. If starting from end of selection exclude last character.
vim.opt.mouse = 'a' -- Enable mouse support
vim.opt.clipboard:append 'unnamedplus' -- Use system clipboard
vim.opt.modifiable = true -- Allow buffer modifications
vim.opt.encoding = 'UTF-8' -- Set encoding

-- Folds
vim.opt.foldmethod = 'expr' -- Use expression for folding
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()' -- Use treesitter for folding
vim.opt.foldlevel = 99 -- Start with all folds open

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

-- LSP
vim.lsp.inlay_hint.enable(true) -- Enable inlay hints by default
