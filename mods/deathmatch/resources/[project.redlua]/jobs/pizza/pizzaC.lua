local hitPoint = {800.337890625, -1629.2744140625, 13.3828125}

local refillPoint = {800.337890625, -1629.2744140625, 13.3828125}

local npcPos = {
	{645.1201171875, -1715.044921875, 14.312249183655, 80},
	{1078.83203125, -1861.140625, 13.546875, 0},
	{1045.107421875, -1285.578125, 13.546875, 270},
	{1366.02734375, -1431.9794921875, 13.546875, 90},
	{1379.5693359375, -1753.1220703125, 14.140625, 270},
	{1837.1025390625, -1443.814453125, 13.56565284729, 270},
	{1909.9521484375, -1601.4619140625, 13.549427986145, 180},
	{1675.912109375, -1853.9384765625, 13.53125, 240},
	{2090.7431640625, -1905.7294921875, 13.546875, 90},
	{2239.2255859375, -1643.4296875, 15.49040222168, 157},
}

local skins = {1, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30}
local destroyTimer
local markerSpawned = false
local isHoldingPizza = false
local pizzaCounterPizzaes = 0
local counter = 1
local hitMarker
local jobActive = false
local function pizzaMarkerHit(hitElement)
	if hitElement == localPlayer and not isPedInVehicle(localPlayer) then
		exports["infobox"]:addBox("info", "Başarıyla araca bindin.")
		outputChatBox("[RED:LUA Scripting]: #ffffffİlk olarak gps'de belirlenmiş yere git ve oradan araçtan in ve aracın arka tarafına tıkla, ve daha sonra ped'e tıkla.", 0, 255, 255, true)
		triggerServerEvent("pizzaOlustur", localPlayer, localPlayer)
		generatePizza2Point()
	end
end

--======================================================================================================

--Pizzacı
local PizzaciAdam = createPed(16, 791.7490234375, -1622.849609375, 13.3828125, 90, true)
setElementData(PizzaciAdam, "talk", 1)
setElementData(PizzaciAdam, "name", "Samet Kalender")
setElementFrozen(PizzaciAdam, true)

function pizzaJobDisplayGUI()
	local carlicense = getElementData(getLocalPlayer(), "license.bike")
	
	if (carlicense==1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Samet Kalender diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		pizzaAcceptGUI(getLocalPlayer())
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Samet Kalender diyor ki: La genç, senin motor ehliyetin yok? Şu karşıdan alıverip öyle gel hadi bakayim.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("pizza:meslek", true)
addEventHandler("pizza:meslek", getRootElement(), pizzaJobDisplayGUI)

function pizzaAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Pizzacı", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			managePizzaszallito(true)
			setElementData(localPlayer, "job", 6)
			destroyElement(jobWindow)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Samet Kalender diyor ki: ilerdeki motorlardan birini al ve siparişleri dağıtmaya başla.", 255, 255, 255, 3, {}, true)
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
--======================================================================================================

function resetPizzaszallito()
	for k, v in pairs(getElementsByType("blip", getResourceRootElement(getThisResource()))) do
		if getElementData(v, "pizza2") then
			destroyElement(v)
		end
	end
	for k, v in pairs(getElementsByType("marker", getResourceRootElement(getThisResource()))) do
		if getElementData(v, "pizza2") then
			destroyElement(v)
		end
	end
	for k, v in pairs(getElementsByType("ped", getResourceRootElement(getThisResource()))) do
		if getElementData(v, "pizza2") then
			destroyElement(v)
		end
	end
	if isElement(hitMarker) then
		destroyElement(hitMarker)
	end
	if isElement(deliverMarker) then
		destroyElement(deliverMarker)
	end
	if isElement(holdingObject) then
		exports["bone_attach"]:detachElementFromBone(holdingObject)
		destroyElement(holdingObject)
	end
	if isTimer(destroyTimer) then
		killTimer(destroyTimer)
	end
	if isElement(blip) then
		destroyElement(blip)
	end
	if isElement(marker) then
		destroyElement(marker)
	end
	if isElement(npc) then
		destroyElement(npc)
	end
end

function managePizzaszallito(state)
	if state and not jobActive then
		jobActive = true
		if not isElement(hitMarker) then
			hitMarker = createMarker(hitPoint[1], hitPoint[2], hitPoint[3] - 1, "checkpoint", 4, 255, 255, 255, 100)
			addEventHandler("onClientMarkerHit", hitMarker, pizzaMarkerHit)
		end
	elseif jobActive and not state then
		jobActive = false
		removeEventHandler("onClientMarkerHit", hitMarker, pizzaMarkerHit)
		resetPizzaszallito()
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "job") == 6 then
		managePizzaszallito(true)
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if isElement(blip) then
		setElementData(localPlayer, "job:RestorePizza", true, false)
	end
end)

local oldPoint = 0
function generatePizza2Point()
	resetPizzaszallito()

	local szam = math.random(1,#npcPos)
	if szam == oldPoint then
		generatePizza2Point()
		return
	end
	oldPoint = szam

	blip = createBlip(npcPos[szam][1], npcPos[szam][2], npcPos[szam][3], 61)
	setElementData(blip, "pizza2", true, false)

	marker = createMarker(npcPos[szam][1], npcPos[szam][2], npcPos[szam][3] - 1, "checkpoint", 4, 79, 152, 225, 100)	
	setElementData(marker, "pizza2", true, false)

	setElementData(localPlayer, "rota:x", npcPos[szam][1], true)
	setElementData(localPlayer, "rota:y", npcPos[szam][2], true)

	setTimer(
	function()
		exports["radar"]:makeRoute(npcPos[szam][1], npcPos[szam][2])
	end, 1000, 1)
	
	local skin = skins[math.random(7)]

	npc = createPed(skin, npcPos[szam][1], npcPos[szam][2], npcPos[szam][3])
	setElementRotation(npc, 0, 0, npcPos[szam][4])
	setElementData(npc, "pizza2", true, false)
	setElementData(npc, "pizza2:cangive", true, false)
	setElementData(npc, "npcType", true, false)
	setElementFrozen(npc, true, false)
end

addEventHandler("onClientClick", getRootElement(), 
	function(button, state, x, y, wx, wy, wz, element) 
		if button and state and state == "down" then
			if button == "left" and element and isElement(element) and getElementModel(element) == 448 and not isHoldingPizza and getElementData(element, "meslek:arac") == 6 and getElementData(element, "meslek:arac_sahip") == getElementData(localPlayer, "dbid") then
				local x, y, z = getElementPosition(localPlayer)
				local cx, cy, cz = getElementPosition(element)
				local veh = getPedOccupiedVehicle(localPlayer)
				if not veh then
					if getDistanceBetweenPoints3D(x, y, z, cx, cy, cz) <= 2 and pizzaCounterPizzaes < 15 then
						setPedAnimation(localPlayer, "CARRY", "crry_prtial", 50, false)
						object = createObject(1582, getElementPosition(localPlayer))
						exports["bone_attach"]:attachElementToBone(object, localPlayer, 12, 0.2, 0, 0, -90, 10, -10)
						holdingObject = object	
						isHoldingPizza = true
						triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "motorun arkasından pizza kutusunu alır.")			
					end
				else
					outputChatBox("[RED:LUA Scripting]: #FFFFFFEİlk olarak motordan inmelisin.", 255, 0, 0, true)
				end
			elseif element and isElement(element) and getElementType(element) == "ped" and getElementData(element, "pizza2") and isHoldingPizza and pizzaCounterPizzaes < 15 and not getElementData(element, "pizza2:gotpizza") then
				local x, y, z = getElementPosition(localPlayer)
				local cx, cy, cz = getElementPosition(element)
				local rx, ry, rz = getElementPosition(localPlayer)
				if getDistanceBetweenPoints3D(x, y, z, cx, cy, cz) <= 2 then
					setPedAnimation(element, "CARRY", "crry_prtial", 50, false)
					exports["bone_attach"]:detachElementFromBone(holdingObject)
					destroyElement(holdingObject)
					isHoldingPizza = false	
					triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "müşteriye pizzayı verir.")
					setElementData(element, "pizza2:cangive", false, false)
					triggerServerEvent("animasyon:durdur", localPlayer, localPlayer)

					local miktar = 100

					if getElementData(localPlayer, "vip") == 1 then
						ekpara = 125
					elseif getElementData(localPlayer, "vip") == 2 then
						ekpara = 250
					elseif getElementData(localPlayer, "vip") == 3 then
						ekpara = 375
					elseif getElementData(localPlayer, "vip") == 4 then
						ekpara = 500
					else
						ekpara = 0
					end
					triggerServerEvent("giveMoney", localPlayer, localPlayer, miktar+ekpara)

					generatePizza2Point()
					pizzaCounterPizzaes = pizzaCounterPizzaes + 1
					exports["infobox"]:addBox("success", "Başarıyla pizzayı teslim ettin! Kalan Sipariş:"..(15 - pizzaCounterPizzaes).." ")
					if pizzaCounterPizzaes == 15 then
						spawnPizza2Marker()
					end 	
				end
			end
		end
	end
)

function pizzaszallitiFillUp(hitPlayer)
	if hitPlayer == localPlayer and getPedOccupiedVehicle(localPlayer) then
		exports["infobox"]:addBox("info", "Bekleyin.")
		setTimer(function()
			setElementFrozen(localPlayer, true)
			setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
		end, 2000, 1)
		setTimer(function()
			exports["infobox"]:addBox("info", "Yeni pizzalar motoruna yüklendi, yola koyul.")
			generatePizza2Point()
			setElementFrozen(localPlayer, false)
			setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
			counter = 1
			pizzaCounterPizzaes = 0
		end, 30000, 1)
		removeEventHandler("onClientMarkerHit", deliverMarker, pizzaszallitiFillUp)
	end 
end

function spawnPizza2Marker()
	resetPizzaszallito()
	exports["infobox"]:addBox("info", "Tüm pizzaları dağıtmış görünüyorsun hemen işyerine geri dön.")
	blip = createBlip(refillPoint[1], refillPoint[2], refillPoint[3] - 1, 59)
	setElementData(blip, "pizza2", true, false)
	deliverMarker = createMarker(refillPoint[1], refillPoint[2], refillPoint[3] - 1, "checkpoint", 4, 79, 152, 225, 100)	
	setElementData(deliverMarker, "pizza2", true, false)
	addEventHandler("onClientMarkerHit", deliverMarker, pizzaszallitiFillUp)
end

addEventHandler("onClientPlayerVehicleExit", getRootElement(), function(vehicle, seat) 
	if exports["jobs"]:isJobVehicle(vehicle, 6) and source == localPlayer and seat == 0 then
		destroyTimer = setTimer(function()
			resetPizzaszallito()
			managePizzaszallito(true)
		end, 60000, 1)
	end
end)

addEventHandler("onClientPlayerVehicleEnter", getRootElement(), function(vehicle, seat)
	if vehicle and seat == 0 and exports["jobs"]:isJobVehicle(vehicle, 6) and getElementData(source, "job") == 6 then
		if isTimer(destroyTimer) then
			killTimer(destroyTimer)
		end
	end
end)