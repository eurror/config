local MASKED_DOMAINS = {
  "example.com",
}

local MASKED_EMAIL_DOMAINS = {
  "example.com",
}

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

local function hasDomain(host, domains)
  host = host:lower()
  for _, domain in ipairs(domains) do
    domain = domain:lower()
    if host == domain or host:sub(-#domain - 1) == "." .. domain then
      return true
    end
  end
  return false
end

local function isIPv4(s)
  local octets = { s:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$") }
  if #octets ~= 4 then
    return false
  end
  for _, octet in ipairs(octets) do
    if #octet > 3 or tonumber(octet) > 255 then
      return false
    end
  end
  return true
end

local function maskSensitive(text)
  text = text:gsub("([%w%.%%%+%-_]+)@([%w%.%-]+%.%a%a+)", function(user, domain)
    if hasDomain(domain, MASKED_EMAIL_DOMAINS) then
      return string.rep("*", #user) .. "@" .. maskHost(domain)
    end
  end)

  text = text:gsub("%w[%w%.%-]*", function(token)
    local host, tail = token:match("^(.-)([%.%-]*)$")
    if isIPv4(host) then
      return host:gsub("%d", "*") .. tail
    end
    if hasDomain(host, MASKED_DOMAINS) then
      return maskHost(host) .. tail
    end
  end)

  return text
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "D", function()
  local originalClipboard = hs.pasteboard.readAllData()
  local changeCount = hs.pasteboard.changeCount()

  hs.eventtap.keyStroke({ "cmd" }, "c")

  hs.timer.doAfter(0.1, function()
    if hs.pasteboard.changeCount() == changeCount then
      hs.alert.show("Нет выделенного текста")
      return
    end

    local text = hs.pasteboard.getContents()
    if not text or text == "" then
      hs.pasteboard.writeAllData(originalClipboard)
      hs.alert.show("Нет выделенного текста")
      return
    end

    hs.pasteboard.setContents(maskSensitive(text))
    hs.eventtap.keyStroke({ "cmd" }, "v")

    hs.timer.doAfter(0.3, function()
      hs.pasteboard.writeAllData(originalClipboard)
    end)
  end)
end)
