return {
	"NeogitOrg/neogit",
	cmd = { "Neogit", "Ng" },
	keys = {
		{
			"<leader>gg",
			function()
				local cwd = vim.fn.getcwd()
				if vim.bo.filetype == "oil" then
					local oil = require("oil")
					cwd = oil.get_current_dir() or cwd
				end
				require("neogit").open({ cwd = cwd })
			end,
			desc = "Neogit: Open Status"
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",   -- required
		"sindrets/diffview.nvim",  -- optional - Diff integration
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		vim.cmd("command! Neog Neogit")
		require("neogit").setup {
			disable_relative_line_numbers = false,
			disable_line_numbers = false,
			integrations = {
				diffview = true,
				telescope = nil,
			},
			commit_editor = {
				kind = 'floating',
				--kind = 'split',
				--kind = 'replace',
				--kind = 'tab',
			},
			commit_select_view = {
				kind = "tab",
			},
			commit_view = {
				kind = "vsplit",
				verify_commit = vim.fn.executable("gpg") == 1, -- Can be set to true or false, otherwise we try to find the binary
			},
			log_view = {
				kind = "tab",
			},
			rebase_editor = {
				kind = "auto",
			},
			reflog_view = {
				kind = "tab",
			},
			merge_editor = {
				kind = "auto",
			},
			preview_buffer = {
				kind = "floating_console",
			},
			popup = {
				kind = "split",
			},
			stash = {
				kind = "tab",
			},
			refs_view = {
				kind = "tab",
			},

			mappings = {
				commit_editor = {
					["q"] = "Close",
					["<c-c><c-c>"] = "Submit",
					["<c-c><c-k>"] = "Abort",
					["<m-p>"] = "PrevMessage",
					["<m-n>"] = "NextMessage",
					["<m-r>"] = "ResetMessage",
				},
				commit_editor_I = {
					["<c-c><c-c>"] = "Submit",
					["<c-c><c-k>"] = "Abort",
				},
				rebase_editor = {
					["p"] = "Pick",
					["r"] = "Reword",
					["e"] = "Edit",
					["s"] = "Squash",
					["f"] = "Fixup",
					["x"] = "Execute",
					["d"] = "Drop",
					["b"] = "Break",
					["q"] = "Close",
					["<cr>"] = "OpenCommit",
					["gk"] = "MoveUp",
					["gj"] = "MoveDown",
					["<c-c><c-c>"] = "Submit",
					["<c-c><c-k>"] = "Abort",
					["[c"] = "OpenOrScrollUp",
					["]c"] = "OpenOrScrollDown",
				},
				rebase_editor_I = {
					["<c-c><c-c>"] = "Submit",
					["<c-c><c-k>"] = "Abort",
				},
				finder = {
					["<cr>"] = "Select",
					["<c-c>"] = "Close",
					["<esc>"] = "Close",
					["<c-n>"] = "Next",
					["<c-p>"] = "Previous",
					["<down>"] = "Next",
					["<up>"] = "Previous",
					["<tab>"] = "InsertCompletion",
					["<c-y>"] = "CopySelection",
					["<space>"] = "MultiselectToggleNext",
					["<s-space>"] = "MultiselectTogglePrevious",
					["<c-j>"] = "NOP",
					["<ScrollWheelDown>"] = "ScrollWheelDown",
					["<ScrollWheelUp>"] = "ScrollWheelUp",
					["<ScrollWheelLeft>"] = "NOP",
					["<ScrollWheelRight>"] = "NOP",
					["<LeftMouse>"] = "MouseClick",
					["<2-LeftMouse>"] = "NOP",
				},
				-- Setting any of these to `false` will disable the mapping.
				popup = {
					["?"] = false,
					["g?"] = "HelpPopup",
					["A"] = "CherryPickPopup",
					["d"] = "DiffPopup",
					["M"] = "RemotePopup",
					["P"] = "PushPopup",
					["X"] = "ResetPopup",
					["Z"] = "StashPopup",
					["i"] = "IgnorePopup",
					["t"] = "TagPopup",
					["b"] = "BranchPopup",
					["B"] = "BisectPopup",
					["w"] = "WorktreePopup",
					["c"] = "CommitPopup",
					["f"] = "FetchPopup",
					["l"] = "LogPopup",
					["m"] = "MergePopup",
					["p"] = "PullPopup",
					["r"] = "RebasePopup",
					["v"] = "RevertPopup",
				},
				status = {
					-- changed
					["1"] = false,
					["2"] = false,
					["3"] = false,
					["4"] = false,
					["<c-1>"] = "Depth1",
					["<c-2>"] = "Depth2",
					["<c-3>"] = "Depth3",
					["<c-4>"] = "Depth4",
					-- Unchanged
					["s"] = "Stage",
					["S"] = "StageUnstaged",
					["j"] = "MoveDown",
					["k"] = "MoveUp",
					["o"] = "OpenTree",
					["q"] = "Close",
					["I"] = "InitRepo",
					["<c-s>"] = "StageAll",
					["Q"] = "Command",
					["<tab>"] = "Toggle",
					["za"] = "Toggle",
					["zo"] = "OpenFold",
					["x"] = "Discard",
					["u"] = "Unstage",
					["K"] = "Untrack",
					["U"] = "UnstageStaged",
					["y"] = "ShowRefs",
					["$"] = "CommandHistory",
					["Y"] = "YankSelected",
					["<c-r>"] = "RefreshBuffer",
					["<cr>"] = "GoToFile",
					["<s-cr>"] = "PeekFile",
					["<c-v>"] = "VSplitOpen",
					["<c-x>"] = "SplitOpen",
					["<c-t>"] = "TabOpen",
					["{"] = "GoToPreviousHunkHeader",
					["}"] = "GoToNextHunkHeader",
					["[c"] = "OpenOrScrollUp",
					["]c"] = "OpenOrScrollDown",
					["<c-k>"] = "PeekUp",
					["<c-j>"] = "PeekDown",
					["<c-n>"] = "NextSection",
					["<c-p>"] = "PreviousSection",
				},
			},
		}
	end
}
