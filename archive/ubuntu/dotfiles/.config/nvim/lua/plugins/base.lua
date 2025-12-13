return {
 	{
    'echasnovski/mini.align',
    version = '*',
    config = function()
      require('mini.align').setup {
      }
    end,
  },
  {
    'tpope/vim-surround',
    version = '*'
  },
  {
    "junegunn/fzf.vim",
    dependencies = {
      "junegunn/fzf",
    }
  }
}

