-- More vim init for "bells and whistles you are using vim for dev" mode

-- LSP
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Completion
local cmp = require'cmp'
cmp.setup({
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }),
}, {
  { name = 'buffer' },
})

-- Language servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
require'lspconfig'.pylsp.setup{
  on_attach = on_attach,
  capabilities = capabilities,
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
  on_attach = on_attach,
  capabilities = capabilities,
}
require'lspconfig'.rust_analyzer.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
require'lspconfig'.dhall_lsp_server.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
require'lspconfig'.eslint.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
-- Configure volar (vuejs language server stuff) in "takeover" mode
require'lspconfig'.volar.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
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
