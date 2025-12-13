-- Usage: start typing and as suggestions
-- come up, use <c-n> and <c-p> to cycle
-- through them. note that whatever you have typed
-- till now is also a part of the list (although not shown)
-- and comes right before the first element.
--
-- Sources:
-- 1. cmp-buffer (words from the current buffer)
-- 2. cmp-path (filesystem paths)
-- 3. cmp-cmdline (completion for search '/' and commands ':')

local function configure_cmp()
  local cmp = require('cmp')

  -- Standard insert mode completion
  cmp.setup({
    -- completion = {
    --   only show completions when hotkey is pressed (see mapping)
    --   autocomplete = false
    -- },
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
      completion = {
        scrollbar = true, -- Optional: Enable scrollbar
        max_width = 50,    -- Limit the width (adjust as needed)
        max_height = 10,   -- Limit the height (adjust as needed)
      },
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.config.disable,
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp', max_item_count = 5 },
      { name = 'vsnip' },
      { name = 'buffer', keyword_length = 2 },
      { name = 'path' },
    })
  })

  -- Words from current buffer in the search
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Complete commands on ":"
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' }
        }
      }
    })
  })

  -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- An example for configuring `clangd` LSP to use nvim-cmp as a completion engine
  require('lspconfig').clangd.setup {
    capabilities = capabilities,
    -- other lspconfig configs
  }
  -- Uncomment to use python cmp
  -- require('lspconfig').pyright.setup{}
  vim.o.signcolumn = "number"
end

return {
  { 'hrsh7th/nvim-cmp', version = '*', config = configure_cmp, },
  { 'hrsh7th/cmp-buffer', version = '*' },
  { 'hrsh7th/cmp-cmdline', version = '*' },
  { 'hrsh7th/cmp-nvim-lsp', version = '*' },
  { 'hrsh7th/cmp-path', version = '*' },
  { 'hrsh7th/vim-vsnip', version = '*' },
  { 'hrsh7th/cmp-vsnip', version = '*' },
  { 'neovim/nvim-lspconfig', version = '*' },
}
