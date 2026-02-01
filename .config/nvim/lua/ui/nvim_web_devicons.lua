return {
    'nvim-tree/nvim-web-devicons',
    lazy = false,
    priority = 1000,
    config = function()
        require('nvim-web-devicons').setup({
            default = true,
            -- Override to force specific icons and brighter colors for Gruvbox
            override = {
                ["swift"] = {
                    icon = "",
                    color = "#F05138",
                    name = "Swift"
                },
                ["js"] = {
                    icon = "",
                    color = "#cbcb41",
                    name = "Js"
                },
                ["ts"] = {
                    icon = "",
                    color = "#519aba",
                    name = "Ts"
                },
                ["css"] = {
                    icon = "",
                    color = "#563d7c",
                    name = "Css"
                },
                ["html"] = {
                    icon = "",
                    color = "#e34c26",
                    name = "Html"
                },
                ["py"] = {
                    icon = "",
                    color = "#3572A5",
                    name = "Py"
                },
                ["lua"] = {
                    icon = "",
                    color = "#51a0cf",
                    name = "Lua"
                },
                ["json"] = {
                    icon = "",
                    color = "#cbcb41",
                    name = "Json"
                },
                ["c"] = {
                    icon = "",
                    color = "#599eff",
                    name = "C"
                },
                ["cpp"] = {
                    icon = "",
                    color = "#519aba",
                    name = "Cpp"
                },
                ["h"] = {
                    icon = "",
                    color = "#a074c4",
                    name = "Header"
                },
                ["md"] = {
                    icon = "",
                    color = "#e3e3e3",
                    name = "Md"
                },
                ["go"] = {
                    icon = "",
                    color = "#519aba",
                    name = "Go"
                },
                ["rs"] = {
                    icon = "",
                    color = "#dea584",
                    name = "Rs"
                }, 
                ["toml"] = {
                    icon = "",
                    color = "#9c4221",
                    name = "Toml"
                },
                ["lock"] = {
                    icon = "",
                    color = "#de6e5e",
                    name = "Lock"
                }
            }
        })
    end
}
