
return {
    'sindrets/diffview.nvim',
    config = function()
        vim.cmd("command! Diff DiffviewOpen")
    end,
    keys = {
        {'<leader>nd', ':DiffviewOpen<cr>', mode = 'n'}
    },
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
        "DiffviewClose",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
        "Diff",
    },

}
