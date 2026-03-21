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
local tempColorscriptPath = configPath .. "/tempColorscripts/"
local lastUsedColorschemeFileName = "lastColorScheme.txt"
local lastCurrentColorschemeFilePath
local ESC_CHAR = "\\033]"
local END_LINE = "\\" .. "007\""

local weztermColorsPath = "/Users/francistran/.config/wezterm/colors/"

-- Looks up a Neovim highlight group and returns its color as a hex string.
local function getNvimHightlightGroup(highlight_group, color_attribute)
  local success, highlight_def = pcall(vim.api.nvim_get_hl, 0, { name = highlight_group, link = false })
  if success and highlight_def and highlight_def[color_attribute] then
    return string.format("#%06x", highlight_def[color_attribute])
  end
  return ""
end

-- Reads in the current nvim colorscheme and generates the shell script to set the terminal colorscheme
-- Executes the script if it doesn't exist.
local function createColorschemeShellScript(colorschemeName)
  local colorschemePath = tempColorscriptPath .. colorschemeName .. ".sh"
  local lastColorschemeShellScriptExists = vim.uv.fs_stat(colorschemePath) ~= nil

  if lastColorschemeShellScriptExists then
    return
  end

  local colorscript = { "#!/bin/sh", "" .. "#" .. colorschemeName }

  local foreground = vim.g.terminal_color_foreground ~= "" and vim.g.terminal_color_foreground or
      getNvimHightlightGroup("Normal", "fg")
  local background = vim.g.terminal_color_background ~= "" and vim.g.terminal_color_background or
      getNvimHightlightGroup("Normal", "bg")

  local cursorFg = getNvimHightlightGroup("Cursor", "fg")
  if cursorFg == "" then cursorFg = foreground end

  local selectionBg = getNvimHightlightGroup("Visual", "bg")
  local selectionFg = getNvimHightlightGroup("Visual", "fg")
  if selectionFg == "" then selectionFg = foreground end

  -- Set ansi
  local ansiLine = "printf \"" .. ESC_CHAR .. "4"
  for i = 0, 15 do
    ansiLine = ansiLine .. ";" .. i .. ";" .. vim.g["terminal_color_" .. i] or ""
  end
  table.insert(colorscript, ansiLine .. END_LINE)

  -- Set Foreground, Background, Cursor (foreground)
  local fgBgCsrLine = "printf \"" .. ESC_CHAR .. "10;" .. foreground .. ";" .. background .. ";" .. cursorFg .. END_LINE
  table.insert(colorscript, fgBgCsrLine)

  -- Set Selection Background
  local seletionBgline = "printf \"" .. ESC_CHAR .. "17;" .. selectionBg .. END_LINE
  table.insert(colorscript, seletionBgline)

  -- Set Selection Foreground
  local seletionFgline = "printf \"" .. ESC_CHAR .. "19;" .. selectionFg .. END_LINE
  table.insert(colorscript, seletionFgline)

  -- Set Special Index Color
  local specialIndexLine = "printf \"" .. ESC_CHAR .. "5;0;" .. selectionFg .. END_LINE
  table.insert(colorscript, specialIndexLine)

  vim.fn.writefile(colorscript, colorschemePath)
  os.execute('sh ' .. colorschemePath)
end

-- Reads in the current nvimColorscheme and generates a TOML for the colorscheme
local function createColorSchemeTOML(nvimColorschemeName)
  local colorschemeTOMLPath = weztermColorsPath .. nvimColorschemeName .. ".toml"
  local colorschemeTOMLExists = vim.uv.fs_stat(colorschemeTOMLPath) ~= nil
  if colorschemeTOMLExists then
    return
  end
  local ansi = {}
  local brights = {}
  for i = 0, 7 do
    ansi[i + 1] = vim.g["terminal_color_" .. i] or ""
  end
  for i = 8, 15 do
    brights[i - 7] = vim.g["terminal_color_" .. i] or ""
  end

  local foreground = vim.g.terminal_color_foreground ~= "" and vim.g.terminal_color_foreground or
      getNvimHightlightGroup("Normal", "fg")
  local background = vim.g.terminal_color_background ~= "" and vim.g.terminal_color_background or
      getNvimHightlightGroup("Normal", "bg")

  local cursor_bg = getNvimHightlightGroup("Cursor", "bg")
  if cursor_bg == "" then cursor_bg = foreground end
  local cursor_fg = getNvimHightlightGroup("Cursor", "fg")
  if cursor_fg == "" then cursor_fg = background end
  local cursor_border = cursor_bg

  local compose_cursor = getNvimHightlightGroup("Number", "fg")
  local scrollbar_thumb = getNvimHightlightGroup("LineNr", "fg")
  local split = getNvimHightlightGroup("WinSeparator", "fg")
  local visual_bell = foreground

  local selection_bg = getNvimHightlightGroup("Visual", "bg")
  local selection_fg = getNvimHightlightGroup("Visual", "fg")
  if selection_fg == "" then selection_fg = foreground end

  local indexed = {}
  for i = 16, 21 do
    local c = vim.g["terminal_color_" .. i]
    if c then indexed[i] = c end
  end

  -- Add ansi colors to file
  local toml = { "[colors]", "ansi = [" }
  for _, c in ipairs(ansi) do
    table.insert(toml, string.format('    "%s",', c))
  end
  table.insert(toml, "]")

  if background ~= "" then
    table.insert(toml, string.format('background = "%s"', background))
  end
  table.insert(toml, "brights = [")
  for _, c in ipairs(brights) do
    table.insert(toml, string.format('    "%s",', c))
  end
  table.insert(toml, "]")
  if compose_cursor ~= "" then
    table.insert(toml, string.format('compose_cursor = "%s"', compose_cursor))
  end
  if cursor_bg ~= "" then
    table.insert(toml, string.format('cursor_bg = "%s"', cursor_bg))
  end
  if cursor_border ~= "" then
    table.insert(toml, string.format('cursor_border = "%s"', cursor_border))
  end
  if cursor_fg ~= "" then
    table.insert(toml, string.format('cursor_fg = "%s"', cursor_fg))
  end
  if foreground ~= "" then
    table.insert(toml, string.format('foreground = "%s"', foreground))
  end
  if scrollbar_thumb ~= "" then
    table.insert(toml, string.format('scrollbar_thumb = "%s"', scrollbar_thumb))
  end
  if selection_bg ~= "" then
    table.insert(toml, string.format('selection_bg = "%s"', selection_bg))
  end
  if selection_fg ~= "" then
    table.insert(toml, string.format('selection_fg = "%s"', selection_fg))
  end
  if split ~= "" then
    table.insert(toml, string.format('split = "%s"', split))
  end
  if visual_bell ~= "" then
    table.insert(toml, string.format('visual_bell = "%s"', visual_bell))
  end

  local has_indexed = false
  for i = 16, 21 do
    if indexed[i] then
      has_indexed = true; break
    end
  end
  if has_indexed then
    table.insert(toml, "")
    table.insert(toml, "[colors.indexed]")
    for i = 16, 21 do
      if indexed[i] then
        table.insert(toml, string.format('%d = "%s"', i, indexed[i]))
      end
    end
  end

  table.insert(toml, "")
  table.insert(toml, "[metadata]")
  table.insert(toml, 'aliases = []')
  table.insert(toml, 'author = ""')
  table.insert(toml, string.format('name = "%s"', nvimColorschemeName))
  table.insert(toml, 'origin_url = ""')
  table.insert(toml, 'wezterm_version = ""')

  vim.fn.writefile(toml, weztermColorsPath .. nvimColorschemeName .. ".toml")
end

-- On nvim load, read in colorscripts.txt
-- Set the nvim colorscheme, and calls the script to set the terminal colorscheme
function SetColorschemeFromFile()
  lastCurrentColorschemeFilePath = configPath .. "/" .. lastUsedColorschemeFileName
  local lastCurrentColorSchemeFileExists = vim.uv.fs_stat(lastCurrentColorschemeFilePath) ~= nil

  if lastCurrentColorSchemeFileExists then
    local lastColorschemes = vim.fn.system("cat " .. lastCurrentColorschemeFilePath)
    local lastColorchemesArray = vim.split(lastColorschemes, "\n", { plain = true })
    local lastColorschemeNvimName = lastColorchemesArray[1]
    local lastColorschemeScriptName = lastColorchemesArray[2]

    local defaultColorSchemePath = configPath .. "/" .. defaultColorScheme .. ".sh"
    local lastColorschemeShellScriptPath = colorscriptPath .. "" .. lastColorschemeScriptName .. ".sh"
    local lastColorschemeShellScriptExists = vim.uv.fs_stat(lastColorschemeShellScriptPath) ~= nil

    -- local lastColorschemeTOMLPath = weztermColorsPath .. lastColorschemeNvimName .. ".toml"
    -- local lastColorschemeTOMLExists = vim.uv.fs_stat(lastColorschemeTOMLPath) ~= nil

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

-- When the colorscheme changes, create a colorscheme toml file if it doesn't already exist
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(event)
    local colorschemeName = string.gsub(string.lower(event.match), "-", "")
    createColorSchemeTOML(colorschemeName)
  end,
})

-- Run a shell script inside /nvim/colorscripts. script must be normalized to no spaces, dashes, or uppercases
-- The shell script will be run inside create createColorschemeShellScript() if the script doesn't exist
vim.keymap.set('n', '<leader>zz', function()
  builtin.colorscheme({
    enable_preview = true,
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local entry = action_state.get_selected_entry()
        local nvimColorschemName = entry.value
        local colorschemeName = string.gsub(string.lower(nvimColorschemName), "-", "")
        local scriptPath = colorscriptPath .. colorschemeName .. ".sh"
        -- First line is the neovim colorscheme name, and the second line is the colorscheme with no - or caps
        vim.fn.writefile({ nvimColorschemName, colorschemeName }, lastCurrentColorschemeFilePath)
        createColorschemeShellScript(colorschemeName)
        os.execute('sh ' .. scriptPath)
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
