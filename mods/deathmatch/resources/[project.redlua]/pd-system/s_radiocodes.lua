local mysql = exports["mysql"]

function refreshPdCodes()
   local content = {}
end
addEvent("refreshPdCodes", true)
addEventHandler("refreshPdCodes", root, refreshPdCodes)

function updatePdCodes(contentFromClient)
	if contentFromClient then
		if contentFromClient.codes then
			if dbExec(mysql:getConnection(), "UPDATE `settings` SET `value`= '"..(contentFromClient.codes).."' WHERE `name`='pdcodes' ") then
				outputChatBox("Codes saved successfully!", client)
			end
		end
		if contentFromClient.procedures then
			if dbExec(mysql:getConnection(), "UPDATE `settings` SET `value`= '"..(contentFromClient.procedures).."' WHERE `name`='pdprocedures' ") then
				outputChatBox("Procedures saved successfully!", client)
			end
		end
	end
end
addEvent("updatePdCodes", true)
addEventHandler("updatePdCodes", getRootElement(), updatePdCodes)