-- ========================================================================== --
--  1. BOOTSTRAP PLUGIN MANAGER (LAZY.NVIM)
--  (Automatically installs itself on first run)
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
--  2. SETTINGS
--  (Note: syntax, hidden, incsearch, ttimeoutlen are Neovim defaults!)
-- ========================================================================== --
vim.g.mapleader = " "

vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.ignorecase = true      -- Ignore case when searching...
vim.opt.smartcase = true       -- ...unless you type a capital
vim.opt.wrap = false           -- No wrapping
vim.opt.splitright = true      -- Split to the right
vim.opt.splitbelow = true      -- Split to the bottom

-- Indentation
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.tabstop = 2            -- 2 spaces
vim.opt.shiftwidth = 2         -- 2 spaces
vim.opt.softtabstop = 2        -- 2 spaces
vim.opt.updatecount = 0        -- 2 spaces

-- ========================================================================== --
--  3. PLUGINS
-- ========================================================================== --
require("lazy").setup({
  -- A. FZF (The binary + the plugin)
  { "junegunn/fzf", build = "./install --bin" },
  { 
    "junegunn/fzf.vim",
    keys = {
      { "<leader>e", ":Files<CR>", desc = "Find Files" },
      { "<leader>b", ":Buffers<CR>", desc = "Find Buffers" },
      { "<leader>f", ":Rg<CR>", desc = "Grep (Ripgrep)" },
    } 
  },

  -- B. SURROUND (kylechui/nvim-surround is the modern Lua version of tpope's)
  { 
    "kylechui/nvim-surround", 
    version = "*", 
    event = "VeryLazy",
    config = function() require("nvim-surround").setup({}) end 
  },

  -- C. ALIGN (Interactive alignment)
  -- Usage: Select text -> type 'ga' -> type delimiter (e.g. '=')
  { "junegunn/vim-easy-align", keys = { { "ga", "<Plug>(EasyAlign)", mode = {"n", "x"} } } },

  -- D. MINIMAL COMPLETION (Buffer + Path)
  -- Lightweight alternative to nvim-cmp. Just works.
  { 
    "echasnovski/mini.completion", 
    version = false, 
    config = function() require("mini.completion").setup({}) end 
  },
})
