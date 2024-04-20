function syncFuel(ifuel)
	if not (ifuel) then
		fuel = 100
	else
		fuel = ifuel
	end
end
addEvent("syncFuel", true)
addEventHandler("syncFuel", getRootElement(), syncFuel)