--MAXIME

function getServerCurrentTimeSec()
	triggerClientEvent(source, "setServerCurrentTimeSec", source, now())
end
addEvent("getServerCurrentTimeSec", true)
addEventHandler("getServerCurrentTimeSec", root, getServerCurrentTimeSec)