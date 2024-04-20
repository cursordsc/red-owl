local distance = 50

local gpn = getPlayerName
function oyuncuisim(p)
	local name = gpn(p) or getElementData(p, "name") or p
	return string.gsub(name, "_", " ")
end

function clearAdo ( thePlayer )
	triggerClientEvent("clearAdo", getRootElement(), thePlayer)
end
addCommandHandler("clear", clearAdo, false, false)
addCommandHandler("clearado", clearAdo, false, false)

function sendAdo( thePlayer, commandName, ... )
	if not (...) then
		outputChatBox("SYNTAX: /ado [Etkileşim]", thePlayer, 255, 194, 14)
		return false
	end

	local name = oyuncuisim(thePlayer)
	local message = table.concat({...}, " ")



	if getElementData(thePlayer, "adoSpam") == message then
		outputChatBox("SPAM: SPAM: /ado'nuz spam önlemez. Birkaç saniye içinde tekrar deneyin.", thePlayer, 255, 0, 0)
		return nil
	else
		setElementData(thePlayer, "adoSpam", message)
		setTimer( function()
			setElementData(thePlayer, "adoSpam", nil)
		end, 5000, 1)
		local state, affectedPlayers = sendToNearByClients(thePlayer, "* " ..  message .. " (( " ..name.. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. " )) *")
		return state, affectedPlayers
	end
end
addCommandHandler("ado", sendAdo)
addEvent("sendAdo", true)
addEventHandler("sendAdo", getRootElement(),
	function(message)
	triggerClientEvent(root,"addChatBubblee",source,message)
	end)

function sendToNearByClients(root, message)
	local affectedPlayers = { }
	local x, y, z = getElementPosition(root)

	if getElementType(root) == "player" and exports['freecam-tv']:isPlayerFreecamEnabled(root) then return end

	local shownto = 0
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < ( distance or 20 ) then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if logged==1 and getElementDimension(root) == getElementDimension(nearbyPlayer) then
				triggerClientEvent(nearbyPlayer,"onClientAdo", root, message)
				table.insert(affectedPlayers, nearbyPlayer)
				shownto = shownto + 1
				if nearbyPlayer~=root then
					outputConsole(message, nearbyPlayer)
				end
			end
		end
	end

	outputChatBox(message, root)

	if shownto > 0  then
		exports["logs"]:dbLog(root, 40, affectedPlayers, message)
		return true, affectedPlayers
	else
		return false, false
	end

end
addEvent("sendToNearByClients", true)
addEventHandler("sendToNearByClients", getRootElement(), sendToNearByClients)