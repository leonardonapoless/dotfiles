local launcher_mod = {'cmd'}

local apps = {
  ['1'] = "Safari",
  ['2'] = "Finder",
  ['3'] = "Warp",
  ['4'] = "Xcode",
  ['5'] = "Zed",
  ['8'] = "Discord",
  ['9'] = "Apple Music",
  ['0'] = "iPhone Mirroring"
}

local function launchOrToggle(appName)
  local app = hs.application.find(appName)

  if app and app:isFrontmost() then
    app:hide()
  else
    hs.application.launchOrFocus(appName)
    -- specific behavior for finder
    if appName == "Finder" then
        hs.timer.doAfter(0.1, function()
            local app = hs.application.find(appName)
            if app then
                local count = 0
                for _, win in ipairs(app:allWindows()) do
                    -- check for standard windows (excludes desktop)
                    if win:isStandard() and not win:isMinimized() then
                        count = count + 1
                    end
                end
                
                if count == 0 then
                    hs.eventtap.keyStroke({"cmd"}, "n")
                end
            end
        end)
    end
  end
end

-- binds the hotkeys from the `apps` table
for key, appName in pairs(apps) do
  hs.hotkey.bind(launcher_mod, key, function()
    launchOrToggle(appName)
  end)
end

-- hotkey to reload the hammerspoon config (cmd+alt+R)
hs.hotkey.bind({'cmd', 'alt'}, 'R', function()
  hs.reload()
end)
