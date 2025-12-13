-- Allow using vim colorschemes directly
vim.opt.runtimepath:append(vim.fn.expand("$HOME/.vim"))

-- Source original vimrc
vim.cmd("source $HOME/.vim/vimrc")

-- Plugins
require("config.lazy")

