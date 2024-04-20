function onStealthKill(targetPlayer)
	--exports["global"]:sendMessageToAdmins("[ANTIDM] Blocked stealth kill from "..getPlayerName(source) .." against " .. getPlayerName(targetPlayer))
    cancelEvent(true)
end
addEventHandler("onPlayerStealthKill", getRootElement(), onStealthKill)

local checked = false
function checkDimension(thePlayer, newdim, newint)
	if not (type(firearmstable[thePlayer]) == "table") then return end

	for k,v in pairs(firearmstable[thePlayer]) do
		if isElement(v) then
			if (checked == false) then
				if not (isElement(v)) then
					--removeData(thePlayer) -- to prevent debug errors
					--outputDebugString("WearableCheckDimension: This is not a element: " .. tostring(v[thePlayer]) .. " - Owner: " .. getPlayerName(thePlayer))
					checked = true
				end
			end
			local dim = getElementDimension (v)
			local int = getElementInterior (v)
				
			if (dim ~= newdim) then
				setElementDimension (v, newdim)
			end
			if (int ~= newint) then
				setElementInterior(v, newint)
			end
		end
	end
end