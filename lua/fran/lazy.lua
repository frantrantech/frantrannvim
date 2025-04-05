---@diagnostic disable: undefined-global
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- require("lazy").setup(plugins)

require("lazy").setup({
    spec = {
        -- Telescope
        {
            'nvim-telescope/telescope.nvim',
            version = '0.1.8',
            dependencies = { { 'nvim-lua/plenary.nvim' } }
        },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

        -- Treesitter
        { 'nvim-treesitter/nvim-treesitter',          build = ':TSUpdate' },
        'nvim-treesitter/playground',

        -- Productivity plugins
        'ThePrimeagen/harpoon',
        'mbbill/undotree',
        'tpope/vim-fugitive',
        { "scottmckendry/cyberdream.nvim" },
        'ThePrimeagen/vim-be-good',

        -- LSP and completion
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp' },
        {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },

        -- {
        --     'saghen/blink.cmp',
        --     -- optional: provides snippets for the snippet source
        --     dependencies = 'rafamadriz/friendly-snippets',
        --
        --     -- use a release tag to download pre-built binaries
        --     version = '*',
        --     -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        --     -- build = 'cargo build --release',
        --     -- If you use nix, you can build from source using latest nightly rust with:
        --     -- build = 'nix run .#build-plugin',
        --
        --     ---@module 'blink.cmp'
        --     ---@type blink.cmp.Config
        --     opts = {
        --         -- 'default' for mappings similar to built-in completion
        --         -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        --         -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        --         -- See the full "keymap" documentation for information on defining your own keymap.
        --         keymap = { preset = 'default' },
        --
        --         appearance = {
        --             -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        --             -- Useful for when your theme doesn't support blink.cmp
        --             -- Will be removed in a future release
        --             use_nvim_cmp_as_default = true,
        --             -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        --             -- Adjusts spacing to ensure icons are aligned
        --             nerd_font_variant = 'mono'
        --         },
        --
        --         -- Default list of enabled providers defined so that you can extend it
        --         -- elsewhere in your config, without redefining it, due to `opts_extend`
        --         sources = {
        --             default = { 'lsp', 'path', 'snippets', 'buffer' },
        --         },
        --     },
        --     opts_extend = { "sources.default" }
        -- },

        -- Autopairs
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter", -- Corrected key
            config = function()
                require("nvim-autopairs").setup {}
            end
        },
        -- TypeScript tools
        {
            "pmizio/typescript-tools.nvim",
            dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
            config = function()
                require("typescript-tools").setup {}
            end,
        },

        -- Null-ls and formatting
        'jose-elias-alvarez/null-ls.nvim',
        'MunifTanjim/prettier.nvim',

        -- Themes
        'rose-pine/neovim',
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            lazy = {},
        },
        "rebelot/kanagawa.nvim",
        { "ellisonleao/gruvbox.nvim" },
        "EdenEast/nightfox.nvim",
        { 'nyoom-engineering/oxocarbon.nvim' },
        "maxmx03/fluoromachine.nvim",

        -- Statusline
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
        },

        -- Commenting
        {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        },

        {
            "folke/snacks.nvim",
            priority = 1000,
            lazy = false,
            ---@type snacks.Config
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                -- bigfile = { enabled = true },
                dashboard =

                ---@class snacks.dashboard.Config
                ---@field enabled? boolean
                ---@field sections snacks.dashboard.Section
                ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
                {
                    width = 60,
                    row = nil,                                                                   -- dashboard position. nil for center
                    col = nil,                                                                   -- dashboard position. nil for center
                    pane_gap = 4,                                                                -- empty columns between vertical panes
                    autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
                    -- These settings are used by some built-in sections
                    preset = {
                        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
                        ---@type fun(cmd:string, opts:table)|nil
                        pick = nil,
                        -- Used by the `keys` section to show keymaps.
                        -- Set your custom keymaps here.
                        -- When using a function, the `items` argument are the default keymaps.
                        ---@type snacks.dashboard.Item[]
                        keys = {
                            { icon = " ",  key = "f", desc = "Find File",       action = ":lua Snacks.dashboard.pick('files')" },
                            { icon = " ",  key = "n", desc = "New File",        action = ":ene | startinsert" },
                            { icon = " ",  key = "g", desc = "Find Text",       action = ":lua Snacks.dashboard.pick('live_grep')" },
                            { icon = " ",  key = "r", desc = "Recent Files",    action = ":lua Snacks.dashboard.pick('oldfiles')" },
                            { icon = " ",  key = "c", desc = "Config",          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                            { icon = " ",  key = "s", desc = "Restore Session", section = "session" },
                            { icon = "󰒲 ", key = "L", desc = "Lazy",            action = ":Lazy",                                                                enabled = package.loaded.lazy ~= nil },
                            { icon = " ",  key = "q", desc = "Quit",            action = ":qa" },
                        },
                        -- Used by the `header` section
                        header = [[

███████╗██████╗  █████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔════╝██╔══██╗██╔══██╗████╗  ██║██║   ██║██║████╗ ████║
█████╗  ██████╔╝███████║██╔██╗ ██║██║   ██║██║██╔████╔██║
██╔══╝  ██╔══██╗██╔══██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║     ██║  ██║██║  ██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                                                                 ]],
                    },
                    -- item field formatters
                    formats = {
                        icon = function(item)
                            if item.file and item.icon == "file" or item.icon == "directory" then
                                return M.icon(item.file, item.icon)
                            end
                            return { item.icon, width = 2, hl = "icon" }
                        end,
                        footer = { "%s", align = "center" },
                        header = { "%s", align = "center" },
                        file = function(item, ctx)
                            local fname = vim.fn.fnamemodify(item.file, ":~")
                            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                            if #fname > ctx.width then
                                local dir = vim.fn.fnamemodify(fname, ":h")
                                local file = vim.fn.fnamemodify(fname, ":t")
                                if dir and file then
                                    file = file:sub(-(ctx.width - #dir - 2))
                                    fname = dir .. "/…" .. file
                                end
                            end
                            local dir, file = fname:match("^(.*)/(.+)$")
                            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or
                                { { fname, hl = "file" } }
                        end,
                    },
                    sections = {
                        { section = "header" },
                        { section = "keys",   gap = 1, padding = 1 },
                        { section = "startup" },
                    },
                },
                -- indent = { enabled = true },
                -- input = { enabled = true },
                -- notifier = { enabled = true },
                -- quickfile = { enabled = true },
                -- scroll = { enabled = true },
                -- statuscolumn = { enabled = true },
                -- words = { enabled = true },
            },
        },

        {
            "kawre/leetcode.nvim",
            build = ":TSUpdate html",
            dependencies = {
                "nvim-telescope/telescope.nvim",
                "nvim-lua/plenary.nvim", -- required by telescope
                "MunifTanjim/nui.nvim",

                -- optional
                "nvim-treesitter/nvim-treesitter",
                "rcarriga/nvim-notify",
                "nvim-tree/nvim-web-devicons",
            },
            opts = {
                ---@type string
                arg = "leetcode.nvim",

                ---@type lc.lang
                lang = "python3",

                cn = { -- leetcode.cn
                    enabled = false, ---@type boolean
                    translator = true, ---@type boolean
                    translate_problems = true, ---@type boolean
                },

                ---@type lc.storage
                storage = {
                    home = vim.fn.stdpath("data") .. "/leetcode",
                    cache = vim.fn.stdpath("cache") .. "/leetcode",
                },

                ---@type table<string, boolean>
                plugins = {
                    non_standalone = false,
                },

                ---@type boolean
                logging = true,

                injector = {}, ---@type table<lc.lang, lc.inject>

                cache = {
                    update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
                },

                console = {
                    open_on_runcode = true, ---@type boolean

                    dir = "row", ---@type lc.direction

                    size = { ---@type lc.size
                        width = "90%",
                        height = "75%",
                    },

                    result = {
                        size = "60%", ---@type lc.size
                    },

                    testcase = {
                        virt_text = true, ---@type boolean

                        size = "40%", ---@type lc.size
                    },
                },

                description = {
                    position = "left", ---@type lc.position

                    width = "40%", ---@type lc.size

                    show_stats = true, ---@type boolean
                },

                hooks = {
                    ---@type fun()[]
                    ["enter"] = {},

                    ---@type fun(question: lc.ui.Question)[]
                    ["question_enter"] = {},

                    ---@type fun()[]
                    ["leave"] = {},
                },

                keys = {
                    toggle = { "q" }, ---@type string|string[]
                    confirm = { "<CR>" }, ---@type string|string[]

                    reset_testcases = "r", ---@type string
                    use_testcase = "U", ---@type string
                    focus_testcases = "H", ---@type string
                    focus_result = "L", ---@type string
                },

                ---@type lc.highlights
                theme = {},

                ---@type boolean
                image_support = false,
            },
        },

        --- Add Plugins here---
        {
            "sphamba/smear-cursor.nvim",
            opts = {
                -- Smear cursor when switching buffers or windows.
                
                smear_between_buffers = false,

                -- Smear cursor when moving within line or to neighbor lines.
                -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
                smear_between_neighbor_lines = true,

                -- Draw the smear in buffer space instead of screen space when scrolling
                scroll_buffer_space = false,

                -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
                -- Smears will blend better on all backgrounds.
                legacy_computing_symbols_support = false,

                -- Smear cursor in insert mode.
                -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
                smear_insert_mode = false,
            },
        },









    },
    -- automatically check for plugin updates
    checker = { enabled = false },
    rocks = { enabled = false },
})
