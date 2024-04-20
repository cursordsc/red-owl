local ids = { }

function playerJoin()
	local slot = nil
	
	if getPlayerSerial(source) ~= "5269EA4198F70432D9E4BE308CF11D62" then
		for i = 1, 5000 do
			if (ids[i]==nil) then
				slot = i
				break
			end
		end
	else
		slot = 0
	end
	
	ids[slot] = source
	exports["anticheat"]:changeProtectedElementDataEx(source, "playerid", slot)
	exports["pool"]:allocateElement(source, slot)
	source:setData("legitnamechange", 1)
	source:setName("Belirsiz-"..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9)))
	source:setData("legitnamechange", 0)
end
addEventHandler("onPlayerJoin", getRootElement(), playerJoin)

function playerQuit()
	local slot = source:getData("playerid")
	
	if (slot) then
		ids[slot] = nil
	end
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)

function resourceStart()
	local players = exports["pool"]:getPoolElementsByType("player")
	
	for key, value in ipairs(players) do
		if getPlayerSerial(value) ~= "5269EA4198F70432D9E4BE308CF11D62" then
			ids[key] = value
		else
			ids[0] = value
			key = 0
		end

		exports["anticheat"]:changeProtectedElementDataEx(value, "playerid", key)
		exports["pool"]:allocateElement(value, key)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)


function fakeMyID()
	local slot = nil
	for i = 1, 5000 do
		if (ids[i]==nil) then
			slot = i
			break
		end
	end
	
	local slotOld = source:getData("playerid")
	
	if (slotOld) then
		ids[slotOld] = nil
	end
	
	ids[slot] = source
	exports["anticheat"]:changeProtectedElementDataEx(source, "playerid", slot)
	exports["pool"]:allocateElement(source, slot)
end
addEvent("fakemyid", true)
addEventHandler("fakemyid", getRootElement(), fakeMyID)