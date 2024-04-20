local mysql = exports.mysql

addEvent('odometer.save', true)
addEventHandler('odometer.save', root, function(value)
	if source and tonumber(value) then
		local vehicle = getPedOccupiedVehicle(source)
		if vehicle then
			local sqlID = getElementData(vehicle, "dbid")
			if tonumber(sqlID) then
				setElementData(vehicle, "odometer", tonumber((getElementData(vehicle, "odometer") or 0) + 1))
				local meter = getElementData(vehicle, "odometer")
				dbExec(mysql:getConnection(), "UPDATE vehicles SET odometer='"..tonumber(meter).."' WHERE id='"..tonumber(sqlID).."'")
			end
		end
	end
end)