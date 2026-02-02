local launcher_mod = { 'cmd' }

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
    if appName == "Finder" then
      hs.timer.doAfter(0.1, function()
        local app = hs.application.find(appName)
        if app then
          local count = 0
          for _, win in ipairs(app:allWindows()) do
            if win:isStandard() and not win:isMinimized() then
              count = count + 1
            end
          end

          if count == 0 then
            hs.eventtap.keyStroke({ "cmd" }, "n")
          end
        end
      end)
    end
  end
end

for key, appName in pairs(apps) do
  hs.hotkey.bind(launcher_mod, key, function()
    launchOrToggle(appName)
  end)
end

hs.hotkey.bind({ 'cmd', 'alt' }, 'R', function()
  hs.reload()
end)

-- Mouse Hiding Logic
local CURSOR_HELPER_PATH = os.getenv("HOME") .. "/.config/hammerspoon/cursor_helper"
local cursorTask = nil

local function sendCursorCommand(cmd)
  if cursorTask and cursorTask:isRunning() then
    cursorTask:setInput(cmd .. "\n")
  else
    cursorTask = hs.task.new(CURSOR_HELPER_PATH, nil, function() return true end, { cmd })
    cursorTask:start()
  end
end

local mouseTimer = nil
local eventTap = nil

local function showMouse()
  sendCursorCommand("show")
  if mouseTimer then mouseTimer:stop() end
  mouseTimer = hs.timer.doAfter(7, function()
    sendCursorCommand("hide")
  end)
end

local function startTracking()
  if not eventTap then
    eventTap = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, showMouse)
    eventTap:start()
  end
  sendCursorCommand("hide")
end

local function stopTracking()
  if eventTap then
    eventTap:stop()
    eventTap = nil
  end
  if mouseTimer then
    mouseTimer:stop()
    mouseTimer = nil
  end
  sendCursorCommand("show")
end

local filter = hs.window.filter.new('Warp')
filter:subscribe(hs.window.filter.windowFocused, startTracking)
filter:subscribe(hs.window.filter.windowUnfocused, stopTracking)

cursorTask = hs.task.new(CURSOR_HELPER_PATH, nil, function() return true end)
cursorTask:start()

hs.shutdownCallback = function()
  if cursorTask then cursorTask:terminate() end
end
