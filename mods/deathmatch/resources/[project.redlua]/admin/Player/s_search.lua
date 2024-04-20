-- FIND IP --
local function showIPAlts(thePlayer, ip)
	local count = 0
	outputChatBox( " IP Address: " .. ip, thePlayer)

	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if not row then break end
		
				if row["lastlogin"] == "NULL" then
					row["lastlogin"] = "Never"
				end

				local text = " #" .. count .. ": " .. tostring(row["username"])
				if tonumber( row["appstate"] ) < 3 then
					text = text .. " (Awaiting App)"
				end

				outputChatBox( text, thePlayer)
				count = count + 1
			end
		end
	end,
	mysql:getConnection(), "SELECT `username`, `lastlogin` ,`appstate` FROM `accounts` WHERE `ip` = '" .. (ip) .. "' ORDER BY `id` ASC")
end

function findAltAccIP(thePlayer, commandName, ...)
	if exports["integration"]:isPlayerTrialAdmin( thePlayer ) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = exports["global"]:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer or getElementData( targetPlayer, "loggedin" ) ~= 1 then
				-- select by charactername
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local ip = row["ip"] or '0.0.0.0'
							showIPAlts( thePlayer, ip )
							return
						end
					end
				end,
				mysql:getConnection(), "SELECT a.`ip` FROM `characters` c LEFT JOIN `accounts` a on c.`account`=a.`id` WHERE c.`charactername` = '" .. (targetPlayerName ) .. "'")

				targetPlayerName = table.concat({...}, " ")
				
				-- select by accountname
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local ip = row["ip"] or '0.0.0.0'
							showIPAlts( thePlayer, ip )
							return
						end
					end
				end,
				mysql:getConnection(), "SELECT ip FROM accounts WHERE username = '" .. (targetPlayerName ) .. "'")

				-- select by ip
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows >= 1 then
						for index, row in ipairs(res) do
							local ip = tonumber( row["ip"] ) or '0.0.0.0'
							showIPAlts( thePlayer, ip )
							return
						end
					else
						--outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
					end
				end,
				mysql:getConnection(), "SELECT ip FROM accounts WHERE ip = '" .. ( targetPlayerName ) .. "'")

			else -- select by online player
				showIPAlts( thePlayer, getPlayerIP(targetPlayer) )
			end
		end
	end
end
addCommandHandler( "findip", findAltAccIP )
-- END FIND IP --

-- START FINDALTS --
local function showAlts(thePlayer, id, creation)
	local count = 0
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, name in ipairs(res) do
					local uname = name["username"]
					if uname  then

					outputChatBox( "WHOIS " .. uname .. ": ", thePlayer, 255, 194, 14 )

					if (tonumber(name["appstate"])) < 3 then
						outputChatBox( "This account didn't pass an application yet.", thePlayer, 255, 0, 0 )	
					end
				else
					outputChatBox( "?", thePlayer )
				end
			end
		end
	end,
	mysql:getConnection(), "SELECT `username`, `appstate` FROM `accounts` WHERE `id` = '" .. (id) .. "'")
				
	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do

				if not row then break end
		
				count = count + 1
				local r = 255
				if getPlayerFromName( row["charactername"] ) then
					r = 0
				end

				local text = "#" .. count .. ": " .. row["charactername"]:gsub("_", " ")
				if tonumber( row["cked"] ) == 1 then
					text = text .. " (Missing)"
				elseif tonumber( row["cked"] ) == 2 then
					text = text .. " (Buried)"
				end

				if row['lastlogin'] ~= "NULL" then
					text = text .. " - " .. tostring( row['lastlogin'] )
				end

				if creation and row['creationdate'] ~= "NULL" then
					text = text .. " - Created " .. tostring( row['creationdate'] )
				end

				local faction = tonumber( row["faction_id"] ) or 0
				if faction > 0 and exports["integration"]:isPlayerAdmin( thePlayer ) then
					local theTeam = exports["pool"]:getElement("team", faction)
					if theTeam then
						text = text .. " - " .. getTeamName( theTeam )
					end
				end

				local hours = tonumber(row.hoursplayed)
				local newhours = tonumber(row.hoursplayed) + tonumber(row.hoursplayed)
				if hours and hours > 0 then
					text = text .. " - " .. hours .. " hours"
				end
				local activated = tonumber(row.active)
				if activated then
					if activated == 0 then
						text = text .. " (Deactivated)"
					end
				end
				outputChatBox( text, thePlayer, r, 255, 0)
			end
		end
	end,
	mysql:getConnection(), "SELECT `charactername`, `cked`, `faction_id`, `lastlogin`, `creationdate`, `hoursplayed`, `active` FROM `characters` WHERE `account` = '" .. (id) .. "' ORDER BY `charactername` ASC" )
end

function findAltChars(thePlayer, commandName, ...)
	if exports["integration"]:isPlayerTrialAdmin( thePlayer ) or exports["integration"]:isPlayerSupporter( thePlayer ) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local creation = commandName == "findalts2"
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = targetPlayerName == "*" and thePlayer or exports["global"]:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer or getElementData( targetPlayer, "loggedin" ) ~= 1 then
				-- select by character name
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local id = tonumber( row["account"] ) or 0
							showAlts( thePlayer, id, creation )
							return
						end
					end
				end,
				mysql:getConnection(), "SELECT account FROM characters WHERE charactername = '" .. (targetPlayerName ) .. "'")

				targetPlayerName = table.concat({...}, " ")
				
				-- select by account name
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local id = tonumber( row["id"] ) or 0
							showAlts( thePlayer, id, creation )
							return
						end
					else
						--outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
					end
				end,
				mysql:getConnection(), "SELECT id FROM accounts WHERE username = '" .. ( targetPlayerName ) .. "'")

			else
				local id = getElementData( targetPlayer, "account:id" )
				if id then
					showAlts( thePlayer, id, creation )
				else
					outputChatBox("Game Account is unknown.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler( "findalts", findAltChars )
addCommandHandler( "findalts2", findAltChars )
-- END FINDALTS --

-- START FINDSERIAL --
local function showSerialAlts(thePlayer, serial)
	local count = 0
	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if not row then break end
				count = count + 1
				if (count == 1) then
					outputChatBox( " Serial: " .. serial, thePlayer)
				end
				local text = "#" .. count .. ": " .. row["username"]
				if tonumber( row["appstate"] ) < 3 then
					text = text .. " (Application not passed)"
				end
			
				outputChatBox( text, thePlayer)
			end
		end
	end,
	mysql:getConnection(), "SELECT `username`, `lastlogin`, `appstate` FROM `accounts` WHERE mtaserial = '" .. (serial) .. "'")
end

function findAltAccSerial(thePlayer, commandName, ...)
	if exports["integration"]:isPlayerTrialAdmin( thePlayer ) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Nick/Serial]", thePlayer, 255, 194, 14)
		else
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = exports["global"]:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer then --or getElementData( targetPlayer, "loggedin" ) ~= 1 then
				
				
				-- select by charactername
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local serial = row["mtaserial"] or 'UnknownSerial'
							showSerialAlts( thePlayer, serial )
							return
						end
					end
				end,
				mysql:getConnection(), "SELECT a.`mtaserial` FROM `characters` c LEFT JOIN `accounts` a on c.`account`=a.`id` WHERE c.`charactername` = '" .. (targetPlayerName ) .. "'")

				targetPlayerName = table.concat({...}, " ")
				
				-- select by accountname
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local serial = row["mtaserial"] or 'UnknownSerial'
							showSerialAlts( thePlayer, serial)
							return
						end
					end
				end,
				mysql:getConnection(), "SELECT `mtaserial` FROM `accounts` WHERE `username` = '" .. (targetPlayerName ) .. "'")
				
				-- select by ip
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local serial = row["mtaserial"] or 'UnknownSerial'
							showSerialAlts( thePlayer, serial )
							return
						end
					end
				end,
				mysql:getConnection(), "SELECT `mtaserial` FROM `accounts` WHERE `ip` = '" .. ( targetPlayerName ) .. "'")
				
				-- select by serial
				dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local serial = row["mtaserial"] or 'UnknownSerial'
							showSerialAlts( thePlayer, serial )
							return
						end
					else
						--outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
					end
				end,
				mysql:getConnection(), "SELECT `mtaserial` FROM `accounts` WHERE `mtaserial` = '" .. ( targetPlayerName ) .. "'")
			else -- select by online player
				showSerialAlts( thePlayer, getPlayerSerial(targetPlayer) )
			end
		end
	end
end
addCommandHandler( "findserial", findAltAccSerial )
-- END FINDSERIAL --