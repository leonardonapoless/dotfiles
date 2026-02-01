
local km = vim.keymap.set

return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	lazy = false,
	dependencies = {'nvim-lua/plenary.nvim'},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- Harpoon management
		km("n", "<leader>ha", function() harpoon:list():add() end,
			{ desc = "Harpoon: Add file" })
		km("n", "<leader>hs", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
			vim.api.nvim_feedkeys("k", "t", false)
		end, { desc = "Harpoon: Toggle menu" })

		-- Quick access with Control+number (macOS compatible)
		-- Control+1 through Control+9 for fast file switching
		km("n", "<C-1>", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
		km("n", "<C-2>", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
		km("n", "<C-3>", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
		km("n", "<C-4>", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
		km("n", "<C-5>", function() harpoon:list():select(5) end, { desc = "Harpoon file 5" })
		km("n", "<C-6>", function() harpoon:list():select(6) end, { desc = "Harpoon file 6" })
		km("n", "<C-7>", function() harpoon:list():select(7) end, { desc = "Harpoon file 7" })
		km("n", "<C-8>", function() harpoon:list():select(8) end, { desc = "Harpoon file 8" })
		km("n", "<C-9>", function() harpoon:list():select(9) end, { desc = "Harpoon file 9" })

		-- Alternative: Option key (may work depending on terminal settings)
		km("n", "<M-1>", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
		km("n", "<M-2>", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
		km("n", "<M-3>", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
		km("n", "<M-4>", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
		km("n", "<M-5>", function() harpoon:list():select(5) end, { desc = "Harpoon file 5" })

		-- Navigate harpoon list
		km("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon: Next file" })
		km("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon: Previous file" })

	end
}

