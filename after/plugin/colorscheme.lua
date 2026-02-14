---@diagnostic disable: undefined-global
local action_state = require "telescope.actions.state"
local builtin = require "telescope.builtin"

--[[
------------------------   Colorscheme Flow ------------------------
--
-- Assumptions for this to work:
--    Terminal Colorscheme should already set in wezterm.lua
--    Shell Scripts for setting color should be in nvim/colorscripts
--    Colorscripts are taken from https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master/dynamic-colors
--        Then made all lowercase, no spaces in order to normalize from the neovim colorscheme format
--
-- Open Telescope colorpicker to set a color.
--    On Colorscheme Select: Save the colorscheme to a file in the format of:
--        NEOVIM_COLORSCHEME_NAME
--        SHELL_SCRIPT_COLORSCHEME_NAME
--
--    On Neovim Load: Read the file that stores the colorscheme names
--
--        If the shell script exists for the colorscheme:
--          Set Neovim Colorscheme
--          Run Shell Script to Update terminal colorscheme
--
--        If the shell script doesn't exist:
--          Set Neovim colorscheme to default
--          Set Terminal colorscheme to default
--
--        If the colorscheme file does not exist:
--          Set Neovim colorscheme to default
--          Do not call a shell script, keep using default terminal colors
--]]

local defaultColorScheme = "carbonfox"
local configPath = vim.fn.stdpath("config")
local colorscriptPath = configPath .. "/colorscripts/"
local lastUsedColorschemeFileName = "lastColorScheme.txt"
local lastCurrentColorschemeFilePath

function SetColorschemeFromFile()
  lastCurrentColorschemeFilePath = configPath .. "/" .. lastUsedColorschemeFileName
  local lastCurrentColorSchemeFileExists = vim.uv.fs_stat(lastCurrentColorschemeFilePath) ~= nil

  if lastCurrentColorSchemeFileExists then
    local lastColorschemes = vim.fn.system("cat " .. lastCurrentColorschemeFilePath)
    local lastColorchemesArray = vim.split(lastColorschemes, "\n", { plain = true })
    local lastColorschemeNvimName = lastColorchemesArray[1]
    local lastColorschemeScriptName = lastColorchemesArray[2]

    local defaultColorSchemePath = configPath .. "/" .. defaultColorScheme.. ".sh"
    local lastColorschemeShellScriptPath = colorscriptPath.. "" .. lastColorschemeScriptName .. ".sh"
    local lastColorschemeShellScriptExists = vim.uv.fs_stat(lastColorschemeShellScriptPath) ~= nil

    if lastColorschemeShellScriptExists then
      -- If the shell script exists, then use set nvim colorscheme AND execute colorscheme script
      vim.cmd.colorscheme(lastColorschemeNvimName)
      os.execute('sh ' .. lastColorschemeShellScriptPath)
    else
      -- If the shell script doesn't exist, then default to carbonfox
      vim.cmd.colorscheme(defaultColorScheme)
      os.execute('sh ' .. defaultColorSchemePath)
    end
  else
    -- If we don't have the colorscheme file, use default
    vim.cmd.colorscheme(defaultColorScheme)
  end
end

SetColorschemeFromFile()

-- Run a shell script inside /nvim/colorscripts. script must be normalized to no spaces, dashes, or uppercases
vim.keymap.set('n', '<leader>zz', function()
  builtin.colorscheme({
    enable_preview = true,
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local entry = action_state.get_selected_entry()
        local colorschemeName = string.gsub(string.lower(entry.value), "-", "")
        -- First line is the neovim colorscheme name, and the second line is the colorscheme with no - or caps
        vim.fn.writefile({ entry.value, colorschemeName }, lastCurrentColorschemeFilePath)
        os.execute('sh ' .. colorscriptPath.. colorschemeName .. '.sh')
        require("telescope.actions").select_default(prompt_bufnr)
      end)

      return true
    end
  })
end, { desc = "Run a shell script to update terminal colorscheme after using telescope color picker" })


-- vim.opt.background = "dark" -- set this to dark or light
-- -- Transparent main buffer
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

-- Floating windows = solid background
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26" })       -- same as tokyonight float bg
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1a1b26" })
-- vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1a1b26" })             -- popup menus (like completion)
-- vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#1a1b26" })   -- Telescope popups
-- vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#1a1b26" })vim.cmd("colorscheme kanagawa")
