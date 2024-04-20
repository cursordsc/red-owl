
local carJackVehicles = {}
local destroyTimer = {}
local count = 0
local jobId = 13
local wheel1 = {}
local wheel2 = {}
local wheel3 = {}
local wheel4 = {}
local wheel5 = {}
local wheel6 = {}
local wheel7 = {}
local wheel8 = {}

addEvent("onClientHitCarJackMarkers",true)
addEventHandler("onClientHitCarJackMarkers", getRootElement(),
	function(hitElement, jobVehicleId)
		local letter1 = string.char(math.random(65,90))
		local letter2 = string.char(math.random(65,90)) -- TÜRK PLAKA
		local plate = "34 " .. letter1 .. letter2 .. " " .. tostring(math.random(100, 9999))
		local count = count + 1

		carJackVehicles[hitElement] = createVehicle (jobVehicleId, 1250.896484375, -1820.2412109375, 13.408143997192, 0, 0, 180, plate)
		setElementData(carJackVehicles[hitElement], "fuel", 100)
		setElementData(carJackVehicles[hitElement], "dbid", -count)
		setElementData(carJackVehicles[hitElement], "enginebroke", 0)
		setElementData(carJackVehicles[hitElement], "meslek:arac", getElementData(hitElement, "job"))
		setElementData(carJackVehicles[hitElement], "owner", getElementData(hitElement, "dbid"))
		setElementData(carJackVehicles[hitElement], "meslek", true)
		setElementData(carJackVehicles[hitElement], "plate", plate)
		setElementData(hitElement, "meslek:aracim", carJackVehicles[hitElement])

		setElementData(carJackVehicles[hitElement], "isCarJackJobVehicle", true)
		setElementData(carJackVehicles[hitElement], "meslek:lastik_sahip", getElementData(hitElement, "dbid"))
		setElementData(hitElement, "meslek:lastik_sahip", getElementData(hitElement, "dbid"))
		setElementData(hitElement, "otokurtarma:araba_adet", 0)

		fixVehicle(carJackVehicles[hitElement])
		setVehicleDamageProof(carJackVehicles[hitElement], false)
		setTimer(warpPedIntoVehicle, 100, 1, hitElement, carJackVehicles[hitElement]) 
		
		outputChatBox("[BİLGİ]:#ffffff Göreviniz işaretli araçların tekerleklerini değiştirmek.", source, 208, 101, 29, true)
		outputChatBox("[BİLGİ]:#ffffff Bu görev için bir #b41414'kriko'ya'#ffffff ihtiyacın olacak.", source, 208, 101, 29, true)
		outputChatBox("[BİLGİ]:#ffffff Bir araçta arızalı bir tekerlek var. Görevin sırası aşağıdaki gibidir:", source, 208, 101, 29, true)
		outputChatBox("[BİLGİ]:#ffffff Aracı kriko aracılığıyla kaldırmak, eski tekerleği çıkartmak, yenisini takmak ve aracı indirmek.", source, 208, 101, 29, true)
		outputChatBox("[BİLGİ]:#ffffff Eğer aracı indirmeden giderseniz #b41414'krikonuzun'#ffffff orda kalacağını bilmenizi isteriz.", source, 208, 101, 29, true)
end
)

addEvent("destroyCarJackVehicle",true)
addEventHandler("destroyCarJackVehicle", getRootElement(),
	function()
		if carJackVehicles[source] then
			if isElement(carJackVehicles[source]) then
				destroyElement(carJackVehicles[source])
	            setElementData(source, "seatBelt", false)
			if isElement(wheel1[source]) then	
				destroyElement(wheel1[source])
				destroyElement(wheel2[source])
				destroyElement(wheel3[source])
				destroyElement(wheel4[source])
				destroyElement(wheel5[source])
				destroyElement(wheel6[source])
				destroyElement(wheel7[source])
				destroyElement(wheel8[source])
			   end
			end
			carJackVehicles[source] = nil
		end
	end
)

addEventHandler("onPlayerVehicleExit", getRootElement(),
	function(vehicle, seat)
		if seat == 0 and getElementData(vehicle, "meslek:lastik_sahip") == getElementData(source, "meslek:lastik_sahip") and getElementData(vehicle, "isCarJackJobVehicle") and getElementData(source, "job") == jobId then
			local source = source
			destroyTimer[source] = setTimer(function()
				if isElement(carJackVehicles[source]) then
					setElementData(carJackVehicles[source], "isCarJackJobVehicle", false)
					setElementData(carJackVehicles[source], "meslek:lastik_sahip", nil)
					triggerEvent("onClientHitCarJackMarker", source)
					triggerClientEvent(source, "destroyCurrentPoints", source)
					triggerClientEvent(getRootElement(), "stopcarCarrying", source)
				end
			end, (1000*60)*30, 1)
		end
	end
)

addEventHandler("onPlayerVehicleEnter", getRootElement(),
	function(vehicle, seat)
		if vehicle and seat == 0 and getElementData(vehicle, "isCarJackJobVehicle") and getElementData(vehicle, "meslek:lastik_sahip") == getElementData(source, "meslek:lastik_sahip") and getElementData(source, "job") == jobId then
			if isTimer(destroyTimer[source]) then
				killTimer(destroyTimer[source])
			end
		end
	end
)

addEvent("onClientTakeOutcar",true)
addEventHandler("onClientTakeOutcar", getRootElement(),
	function(carUID)
		setPedAnimation(source, "CARRY", "crry_prtial", 0, true, false, true, true)
		triggerClientEvent(getRootElement(), "startcarCarrying", source)
	end
)

addEvent("onClientDestroyCar",true)
addEventHandler("onClientDestroyCar", getRootElement(),
	function()
		setPedAnimation(source, "CARRY", "putdwn05", -1, false, false, false, false)
		triggerClientEvent(getRootElement(), "stopcarCarrying", source)
	end
)

addEventHandler("onPlayerQuit", getRootElement(),
	function()
		if carJackVehicles[source] then
			if isElement(carJackVehicles[source]) then
				destroyElement(carJackVehicles[source])
			end
			carJackVehicles[source] = nil
		end
	end
)

addEvent("changecarDoorOpenRatio", true)
addEventHandler("changecarDoorOpenRatio", root, function(veh, id, to)
	setTimer(function()
	    setVehicleDoorOpenRatio(veh, id, to, 3000)
	end, 200, 1)
end)

addEvent("changecarDoorCloseRatio", true)
addEventHandler("changecarDoorCloseRatio", root, function(veh, id, to)
	setTimer(function()
	    setVehicleDoorOpenRatio(veh, id, to, 11500)
	end, 400, 1)
end)