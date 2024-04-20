local vehicleModel = 455
local moneyPerCheckPoint = 100
local jobId = 1

local eventsPrefix = "Postman_"

local preDefinedPoints = {
	{2144.587890625, -1086.822265625, 24.711051940918},
	{1809.892578125, -1169.4189453125, 23.828125},
	{1586.443359375, -1415.1484375, 13.609573364258},
	{1460.8505859375, -1470.9111328125, 13.539083480835},
	{988.126953125, -1388.08984375, 13.582185745239},
	{775.998046875, -1511.2685546875, 13.5546875},
	{747.8486328125, -1788.9453125, 13.00580406189},
	{432.98828125, -1648.123046875, 25.59375},
	{500.1220703125, -1357.78515625, 16.196784973145},
	{952.2197265625, -983.7998046875, 39.046806335449},
}

local currentPoint = 0
local currentPointMarker = false
local currentPointBlip = false

local vehicleCreatorPoint = {2323.7109375, -2079.1123046875, 13.546875}
local vehicleCreatorMarker = false

local arriveTimer = false

local kargoGirisNPC = createPed(16, 2342.1435546875, -2071.1669921875, 13.546875, 90 ,true)
setElementData(kargoGirisNPC, "talk", 1)
setElementData(kargoGirisNPC, "name", "Ismail Gulen")
setElementFrozen(kargoGirisNPC, true)

function kargoGirisGUI()
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	
	if (carlicense==1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Ismail Gulen diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		kargoAcceptGUI(getLocalPlayer())
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Ismail Gulen diyor ki: La genç, senin araba ehliyetin yok? Alıverip öyle gel hadi bakayim.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("meslek:kargoGUI", true)
addEventHandler("meslek:kargoGUI", getRootElement(), kargoGirisGUI)

function kargoAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Kargo Şöförü", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			setElementData(localPlayer, "job", 1)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Ismail Gulen diyor ki: Arabana bin ve navigasyonda işaretlenmiş yere git ve kargoyu teslim et!.", 255, 255, 255, 3, {}, true)
			return	
		end
	)
	
	local line = guiCreateLabel(9, 32, 289, 19, "____________________________________________________", false, jobWindow)
	guiLabelSetHorizontalAlign(line, "center", false)
	guiLabelSetVerticalAlign(line, "center")
	local cancelBtn = guiCreateButton(159, 55, 139, 33, "İptal Et", false, jobWindow)
	addEventHandler("onClientGUIClick", cancelBtn, 
		function()
			destroyElement(jobWindow)
			return	
		end
	)
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if getElementData(localPlayer, "job") == jobId then
			setElementData(localPlayer,"meslek:aracta",false)
			if not isElement(vehicleCreatorMarker) then
				vehicleCreatorMarker = createMarker(vehicleCreatorPoint[1], vehicleCreatorPoint[2], vehicleCreatorPoint[3], "checkpoint", 4.0, 254, 119, 29)
			end
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == localPlayer then
			if dataName == "job" then
				local newValue = getElementData(source, "job") or false
				if newValue then
					if newValue == jobId then
						if not isElement(vehicleCreatorMarker) then
							vehicleCreatorMarker = createMarker(vehicleCreatorPoint[1], vehicleCreatorPoint[2], vehicleCreatorPoint[3], "checkpoint", 4.0, 254, 119, 29)
						end
					else
						if isElement(vehicleCreatorMarker) then
							destroyElement(vehicleCreatorMarker)
						end
						if isElement(currentPointMarker) then
							destroyElement(currentPointMarker)
						end
						if isElement(currentPointBlip) then
							destroyElement(currentPointBlip)
						end

						triggerServerEvent("deletePlayerVan", localPlayer, localPlayer)
					end
				end
			end
		end
	end
)

addEventHandler("onClientMarkerHit", getRootElement(),
	function (hitElement)
		if hitElement == localPlayer then
			if source == vehicleCreatorMarker and not isPedInVehicle(localPlayer) then
				if not getElementData(localPlayer, "meslek:aracta") then
					triggerServerEvent(eventsPrefix .. "tryToCreateVehicle", localPlayer,localPlayer)
				else
				    triggerServerEvent("processUnusedVehicles",localPlayer,localPlayer)
				    setElementData(localPlayer,"meslek:aracta",false)
					exports["infobox"]:addBox("info", "İşi tamamladın, aracın teslim edildi.")
				end
			elseif source == currentPointMarker then
				local vehicleElement = getPedOccupiedVehicle(localPlayer) or false
				if isElement(vehicleElement) then
					if getElementModel(vehicleElement) == vehicleModel then
						local count = 1
						if not isTimer(arriveTimer) then
							exports["infobox"]:addBox("info", "Lütfen biraz bekleyiniz...")
							arriveTimer = setTimer(
								function ()	
									if count == 1 then
										triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "yavaşca arabadan inerek arka kapağa ilerler.")
									elseif count == 2 then
										triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "postayı araç deposundan çıkartarak şahısa teslim eder.")
									elseif count == 3 then
										triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "kişiden posta ücretini teslim alarak, aracın kapağını kapatır.")
									elseif count == 4 then
										triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "araca doğru ilerleyerek tekrardan araca geri biner.")
									elseif count == 5 then
										triggerServerEvent("kargo:paraver",localPlayer,localPlayer)
										createNextPostmanPoint(false)									
									end
									count = count + 1
								end,
							2850, 5)
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientMarkerLeave", getRootElement(),
	function (leftElement)
		if leftElement == localPlayer then
			if source == currentPointMarker then
				if isTimer(arriveTimer) then
					killTimer(arriveTimer)
				end
			end
		end
	end
)

addEvent(eventsPrefix .. "initializeJob", true)
addEventHandler(eventsPrefix .. "initializeJob", getRootElement(),
	function ()
		if getElementData(source, "job") == jobId then
			if not isElement(currentPointMarker) then
				createNextPostmanPoint(false)
			else 
				createNextPostmanPoint(false)
			end
		end
	end
)

local randomSkins = {"9", "10", "14", "15", "16", "17", "18", "19", "20", "21", "22"}

function createNextPostmanPoint(forcedPoint)
	local nextPoint = 0
	if not forcedPoint then
		nextPoint = math.random(1, #preDefinedPoints)
		if currentPoint > 0 then
			while (nextPoint == currentPoint) do
				nextPoint = math.random(1, #preDefinedPoints)
			end
		end
	else
		nextPoint = forcedPoint
	end

	if nextPoint > 0 then
		if isElement(currentPointMarker) then
			destroyElement(currentPointMarker)
		end
		if isElement(currentPointBlip) then
			destroyElement(currentPointBlip)
		end
		if isElement(postaPED) then
			destroyElement(postaPED)
		end

		postaPED = createPed(table.random(randomSkins), preDefinedPoints[nextPoint][1], preDefinedPoints[nextPoint][2], preDefinedPoints[nextPoint][3])
		setElementFrozen(postaPED, true)
		setElementData(postaPED,"name","Postacı NPC")
		setElementData(postaPED,"talk",0)
		setElementData(postaPED, "job:posta_ped", true)

		currentPointMarker = createMarker(preDefinedPoints[nextPoint][1], preDefinedPoints[nextPoint][2], preDefinedPoints[nextPoint][3], "checkpoint", 4.0, 254, 119, 29)
		if isElement(currentPointMarker) then
			currentPointBlip = createBlip(preDefinedPoints[nextPoint][1], preDefinedPoints[nextPoint][2], preDefinedPoints[nextPoint][3],57)
			if isElement(currentPointMarker) then
				currentPoint = nextPoint
				setElementData(localPlayer, eventsPrefix .. "currentMarker", currentPoint)
			end
		end
	end
end

-- jármű törlési funckió

addEventHandler("onClientPlayerVehicleExit", getRootElement(), 
	function(vehicle, seat) 
		if source == localPlayer and seat == 0 and getElementData(source, "job") == 1 and getElementModel(vehicle) == vehicleModel then
			destroyTimer = setTimer(function()
				if isElement(currentPointMarker) then
						destroyElement(currentPointMarker)
					end
				if isElement(currentPointBlip) then
					destroyElement(currentPointBlip)
				end
				triggerServerEvent("processUnusedVehicles",localPlayer,localPlayer)
				setElementData(localPlayer,"meslek:aracta",false)
			end, 60000, 1)
		end
	end
)

addEventHandler("onClientPlayerVehicleEnter", getRootElement(), 
	function(vehicle, seat)
		if vehicle and seat == 0 and getElementData(source, "job") == 1 then
			if isTimer(destroyTimer) then
				killTimer(destroyTimer)
			end
		end
	end
)