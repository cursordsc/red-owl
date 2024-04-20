mysql = exports["mysql"]

function doMonitorList(sourcePlayer, command, targetPlayerName, ...)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerSupporter(sourcePlayer)) then
		if not targetPlayerName then
			local dataTable = { }
			for key, value in ipairs( getElementsByType( "player" ) ) do
				local loggedin = getElementData(value, "loggedin")
				if (loggedin == 1) then
					local reason = getElementData(value, "admin:monitor")
					if reason and #reason > 0 then
						local playerAccount = getElementData(value, "account:username")
						local playerName = getPlayerName(value):gsub("_", " ")
						table.insert(dataTable, { playerAccount, playerName, reason } )
					end
				end
			end
			triggerClientEvent( sourcePlayer, "onMonitorPopup", sourcePlayer, dataTable, exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerSupporter(sourcePlayer))		
		else
			if not ... then
				outputChatBox("SYNTAX: /" .. command .. " [player] [reason]", sourcePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(sourcePlayer, targetPlayerName)
				if targetPlayer then
					local accountID = tonumber(getElementData(targetPlayer, "account:id"))
					local month = getRealTime().month + 1
					local timeStr = tostring(getRealTime().monthday) .. "/" ..tostring(month)  
					local reason = table.concat({...}, " ") .. " (" .. getElementData(sourcePlayer, "account:username") .. " "..timeStr..")"
					if dbExec(mysql:getConnection(), "UPDATE accounts SET monitored = '" .. (reason) .. "' WHERE id = " .. (accountID)) then
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "admin:monitor", reason, false)
						outputChatBox("You added " .. getPlayerName(targetPlayer):gsub("_", " ") .. " to the monitor list.", sourcePlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("monitor", doMonitorList)

addEvent("monitor:onSaveEdittedMonitor", true)
addEventHandler("monitor:onSaveEdittedMonitor", getRootElement( ),
	function (sourcePlayer, username, monitorContent, targetPlayerName1)
		local staffUsername = getElementData(sourcePlayer, "account:username")
		local month = getRealTime().month + 1
		local timeStr = tostring(getRealTime().monthday) .. "/" ..tostring(month)  
		local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(sourcePlayer, targetPlayerName1)
		local reason = monitorContent .. " (" .. staffUsername .. " "..timeStr..")"
		if dbExec(mysql:getConnection(), "UPDATE accounts SET monitored = '" .. (reason) .. "' WHERE username = '" .. (username).."'") then
			exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "admin:monitor", reason, false)
			outputChatBox("[MONITOR] You updated " .. username .. " to the monitor list.", sourcePlayer, 0, 255, 0)
			doMonitorList(sourcePlayer, "monitor") 
			if exports["integration"]:isPlayerTrialAdmin(sourcePlayer) then
				staffTitle = exports["global"]:getPlayerAdminTitle(sourcePlayer)
			end
			exports["global"]:sendMessageToAdmins("[MONITOR] "..staffTitle.." "..staffUsername.." modified monitor on player '"..targetPlayerName.."' ("..monitorContent..").")
			exports["global"]:sendMessageToSupporters("[MONITOR] "..staffTitle.." "..staffUsername.." modified monitor on player '"..targetPlayerName.."' ("..monitorContent..").")
		else
			outputChatBox("[MONITOR] Failed to update " .. username .. " to the monitor list.", sourcePlayer, 255, 0, 0) 
		end
	end	
)

addEvent("monitor:add", true)
addEventHandler("monitor:add", getRootElement( ),
	function( name, reason)
		if exports["integration"]:isPlayerTrialAdmin(client) or exports["integration"]:isPlayerSupporter(client) then
			offlineMonitorADD(client, "omonitor", name, reason)
		end
	end
)

addEvent("monitor:checkUsername", true)
addEventHandler("monitor:checkUsername", getRootElement( ),
function()

end)

addEvent("monitor:remove", true)
addEventHandler("monitor:remove", getRootElement( ),
	function( )
		if exports["integration"]:isPlayerTrialAdmin(client) or exports["integration"]:isPlayerSupporter(client) then
			local staffUsername = getElementData(client, "account:username")
			local playerUsername = getElementData(source, "account:username")
			local accountID = tonumber(getElementData(source, "account:id"))
			if dbExec(mysql:getConnection(), "UPDATE accounts SET monitored = '' WHERE id = " .. (accountID)) then
				exports["anticheat"]:changeProtectedElementDataEx(source, "admin:monitor", false, false)
				outputChatBox("You removed " .. getPlayerName(source):gsub("_", " ") .. " from the monitor list.", client, 0, 255, 0)
				
				staffTitle = exports["global"]:getPlayerAdminTitle(client)
				exports["global"]:sendMessageToAdmins("[MONITOR] "..staffTitle.." "..staffUsername.." removed monitor on player '"..playerUsername.."'.")
				exports["global"]:sendMessageToSupporters("[MONITOR] "..staffTitle.." "..staffUsername.." removed monitor on player '"..playerUsername.."'.")
				
				doMonitorList(client)
			end
		end
	end
)