-- Color command
vim.api.nvim_create_user_command("Color", function(args)
    local colorscheme = args.args
    vim.cmd("colorscheme " .. colorscheme)
end, { nargs = 1 })
