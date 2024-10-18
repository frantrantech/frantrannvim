local wezterm = require("wezterm")
local act = wezterm.action

return {
  colors = {
    foreground = "#c8d3f5",
    background = "#222436",
    cursor_bg = "#c8d3f5",
    cursor_border = "#c8d3f5",
    cursor_fg = "#222436",
    selection_bg = "#2d3f76",
    selection_fg = "#c8d3f5",
    split = "#82aaff",
    compose_cursor = "#ff966c",
    scrollbar_thumb = "#2f334d",
    ansi = { "#1b1d2b", "#ff757f", "#c3e88d", "#ffc777", "#82aaff", "#c099ff", "#86e1fc", "#828bb8" },
    brights = { "#444a73", "#ff757f", "#c3e88d", "#ffc777", "#82aaff", "#c099ff", "#86e1fc", "#c8d3f5" },

    tab_bar = {
      inactive_tab_edge = "#1e2030",
      background = "#222436",

      active_tab = {
        fg_color = "#1e2030",
        bg_color = "#82aaff",
      },

      inactive_tab = {
        fg_color = "#545c7e",
        bg_color = "#2f334d",
      },

      inactive_tab_hover = {
        fg_color = "#82aaff",
        bg_color = "#2f334d",
      },

      new_tab_hover = {
        fg_color = "#82aaff",
        bg_color = "#222436",
        intensity = "Bold",
      },

      new_tab = {
        fg_color = "#82aaff",
        bg_color = "#222436",
      },
    },
  },
  keys = {
    -- Remap Command to act as Control
    { key = "n", mods = "SUPER", action = wezterm.action { SendKey = { key = "n", mods = "CTRL" } } },
    { key = "u", mods = "SUPER", action = wezterm.action { SendKey = { key = "u", mods = "CTRL" } } },
    { key = "d", mods = "SUPER", action = wezterm.action { SendKey = { key = "d", mods = "CTRL" } } },
    { key = "j", mods = "SUPER", action = wezterm.action { SendKey = { key = "j", mods = "CTRL" } } },
    { key = "k", mods = "SUPER", action = wezterm.action { SendKey = { key = "k", mods = "CTRL" } } },
    { key = "o", mods = "SUPER", action = wezterm.action { SendKey = { key = "o", mods = "CTRL" } } },
    { key = "r", mods = "SUPER", action = wezterm.action { SendKey = { key = "r", mods = "CTRL" } } },
    { key = "p", mods = "SUPER", action = wezterm.action { SendKey = { key = "p", mods = "CTRL" } } },
  },


}
