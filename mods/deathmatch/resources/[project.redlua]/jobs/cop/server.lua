
local trashVehicles = {}
local destroyTimer = {}
local jobId = 12
local count = 0

addEvent("onClientHitTrashMarker",true)
addEventHandler("onClientHitTrashMarker", getRootElement(),
	function(hitElement, jobVehicleId)
		local letter1 = string.char(math.random(65,90))
		local letter2 = string.char(math.random(65,90)) -- TÜRK PLAKA
		local plate = "34 " .. letter1 .. letter2 .. " " .. tostring(math.random(100, 9999))
		local count = count + 1

		trashVehicles[hitElement] = createVehicle (jobVehicleId, 1660.453125, -1892.2724609375, 13.552103996277, 0, 0, 0, plate)
		
		setElementData(trashVehicles[hitElement], "fuel", 100)
		setElementData(trashVehicles[hitElement], "dbid", -count)
		setElementData(trashVehicles[hitElement], "enginebroke", 0)
		setElementData(trashVehicles[hitElement], "meslek:arac", getElementData(hitElement, "job"))
		setElementData(trashVehicles[hitElement], "owner", getElementData(hitElement, "dbid"))
		setElementData(trashVehicles[hitElement], "meslek", true)
		setElementData(trashVehicles[hitElement], "plate", plate)
		setElementData(hitElement, "meslek:aracim", trashVehicles[hitElement])
		setElementData(trashVehicles[hitElement], "meslek:aracim", hitElement)
		setElementData(hitElement,"meslek:aracta",true)

		setElementData(source, "karisik", 0)
		setElementData(source, "kagit", 0)
		setElementData(source, "cam", 0)
		setElementData(trashVehicles[hitElement], "meslek:cop_type", math.random(1, 3))
		
		local trashType = getElementData(trashVehicles[hitElement], "meslek:cop_type")
			if trashType == 1 then
			    r, g, b = 255, 255, 255
				trashT = "#dcdcdc'karışık'"
			elseif trashType == 2 then
				r, g, b = 0, 51, 102
				trashT = "#003366'kağıt'"
			elseif trashType == 3 then
				r, g, b = 0, 90, 40
				trashT = "#005a28'cam'"
		end

		setVehicleColor(trashVehicles[hitElement], 0, 85, 0)

		fixVehicle(trashVehicles[hitElement])
		setVehicleDamageProof(trashVehicles[hitElement], false)
		warpPedIntoVehicle(hitElement, trashVehicles[hitElement])
		
		outputChatBox("[BİLGİ]:#ffffff Senin görevin şehirdeki atık ".. trashT .."#ffffff çöpleri toplamak.", source, 208, 101, 29, true)
		outputChatBox("[BİLGİ]:#ffffff Çöp torbasının içeriğine torbaya #d0651d'sağ tıklayarak'#ffffff bakabilirsiniz.", source, 208, 101, 29, true)
		outputChatBox("[BİLGİ]:#ffffff Topladığın çöpün türüne dikkat et, yanlış türde çöp alırsan maaşında kesinti olabilir.", source, 208, 101, 29, true)
	end
)

addEvent("destroyTrashVehicle",true)
addEventHandler("destroyTrashVehicle", getRootElement(),
	function()
		if trashVehicles[source] then
			if isElement(trashVehicles[source]) then
				destroyElement(trashVehicles[source])
	            setElementData(source, "seatBelt", false)
			end
			trashVehicles[source] = nil
		end
	end
)

addEventHandler("onPlayerVehicleExit", getRootElement(),
	function(vehicle, seat)
		if seat == 0 and getElementData(vehicle, "meslek:aracim") == source and getElementData(vehicle, "meslek") and getElementData(source, "job") == jobId then
			local source = source
			destroyTimer[source] = setTimer(function()
				if isElement(trashVehicles[source]) then
					setElementData(trashVehicles[source], "meslek", false)
					setElementData(trashVehicles[source], "meslek:aracim", nil)
					destroyElement(trashVehicles[source])
					triggerClientEvent(source, "destroyCurrentPoints", source)
					triggerClientEvent(getRootElement(), "stopTrashCarrying", source)
				end
			end, (1000*60)*30, 1)
		end
	end
)

addEventHandler("onPlayerVehicleEnter", getRootElement(),
	function(vehicle, seat)
		if vehicle and seat == 0 and getElementData(vehicle, "meslek") and getElementData(vehicle, "meslek:aracim") == source and getElementData(source, "job") == jobId then
			if isTimer(destroyTimer[source]) then
				killTimer(destroyTimer[source])
			end
		end
	end
)

addEvent("onClientTakeOutTrash",true)
addEventHandler("onClientTakeOutTrash", getRootElement(),
	function(trashUID)
		setPedAnimation(source, "CARRY", "crry_prtial", -1, false, false, false, false)
		triggerClientEvent(getRootElement(), "startTrashCarrying", source)
	end
)

addEvent("onClientDestroyTrash",true)
addEventHandler("onClientDestroyTrash", getRootElement(),
	function()
		setPedAnimation(source, "CARRY", "putdwn05", -1, false, false, false, false)
		triggerClientEvent(getRootElement(), "stopTrashCarrying", source)
	end
)

addEventHandler("onPlayerQuit", getRootElement(),
	function()
		if trashVehicles[source] then
			if isElement(trashVehicles[source]) then
				destroyElement(trashVehicles[source])
				triggerClientEvent(source, "destroyTrashElements", source)
			end
			trashVehicles[source] = nil
		end
	end
)

addEvent("changeTrashDoorOpenRatio", true)
addEventHandler("changeTrashDoorOpenRatio", root, function(veh, id, to)
	setTimer(function()
	    setVehicleDoorOpenRatio(veh, id, to, 5000)
	end, 250, 1)
end)

addEvent("changeTrashDoorCloseRatio", true)
addEventHandler("changeTrashDoorCloseRatio", root, function(veh, id, to)
	setTimer(function()
	    setVehicleDoorOpenRatio(veh, id, to, 5000)
	end, 250, 1)
end)