-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/playground'

    -- Productivity plugins
    use 'ThePrimeagen/harpoon'
    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'
    use { "scottmckendry/cyberdream.nvim" }
    use 'ThePrimeagen/vim-be-good'

    -- LSP and completion
    use { 'neovim/nvim-lspconfig' }
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    }

    -- Autopairs
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }

    -- TypeScript tools
    use {
        "pmizio/typescript-tools.nvim",
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup {}
        end,
    }

    -- Null-ls and formatting
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'MunifTanjim/prettier.nvim'

    -- Themes
    use 'rose-pine/neovim'
    use {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    }
    use "rebelot/kanagawa.nvim"
    use { "ellisonleao/gruvbox.nvim" }
    use "EdenEast/nightfox.nvim"
    use { 'nyoom-engineering/oxocarbon.nvim' }
    use "maxmx03/fluoromachine.nvim"

    -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Commenting
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- Leetcode.nvim
    use {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        requires = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter",
            "rcarriga/nvim-notify",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            arg = "leetcode.nvim",
            lang = "python3",
            cn = {
                enabled = false,
                translator = true,
                translate_problems = true,
            },
            storage = {
                home = vim.fn.stdpath("data") .. "/leetcode",
                cache = vim.fn.stdpath("cache") .. "/leetcode",
            },
            plugins = {
                non_standalone = false,
            },
            logging = true,
            injector = {},
            cache = {
                update_interval = 60 * 60 * 24 * 7, -- 7 days
            },
            console = {
                open_on_runcode = true,
                dir = "row",
                size = {
                    width = "90%",
                    height = "75%",
                },
                result = {
                    size = "60%",
                },
                testcase = {
                    virt_text = true,
                    size = "40%",
                },
            },
            description = {
                position = "left",
                width = "40%",
                show_stats = true,
            },
            hooks = {
                enter = {},
                question_enter = {},
                leave = {},
            },
            keys = {
                toggle = { "q" },
                confirm = { "<CR>" },
                reset_testcases = "r",
                use_testcase = "U",
                focus_testcases = "H",
                focus_result = "L",
            },
            theme = {},
            image_support = false,
        },
    }
end)
