local function maskHost(host)
	local labels = {}
	for label in host:gmatch("[^%.]+") do
		table.insert(labels, label)
	end
	for i = 1, #labels - 1 do
		if not (i == 1 and labels[i]:lower() == "www") then
			labels[i] = string.rep("*", #labels[i])
		end
	end
	return table.concat(labels, ".")
end

local function maskDomains(text)
	-- email: user@domain.tld
	text = text:gsub("([%w%.%%%+%-_]+)@([%w%.%-]+%.%a%a+)", function(user, domain)
		return user .. "@" .. maskHost(domain)
	end)

	-- URL со схемой: http(s)://domain
	text = text:gsub("(https?://)([%w%.%-]+)", function(scheme, host)
		return scheme .. maskHost(host)
	end)

	-- домен вида www.domain.tld без схемы
	text = text:gsub("%f[%w](www%.[%w%.%-]+)", function(host)
		return maskHost(host)
	end)

	return text
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "D", function()
	local originalClipboard = hs.pasteboard.getContents()

	hs.eventtap.keyStroke({ "cmd" }, "c")

	hs.timer.doAfter(0.1, function()
		local text = hs.pasteboard.getContents()
		if not text or text == "" then
			hs.alert.show("Нет выделенного текста")
			return
		end

		local masked = maskDomains(text)

		hs.pasteboard.setContents(masked)
		hs.eventtap.keyStroke({ "cmd" }, "v")

		hs.timer.doAfter(0.3, function()
			hs.pasteboard.setContents(originalClipboard)
		end)
	end)
end)
