local function toggleApp(appName, launch)
  launch = launch or false
  local app = hs.application.get(appName)

  if app then
    if app:isFrontmost() then
      app:hide()
    else
      app:activate()
    end
  elseif launch then
    hs.application.launchOrFocus(appName)
  else
    hs.alert.show("App '" .. appName .. "' is not loaded!")
  end
end

-- https://apple.stackexchange.com/questions/442280/how-to-toggle-an-app-in-hammerspoon

local function focusApp(appName, launch)
  launch = launch or false
  local app = hs.application.get(appName)

  if app then
    if not app:isFrontmost() then
      app:activate()
    end
  elseif launch then
    hs.application.launchOrFocus(appName)
  else
    hs.alert.show("App '" .. appName .. "' is not loaded!")
  end
end

hs.hotkey.bind({}, "f1", function()
  toggleApp("Alacritty")
end)

hs.hotkey.bind({}, "f2", function()
  focusApp("Firefox")
end)

hs.hotkey.bind({}, "f3", function()
  focusApp("Emacs")
end)

hs.hotkey.bind({}, "f4", function()
  focusApp("foobar2000")
end)
