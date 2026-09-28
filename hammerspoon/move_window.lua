local hyper = {"cmd", "alt", "ctrl", "shift"}

hs.hotkey.bind(hyper, "down", function()
  local win = hs.window.focusedWindow()
  if win then
    win:moveOneScreenSouth()
  end
end)

hs.hotkey.bind(hyper, "up", function()
  local win = hs.window.focusedWindow()
  if win then
    win:moveOneScreenNorth()
  end
end)
