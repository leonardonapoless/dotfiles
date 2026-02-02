return {
    'sindrets/diffview.nvim',
    config = function()
        vim.cmd("command! Diff DiffviewOpen")
    end,
    keys = {
        { '<leader>gd', ':DiffviewOpen<cr>',        mode = 'n', desc = "Diffview: Open Diff" },
        { '<leader>gh', ':DiffviewFileHistory<cr>', mode = 'n', desc = "Diffview: File History" },
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
