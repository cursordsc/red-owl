
-- // ADMIN COMMANDS

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM factions AS e1 LEFT JOIN factions AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end


function createFaction(thePlayer, commandName, factionType, ...)
	if exports["integration"]:isPlayerDeveloper(thePlayer) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Faction Type 0=GANG, 1=MAFIA, 2=LAW, 3=GOV, 4=MED, 5=OTHER, 6=NEWS, 7=MECHANIC] [Faction Name]", thePlayer, 255, 194, 14)
		else
			factionName = table.concat({...}, " ")
			factionType = tonumber(factionType)
			
			local theTeam = createTeam(tostring(factionName))
			if theTeam then
				if dbExec(mysql:getConnection(),"INSERT INTO factions SET name='" .. (factionName) .. "', bankbalance='0', type='" .. (factionType) .. "'") then
					local id = SmallestID()
					exports["pool"]:allocateElement(theTeam, id)
					
					dbExec(mysql:getConnection(),"UPDATE factions SET rank_1='Dynamic Rank #1', rank_2='Dynamic Rank #2', rank_3='Dynamic Rank #3', rank_4='Dynamic Rank #4', rank_5='Dynamic Rank #5', rank_6='Dynamic Rank #6', rank_7='Dynamic Rank #7', rank_8='Dynamic Rank #8', rank_9='Dynamic Rank #9', rank_10='Dynamic Rank #10', rank_11='Dynamic Rank #11', rank_12='Dynamic Rank #12', rank_13='Dynamic Rank #13', rank_14='Dynamic Rank #14', rank_15='Dynamic Rank #15', rank_16='Dynamic Rank #16', rank_17='Dynamic Rank #17', rank_18='Dynamic Rank #18', rank_19='Dynamic Rank #19', rank_20='Dynamic Rank #20',  motd='Welcome to the faction.', note = '' WHERE id='" .. id .. "'")
					setElementData(theTeam, "type", tonumber(factionType))
					setElementData(theTeam, "id", tonumber(id))
					setElementData(theTeam, "money", 0)
					
					local factionRanks = {}
					local factionWages = {}
					for i = 1, 20 do
						factionRanks[i] = "Dynamic Rank #" .. i
						factionWages[i] = 100
					end
					setElementData(theTeam, "ranks", factionRanks, false)
					setElementData(theTeam, "wages", factionWages, false)
					setElementData(theTeam, "motd", "Welcome to the faction.", false)
					setElementData(theTeam, "note", "", false)
					exports["logs"]:dbLog(thePlayer, 4, theTeam, "MAKE FACTION")
					table.insert(dutyAllow, { id, factionName, { --[[Duty information]] } })
					outputChatBox("Faction " .. factionName .. " created with ID #" .. id .. ".", thePlayer, 0, 255, 0)
				else
					destroyElement(theTeam)
					outputChatBox("Error creating faction.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Faction '" .. tostring(factionName) .. "' already exists.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("maketextfaction", createFaction, false, false)



function adminRenameFaction(thePlayer, commandName, factionID, ...)
	if (exports["integration"]:isPlayerLeadAdmin(thePlayer))  then
		if not (factionID) or not (...)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Faction ID] [Faction Name]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports["pool"]:getElement("team", factionID)
				if (theTeam) then
					local factionName = table.concat({...}, " ")
					dbExec(mysql:getConnection(),"UPDATE factions SET name='" .. (factionName) .. "' WHERE id='" .. factionID .. "'")
					local oldName = getTeamName(theTeam)
					setTeamName(theTeam, factionName)
					
					exports["global"]:sendMessageToAdmins(exports["global"]:getPlayerFullIdentity(thePlayer).." renamed faction '" .. oldName .. "' to '" .. factionName .. "'.")
					--exports["factions"]:sendNotiToAllFactionMembers(factionID, "Your faction '"..oldName.."' was renamed to '"..factionName.."' by "..exports["global"]:getPlayerFullIdentity(thePlayer,1,true))
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("renamefaction", adminRenameFaction, false, false)

function adminSetPlayerFaction(thePlayer, commandName, partialNick, factionID)
	if exports["integration"]:isPlayerSeniorAdmin(thePlayer) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Name/ID] [Faction ID (-1 for none)]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerNick = exports["global"]:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports["pool"]:getElement("team", factionID)
				if not theTeam and factionID ~= -1 then
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if dbExec(mysql:getConnection(),"UPDATE characters SET faction_leader = 0, faction_id = " .. factionID .. ", faction_rank = 1, faction_phone = NULL, duty = 0 WHERE id=" .. getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					if factionID > 0 then
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "faction", factionID, true)
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, true)
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionphone", nil, true)
						--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, factionID, 1)
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionleader", 0, true)
						triggerEvent("duty:offduty", targetPlayer)
						
						outputChatBox("Player " .. targetPlayerNick .. " is now a member of faction '" .. getTeamName(theTeam) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
						triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
						outputChatBox("You were set to Faction '" .. getTeamName(theTeam) .. "'.", targetPlayer, 255, 194, 14)
						
						exports["logs"]:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION")
					else
						-- Citizen bug fix by Anthony
						local citizenTeam = getTeamFromName("Citizen")
						setPlayerTeam(targetPlayer, citizenTeam)
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "faction", -1, true)
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, true)
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionphone", nil, true)
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionleader", 0, true)
						--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, -1, 1)
						if getElementData(targetPlayer, "duty") and getElementData(targetPlayer, "duty") > 0 then
							takeAllWeapons(targetPlayer)
							exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "duty", 0, true)
						end
						
						outputChatBox("Player " .. targetPlayerNick .. " was set to no faction.", thePlayer, 0, 255, 0)
						outputChatBox("You were removed from your faction.", targetPlayer, 255, 0, 0)
						
						exports["logs"]:dbLog(thePlayer, 4, { targetPlayer }, "REMOVE FROM FACTION")
					end
				end
			end
		end
	end
end
addCommandHandler("setfaction", adminSetPlayerFaction, false, false)

function adminSetFactionLeader(thePlayer, commandName, partialNick, factionID)
	if exports["integration"]:isPlayerLeadAdmin(thePlayer)  then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Name] [Faction ID]", thePlayer, 255, 194, 14)
		elseif factionID > 0 then
			local targetPlayer, targetPlayerNick = exports["global"]:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports["pool"]:getElement("team", factionID)
				if not theTeam then
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if dbExec(mysql:getConnection(),"UPDATE characters SET faction_leader = 1, faction_id = " .. tonumber(factionID) .. ", faction_rank = 1, faction_phone = NULL, duty = 0 WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "faction", factionID, true)
					exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, true)
					exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionleader", 1, true)
					exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionphone", nil, true)
					--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, factionID, 1)
					triggerEvent("duty:offduty", targetPlayer)
					
					outputChatBox("#575757RED:LUA Scripting: #f4f4f4Oyuncu " .. targetPlayerNick .. " isimli birlik lideri sizi birliğine ekledi '" .. getTeamName(theTeam) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0, true)
						
					triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
					outputChatBox("#575757RED:LUA Scripting: #f4f4f4İhtilaf liderine atandın '" .. getTeamName(theTeam) .. "'.", targetPlayer, 255, 194, 14, true)
					
					exports["logs"]:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION LEADER")
					--exports["factions"]:sendNotiToAllFactionMembers(factionID, targetPlayerNick .. " is now a leader of your faction '" .. getTeamName(theTeam) .. "'!", "Set by "..exports["global"]:getPlayerFullIdentity(thePlayer))
				else
					outputChatBox("#575757RED:LUA Scripting: #f4f4f4Geçersiz İhtilaf Kimliği.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("setfactionleader", adminSetFactionLeader, false, false)

function adminSetFactionRank(thePlayer, commandName, partialNick, factionRank)
	if (exports["integration"]:isPlayerLeadAdmin(thePlayer))   then
		factionRank = math.ceil(tonumber(factionRank) or -1)
		if not (partialNick) or not (factionRank)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Name] [Faction Rank, 1-20]", thePlayer, 255, 194, 14)
		elseif factionRank >= 1 and factionRank <= 20 then
			local targetPlayer, targetPlayerNick = exports["global"]:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = getPlayerTeam(targetPlayer)
				if not theTeam or getTeamName( theTeam ) == "Citizen" then
					outputChatBox("Player is not in a faction.", thePlayer, 255, 0, 0)
					return
				end
				
				if dbExec(mysql:getConnection(),"UPDATE characters SET faction_rank = " .. factionRank .. " WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "factionrank", factionRank, true)
					
					outputChatBox("Player " .. targetPlayerNick .. " is now rank " .. factionRank .. ".", thePlayer, 0, 255, 0)
					outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_"," ") .. " set you to rank " .. factionRank .. ".", targetPlayer, 0, 255, 0)
					
					exports["logs"]:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION RANK " .. factionRank)
				else
					outputChatBox("Error #125151 - Report on Mantis.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox( "Invalid Rank - valid ones are 1 to 20", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler("setfactionrank", adminSetFactionRank, false, false)

function adminDeleteFaction(thePlayer, commandName, factionID)
	if (exports["integration"]:isPlayerLeadAdmin(thePlayer))  then
		if not (factionID)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports["pool"]:getElement("team", factionID)
				
				if (theTeam) then
					
					dbExec(mysql:getConnection(),"DELETE FROM factions WHERE id='" .. factionID .. "'")
					
					outputChatBox("Faction #" .. factionID .. " was deleted.", thePlayer, 0, 255, 0)
					exports["logs"]:dbLog(thePlayer, 4, theTeam, "DELETE FACTION")
					local civTeam = getTeamFromName("Citizen")
					for key, value in pairs( getPlayersInTeam( theTeam ) ) do
						setPlayerTeam( value, civTeam )
						exports["anticheat"]:changeProtectedElementDataEx( value, "faction", -1, true )
					end
					destroyElement( theTeam )
				
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delfaction", adminDeleteFaction, false, false)

function adminShowFactions(thePlayer)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer) or exports["integration"]:isPlayerScripter(thePlayer))  then
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					local factions = {}
					for i, row in ipairs(res) do
						table.insert( factions, { row.id, row.name, row.type, ( getTeamFromName( row.name ) and #getPlayersInTeam( getTeamFromName( row.name ) ) or "?" ) .. " / " .. row.members } )
				
					end
					triggerClientEvent(thePlayer, "showFactionList", getRootElement(), factions)
				end
			end,
		mysql:getConnection(), "SELECT id, name, type, (SELECT COUNT(*) FROM characters c WHERE c.faction_id = f.id) AS members FROM factions f ORDER BY id ASC")
		
	end
end
addCommandHandler("showfactions", adminShowFactions, false, false)

function adminShowFactionOnlinePlayers(thePlayer, commandName, factionID)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer))  then
		if not (factionID)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports["pool"]:getElement("team", factionID)
				local theTeamName = getTeamName(theTeam)
				local teamPlayers = getPlayersInTeam(theTeam)
				
				if #teamPlayers == 0 then
					outputChatBox("There are no players online in faction '".. theTeamName .."'", thePlayer, 255, 194, 14)
				else
					local teamRanks = getElementData(theTeam, "ranks")
					outputChatBox("Players online in faction '".. theTeamName .."':", thePlayer, 255, 194, 14)
					for k, teamPlayer in ipairs(teamPlayers) do
						local leader = ""
						local playerRank = teamRanks [ getElementData(teamPlayer, "factionrank") ]
						if (getElementData(teamPlayer, "factionleader") == 1) then
							leader = "LEADER "
						end
						outputChatBox("  "..leader.." ".. getPlayerName(teamPlayer) .." - "..playerRank, thePlayer, 255, 194, 14)
					end
				end
			else
				outputChatBox("Faction not found.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("showfactionplayers", adminShowFactionOnlinePlayers, false, false)

function callbackAdminPlayersFaction(teamID)
	adminShowFactionOnlinePlayers(client, "showfactionplayers", teamID)
end
addEvent("faction:admin:showplayers", true )
addEventHandler("faction:admin:showplayers", getRootElement(), callbackAdminPlayersFaction)

addEvent('faction:admin:showf3', true)
addEventHandler('faction:admin:showf3', root,
	function(id, fromF3)
		if exports["integration"]:isPlayerTrialAdmin(client) --[[or exports["integration"]:isPlayerSupporter(client)]] then
			showFactionMenuEx(client, id, fromF3)
		end
	end)

function setFactionMoney(thePlayer, commandName, factionID, amount)
	if (exports["integration"]:isPlayerLeadAdmin(thePlayer)) then
		if not (factionID) or not (amount)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports["pool"]:getElement("team", factionID)
				amount = tonumber(amount) or 0
				if amount and amount > 500000*2 then
					outputChatBox("For security reason, you're not allowed to set more than $1,000,000 at once to a faction.", thePlayer, 255, 0, 0)
					return false
				end
				
				if (theTeam) then
					if exports["global"]:setMoney(theTeam, amount) then
						outputChatBox("Set faction '" .. getTeamName(theTeam) .. "'s money to " .. amount .. " $.", thePlayer, 255, 194, 14)
					--	exports["factions"]:sendNotiToAllFactionMembers(factionID, exports["global"]:getPlayerFullIdentity(thePlayer, 1).." has set your faction bank to $"..exports["global"]:formatMoney(amount)..".", nil, true)
					else
						outputChatBox("Could not set money to that faction.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setfactionmoney", setFactionMoney, false, false)


-----

function loadWelfare()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				unemployedPay = res[1].value
			end
		end,
	mysql:getConnection(), "SELECT value FROM settings WHERE name = 'welfare'")
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		loadWelfare()
	end
)


function getTax(thePlayer)
	loadWelfare( )
	outputChatBox( "Welfare: $" .. exports["global"]:formatMoney(unemployedPay), thePlayer, 255, 194, 14 )
	outputChatBox( "Tax: " .. ( exports["global"]:getTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
	outputChatBox( "Income Tax: " .. ( exports["global"]:getIncomeTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
end
addCommandHandler("gettax", getTax, false, false)

function setFactionBudget(thePlayer, commandName, factionID, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos Government") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not factionID or not amount or amount < 0 then
			outputChatBox("KULLANIM: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports["pool"]:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					if getElementData(theTeam, "type") >= 2 and getElementData(theTeam, "type") <= 6 then
						if exports["global"]:takeMoney(getPlayerTeam(thePlayer), amount) then
							exports["global"]:giveMoney(theTeam, amount)
							outputChatBox("You added $" .. exports["global"]:formatMoney(amount) .. " to the budget of '" .. getTeamName(theTeam) .. "' (Total: " .. exports["global"]:getMoney(theTeam) .. ").", thePlayer, 255, 194, 14)
							dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. -getElementData(getPlayerTeam(thePlayer), "id") .. ", " .. -getElementData(theTeam, "id") .. ", " .. amount .. ", '', 8)" )
						else
							outputChatBox("You can't afford this.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("You can't set a budget for that faction.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setbudget", setFactionBudget, false, false)

function setTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos Government") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 30 then
			outputChatBox("KULLANIM: /" .. commandName .. " [0-30%]", thePlayer, 255, 194, 14)
		else
			exports["global"]:setTaxAmount(amount)
			outputChatBox("New Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("settax", setTax, false, false)

function setIncomeTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos Government") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 25 then
			outputChatBox("KULLANIM: /" .. commandName .. " [0-25%]", thePlayer, 255, 194, 14)
		else
			exports["global"]:setIncomeTaxAmount(amount)
			outputChatBox("New Income Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("setincometax", setIncomeTax, false, false)

function setWelfare(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos Government") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount <= 0 then
			outputChatBox("KULLANIM: /" .. commandName .. " [Money]", thePlayer, 255, 194, 14)
		elseif dbExec(mysql:getConnection(), "UPDATE settings SET value = " .. unemployedPay .. " WHERE name = 'welfare'" ) then
			unemployedPay = amount
			outputChatBox("New Welfare is $" .. exports["global"]:formatMoney(unemployedPay) .. "/payday", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 129314 - Report on Mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setwelfare", setWelfare, false, false)

function issueGovLicense(thePlayer, commandName, type, ...)
	local licenseTypes = {"Business License - Regular", "Business License - Premium", "Adult Entertainment License", "Gambling License", "Liquor License"}
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos Government") and getElementData(thePlayer, "factionrank") >= 3 then
		local type = tonumber(type)
		if not type or not licenseTypes[type] or not ... then
			outputChatBox("KULLANIM: /" .. commandName .. " [type] [biz name]", thePlayer, 255, 194, 14)
			for k, v in ipairs(licenseTypes) do
			outputChatBox("  " .. k .. ": " .. v, thePlayer, 255, 194, 14)
			end
		else
			local text = licenseTypes[type] .. " - " .. table.concat({...}, " ")
			local success, error = exports["global"]:giveItem(thePlayer, 80, text)
			if success then
				outputChatBox("Created a " .. text .. ".", thePlayer, 0, 255, 0)
			else
				outputChatBox(error, thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("govlicense", issueGovLicense, false, false)

--

function respawnFactionVehicles(thePlayer, commandName, factionID)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) then
		local factionID = tonumber(factionID)
		if (factionID) and (factionID > 0) then
			local theTeam = exports["pool"]:getElement("team", factionID)
			if (theTeam) then
				for key, value in ipairs(exports["pool"]:getPoolElementsByType("vehicle")) do
					local faction = tonumber(getElementData(value, "faction"))
					if (faction == factionID and not getVehicleOccupant(value, 0) and not getVehicleOccupant(value, 1) and not getVehicleOccupant(value, 2) and not getVehicleOccupant(value, 3) and not getVehicleTowingVehicle(value)) then
						respawnVehicle(value)
						setElementInterior(value, getElementData(value, "interior"))
						setElementDimension(value, getElementData(value, "dimension"))
					end
				end
				
				local hiddenAdmin = tonumber(getElementData(thePlayer, "hiddenadmin"))
				local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				for k,v in ipairs(getPlayersInTeam(theTeam)) do
					outputChatBox((hiddenAdmin == 0 and adminTitle .. " " .. username or "Hidden Admin") .. " respawned all unoccupied faction vehicles.", v)
				end
				
				exports["global"]:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " respawned all unoccupied faction vehicles for faction ID " .. factionID .. ".")
				exports["logs"]:dbLog(thePlayer, 4, theTeam, "FACTION RESPAWN for " .. factionID)
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 0, 0, false)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14, false)
		end
	end
end
addCommandHandler("respawnfaction", respawnFactionVehicles, false, false)

function adminDutyStart()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				dbQuery(
					function(qh, res)
						local res2, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							dutyAllow = {}
							dutyAllowChanges = {}
							i = 0

							maxIndex = tonumber(res2[1].id) or 0
							for index, row in ipairs(res) do
								table.insert(dutyAllow, { row.id, row.name, { --[[Duty information]] } })
								i = i+1
								local res = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM duty_allowed WHERE faction="..tonumber(row.id)), -1)
								for index, row1 in ipairs(res) do
									table.insert(dutyAllow[i][3], { row1.id, tonumber(row1.itemID), row1.itemValue })
								end
								setElementData(resourceRoot, "maxIndex", maxIndex)
								setElementData(resourceRoot, "dutyAllowTable", dutyAllow)
								
							end
						end
					end,
				{res}, mysql:getConnection(), "SELECT id FROM duty_allowed ORDER BY id DESC LIMIT 0, 1")
			end
		end,
	mysql:getConnection(), "SELECT id, name FROM factions WHERE type >= 2 ORDER BY id ASC")
end
addEventHandler("onResourceStart", resourceRoot, adminDutyStart)

function getAllowList(factionID)
	local factionID = tonumber(factionID)
	if factionID then
		for k,v in pairs(dutyAllow) do
			if tonumber(v[1]) == factionID then
				key = k
				break
			end
		end
		return dutyAllow[key][3]
	end
end

function adminDuty(thePlayer)
	if exports["integration"]:isPlayerHeadAdmin(thePlayer) then
		if not getElementData(resourceRoot, "dutyadmin") and type(dutyAllow) == "table" then
			triggerClientEvent(thePlayer, "adminDutyAllow", resourceRoot, dutyAllow, dutyAllowChanges)
			setElementData( resourceRoot, "dutyadmin", true )
		elseif type(dutyAllow) ~= "table" then
			outputChatBox("There was a issue with the startup caching of this resource. Contact a Scripter.", thePlayer, 255, 0, 0)
		else
			outputChatBox("Oops! Someone is already editing duty permissions. Sorry!", thePlayer, 255, 0, 0) -- No time to set up proper syncing + kinda not needed.
		end
	end
end
addCommandHandler("dutyadmin", adminDuty, false, false)

function updateTable(newTable, changesTable)
	dutyAllow = newTable
	dutyAllowChanges = changesTable
	removeElementData(resourceRoot, "dutyadmin")
	setElementData(resourceRoot, "dutyAllowTable", dutyAllow)
end
addEvent("dutyAdmin:Save", true)
addEventHandler("dutyAdmin:Save", resourceRoot, updateTable)

function saveChanges()
	local tick = getTickCount()

	for key,value in pairs(dutyAllowChanges) do
		if value[2] == 0 then -- Delete row
			dbExec(mysql:getConnection(),"DELETE FROM duty_allowed WHERE id="..(tonumber(value[3])))
		elseif value[2] == 1 then
			dbExec(mysql:getConnection(),"INSERT INTO duty_allowed SET id="..(tonumber(value[3]))..", faction="..(tonumber(value[1]))..", itemID="..(tonumber(value[4]))..", itemValue='"..(value[5]).."'")
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, saveChanges)

function saveDutys()
	local tick = getTickCount()

	for key,value in pairs(dutyAllowChanges) do
		if value[2] == 0 then -- Delete row
			dbExec(mysql:getConnection(),"DELETE FROM duty_allowed WHERE id="..(tonumber(value[3])))
		elseif value[2] == 1 then
			dbExec(mysql:getConnection(),"INSERT INTO duty_allowed SET id="..(tonumber(value[3]))..", faction="..(tonumber(value[1]))..", itemID="..(tonumber(value[4]))..", itemValue='"..(value[5]).."'")
		end
	end
end
addCommandHandler("dutykaydet", saveDutys)


mysql = exports["mysql"]

function BirlikOnayVER(thePlayer, commandName, factionID, onay)
  if (exports["integration"]:isPlayerAdminII(thePlayer)) then
    if not (factionID) or not (onay)  then
    outputChatBox("#000fff[!]#ffffff /" .. commandName .. " [Faction ID] [1-0]", thePlayer, 255, 194, 14, true)
    outputChatBox("- 1 : Onayı Ver", thePlayer, 255, 194, 14)
    outputChatBox("- 0 : Onayı Al", thePlayer, 255, 194, 14)
  else 
  factionID = tonumber(factionID)  
      if factionID then      	
      local theTeam = exports["pool"]:getElement("team", factionID)  
      onay = tonumber(onay)
      if (theTeam) then
      setElementData(theTeam, "birlik_onay", onay)	
      dbExec(mysql:getConnection(), "UPDATE `factions` SET `BirlikOnayi`="..(onay).." WHERE `id`=" .. (factionID) )
    outputChatBox("[!]#ffffff ["..factionID.."] ID'li birliğin onay durumunu [" .. onay .. "] olarak seçtiniz.", thePlayer, 0, 255, 0, true)
else
end
end
end 
end
end
addCommandHandler("setfactiononay", BirlikOnayVER)


function BirlikSeviyeVER(thePlayer, commandName, factionID, seviye)
  if (exports["integration"]:isPlayerAdminII(thePlayer)) then
    if not (factionID) or not (seviye)  then
    outputChatBox("#000fff[!]#ffffff /" .. commandName .. " [Faction ID] [1-5]", thePlayer, 255, 194, 14, true)
    outputChatBox("- Birlik seviyesi [1 ile 5] arası olmak zorundadır. ", thePlayer, 255, 194, 14)
  else   
  	factionID = tonumber(factionID)
      if factionID then      	
      local theTeam = exports["pool"]:getElement("team", factionID)
      seviye = tonumber(seviye)     
      if (theTeam) then
      setElementData(theTeam, "birlik_level", seviye)	
      dbExec(mysql:getConnection(),"UPDATE `factions` SET `BirlikSeviyesi`="..(seviye).." WHERE `id`=" .. (factionID) )
    outputChatBox("[!]#ffffff ["..factionID.."] ID'li birliğin seviye durumunu [" .. seviye .. "] olarak seçtiniz.", thePlayer, 0, 255, 0, true)
else
end
end
end 
end
end
addCommandHandler("setfactionseviye", BirlikSeviyeVER)



--[[

  `BirlikOnayi` tinyint(1) NULL DEFAULT 0,
  `BirlikSeviyesi` tinyint(1) NULL DEFAULT 0,

--]]
