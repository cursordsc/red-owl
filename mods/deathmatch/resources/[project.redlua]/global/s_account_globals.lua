function getCharacterIDFromName(charName)
	if not charName then return false end
	charName = string.gsub(charName, " ", "_")
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local id = tonumber(row["id"])
					if id > 0 then
						return id
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `id` FROM characters WHERE `charactername`='"..(charName).."' LIMIT 1")
	return false
end
function getCharacterNameFromID(charID)
	if not charID then return false end
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row2 in ipairs(res) do
					local charName = tostring(row2["charactername"])
					if charName then
						return charName
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `charactername` FROM characters WHERE `id`='"..(charID).."' LIMIT 1")
	--outputDebugString("getCharacterNameFromID(): Unable",2)
	return false
end

function getUserNameFromID(userID)
	if not userID then 
		return false
	end

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local userName = tostring(row["username"])
					if userName then
						return userName
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `username` FROM accounts WHERE `id`='"..tostring(userID).."' LIMIT 1")
	return false
end

function getPlayerFromCharacterID(charID)
	local players = exports["pool"]:getPoolElementsByType("player")
	for k,v in ipairs(players) do
		if(tonumber(getElementData(v, "dbid")) == tonumber(charID)) then
			return v
		end
	end
	return false
end