return {
    'gelguy/wilder.nvim',
    lazy = false,
    config = function()
        local wilder = require('wilder')
        wilder.setup({ modes = { '/', '?', ':', }, })



        wilder.set_option('pipeline', {
            wilder.branch(
                wilder.cmdline_pipeline({
                    language = 'vim',
                    fuzzy = 1,
                }),
                wilder.python_search_pipeline({
                    pattern = wilder.python_fuzzy_pattern(),
                    sorter = wilder.python_difflib_sorter(),
                    engine = 're',
                })
            ),
        })
    end
}
