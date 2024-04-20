--MAXIME
local mysql = exports["mysql"]
local refreshCacheRate = 10
local usernameCache = {}
local searched = {}
function getUsername( clue )
	if not clue or string.len(clue) < 1 then
		--outputDebugString("Server cache: clue is empty.")
		return false
	end
	
	for i, username in pairs(usernameCache) do
		if username and string.lower(username) == string.lower(clue) then
			--outputDebugString("Server cache: Username found in cache - "..username) 
			return username
		end
	end
	
	--outputDebugString("Server cache: Username not found in cache. Searching in all current online players.")
	for i, player in pairs(exports["pool"]:getPoolElementsByType("player")) do
		local username = getElementData(player, "account:username")
		if username and string.lower(username) == string.lower(clue) then
			usernameCache[getElementData(player, "account:id")] = username
			--outputDebugString("Server cache: Username found in current online players. - "..username) 
			return username
		end
	end

	if not searched[clue] then
		dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					if row and row["username"] and string.len(row["username"]) > 0 then
						usernameCache[tonumber(row["id"])] = row["username"]
						--outputDebugString("Server cache: Username found in database, added to cache. - "..row["username"])
						return row["username"]
					end
				end
			end
		end, mysql:getConnection(), "SELECT `username`, `id` FROM `accounts` WHERE `username` = '" .. (clue) .. "' LIMIT 1")
		--outputDebugString("Server cache: Username does not exist in database.")
		searched[clue] = true
		setTimer(function()
			local index = clue
			searched[index] = nil
		end, refreshCacheRate*1000*60, 1)
	else
		--outputDebugString("Server cache: Previously requested for server's cache. Searching cancelled within refresh rate ("..refreshCacheRate.." minutes).")
	end
	return false
end

function checkUsernameExistance(clue)
	if not clue or string.len(clue) < 1 then
		return false, "Please enter account name."
	end 
	local found = getUsername( clue )
	if found then
		return true, "Account name '"..found.."' is existed and valid!"
	else
		return false, "Account name '"..clue.."' does not exist."
	end
end

function requestUsernameCacheFromServer(clue)
	local found = getUsername( clue )
	--outputDebugString("Server cache: Checked server's cache and responding to client")
	triggerClientEvent(client, "retrieveUsernameCacheFromServer", source, found)
end
addEvent("requestUsernameCacheFromServer", true)
addEventHandler("requestUsernameCacheFromServer", root, requestUsernameCacheFromServer)

function getUsernameFromId(id)
	if not id or not tonumber(id) then
		--outputDebugString("Server cache: id is empty.")
		return false
	else
		id = tonumber(id)
	end
	
	if usernameCache[id] then
		--outputDebugString("Server cache: Username found in cache - "..usernameCache[id]) 
		return usernameCache[id]
	end
	
	--outputDebugString("Server cache: Username not found in cache. Searching in all current online players.")
	for i, player in pairs(exports["pool"]:getPoolElementsByType("player")) do
		if id == getElementData(player, "account:id") then
			usernameCache[id] = getElementData(player, "account:username")
			--outputDebugString("Server cache: Username found in current online players. - "..usernameCache[id]) 
			return usernameCache[id]
		end
	end
	
	if searched[id] then
		--outputDebugString("Server cache: Previously requested for server's cache but not found. Searching cancelled.")
		return false
	end
	searched[id] = true

	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if row and row["username"] and string.len(row["username"]) > 0 then
					usernameCache[id] = row["username"]
					--outputDebugString("Server cache: Username found in database, added to cache. - "..query["username"])
					return usernameCache[id]
				end

				setTimer(function()
					local index = id
					searched[index] = nil
				end, refreshCacheRate*1000*60, 1)

				--outputDebugString("Server cache: Username does not exist in database.")
				return false
			end
		end
	end, mysql:getConnection(), "SELECT `username`, `id` FROM `accounts` WHERE `id` = '" .. (id) .. "' LIMIT 1")

local accountCache = {}
local accountCacheSearched = {}
function getAccountFromCharacterId(id)
	if id and tonumber(id) then
		id = tonumber(id)
	else
		return false
	end

	if accountCache[id] then
		return accountCache[id]
	end

	for i, player in pairs(getElementsByType("player")) do
		if getElementData(player, "dbid") == id then
			accountCache[id] = {id = getElementData(player, "account:id"), username = getElementData(player, "account:username")}
			return accountCache[id]
		end
	end

	if accountCacheSearched[id] then
		return false
	end
	accountCacheSearched[id] = true

	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if row and row["id"] ~= "NULL" then
					accountCache[id] = {id = tonumber(user.id), username = user.username}
					return accountCache[id]
				end

				setTimer(function()
					local index = id
					accountCacheSearched[index] = nil
				end, refreshCacheRate*1000*60, 1)
				return false
			end
		end
	end, mysql:getConnection(), "SELECT a.id AS id, username FROM accounts a LEFT JOIN characters c ON a.id=c.account WHERE c.id="..id.." LIMIT 1")
  end
end