
-- System checks (runs once at startup)

local function warn(msg, level, opts)
	-- Resolve lazily: Notify (snacks) may not exist yet at require-time
	local notify_fn = Notify or vim.notify
	notify_fn(msg, level, opts)
end

local _os = {
	Linux = {
		clipboard = function()
			vim.fn.system('which xclip')
			local xclip = vim.v.shell_error
			vim.fn.system('which wl-paste')
			local wl_clipboard = vim.v.shell_error

			if xclip ~= 0 and wl_clipboard ~= 0 then
				warn(
					"xclip or wl_clipboard NOT INSTALLED\n" .. xclip .. wl_clipboard,
					4,
					{ title = 'SYSTEM CLIPBOARD NOT WORKING' }
				)
			end
		end,
	}
}

local checks = _os[vim.uv.os_uname().sysname]
if checks ~= nil then
	for _, func in pairs(checks) do
		func()
	end
end
