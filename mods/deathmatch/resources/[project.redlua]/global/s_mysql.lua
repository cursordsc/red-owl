function toSQL(stuff)
	return stuff
end

function getSmallestIdFromDbTable(tableName) -- finds the smallest ID in the SQL instead of auto increment
	if not tableName then
		return false
	end
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM "..tableName.." AS e1 LEFT JOIN "..tableName.." AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end