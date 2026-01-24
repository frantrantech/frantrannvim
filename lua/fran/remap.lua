---@diagnostic disable: undefined-global
--- Used Leader Mappings ---              +------------+------------+------------+------------+              +------------+------------+------------+------------+
----                                      |            |            |            |            |              |            |            |            |            |
--- Used Leader Mappings ---              +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- 1-4   harpoon                        |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- 6,7   vertical resize                |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- 8     create a comment               |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- 9     copy file to clipboard         |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- 0     format file                    |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- a     harpoon finder                 |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- b     harpoon mark                   |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- lf    file finder                    |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- ls    fuzzy finder                   |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- lv    netrw                          |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- y/Y   yank to clipboard              |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- qf/ff close quickfix                 |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- o     cycle window                   |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- i     vsplit, switch, harpoon 1      |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- u     undotree                       |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- ;     save file                      |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- n     save and quit                  |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- p     paste (blackhole)              |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- d     delete (blackhole)             |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- g     fugitive                       |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+
---- vh    help?                          |            |            |            |            |              |            |            |            |            |
----                                      +------------+------------+------------+------------+              +------------+------------+------------+------------+

------------- Map Keys Here --------------

vim.g.mapleader = " "

-- Move to virtual lines instead of real lines --
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

-- Go to netrw --
vim.keymap.set("n", "<leader>lv", vim.cmd.Ex)

-- Move selected lines up and down and sets tab spacing
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Don't lose cursor position when joining lines vim.keymap.set("n", "J", "mzJ`z")

-- Moving vertically centers screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Going to next match centers screen --
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--; Paste and send pasted over to black hole register --
--
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to clipboard register --
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete to black hole register --
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Ctrl j, Ctrl k cycle quickfix list
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- close quick fix with leader qf or ff
vim.keymap.set('n', '<leader>qf', ':cclose<CR>')
vim.keymap.set('n', '<leader>ff', ':cclose<CR>')

-- Copy and paste this line, comment out the first line
-- Remap to use "gcc" from comment remap/package
vim.keymap.set('n', '<leader>[', 'yygccp', { remap = true })

-- Highlight from this character to the end of the line
vim.keymap.set('n','<leader>vv', 'v$', {remap = false})

-- copy buffer contents to clipboard
vim.keymap.set('n', '<leader>9', 'ggVG"+y<C-o>')

-- Multiline comment
vim.keymap.set('n', '<leader>8', 'o//<Esc>i**<Esc>i')

-- Resize window
vim.keymap.set('n', '<leader>7', ':vertical resize +2<cr>')
vim.keymap.set('n', '<leader>6', ':vertical resize -2<cr>')
-- Cycle through windows
vim.keymap.set('n', '<leader>o', '<C-w>w')
-- Create window, go to first buffer in harpoon
vim.keymap.set('n', '<leader>i', ':vsplit<cr><C-w>w<leader>1', { remap = true })

-- Save File
vim.keymap.set('n', '<leader>;', ':w<cr>')

-- Save and quit buffer. If in netrw, just quit
vim.keymap.set("n", "<leader>n", function()
  if vim.bo.filetype == "netrw" then
    vim.cmd("q")  -- Quit netrw normally
  elseif vim.bo.modified then
    vim.cmd("wq") -- Save and quit if buffer has unsaved changes
  else
    vim.cmd("q!") -- Quit without saving if no changes
  end
end, { noremap = true, silent = true })

-- Swap 0 (start of line) to _ (first char in line)
vim.keymap.set('n', '0', '_', {remap = false})
vim.keymap.set('n', '_', '0', {remap = false})

-- remaps to find matches revisit later if layer keys are bad xd
-- vim.keymap.set('n', '<leader>m', "%")
-- vim.keymap.set('n', '<leader>;', "*")
--

-- Disable arrow keys
local opts = { noremap = true, silent = true }
vim.keymap.set({ 'n', 'i', 'v' }, '<Up>', '<Nop>', opts)
vim.keymap.set({ 'n', 'i', 'v' }, '<Down>', '<Nop>', opts)
vim.keymap.set({ 'n', 'i', 'v' }, '<Left>', '<Nop>', opts)
vim.keymap.set({ 'n', 'i', 'v' }, '<Right>', '<Nop>', opts)
