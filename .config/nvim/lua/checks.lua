
local warn_func = Notify
local linux = {

	clipboard = function(self)

		vim.fn.system('which xclip')
		local xclip = vim.v.shell_error
		vim.fn.system('which wl-paste')
		local wl_clipboard = vim.v.shell_error
		-- vim.notify(xclip..' '..type(xclip)..wl_clipboard..' '..type(wl_clipboard))

		if xclip ~= 0 and wl_clipboard ~= 0 then
			self.warn_func("xclip or wl_clipboard NOT INSTALLED\n"..xclip..wl_clipboard, 4,{title='SYSTEM CLIPBOARD NOT WORKING'})
		end

	end,
}


-- Code/calls
local _os = {
	Linux = {
		clipboard = function()

			vim.fn.system('which xclip')
			local xclip = vim.v.shell_error
			vim.fn.system('which wl-paste')
			local wl_clipboard = vim.v.shell_error
			-- vim.notify(xclip..' '..type(xclip)..wl_clipboard..' '..type(wl_clipboard))

			if xclip ~= 0 and wl_clipboard ~= 0 then
				warn_func("xclip or wl_clipboard NOT INSTALLED\n"..xclip..wl_clipboard, 4,{title='SYSTEM CLIPBOARD NOT WORKING'})
			end

		end,
	}
}

local checks = _os[vim.loop.os_uname().sysname]
if checks ~= nil then 
	for _, func in ipairs(checks) do
		func()
	end
end

