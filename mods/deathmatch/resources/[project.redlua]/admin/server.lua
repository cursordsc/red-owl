local mysql = exports["mysql"]

function doCheck(sourcePlayer, command, ...)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerSupporter(sourcePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. command .. " [Partial Player Name / ID]", sourcePlayer, 255, 194, 14)
		else
			local noob = exports["global"]:findPlayerByPartialNick(sourcePlayer, table.concat({...},"_"))
			if (noob) then
				local logged = getElementData(noob, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", sourcePlayer, 255, 0, 0)
				else
					if noob and isElement(noob) then
						local ip = getPlayerIP(noob)
						local adminreports = tonumber(getElementData(noob, "adminreports"))
						local donPoints = nil
						
						-- get admin note
						local note = ""
						local warns = "?"
						local transfers = "?"
						dbQuery(
							function(qh)
								local res, rows, err = dbPoll(qh, 0)
								local result = res[1]
								if result then
									text = result["adminnote"] or "?"
									
									
									warns = result["warns"] or "?"
									donPoints = result["credits"] or "?"
								end

								dbQuery(
									function(qh)
										local res, rows, err = dbPoll(qh, 0)
										history = {}
										for index, row in ipairs(res) do
											if row then
												table.insert(history, {tonumber(row.action), tonumber(row.numbr)})
											end
										end
										hoursAcc = "N/A"
										dbQuery(
											function(qh)
												local res, rows, err = dbPoll(qh, 0)

												hoursAcc = tonumber(res[1].hours)
												local bankmoney = getElementData(noob, "bankmoney") or -1
												local money = getElementData(noob, "money") or -1
												
												local adminlevel = exports["global"]:getPlayerAdminTitle(noob)
												
												local hoursPlayed = getElementData( noob, "hoursplayed" )
												local username = getElementData( noob, "account:username" )
												triggerClientEvent( sourcePlayer, "onCheck", noob, ip, adminreports, donPoints, note, history, warns, transfers, bankmoney, money, adminlevel, hoursPlayed, username, hoursAcc)
											end,
										mysql:getConnection(), "SELECT SUM(hoursPlayed) AS hours FROM `characters` WHERE account = " .. (tostring(getElementData(noob, "account:id"))))
									end,
								mysql:getConnection(), "SELECT action, COUNT(*) as numbr FROM adminhistory WHERE user = " .. (tostring(getElementData(noob, "account:id"))) .. " GROUP BY action" )
							end,
						mysql:getConnection(), "SELECT adminnote, warns, credits FROM accounts WHERE id = " .. (tostring(getElementData(noob, "account:id"))))	
					end
				end
				exports["logs"]:dbLog(thePlayer, 4, ..., "CHECK")
			end
		end
	end
end
addEvent("checkCommandEntered", true)
addEventHandler("checkCommandEntered", getRootElement(), doCheck)

function savePlayerNote( target, text )
	if exports["integration"]:isPlayerTrialAdmin(client) or exports["integration"]:isPlayerSupporter(client) then
		local account = getElementData(target, "account:id")
		if account then
			local result = dbExec(mysql:getConnection(),"UPDATE accounts SET adminnote = '" .. ( text ) .. "' WHERE id = " .. (account) )
			if result then
				outputChatBox( "Note for the " .. getPlayerName( target ):gsub("_", " ") .. " (" .. getElementData( target, "account:username" ) .. ") has been updated.", client, 0, 255, 0 )
			else
				outputChatBox( "Note Update failed.", client, 255, 0, 0 )
			end
		else
			outputChatBox( "Unable to get Account ID.", client, 255, 0, 0 )
		end
	end
end
addEvent( "savePlayerNote", true )
addEventHandler( "savePlayerNote", getRootElement(), savePlayerNote )

function showAdminHistory( target )
	if source and isElement(source) and getElementType(source) == "player" then
		client = source
	end
	
	if not (exports["integration"]:isPlayerTrialAdmin( client ) or exports["integration"]:isPlayerSupporter( client )) then
		if client ~= target then
			return false
		end
	end
	
	local targetID = getElementData( target, "account:id" )
	if targetID then
		dbQuery(
			function(qh, client)
				local res, rows, err = dbPoll(qh, 0)
				local record = {}
				local info = {}
				for index, row in ipairs(res) do
					record[1] = row["date"]
					record[2] = row["action"]
					record[3] = row["reason"]
					record[4] = row["duration"]
					record[5] = row["username"] == nil and "SYSTEM" or row["username"]
					record[6] = row["user_char"] == nil and "N/A" or row["user_char"]
					record[7] = row["recordid"]
					record[8] = row["hadmin"]
					
					table.insert( info, record )
				end
			
				triggerClientEvent( client, "cshowAdminHistory", target, info, tostring( getElementData( target, "account:username" ) ) )
				
			end,
		{client}, mysql:getConnection(), "SELECT DATE_FORMAT(date,'%b %d, %Y at %h:%i %p') AS date, action, h.admin AS hadmin, reason, duration, a.username as username, c.charactername AS user_char, h.id as recordid FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin LEFT JOIN characters c ON h.user_char=c.id WHERE user = " .. (targetID) .. " ORDER BY h.id DESC")
	
	else
		outputChatBox("Unable to find the account id.", client, 255, 0, 0)
	end
end
addEvent( "showAdminHistory", true )
addEventHandler( "showAdminHistory", getRootElement(), showAdminHistory )

function removeAdminHistoryLine(ID)
	if not ID then return end

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				local sqlQuery = res[1]
				if (tonumber(sqlQuery["action"]) == 4) then -- Warning
					local accountNumber = tostring(sqlQuery["user"])
					dbExec(mysql:getConnection(),"UPDATE `accounts` SET `warns`=warns-1 WHERE `ID`='"..(accountNumber).."' AND `warns` > 0")
					for i, player in pairs(getElementsByType("player")) do
						if getElementData(player, "account:id") == tonumber(accountNumber) then
							local warns = getElementData(player, "warns") - 1
							exports["anticheat"]:changeProtectedElementDataEx(player, "warns", warns, false)
							break
						end
					end
				end
			
				dbExec(mysql:getConnection(),"DELETE FROM `adminhistory` WHERE `id`='".. (tostring(ID)) .."'")
				if source then
					outputChatBox("Admin history entry #"..ID.." removed", source, 0, 255, 0)
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `adminhistory` WHERE `id`='".. (tostring(ID)).."'")
end
addEvent( "admin:removehistory", true)
addEventHandler( "admin:removehistory", getRootElement(), removeAdminHistoryLine )

addCommandHandler( "history", 
	function( thePlayer, commandName, ... )
		if not (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer)) then
			if (...) then
				outputChatBox("Only Admins or Supporters can check other's player admin history.", thePlayer, 255, 0, 0)
				return false
			end
		end
		
		local targetPlayer = thePlayer
		if (...) then
			targetPlayer = exports["global"]:findPlayerByPartialNick(thePlayer, table.concat({...},"_"))
		end
		
		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==0) then
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
			else
				triggerEvent("showAdminHistory", thePlayer, targetPlayer)
			end
		else
			local targetPlayerName = table.concat({...},"_")
			-- select by charactername
			dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows == 1 then
					for index, row in ipairs(res) do
						if not row then break end
						local id = row["account"] or '0'
						triggerEvent("showOfflineAdminHistory", thePlayer, id, targetPlayerName)
						return
					end
				else
					dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows == 1 then
							for index, row2 in ipairs(res) do
								local id = tonumber( row2["id"] ) or '0'
								triggerEvent("showOfflineAdminHistory", thePlayer, id, targetPlayerName)
								return
							end
						end
					end,
					mysql:getConnection(), "SELECT id FROM accounts WHERE username = '" .. ( targetPlayerName ))
				end
			end,
			mysql:getConnection(), "SELECT account FROM characters WHERE charactername = '" .. (targetPlayerName ) .. "'")

			outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
		end
	end
)


addEvent("admin:showInventory", true)
addEventHandler("admin:showInventory", getRootElement(), 
	function ()
		 executeCommandHandler( "showinv", client, getElementData(source, "playerid") )
	end
)

function addAdminHistory(user, admin, reason, action, duration)
	local user_char = 0
	if not action or not tonumber(action) then
		action = getHistoryAction(action)
	end
	if not action then
		action = 6
	end
	if not duration or not tonumber(duration) then
		duration = 0
	end
	if isElement(user) then
		user_char = getElementData(user, "dbid") or 0
		user = getElementData(user, "account:id") or 0
	end
	if isElement(admin) then
		admin = getElementData(admin, "account:id")
	end
	if not tonumber(user) or not tonumber(admin) or not reason then
		--outputDebugString("addAdminHistory failed.")
		return false
	end
	return dbExec(mysql:getConnection(),"INSERT INTO adminhistory SET admin="..admin..", user="..user..", user_char="..user_char..", action="..action..", duration="..duration..", reason='"..(reason).."' ")
end

-- WATCH


local watcher = { }
local watched = { }
local watchTimers = { }

function takeScreen( )
	for i, k in pairs( watched ) do
		if isElement( i ) then
			takePlayerScreenShot( i, 200, 200, getPlayerName( i ), 50, 1000000 )
		end
	end
end
setTimer( takeScreen, 50, 0 )

addEventHandler( "onPlayerScreenShot", root,
	function ( theResource, status, imageData, timestamp, tag )
		if status == "ok" then
			if watched[ source ] then
				for i, k in pairs( watched[ source ] ) do
					if not isElement( k ) then
						watched[ source ][ i ] = nil
						watcher[ k ] = nil
						if watchTimers[ k ] then
							killTimer( watchTimers[ k ])
						end
					else
						triggerClientEvent( k, "updateScreen", k, imageData, source )
					end
				end
			end
		end
	end
)

function setWatch( player, other )
	if watcher[ player ] then
		if watched[ watcher[ player ] ] then
			for i, k in pairs( watched[ watcher[ player ] ] ) do
				if k == player then
					watched[ watcher[ player ] ][ i ] = nil
				end
			end
		end
	end
	watcher[ player ] = other
	if not watched[ other ] then
		watched[ other ] = { }
	end
	table.insert( watched[ other ], player )
end


function updateAutoWatch( player )
	local nextIncrement = 0
	for index, other in ipairs( getElementsByType( 'player' )) do
		if nextIncrement == 1 then
			setWatch( player, other )
			return
		elseif watcher[ player ] == other then
			nextIncrement = 1
		end
	end
	setWatch( player, getElementsByType( 'player' )[ 1 ])
end

addCommandHandler( 'autowatch',
	function ( player, command, interval )
		if exports["integration"]:isPlayerTrialAdmin( player ) then
			interval = tonumber( interval )
			if interval then
				watchTimers[ player ] = setTimer( updateAutoWatch, interval * 1000, 0, player )
				setWatch( player, getElementsByType( 'player' )[ 1 ])
			else
				outputChatBox( "/" .. command .. " [time interval]", player, 255, 255, 255 )
			end
		end
	end
)

addCommandHandler( 'pausewatch',
	function (player, command)
		if exports["integration"]:isPlayerTrialAdmin( player ) then
			if watchTimers[ player ] then
				killTimer( watchTimers[ player])
				outputChatBox( 'Watch timer paused.', player, 255, 102, 0 )
			else
				outputChatBox( 'You do not have watch enabled!', player, 255, 155, 155 )
			end
		end
	end
)

addCommandHandler( 'resumewatch',
	function ( player, command, interval )
		if exports["integration"]:isPlayerTrialAdmin( player ) then
			interval = tonumber( interval )
			if interval then
				watchTimers[ player ] = setTimer( updateAutoWatch, interval * 1000, 0, player )
			else
				outputChatBox( "/" .. command .. " [time interval]", player, 255, 255, 255 )
			end
		end
	end
)


addCommandHandler( 'stopwatch',
	function( player, command )
		if watcher[ player ] and watched[ watcher[ player ] ] then
			for i, k in pairs( watched[ watcher[ player ] ] ) do
				if k == player then
					watched[ watcher[ player ] ][ i ] = nil
				end
			end
			watcher[ player ] = nil
			killTimer( watchTimers[ player ] ) -- stop the auto updating timer
			outputChatBox( "You are no longer watching anyone.", player, 255, 155, 155 )
		end
		triggerClientEvent( player, "stopScreen", player )
	end
)

addCommandHandler( "watch",
	function( player, command, other )
		if exports["integration"]:isPlayerTrialAdmin( player ) then
			if other then
				local other, name = exports["global"]:findPlayerByPartialNick( player, other )
				if other then
					-- remove the original watch before moving to a new one
					if watcher[ player ] and watched[ watcher[ player ] ] then
						for i, k in pairs( watched[ watcher[ player ] ] ) do
							if k == player then
								watched[ watcher[ player ] ][ i ] = nil
							end
						end
					end
					watcher[ player ] = other
					if not watched[ other ] then
						watched[ other ] = { }
					end
					table.insert( watched[ other ], player )
					outputChatBox( "You are now watching " .. name .. ".", player, 155, 255, 155 )
				end
			else
				if watcher[ player ] and watched[ watcher[ player ] ] then
					for i, k in pairs( watched[ watcher[ player ] ] ) do
						if k == player then
							watched[ watcher[ player ] ][ i ] = nil
						end
					end
					watcher[ player ] = nil
					triggerClientEvent( player, "stopScreen", player )
					outputChatBox( "You are no longer watching anyone.", player, 255, 155, 155 )
				else
					triggerClientEvent( player, "stopScreen", player )
					outputChatBox( "SYNTAX: /"..command.." [Player]", player, 255, 255, 255 )
				end
			end
		end
	end, false, false
)

addEventHandler( "onPlayerQuit", root,
	function()
		watcher[ source ] = nil
		for i, k in pairs( watched ) do
			for l, m in pairs( k ) do
				if source == m then
					watched[ i ][ l ] = nil
				end
			end
		end
		watched[ source ] = nil
	end
)

function doRealBigEars ( message )
	if not exports["integration"]:isPlayerSeniorAdmin(client) then
		-- big ears
		for key, value in pairs( getElementsByType( "player" ) ) do
			if isElement( value ) then
				local listening = getElementData( value, "realbigears" )
				if listening == client and value ~= client then
					outputChatBox("(" .. getPlayerName(client) .. ") " .. message, value, 255, 255, 0)
				end
			end
		end
	end
end
addEvent( "adm:rbe", true )
addEventHandler( "adm:rbe", getRootElement(), doRealBigEars )

local spam = {}
local uTimers = {}
local antispamCooldown = 5000

function onCmd( commandName )
	if not getElementData(source, "cmdDisabled") then
		spam[source] = tonumber(spam[source] or 0) + 1
		if spam[source] == 100 then
			local playerName = source:getName():gsub('_', ' ')
			outputChatBox('   Please try not to spam too much or you will have your commands disabled.', source, 255,0,0)
			exports["global"]:sendMessageToAdmins("[RED:LUA Scripting] Detected Player '" .. playerName .. "' for possibly spamming "..tonumber(spam[source]).." commands / "..(antispamCooldown/1000).." seconds. ('/"..commandName.."').")
		elseif spam[source] > 150 then
			local playerName = source:getName():gsub('_', ' ')
			exports["global"]:sendMessageToAdmins("[RED:LUA Scripting] Player '" .. playerName .. "' has had his commands disabled spamming "..tonumber(spam[source]).." commands / "..(antispamCooldown/1000).." seconds. ('/"..commandName.."').")
			outputChatBox('   Your command usage has been disabled.', source, 255,0,0)
			exports["anticheat"]:changeProtectedElementDataEx(source, "cmdDisabled", true)
			spam[source] = 0
		end
	
		if isTimer(uTimers[source]) then
			killTimer(uTimers[source])
		end
	
		uTimers[source] = setTimer(	function (source)
			spam[source] = 0
			
			if isElement(source) and getElementData(source, "cmdDisabled") then
				exports["anticheat"]:changeProtectedElementDataEx(source, "cmdDisabled", false)
			end
		end, antispamCooldown, 1, source)
	else
		cancelEvent()
	end
end
addEventHandler('onPlayerCommand', root, onCmd)

function quitPlayer()
	spam[source] = nil
end
addEventHandler("onPlayerQuit", root, quitPlayer)

-- GET VEHICLE KEY OR INTERIOR KEY / MAXIME
function getKey(thePlayer, commandName)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer)	then
		local adminName = getPlayerName(thePlayer):gsub(" ", "_")
		local veh = getPedOccupiedVehicle(thePlayer)
		if veh then
			local vehID = getElementData(veh, "dbid")
			
			givePlayerItem(thePlayer, "giveitem" , adminName, "3" , tostring(vehID))
			
			return true
		else
			local intID = getElementDimension(thePlayer)
			if intID then
				local foundIntID = false
				local keyType = false
				local possibleInteriors = getElementsByType("interior")
				for _, theInterior in pairs (possibleInteriors) do
					if getElementData(theInterior, "dbid") == intID then
						local intType = getElementData(theInterior, "status")[1] 
						if intType == 0 or intType == 2 or intType == 3 then
							keyType = 4 --Yellow key
						else
							keyType = 5 -- Pink key
						end
						foundIntID = intID
						break
					end
				end
				
				if foundIntID and keyType then
					givePlayerItem(thePlayer, "giveitem" , adminName, tostring(keyType) , tostring(foundIntID))
					
					return true
				else
					outputChatBox(" You're not in any vehicle or possible interior.", thePlayer, 255,0 ,0 )
					return false
				end
			end
		end
	end
end
addCommandHandler("getkey", getKey, false, false)

function setSvPassword(thePlayer, commandName, password)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer)	then
		outputChatBox("SYNTAX: /" .. commandName .. " [Password without spaces, empty to remove pw] - Set/remove server's password", thePlayer, 255, 194, 14)
		if password and string.len(password) > 0 then
			if setServerPassword(password) then
				exports["global"]:sendMessageToStaff("[SYSTEM] "..exports["global"]:getPlayerFullIdentity(thePlayer).." has set server's password to '"..password.."'.", true)
			end
		else
			if setServerPassword('') then
				exports["global"]:sendMessageToStaff("[SYSTEM] "..exports["global"]:getPlayerFullIdentity(thePlayer).." has removed server's password.", true)
			end
		end
	end
end
addCommandHandler("setserverpassword", setSvPassword, false, false)
addCommandHandler("setserverpw", setSvPassword, false, false)

function AdminLoungeTeleport(sourcePlayer)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerSupporter(sourcePlayer)) then
		setElementPosition(sourcePlayer, 275.761475, -2052.245605, 3085.291962 )
		setPedGravity(sourcePlayer, 0.008)
		setElementDimension(sourcePlayer, 0)
		setElementInterior(sourcePlayer, 0)
		triggerEvent("texture-system:loadCustomTextures", sourcePlayer)
	end
end

addCommandHandler("adminlounge", AdminLoungeTeleport)
addCommandHandler("gmlounge", AdminLoungeTeleport)

function setX(sourcePlayer, commandName, newX)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerScripter(sourcePlayer)) then
		if not (newX) then
			outputChatBox("SYNTAX: /" .. commandName .. " [x coordinate]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, newX, y, z)
			x, y, z = nil
		end
	end
end

addCommandHandler("setx", setX)

function setY(sourcePlayer, commandName, newY)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerScripter(sourcePlayer)) then
		if not (newY) then
			outputChatBox("SYNTAX: /" .. commandName .. " [y coordinate]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, x, newY, z)
			x, y, z = nil
		end
	end
end

addCommandHandler("sety", setY)

function setZ(sourcePlayer, commandName, newZ)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerScripter(sourcePlayer)) then
		if not (newZ) then
			outputChatBox("SYNTAX: /" .. commandName .. " [z coordinate]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, x, y, newZ)
			x, y, z = nil
		end
	end
end

addCommandHandler("setz", setZ)

function setXYZ(sourcePlayer, commandName, newX, newY, newZ)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerScripter(sourcePlayer)) then
		if (newX) and (newY) and (newZ) then
			local newX = newX:gsub(",", "")
			local newY = newY:gsub(",", "")
			local newZ = newZ:gsub(",", "")
			
			setElementPosition(sourcePlayer, newX, newY, newZ)
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [x coordnate] [y coordinate] [z coordinate]", sourcePlayer, 255, 194, 14)
		end
	end
end

addCommandHandler("setxyz", setXYZ)

function setXY(sourcePlayer, commandName, newX, newY)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerScripter(sourcePlayer)) then
		if (newX) and (newY) then
			setElementPosition(sourcePlayer, newX, newY)
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [x coordnate] [y coordinate]", sourcePlayer, 255, 194, 14)
		end
	end
end

addCommandHandler("setxy", setXY)

function setXZ(sourcePlayer, commandName, newX, newZ)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerScripter(sourcePlayer)) then
		if (newX) and (newZ) then
			setElementPosition(sourcePlayer, newX, newZ)
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [x coordnate] [z coordinate]", sourcePlayer, 255, 194, 14)
		end
	end
end

addCommandHandler("setxz", setXZ)

function setYZ(sourcePlayer, commandName, newY, newZ)
	if (exports["integration"]:isPlayerTrialAdmin(sourcePlayer) or exports["integration"]:isPlayerScripter(sourcePlayer)) then
		if (newY) and (newZ) then
			setElementPosition(sourcePlayer, newY, newZ)
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [y coordinate] [z coordinate]", sourcePlayer, 255, 194, 14)
		end
	end
end

addCommandHandler("setyz", setYZ)