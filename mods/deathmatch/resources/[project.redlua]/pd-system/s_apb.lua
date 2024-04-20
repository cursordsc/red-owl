function showAPB(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) or (factionType==3) then
			local found = false
			outputChatBox(" ", thePlayer)
			dbExec(mysql:getConnection(), "DELETE FROM `apb` WHERE `time` < (NOW() - interval 49 hour)")

			dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						if not row then break end
					local issuerName = exports['cache']:getCharacterName(row["doneby"])
					if issuerName == false then
						issuerName = "Unknown"
					end
					outputChatBox("> "..row["description"], thePlayer)
					outputChatBox("ID: "..tostring(row["id"]).." Issued by "..issuerName.." at "..row["newtime"], thePlayer)
					outputChatBox(" ", thePlayer)
					end
				end
			end,
			mysql:getConnection(), "SELECT `id`, `description`, `doneby`, `time` - INTERVAL 1 hour as 'newtime'  FROM `apb` ORDER BY `id` ASC")

			outputChatBox("> End of APB's.", thePlayer)
		end
	end
end
addCommandHandler("apb", showAPB)

function newAPB(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) or (factionType==3) then
			if not  (...) then
				outputChatBox("Syntax: /"..commandName.." [Description]", thePlayer)
			else
				local description = table.concat( { ... }, " " )
				dbExec(mysql:getConnection(), "INSERT INTO `apb` (`description`, `doneby`, `time`) VALUES ('".. (description) .."', "..getElementData(thePlayer, "account:character:id")..", NOW() - interval 1 hour)")
				outputChatBox("> Record succesfully added.", thePlayer)
				local theTeam = getPlayerTeam(thePlayer)
				local teamPlayers = getPlayersInTeam(theTeam)
				local username  = getPlayerName(thePlayer):gsub("_", " ")

				local factionID = getElementData(thePlayer, "faction")
				local factionRank = getElementData(thePlayer, "factionrank")

				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
											
				for key, value in ipairs(teamPlayers) do
					outputChatBox("" .. factionRankTitle .. " " .. username .." has just added a new APB.", value, 0, 102, 255)
				end
			end
		end
	end
end
addCommandHandler("newapb", newAPB)

function delAPB(thePlayer, commandName, id)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) or (factionType==3) then
			if not id or not (tonumber(id)) or (tonumber(id) < 2) then
				outputChatBox("Syntax: /"..commandName.." [ID]", thePlayer)
			else
				dbExec(mysql:getConnection(), "DELETE  FROM `apb` WHERE `id`='"..(id).."'")
				outputChatBox("> Record succesfully deleted.", thePlayer)
				local theTeam = getPlayerTeam(thePlayer)
				local teamPlayers = getPlayersInTeam(theTeam)
				local username  = getPlayerName(thePlayer):gsub("_", " ")

				local factionID = getElementData(thePlayer, "faction")
				local factionRank = getElementData(thePlayer, "factionrank")
																		
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
											
				for key, value in ipairs(teamPlayers) do
					outputChatBox("" .. factionRankTitle .. " " .. username .." has just deleted APB " .. (id) .. ".", value, 0, 102, 255)
				end
			end
		end
	end
end
addCommandHandler("delapb", delAPB)