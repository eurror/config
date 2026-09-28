hs.loadSpoon("EmmyLua")
require("mask_url")
require("move_window")

local wf = hs.window.filter.new()

wf:subscribe(hs.window.filter.windowFocused, function(win)
	if win:isStandard() and win:isMaximizable() then
		hs.timer.doAfter(0.05, function()
			win:maximize()
		end)
	end
end)
