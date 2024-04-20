local distance = 50

local gpn = getPlayerName
function oyuncuisim(p)
	local name = gpn(p) or getElementData(p, "name") or p
	return string.gsub(name, "_", " ")
end

function clearAme ( thePlayer )
	triggerClientEvent("clearAme", getRootElement(), thePlayer)
end
addCommandHandler("clear", clearAme, false, false)
addCommandHandler("clearame", clearAme, false, false)

function sendAme( thePlayer, commandName, ... )
	if not (...) then
		outputChatBox("SYNTAX: /ame [Aktive]", thePlayer, 255, 194, 14)
		return false
	end
	
	local name = oyuncuisim(thePlayer)
	local message = table.concat({...}, " ")



	if getElementData(thePlayer, "ameSpam") == message then
		outputChatBox("SPAM: SPAM: /ame'niz spam önlemez. Birkaç saniye içinde tekrar deneyin.", thePlayer, 255, 0, 0)
		return nil
	else
		setElementData(thePlayer, "ameSpam", message)
		setTimer( function()
			setElementData(thePlayer, "ameSpam", nil)
		end, 5000, 1)
		local state, affectedPlayers = sendToNearByClients(thePlayer, "*" ..  name.. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message.."*")
		return state, affectedPlayers
	end
end
addCommandHandler("ame", sendAme)
addEvent("sendAme", true)
addEventHandler("sendAme", getRootElement(),
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
				triggerClientEvent(nearbyPlayer,"onClientAme", root, message)
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