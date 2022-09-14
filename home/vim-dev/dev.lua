-- More vim init for "bells and whistles you are using vim for dev" mode

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
require'lspconfig'.rust_analyzer.setup{
  on_attach = on_attach
}
require'lspconfig'.dhall_lsp_server.setup{
  on_attach = on_attach
}
require'lspconfig'.eslint.setup{
  on_attach = on_attach
}
-- Configure volar (vuejs language server stuff) in "takeover" mode
require'lspconfig'.volar.setup{
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
  on_attach = on_attach
}
--[[ If we didn't have takeover mode enabled above, we'd want this
require'lspconfig'.tsserver.setup{
  on_attach = on_attach
}
]]--

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
