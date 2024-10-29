local wezterm = require("wezterm")
local act = wezterm.action

return {
  -- Define the color schemes
  color_schemes = {
    -- TokyoNight color scheme
    ["tokyonight"] = {
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

    ["carbonfox"] = {
      foreground = "#f2f4f8",
      background = "#161616",
      cursor_bg = "#f2f4f8",
      cursor_border = "#f2f4f8",
      cursor_fg = "#161616",
      selection_bg = "#2a2a2a",
      selection_fg = "#f2f4f8",
      split = "#0c0c0c",
      compose_cursor = "#3ddbd9",
      scrollbar_thumb = "#7b7c7e",
      ansi = { "#282828", "#ee5396", "#25be6a", "#08bdba", "#78a9ff", "#be95ff", "#33b1ff", "#dfdfe0" },
      brights = { "#484848", "#f16da6", "#46c880", "#2dc7c4", "#8cb6ff", "#c8a5ff", "#52bdff", "#e4e4e5" },
      tab_bar = {
        background = "#0c0c0c",
        inactive_tab_edge = "#0c0c0c",
        active_tab = {
          bg_color = "#7b7c7e",
          fg_color = "#161616",
        },
        inactive_tab = {
          bg_color = "#252525",
          fg_color = "#b6b8bb",
        },
        inactive_tab_hover = {
          bg_color = "#353535",
          fg_color = "#f2f4f8",
        },
        new_tab = {
          bg_color = "#161616",
          fg_color = "#b6b8bb",
        },
        new_tab_hover = {
          bg_color = "#353535",
          fg_color = "#f2f4f8",
        },
      },
    },
  },

  color_scheme = "carbonfox",
    -- window_background_image = "/Users/francis.tran/Desktop/online_psykos-review.jpg",
    -- window_background_opacity = 0.5,


  keys = {
    { key = "n", mods = "SUPER", action = wezterm.action { SendKey = { key = "n", mods = "CTRL" } } },
    { key = "u", mods = "SUPER", action = wezterm.action { SendKey = { key = "u", mods = "CTRL" } } },
    { key = "d", mods = "SUPER", action = wezterm.action { SendKey = { key = "d", mods = "CTRL" } } },
    { key = "j", mods = "SUPER", action = wezterm.action { SendKey = { key = "j", mods = "CTRL" } } },
    -- { key = "k", mods = "SUPER", action = wezterm.action { SendKey = { key = "k", mods = "CTRL" } } },
    { key = "o", mods = "SUPER", action = wezterm.action { SendKey = { key = "o", mods = "CTRL" } } },
    { key = "r", mods = "SUPER", action = wezterm.action { SendKey = { key = "r", mods = "CTRL" } } },
    { key = "p", mods = "SUPER", action = wezterm.action { SendKey = { key = "p", mods = "CTRL" } } },
    { key = 'k', mods = 'SUPER', action = wezterm.action.ClearScrollback("ScrollbackOnly")},
  }  
}

