local distance1 = 100

function sendStatus( thePlayer, commandName, ... )
	if not (...) then
		triggerClientEvent("clearStatus", getRootElement(), thePlayer)
		removeElementData(thePlayer, "isStatusShowing")
		return
	end
	setElementData(thePlayer, "isStatusShowing", true)
	local name = getPlayerName(thePlayer)
	local message = table.concat({...}, " ")
	outputChatBox("[!] başırı bir biçimde statüs'ü etkinleştirdiniz. Tekrardan kapatmak için komutu tekrarlayınız.", thePlayer, 255, 194, 14)
	local state, affectedPlayers = sendToNearByClientsStatus(thePlayer, "" .. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message.."")
	-- triggerClientEvent(root,"addChatBubbleee",source,message)
	return state, affectedPlayers
end
addCommandHandler("status", sendStatus)
--addCommandHandler("z3x1status", sendStatus)
addEvent("sendStatus", true)
addEventHandler("sendStatus", getRootElement(),
	function(message)
		-- triggerClientEvent(root,"addChatBubbleee",source,message)
		return sendToNearByClientsStatus(source, "" .. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message.."")
	end)

function sendToNearByClientsStatus(root, message)
	local affectedPlayers = { }
	local x, y, z = getElementPosition(root)
	
	if getElementType(root) == "player" and exports['freecam-tv']:isPlayerFreecamEnabled(root) then return end
	
	for k, v in pairs(exports["pool"]:getPoolElementsByType("player")) do
		triggerClientEvent(v,"onClientStatus", root, message)
	end
	
	outputChatBox(message, root)

end
addEvent("sendToNearByClientsStatus", true)
addEventHandler("sendToNearByClientsStatus", getRootElement(), sendToNearByClientsStatus)