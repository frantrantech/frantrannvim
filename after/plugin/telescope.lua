-- require("telescope.config").set_defaults({
--   file_ignore_patterns = "test"
-- })
local action_state = require "telescope.actions.state"
local builtin = require "telescope.builtin"

vim.keymap.set('n', '<leader>lf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ls', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

-- Run a shell script inside /nvim/colorscripts. script must be normalized to no spaces, dashes, or uppercases
vim.keymap.set('n', '<leader>zz', function()
  builtin.colorscheme({
    enable_preview=true,
    attach_mappings = function(prompt_bufnr, map)
        map('i', '<CR>', function()
          local entry = action_state.get_selected_entry()
          local colorschemeName = string.gsub(string.lower(entry.value), "-", "")
          os.execute('sh ./colorscripts/'..colorschemeName..'.sh')
          require("telescope.actions").select_default(prompt_bufnr) -- apply it
        end)

        return true
      end
  })
end, {})
