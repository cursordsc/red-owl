--MAXIME

addEventHandler("onClientResourceStart", resourceRoot, function()
	serverCurrentTimeSec = 0
	lastTime = getRealTime().timestamp
	triggerServerEvent("getServerCurrentTimeSec", localPlayer)
end)

function setServerCurrentTimeSec(serverTimeSec)
	serverCurrentTimeSec = serverTimeSec
end
addEvent("setServerCurrentTimeSec", true)
addEventHandler("setServerCurrentTimeSec", root, setServerCurrentTimeSec)