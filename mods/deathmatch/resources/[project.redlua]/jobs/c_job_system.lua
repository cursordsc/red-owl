addCommandHandler("meslekbitir", function()
	if getElementData(localPlayer, "loggedin") == 1 then
		local meslek = getElementData(localPlayer, "job")

		if meslek ~= 0 then
			exports["jobs"]:managePizzaszallito(false)
			exports["radar"]:endRoute()
			setElementData(localPlayer, "job", 0)
			local aracim = getElementData(localPlayer, "meslek:aracim")
			if aracim then
				if isElement("aracim") then
                	triggerServerEvent("meslek:event", localPlayer, aracim)
				end
			end

			setElementData(localPlayer, "rota:x", nil)
			setElementData(localPlayer, "rota:y", nil)
			triggerServerEvent("deletePlayerVan", localPlayer, localPlayer)
			outputChatBox("#FF0000[!]#FFFFFF Başarıyla meslekten ayrıldın.",  255, 255, 255, true)
		else
			outputChatBox("#FF0000[!]#FFFFFF Zaten bir meslekte değilsin.", 255, 255, 255, true)
		end
	end
end)

function isJobVehicle(veh, job)
	local jobID = tonumber(getElementData(veh, "meslek:arac")) or 0
	return jobID == job
end

function isMyJobVehicle(veh)
	local owner = tonumber(getElementData(veh, "owner")) or 0
	local myID = tonumber(getElementData(localPlayer, "dbid")) or 0
	return owner == myID
end

addEventHandler("onClientPlayerVehicleExit", getRootElement(), function(vehicle, seat) 
	if getElementData(vehicle, "meslek") and source == localPlayer and seat == 0 then
		exports["infobox"]:addBox("info", "1 Dakika İçinde binmezsen araç otomatik olarak silinecek.")
		local aracim = getElementData(source, "meslek:aracim")
		jobTimer = setTimer(function()
			if isElement(aracim) then
				destroyElement(aracim)
			end
		end, 60000, 1)
	end
end)

addEventHandler("onClientVehicleEnter", getRootElement(), function(thePlayer, seat) 
	if thePlayer and thePlayer == localPlayer and getElementData(source, "meslek") then
		if isTimer(jobTimer) then 
			killTimer(jobTimer) 
		end
		if getElementData(thePlayer, "rota:x") and getElementData(thePlayer, "rota:y") then
			exports["radar"]:endRoute()
			exports["radar"]:makeRoute(getElementData(thePlayer, "rota:x"), getElementData(thePlayer, "rota:y"))
		end
	end
end)