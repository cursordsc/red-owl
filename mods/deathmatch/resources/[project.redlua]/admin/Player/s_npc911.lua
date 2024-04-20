local outboundPhoneNumber = "Hidden Number"

function promptGUI(thePlayer)
	if exports["integration"]:isPlayerSupporter(thePlayer) or exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		triggerClientEvent(thePlayer, "buildGUI_npc911", getResourceRootElement())
	end
end
addCommandHandler("911", promptGUI)

function doTheCall(thePlayer, message, location)

	local playerStack = { }

	for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Police Department" ) ) ) do
		table.insert(playerStack, value)
	end

	for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Fire Department" ) ) ) do
		table.insert(playerStack, value)
	end

	for key, value in ipairs( getPlayersInTeam( getTeamFromName( "San Andreas Highway Patrol" ) ) ) do
		table.insert(playerStack, value)
	end



	local affectedElements = { }

	for key, value in ipairs( playerStack ) do
		for _, itemRow in ipairs(exports['items']:getItems(value)) do
			local setIn = false
			if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
				table.insert(affectedElements, value)
				setIn = true
				break
			end
		end
	end
	for key, value in ipairs( affectedElements ) do
		triggerClientEvent(value, "phones:radioDispatchBeep", value)
		outputChatBox("[RADIO] This is dispatch, We've got an incident call from #" .. outboundPhoneNumber .. ", over.", value, 0, 183, 239)
		outputChatBox("[RADIO] Situation: '" .. message .. "', over.", value, 0, 183, 239)
		outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', out.", value, 0, 183, 239)
	end
end
addEvent("npc911", true)
addEventHandler("npc911", getResourceRootElement(), doTheCall)
