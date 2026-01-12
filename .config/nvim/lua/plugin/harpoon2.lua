
return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	lazy = false,
	dependencies = {'nvim-lua/plenary.nvim'},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		km("n","<leader>ha", function() harpoon:list():add() end)
		km("n","<leader>hs", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
			-- sometimes, this function also needs for another movement to register for the harpoon interface to show up
			vim.api.nvim_feedkeys("k", "t", false)
		end)

		-- km("n","<leader>1", function() harpoon:list():select(1) end)
		-- km("n","<leader>2", function() harpoon:list():select(2) end)
		-- km("n","<leader>3", function() harpoon:list():select(3) end)
		-- km("n","<leader>4", function() harpoon:list():select(4) end)
		-- km("n","<leader>5", function() harpoon:list():select(5) end)
		-- km("n","<leader>6", function() harpoon:list():select(6) end)
		-- km("n","<leader>7", function() harpoon:list():select(7) end)
		-- km("n","<leader>8", function() harpoon:list():select(8) end)
		-- km("n","<leader>9", function() harpoon:list():select(9) end)
		km("n","<A-1>", function() harpoon:list():select(1) end)
		km("n","<A-2>", function() harpoon:list():select(2) end)
		km("n","<A-3>", function() harpoon:list():select(3) end)
		km("n","<A-4>", function() harpoon:list():select(4) end)
		km("n","<A-5>", function() harpoon:list():select(5) end)
		km("n","<A-6>", function() harpoon:list():select(6) end)
		km("n","<A-7>", function() harpoon:list():select(7) end)
		km("n","<A-8>", function() harpoon:list():select(8) end)
		km("n","<A-9>", function() harpoon:list():select(9) end)

		-- Toggle previous & next buffers stored within Harpoon list
		-- km("n","<leader>N", function() harpoon:list():prev() end)
		-- km("n","<leader>n", function() harpoon:list():next() end)

	end -- END Config function
}
