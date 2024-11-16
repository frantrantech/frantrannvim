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

        -- Autopairs
        {
            "windwp/nvim-autopairs",
            eventversion = "InsertEnter",
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
        }





    },
    -- automatically check for plugin updates
    checker = { enabled = true },
    rocks = { enabled = false },
})
