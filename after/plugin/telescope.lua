-- require("telescope.config").set_defaults({
--   file_ignore_patterns = "test"
-- })
require "telescope".setup {
  pickers = {
    colorscheme = {
      enable_preview = true
    }
  }
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>lf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ls', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>zz', builtin.colorscheme, {})
