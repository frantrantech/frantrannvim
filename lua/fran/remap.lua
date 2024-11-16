vim.g.mapleader = " "
vim.keymap.set("n", "<leader>lv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- close quick fix with leader qf
vim.keymap.set('n', '<leader>qf', ':cclose<CR>')

-- copy buffer contents to clipboard
vim.keymap.set('n', '<leader>9', 'ggVG"+y')

-- Multiline comment
vim.keymap.set('n', '<leader>8', 'i//<Esc>i**<Esc>i')

vim.keymap.set('n', '<leader>7', ':vertical resize +2<cr>')
vim.keymap.set('n', '<leader>6', ':vertical resize -2<cr>')

vim.keymap.set('n', '<leader>m', "%")
vim.keymap.set('n', '<leader>;', "*")
