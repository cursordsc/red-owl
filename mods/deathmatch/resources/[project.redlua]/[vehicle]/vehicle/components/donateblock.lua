
local donatevehicles = { [494] = true, [502] = true, [503] = true,  [602] = true, [587] = true, [540] = true, [458] = true, [526] = true }

addEventHandler("onVehicleStartEnter" , root , function(player)
    local model 	= source.model
    local owner 	= source:getData("owner")
	local seat  	= getPedOccupiedVehicleSeat(player)
	
	if exports.integration:isPlayerLeadAdmin(player) or getElementData(player, "duty_admin") == 1 then 
	return end
	
	if seat == 0 then

		if player:getData("restrain") == 1 then
			exports["infobox"]:addBox(player, "error", "Kelepçen varken sürücü koltuğuna binemezsin.")
			cancelEvent()
		end	

		--[[if donatevehicles[model] and owner ~= player:getData("dbid") then
			exports["infobox"]:addBox(player, "error", "Donate araçları sadece sahipleri kullanabilir.")
			cancelEvent()
		end]]

	end
	
end)