--[[addEventHandler('back-weapons:update', root,
function(player, newInt, newDim) --This is used by the client-side int/dim change check, to update the int/dim of all attached artifacts when player changes int/dim
	if jugadores[source] then
		for k,v in ipairs(jugadores[source]) do
			if(isElement(v)) then
				setElementInterior(v, newInt)
				setElementDimension(v, newDim)
			end
		end
		jugadores[source] = nil
	end
end)]]