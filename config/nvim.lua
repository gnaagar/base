local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.ignorecase = true      -- Ignore case when searching...
vim.opt.smartcase = true       -- ...unless you type a capital
vim.opt.wrap = false           -- No wrapping
vim.opt.splitright = true      -- Split to the right
vim.opt.splitbelow = true      -- Split to the bottom

vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.tabstop = 2            -- 2 spaces
vim.opt.shiftwidth = 2         -- 2 spaces
vim.opt.softtabstop = 2        -- 2 spaces
vim.opt.updatecount = 0

require("lazy").setup({
  { "junegunn/fzf", build = "./install --bin" },
  { 
    "junegunn/fzf.vim",
    keys = {
      { "<leader>e", ":Files<CR>", desc = "Find Files" },
      { "<leader>l", ":Buffers<CR>", desc = "Find Buffers" },
      { "<leader>f", ":Rg<CR>", desc = "Grep (Ripgrep)" },
    } 
  },
  { 
    "kylechui/nvim-surround", 
    version = "*", 
    event = "VeryLazy",
    config = function() require("nvim-surround").setup({}) end 
  },
  { "junegunn/vim-easy-align", keys = { { "ga", "<Plug>(EasyAlign)", mode = {"n", "x"} } } },
  { 
    "echasnovski/mini.completion", 
    version = false, 
    config = function() require("mini.completion").setup({}) end 
  },
  {
    "rakr/vim-one",
    config = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("one")
    end,
  }
})
