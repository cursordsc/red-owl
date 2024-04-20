function checkLSPD(thePlayer, seat, jacked)
	local playerFaction = tonumber(getElementData(getPlayerTeam(thePlayer), "id"))
	local vehicleFaction = tonumber(getElementData(source, "faction"))
	
	if (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 1) and not (playerFaction == 1) then
		cancelEvent()
		outputChatBox("[!] #f0f0f0Bu aracı sadece Los Santos Polis Departmanı üyeleri kullanabilir!", 255, 0, 0, true)
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), checkLSPD)


function checkAskeriye(thePlayer, seat, jacked)
	local playerFaction = tonumber(getElementData(getPlayerTeam(thePlayer), "id"))
	local vehicleFaction = tonumber(getElementData(source, "faction"))
	
	if (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 56) and not (playerFaction == 56) then
		cancelEvent()
		outputChatBox("[!] #f0f0f0Bu aracı sadece Los Santos Sheriff Departmanı üyeleri kullanabilir!", 255, 0, 0, true)
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), checkAskeriye)