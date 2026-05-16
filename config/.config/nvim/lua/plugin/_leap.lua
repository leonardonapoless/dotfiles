local km = vim.keymap.set

return {
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat', 'tpope/vim-surround' },

    config = function()
        require('leap').create_default_mappings()
        km("v", "s", "<Plug>(leap-forward)")
        km("v", "S", "<Plug>(leap-backward)")
    end,

    keys = {
        { 's', nil, mode = 'n' },
        { 'S', nil, mode = 'n' },
        { 's', nil, mode = 'v' },
        { 'S', nil, mode = 'v' },
    }
}
