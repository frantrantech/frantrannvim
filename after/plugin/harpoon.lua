local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>b", mark.add_file)
vim.keymap.set("n", "<leader>a", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>pa", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>pb", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>pd", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>pf", function() ui.nav_file(4) end)