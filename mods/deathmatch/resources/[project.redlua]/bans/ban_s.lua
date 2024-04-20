local mysql = exports["mysql"]
local lastBan = nil
local lastBanTimer = nil
local bansFetch = {}

function banAPlayer(thePlayer, commandName, targetPlayer, hours, ...)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) or not (hours) or not tonumber(hours) or tonumber(hours)<0 or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Time in Hours, 0 = Infinite] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
			local targetPlayerSerial = getPlayerSerial(targetPlayer)
			local targetPlayerIP = getPlayerIP(targetPlayer)
			hours = tonumber(hours)

			if not (targetPlayer) then
			elseif (hours>168) then
				outputChatBox("You cannot ban for more than 7 days (168 Hours).", thePlayer, 255, 194, 14)
			else
				local thePlayerPower = exports["global"]:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports["global"]:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")

				if (targetPlayerPower <= thePlayerPower) then -- Check the admin isn't banning someone higher rank them him
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					local accountID = getElementData(targetPlayer, "account:id")
					local username = getElementData(targetPlayer, "account:username") or "N/A"

					local seconds = ((hours*60)*60)
					local rhours = hours
					-- text value
					if (hours==0) then
						hours = "Permanent"
					elseif (hours==1) then
						hours = "1 Hour"
					else
						hours = hours .. " Hours"
					end

					if hours == "Permanent" then
						reason = reason .. " (" .. hours .. ")"
					else
						reason = reason .. " (" .. hours .. ")"
					end

					
					exports['admin']:addAdminHistory(targetPlayer, thePlayer, reason, 2 , rhours)
					local banId = nil
					if (seconds == 0) then
						banId = addToBan(accountID, targetPlayerSerial, targetPlayerIP, getElementData(thePlayer, "account:id"), reason)
					else
						addBan(nil, nil, targetPlayerSerial, thePlayer, reason, seconds)
					end

					local adminUsername = getElementData(thePlayer, "account:username")
					local adminUserID = getElementData(thePlayer, "account:id")
					local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == targetPlayerSerial then
							kickPlayer(value, thePlayer, reason)
						end
					end

					if (hiddenAdmin==1) then
						adminTitle = "A hidden admin"
					end

					if string.lower(commandName) == "sban" then
						exports["global"]:sendMessageToAdmins("[SILENT-BAN] " .. adminTitle .. " silently banned " .. targetPlayerName .. ". (" .. hours .. ")")
						exports["global"]:sendMessageToAdmins("[SILENT-BAN] Reason: " .. reason .. ".")
					elseif string.lower(commandName) == "forceapp" then
						outputChatBox("[FA] "..adminTitle .. " " .. playerName .. " forced app " .. targetPlayerName .. ".", root, 255,0,0)
						hours = "Permanent"
						reason = "Failure to meet server standard. Please improve yourself then appeal on forums.owlgaming.net"
						outputChatBox("[FA]: Reason: " .. reason .. "." ,root, 255,0,0)
					else
						outputChatBox("[BAN] " .. adminTitle .. " banned " .. targetPlayerName .. ". (" .. hours .. ")", root, 255,0,0)
						outputChatBox("[BAN] Reason: " .. reason .. ".", root, 255,0,0)
					end
					exports["global"]:sendMessageToAdmins("/showban for details.")
				else
					outputChatBox(" This player is a higher level admin than you.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " attempted to execute the ban command on you.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pban", banAPlayer, false, false)
addCommandHandler("sban", banAPlayer, false, false)

--OFFLINE BAN BY MAXIME
function offlineBanAPlayer(thePlayer, commandName, targetUsername, hours, ...)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		if not (targetUsername) or not (hours) or not tonumber(hours) or (tonumber(hours)<0) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Username] [Time in Hours, 0 = Infinite] [Reason]", thePlayer, 255, 194, 14)
		else
			hours = tonumber(hours) or 0
			if (hours>168) then
				outputChatBox("You cannot ban for more than 7 days (168 Hours).", thePlayer, 255, 194, 14)
				return false
			end
			local accounts, characters = exports["account"]:getTableInformations()
			for index, value in ipairs(accounts) do
				if value.username == targetUsername then
					user = accounts[index]
				end
			end
			if user and user['id'] and tonumber(user['id']) then
				targetUsername = user['username']
				for index, value in ipairs(bansFetch) do
					if value.id == user['id'] then
						ban = bansFetch[index]
					else
						outputChatBox("Could not fetch a database settings, try again.", thePlayer, 255, 0, 0)
						return false
					end
				end
				if ban and ban['id'] and tonumber(ban['id']) then
					printBanInfo(thePlayer, ban)
					return false
				end

				local thePlayerPower = exports["global"]:getPlayerAdminLevel(thePlayer)
				local adminTitle = exports["global"]:getAdminTitle1(thePlayer)
				local adminUsername = getElementData(thePlayer, "account:username" )
				if (tonumber(user['admin']) > thePlayerPower) then
					outputChatBox(" '"..targetUsername.."' is a higher level admin than you.", thePlayer, 255, 0, 0)
					exports["global"]:sendMessageToAdmins("AdmWrn: "..adminTitle.." attempted to execute the ban command on higher admin '"..targetUsername.."'.")
					return false
				end

				--check online players
				for i, player in pairs(getElementsByType("player")) do
					if getElementData(player, "account:id") == tonumber(user['id'])  then
						local cmd = "pban"
						if string.lower(commandName) == "soban" then
							cmd = "sban"
						end
						banAPlayer(thePlayer, cmd, getElementData(player, "playerid"), hours, (...))
						return true
					end
				end

				local reason = table.concat({...}, " ")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local playerName = getPlayerName(thePlayer)

				local seconds = ((hours*60)*60)
				local rhours = hours
				-- text value
				if (hours==0) then
					hours = "Permanent"
				elseif (hours==1) then
					hours = "1 Hour"
				else
					hours = hours .. " Hours"
				end
				reason = reason .. " (" .. hours .. ")"
				exports['admin']:addAdminHistory(user['id'], thePlayer, reason, 2, rhours)

				local targetSerial = nil
				if user['mtaserial'] ~= "NULL" then
					targetSerial = user['mtaserial']
				end
				local banId = nil
				
				if targetSerial then
					addBan(nil, nil, targetSerial, thePlayer, reason, seconds)
				end
				local adminUsername = getElementData(thePlayer, "account:username")
				local adminUserID = getElementData(thePlayer, "account:id")
				adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
				if targetSerial then
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == targetSerial then
							kickPlayer(value, thePlayer, reason)
						end
					end
				end

				if (hiddenAdmin==1) then
					adminTitle = "A hidden admin"
				end
				if string.lower(commandName) == "soban" then
					exports["global"]:sendMessageToAdmins("[OFFLINE-BAN]: " .. adminTitle .. " " .. adminUsername .. " silently banned " .. targetUsername .. ". (" .. hours .. ")")
					exports["global"]:sendMessageToAdmins("[OFFLINE-BAN]: Reason: " .. reason .. ".")
				else
					outputChatBox("[OFFLINE-BAN]: " .. adminTitle .. " " .. adminUsername .. " banned " .. targetUsername .. ". (" .. hours .. ")", getRootElement(), 255, 0, 51)
					outputChatBox("[OFFLINE-BAN]: Reason: " .. reason .. ".", getRootElement(), 255, 0, 51)
				end

				exports["global"]:sendMessageToAdmins("/showban for details.")
			else
				outputChatBox("Player Username not found!", thePlayer, 255, 194, 14)
				return false
			end
		end
	end
end
addCommandHandler("oban", offlineBanAPlayer, false, false)
addCommandHandler("soban", offlineBanAPlayer, false, false)

function banPlayerSerial(thePlayer, commandName, serial, ...)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) then
		if not serial or not string.len(serial) or not string.len(serial) == 32 or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Serial Number] [Reason]", thePlayer, 255, 194, 14)
		else

			local reason = table.concat({...}, " ")
			serial = string.upper(serial)
			local id = addToBan(nil, serial, nil, getElementData(thePlayer,"account:id"), reason)
			if id and tonumber(id) then
				for index, value in ipairs(bansFetch) do
					if value.id == id then
						ban = bansFetch[index]
					else
						outputChatBox("Could not fetch a database settings, try again.", thePlayer, 255, 0, 0)
						return false
					end
				end
				if ban and tonumber(ban['id']) then
					lastBan = ban
					if lastBanTimer and isTimer(lastBanTimer) then
						killTimer(lastBanTimer)
						lastBanTimer = nil
					end
					lastBanTimer = setTimer(function()
						lastBan = nil
					end, 1000*60*5,1) --5 minutes
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == serial then
							kickPlayer(value, thePlayer, reason)
						end
					end
					exports["global"]:sendMessageToAdmins("[BAN] "..exports["global"]:getPlayerFullIdentity(thePlayer).." has banned serial number '"..serial.."' permanently for '"..reason.."'. /showban for details.")
				end
			else

			end
		end
	end
end
addCommandHandler("banserial", banPlayerSerial, false, false)
addCommandHandler("serialban", banPlayerSerial, false, false)

function banPlayerIP(thePlayer, commandName, ip, ...)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) then
		if not ip or not string.len(ip) or string.len(ip) > 15 or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [IP Address] [Reason]", thePlayer, 255, 194, 14)
			outputChatBox("You can use * for IP range ban. For example: 192.168.*.*", thePlayer, 255, 194, 14)
		else
			local reason = table.concat({...}, " ")
			local id = addToBan(nil, nil, ip, getElementData(thePlayer,"account:id"), reason)
			if id and tonumber(id) then
				for index, value in ipairs(bansFetch) do
					if value.id == id then
						ban = bansFetch[index]
					else
						outputChatBox("Could not fetch a database settings, try again.", thePlayer, 255, 0, 0)
						return false
					end
				end
				if ban and tonumber(ban['id']) then
					lastBan = ban
					if lastBanTimer and isTimer(lastBanTimer) then
						killTimer(lastBanTimer)
						lastBanTimer = nil
					end
					lastBanTimer = setTimer(function()
						lastBan = nil
					end, 1000*60*5,1) --5 minutes
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerIP(value) == ip then
							kickPlayer(value, thePlayer, reason)
						end
					end
					exports["global"]:sendMessageToAdmins("[BAN] "..exports["global"]:getPlayerFullIdentity(thePlayer).." has banned IP Address '"..ip.."' permanently for '"..reason.."'. /showban for details.")
				end
			end
		end
	end
end
addCommandHandler("ipban", banPlayerIP, false, false)
addCommandHandler("banip", banPlayerIP, false, false)

function banPlayerAccount(thePlayer, commandName, account, ...)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) then
		if not account or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Username] [Reason]", thePlayer, 255, 194, 14)
		else
			local accounts, characters = exports["account"]:getTableInformations()
			for index, value in ipairs(accounts) do
				if value.username == account then
					account = accounts[index]
				end
			end
			if not account or account.id == "NULL" then
				outputChatBox("Account '"..account.."' does not existed.", thePlayer, 255, 0, 0)
				return false
			end
			local reason = table.concat({...}, " ")
			local id = addToBan(account.id, nil, nil, getElementData(thePlayer,"account:id"), reason)
			if id and tonumber(id) then
				for index, value in ipairs(bansFetch) do
					if value.id == id then
						ban = bansFetch[index]
					else
						outputChatBox("Could not fetch a database settings, try again.", thePlayer, 255, 0, 0)
						return false
					end
				end
				if ban and tonumber(ban['id']) then
					lastBan = ban
					if lastBanTimer and isTimer(lastBanTimer) then
						killTimer(lastBanTimer)
						lastBanTimer = nil
					end
					lastBanTimer = setTimer(function()
						lastBan = nil
					end, 1000*60*5,1) --5 minutes
					for key, value in ipairs(getElementsByType("player")) do
						if getElementData(value, "account:id") == tonumber(account.id) then
							kickPlayer(value, thePlayer, reason)
						end
					end
					exports["global"]:sendMessageToAdmins("[BAN] "..exports["global"]:getPlayerFullIdentity(thePlayer).." has banned account '"..(account.username).."' permanently for '"..reason.."'. /showban for details.")
				end
			end
		end
	end
end
addCommandHandler("banaccount", banPlayerAccount, false, false)
addCommandHandler("accountban", banPlayerAccount, false, false)

-- /UNBAN
function unbanPlayer(thePlayer, commandName, id)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) then
		if not id or not tonumber(id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Ban ID]", thePlayer, 255, 194, 14)
			outputChatBox("/showban [Username or serial or IP] to retrieve ban ID.", thePlayer, 255, 194, 14)
		else
			if getElementData(thePlayer, "cmd:unban") ~= id then
				for index, value in ipairs(bansFetch) do
					if value.id == id then
						ban = bansFetch[index]
					else
						outputChatBox("Could not fetch a database settings, try again.", thePlayer, 255, 0, 0)
						return false
					end
				end
				if ban and ban['id'] and tonumber(ban['id']) then
					printBanInfo(thePlayer,ban)
					outputChatBox("You're about to remove this ban record. Please type /unban "..ban['id'].." once again to proceed.", thePlayer, 255, 194, 14)
					setElementData(thePlayer, "cmd:unban", ban['id'])
				end
			else
				for index, value in ipairs(bansFetch) do
					if value.id == id then
						ban = bansFetch[index]
					else
						outputChatBox("Could not fetch a database settings, try again.", thePlayer, 255, 0, 0)
						return false
					end
				end
				if ban and ban['id'] and tonumber(ban['id']) then
					lastBan = ban
					if lastBanTimer and isTimer(lastBanTimer) then
						killTimer(lastBanTimer)
						lastBanTimer = nil
					end
					lastBanTimer = setTimer(function()
						lastBan = nil
					end, 1000*60*5,1) --5 minutes
					if dbExec(mysql:getConnection(), "DELETE FROM bans WHERE id='"..id.."'") then
						for _, banElement in ipairs(getBans()) do
							if getBanSerial(banElement) == ban['serial'] or getBanIP(banElement) == ban['ip'] then
								removeBan(banElement)
								break
							end
						end
						for index, value in ipairs(bansFetch) do
							if value.id == id then
								bansFetch[index] = nil
							end
						end
						if ban['account'] ~="NULL" then
							exports['admin']:addAdminHistory(ban['account'], thePlayer, "UNBAN", 2 , 0)
						end
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						exports["global"]:sendMessageToAdmins("[UNBAN] "..exports["global"]:getPlayerFullIdentity(thePlayer).." has removed ban record #"..ban['id']..". /showban for details.")
					end
				else
					outputChatBox("Opps, sorry that ban must have been lifted.", thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("unban", unbanPlayer, false, false)

addEventHandler("onPlayerJoin", getRootElement(),
	function()
		local playerNick = getPlayerName(source)
		local playerIP = getPlayerIP(source)
		local playerSerial = getPlayerSerial(source)
		dbQuery(
			function(qh, player)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, result in ipairs(res) do
						local banText = "Sunucudan yasaklandınız."
						if result['serial'] == playerSerial then
						 	banText = "MTA serialiniz sunucudan yasaklandığı için sunucuya erişemezsiniz."
						 	bannedSerial = playerSerial
						end
						if result['ip'] == playerIP then
							bannedIp = playerIP
							banText = "IP adresiniz sunucudan yasaklandığı için sunucuya erişemezsiniz."
						end
						kickPlayer(player, banText)
						exports["global"]:sendMessageToAdmins("[BAN] Sunucuya yasaklı bir kişi ("..(bannedSerial and (" serial: '"..tostring(bannedSerial).."'") or "" ).." "..(bannedIp and (" IP: '"..tostring(bannedIp).."'") or "")..") sunucuya bağlanmaya çalıştı. /showban ile detayları öğrenin.")
					end
				end
			end,
		{source}, mysql:getConnection(), "SELECT * FROM bans WHERE serial='"..playerSerial.."' OR ip='"..playerIP.."' LIMIT 1")
	end
)
addEventHandler("onResourceStart", resourceRoot,
	function()
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						table_row = {}
						for count, data in pairs(value) do
							table_row[count] = data
						end
						bansFetch[#bansFetch + 1] = data
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM bans")
	end
)

function checkAccountBan(userid)
	for index, value in ipairs(bansFetch) do
		if value.account == userid then
			lastBan = bansFetch[index]
			if lastBanTimer and isTimer(lastBanTimer) then
				killTimer(lastBanTimer)
				lastBanTimer = nil
			end
			lastBanTimer = setTimer(function() lastBan = nil end, 1000*60*5,1) --5 minutes
			exports["global"]:sendMessageToAdmins("[BAN] Rejected connection from account "..exports["cache"]:getUsernameFromId(userid).." as account is banned. /showban for details.")
			return true
		end
	end
	return false
end

function showBanDetails(thePlayer, commandName, clue)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		if clue then
			local bans = {}
			dbQuery(
				function(qh, thePlayer, clue)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, value in ipairs(res) do
							table.insert(bans, value)
						end
						for i = 1, #bans do
							local result = bans[i]
							if result and result['id'] and tonumber(result['id']) then
								printBanInfo(thePlayer, result)
							else
								outputChatBox("Sorry, the ban you're looking for must have been lifted.", thePlayer, 255, 194, 14)
							end
						end
					else
						outputChatBox("There is no ban records with serial or IP or account name matched the keyword '"..clue.."'.", thePlayer, 255, 194, 14)
					end
				end,
			{thePlayer, clue}, mysql:getConnection(),"SELECT * FROM bans WHERE id='"..clue.."' OR serial='"..clue.."' OR ip='"..clue.."' OR account=(SELECT a.id FROM accounts a WHERE a.username='"..clue.."')  ORDER BY date DESC")
		elseif lastBan then
			printBanInfo(thePlayer, lastBan)
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [Serial or IP or Username]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("showban", showBanDetails, false, false)
addCommandHandler("findban", showBanDetails, false, false)

function printBanInfo(thePlayer, result)
	outputChatBox("===========BAN RECORD #"..result['id'].."============", thePlayer, 255, 194, 14)

	local bannedAccount = exports["cache"]:getUsernameFromId(result['account'])
	outputChatBox("Account: "..(bannedAccount and bannedAccount or "N/A"), thePlayer, 255, 194, 14)

	local bannedSerial = nil
	if result['serial'] ~= "NULL" then
		bannedSerial = result['serial']
	end
	outputChatBox("Serial: "..(bannedSerial and bannedSerial or "N/A"), thePlayer, 255, 194, 14)

	local bannedIp = nil
	if result['ip'] ~= "NULL" then
		bannedIp = result['ip']
	end
	outputChatBox("IP: "..(bannedIp and bannedIp or "N/A"), thePlayer, 255, 194, 14)

	local banningAdmin = exports["cache"]:getUsernameFromId(result['admin'])
	outputChatBox("Banned by admin: "..(banningAdmin and banningAdmin or "N/A"), thePlayer, 255, 194, 14)

	local bannedDate = nil
	if result['date'] ~= "NULL" then
		bannedDate = result['date']
	end
	outputChatBox("Banned Date: "..(bannedDate and bannedDate or "N/A"), thePlayer, 255, 194, 14)
	local bannedReason = nil
	if result['reason'] ~= "NULL" then
		bannedReason = result['reason']
	end
	outputChatBox("Reason: "..(bannedReason and bannedReason or "N/A"), thePlayer, 255, 194, 14)
	local banThread = nil
end

function addToBan(account, serial, ip, admin, reason)
	local tail = ''
	if serial then
		tail = tail..", serial='"..serial.."'"
	end
	if ip then
		tail = tail..", ip='"..ip.."'"
	end
	if admin and tonumber(admin) then
		tail = tail..", admin='"..admin.."'"
	end
	if reason then
		tail = tail..", reason='"..(reason).."'"
	else
		tail = tail..", reason='"..("N/A").."'"
	end
	if account and tonumber(account) then
		tail = tail..", account='"..account.."'"
	end
	dbExec(mysql:getConnection(), "INSERT INTO bans SET date=NOW() "..tail)
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					table_row = {}
					for count, data in pairs(value) do
						table_row[count] = data
					end
					bansFetch[#bansFetch + 1] = data
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM bans WHERE id = LAST_INSERT_ID()")
	return true
end
