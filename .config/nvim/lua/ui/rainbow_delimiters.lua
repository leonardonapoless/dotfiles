
return {
    'HiPhish/rainbow-delimiters.nvim',
    lazy = false,
    config = function() 
        local rainbow_delimiters = require 'rainbow-delimiters'

        vim.g.rainbow_delimiters = {
            strategy = {
                [''] = rainbow_delimiters.strategy['global'],
                vim = rainbow_delimiters.strategy['local'],
            },
            query = {
                [''] = 'rainbow-delimiters',
                lua = 'rainbow-blocks',
            },
            blacklist = {
                'oil',
                'noice',
                'msg',
                'prompt',
                'terminal',
                'quickfix',
                'toggleterm'
            },
            condition = function(bufnr)
                local filetype = vim.bo[bufnr].filetype
                if filetype and filetype:match('^snacks_') then
                    return false
                end
                return true
            end,
        }
    end
}
