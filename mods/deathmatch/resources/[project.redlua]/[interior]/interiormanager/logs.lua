local mysql = exports["mysql"]
	
function addInteriorLogs(intID, action, actor, clearPreviousLogs)
	if intID and action then
		if clearPreviousLogs then
			if not dbExec(mysql:getConnection(), "DELETE FROM `interior_logs` WHERE `intID`='"..tostring(intID).. "'") then
				--outputDebugString("[INTERIOR MANAGER] Failed to clean previous logs #"..intID.." from `interior_logs`.")
				return false
			end
			if not dbExec(mysql:getConnection(), "DELETE FROM `logtable` WHERE `affected`='in"..tostring(intID).. ";'") then
				--outputDebugString("[INTERIOR MANAGER] Failed to clean previous logs #"..intID.." from `logtable`.")
				return false
			end
		end

		local adminID = nil
		if actor and isElement(actor) and getElementType(actor) == "player" then
		 	adminID = getElementData(actor, "account:id") 
		end
		
		local addLog = dbExec(mysql:getConnection(), "INSERT INTO `interior_logs` SET `intID`= ?, `action` = ? "..(adminID and (", `actor` = ? ") or ""), tostring(intID), action, adminID ) or false

		if not addLog then
			--outputDebugString("[INTERIOR MANAGER] Failed to add interior logs.")
			return false
		else
			return true
		end
	else
		--outputDebugString("[INTERIOR MANAGER] Lack of agruments #1 or #2 for the function addInteriorLogs().")
		return false
	end
end