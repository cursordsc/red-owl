local count = 0 

function createLicenseVehicle(player)
	local letter1 = string.char(math.random(65,90))
	local letter2 = string.char(math.random(65,90)) -- TÜRK PLAKA
	local plate = "34 " .. letter1 .. letter2 .. " " .. tostring(math.random(100, 9999))
	local count = count + 1

	local x, y, z = 1091.5966796875, -1740.8828125, 13.507639884949
	local vehicle = createVehicle(429, x, y, z,0,0,270)
	
	setElementHealth(vehicle, 1000)
	setVehicleColor ( vehicle, 0, 0, 0, 0, 0, 0)
	setVehicleHeadLightColor ( vehicle, 255, 255, 255 )
	
	setElementData(vehicle, "ehliyetarac", true)
	setElementData(vehicle, "enginebroke", 0)
	setElementData(vehicle, "dbid", -count)
	setElementData(vehicle, "owner", -1)
	setElementData(vehicle, "fuel", 20)
	setElementData(vehicle, "engine", 0)
	setElementData(vehicle, "plate", plate)
	setElementInterior(vehicle, 0)
	setElementDimension(vehicle, 0)
	setElementInterior(player, 0)
	setElementDimension(player, 0)
	setVehicleEngineState(vehicle, false)
	setVehiclePlateText(vehicle, plate)
	setVehicleRespawnPosition(vehicle, x,y,z,0,0,359)
	setTimer(warpPedIntoVehicle, 100, 1, player, vehicle) 
end 

addEvent("createLicenseVehicle", true)
addEventHandler("createLicenseVehicle", getRootElement(), createLicenseVehicle)

addEvent("finishLicense", true)
addEventHandler("finishLicense", getRootElement(), 
	function(player)
		if player then
			local dbid = getElementData(player, "dbid")

			destroyElement(getPedOccupiedVehicle(player))
			exports["global"]:giveItem(player, 133, getPlayerName(player):gsub("_"," "))
			exports["global"]:giveItem(player, 153, getPlayerName(player):gsub("_"," "))
			dbExec(exports["mysql"]:getConnection(), "UPDATE characters SET car_license='1', bike_license='1' WHERE id='" .. dbid .. "' LIMIT 1")
		end 
	end
)