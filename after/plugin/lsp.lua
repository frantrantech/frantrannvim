


local lsp_attach = function(client, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', 'gl', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({ 'n', 'x' }, '<leader>0', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities())

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls', 'rust_analyzer', 'tailwindcss', 'cssls', 'lua_ls', 'gopls' },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({
        on_attach = lsp_attach,
        single_file_support = false,
        capabilities = capabilities
      })
    end,
  }
})

require('lspconfig').ts_ls.setup({
  on_attach = lsp_attach,
  capabilities = capabilities,
  settings = {
    javascript = {
      suggest = {
        useCodeSnippetsOnMethodSuggest = true,
        includeCompletionsWithInsertText = true,
      },
    },
  },
  single_file_support = false, -- Avoid attaching the server to unrelated files
})

local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({ ['<CR>'] = cmp.mapping.confirm({ select = true }), }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- VIBE CODED: Ensure that all hover windows are focusable
-- Allows us to move around in LSP hover.
-- Thus j and k do not exit the LSP hover. 
-- Must press q to quit.
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  if not (result and result.contents) then
    return
  end

  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    return
  end

  config = vim.tbl_deep_extend("force", {
    border = "single",
    focusable = true,
  }, config or {})

  local bufnr, winid = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)

  if bufnr and winid then
    -- Add keymap to allow 'q' to close the floating window
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>close<CR>", { silent = true, noremap = true })
    -- Ensure the buffer isn't hanging around after the window is closed
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    -- Set cursor to floating window
    vim.api.nvim_set_current_win(winid)
  end
end
