-- Basics
vim.o.number = true
vim.o.relativenumber = true  -- number + relativenumber == hybrid
vim.o.mouse = "nvi"  -- mouse mode in normal, visual and insert
vim.o.textwidth = 88  -- a vaguely sensible default textwidth
vim.o.formatoptions = "cqj"  -- the default, but minus `t` which autowraps text.
vim.o.colorcolumn = "+0"  -- mark the textwidth
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true  -- owo expands ur tab

vim.o.list = true
vim.o.listchars = "trail:·"  -- show trailing spaces

-- Colors
vim.cmd "colorscheme gruvbox"
vim.o.termguicolors = true

-- Keybinds
vim.api.nvim_set_keymap('n','<C-P>', '<cmd> FZF<CR>', { noremap=true })

-- Language-specific
vim.g.pyindent_open_paren = "shiftwidth()"  -- Don't double indent after ( you villain.

