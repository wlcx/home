-- Basics
vim.o.relativenumber = true
vim.o.mouse = "nvi"  -- mouse mode in normal, visual and insert
vim.o.textwidth = 88  -- A vaguely sensible default textwidth
vim.o.colorcolumn = "+0"  -- Mark the textwidth
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.o.list = true
vim.o.listchars = "trail:·"  -- show trailing spaces

-- Colors
vim.cmd "colorscheme gruvbox"
vim.o.termguicolors = true

-- Keybinds
vim.api.nvim_set_keymap('n','<C-P>', '<cmd> FZF<CR>', { noremap=true })

-- LSP
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Enable Language LSPs
require'lspconfig'.gopls.setup{
  on_attach = on_attach,
}
require'lspconfig'.pylsp.setup{
  on_attach = on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text
        virtual_text = false
      }
    ),
  }
}
require'lspconfig'.rnix.setup{
  on_attach = on_attach
}

-- Diags with Trouble
require('trouble').setup {
  icons = false,
  signs = {
    error = "E",
    warning = "W",
    hint = "H",
    information = "I"
  }
}

vim.g.rustfmt_autosave = 1

-- Tree-sitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}
