return {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    config = function()
        local notify = require("notify")
        
        notify.setup({
            -- "fade", "slide", "fade_in_slide_out", "static"
            stages = "fade_in_slide_out",
            -- "default", "minimal", "simple", "compact"
            render = "minimal",
            -- Default timeout for notifications
            timeout = 3000,
            -- Max number of notifications
            max_width = 80,
            max_height = 20,
            -- Icons for the different levels
            icons = {
                ERROR = "",
                WARN = "",
                INFO = "",
                DEBUG = "",
                TRACE = "✎",
            },
            background_colour = "#000000",
        })
        
        -- Force transparent background by linking to Normal
        vim.api.nvim_set_hl(0, "NotifyBackground", { link = "Normal" })
        
        -- Override vim.notify
        vim.notify = notify
    end,
}
