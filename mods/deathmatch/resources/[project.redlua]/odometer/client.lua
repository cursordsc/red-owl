local distanceTraveled = 0
local oX,oY,oZ = getElementPosition(getLocalPlayer())

setTimer(function()
	if(isPedInVehicle(getLocalPlayer())) then
		x,y,z = getElementPosition(getLocalPlayer())
		distanceTraveled = distanceTraveled + getDistanceBetweenPoints3D(x,y,z,oX,oY,oZ)
		if math.floor(distanceTraveled) >= 1000 then
			triggerServerEvent('odometer.save', localPlayer, math.floor(distanceTraveled))
			distanceTraveled = 0
		end
		oX = x
		oY = y
		oZ = z
	else
		if math.floor(distanceTraveled) > 0 then
			distanceTraveled = 0
		end
	end
end, 0, 0)