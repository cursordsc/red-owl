local DolmuscuAdam = createPed(16, 1810.58203125, -1900.8642578125, 13.576235771179, 90 ,true)
setElementData(DolmuscuAdam, "talk", 1)
setElementData(DolmuscuAdam, "name", "Abdullah Kara")
setElementFrozen(DolmuscuAdam, true)

function DolmusJobDisplayGUI()
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	
	if (carlicense==1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Abdullah Kara diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		DolmusAcceptGUI(getLocalPlayer())
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Abdullah Kara diyor ki: La genç, senin araba ehliyetin yok? Alıverip öyle gel hadi bakayim.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("dolmus:displayJob", true)
addEventHandler("dolmus:displayJob", getRootElement(), DolmusJobDisplayGUI)

function DolmusAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Dolmuş Şöförlüğü", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			setElementData(localPlayer, "job", 3)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Abdullah Kara diyor ki: Yandaki arabalardan birini alıp işe başla, dikkatli olmayı unutma.", 255, 255, 255, 3, {}, true)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Yanındaki arabalardan birine bin ve [/dolmusbasla] yazarak işe başla!", 255, 255, 255, 3, {}, true)
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

local DolmusMarket = 0
local trashCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local DolmusRota = {
	{ 1812.65625, -1889.2421875, 13.4140625, false }, -- Başlangıç
	{ 1824.115234375, -1863.056640625, 13.4140625, false },
	{ 1811.1162109375, -1829.6962890625, 13.390607833862, false },
	{ 1785.5673828125, -1827.666015625, 13.3828125, true },  -- Sıfırıncı

	{ 1727.7705078125, -1812.2978515625, 13.362403869629, false },
	{ 1687.1484375, -1832.375, 13.3828125, false },
	{ 1648.4599609375, -1869.8427734375, 13.3828125, false },
	{ 1551.31640625, -1869.8798828125, 13.3828125, false },
	{ 1450.94140625, -1869.7451171875, 13.390607833862, false },
	{ 1341.8564453125, -1854.703125, 13.3828125, false },
	{ 1314.9326171875, -1840.2958984375, 13.3828125, false },
	{ 1317.06640625, -1812.740234375, 13.3828125, true }, -- Birinci

	{ 1314.9599609375, -1771.5517578125, 13.3828125, false },
	{ 1314.841796875, -1697.693359375, 13.3828125, false },
	{ 1315.048828125, -1589.28515625, 13.3828125, false },
	{ 1340.3740234375, -1499.2958984375, 13.390607833862, false },
	{ 1358.962890625, -1433.275390625, 13.390607833862, false },
	{ 1325.7470703125, -1392.80859375, 13.369052886963, false },
	{ 1230.037109375, -1392.765625, 13.180956840515, false },
	{ 1173.4150390625, -1390.7001953125, 13.394864082336, true }, -- İkinci

	{ 1108.5224609375, -1392.7822265625, 13.453889846802, false },
	{ 1059.62109375, -1423.68359375, 13.371453285217, false },
	{ 1043.0263671875, -1513.2138671875, 13.380692481995, false },
	{ 1034.8662109375, -1592.1474609375, 13.3828125, false },
	{ 1034.9560546875, -1688.1025390625, 13.3828125, false },
	{ 1061.2841796875, -1714.6875, 13.3828125, false },
	{ 1193.7744140625, -1714.71875, 13.3828125, false },
	{ 1282.5361328125, -1714.861328125, 13.3828125, false },
	{ 1294.9248046875, -1747.25390625, 13.3828125, false },
	{ 1292.6767578125, -1812.7431640625, 13.3828125, true }, -- Üçüncü

	{ 1308.2529296875, -1854.6015625, 13.3828125, false },
	{ 1381.912109375, -1874.6875, 13.3828125, false },
	{ 1488.421875, -1874.7919921875, 13.3828125, false },
	{ 1598.775390625, -1874.837890625, 13.3828125, false },
	{ 1683.029296875, -1864.5322265625, 13.390607833862, false },
	{ 1703.265625, -1814.6142578125, 13.36643409729, false },
	{ 1742.822265625, -1821.4150390625, 13.37343120575, false },
	{ 1766.2421875, -1829.7509765625, 13.3828125, true }, -- Dördüncü

	{ 1797.0126953125, -1834.8203125, 13.390607833862, false },
	{ 1819.2490234375, -1858.349609375, 13.4140625, false },

    { 1812.65625, -1889.2421875, 13.4140625, true, true }, -- Bitiş

}

function DolmusBasla(cmd)
	if not getElementData(getLocalPlayer(), "DolmusSoforu") then
		local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 418
		
		if oyuncuArac and getVehicleController(oyuncuArac) == getLocalPlayer() then
		if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "DolmusSoforu", true)
			updateDolmusRota()
			addEventHandler("onClientMarkerHit", resourceRoot, DolmusRotaMarkerHit)
			end
			else
		end
	else
		outputChatBox("[!] #FFFFFFZaten mesleğe başladınız!", 255, 0, 0, true)
	end
end
addCommandHandler("dolmusbasla", DolmusBasla)

function updateDolmusRota()
	DolmusMarket = DolmusMarket + 1
	for i,v in ipairs(DolmusRota) do
		if i == DolmusMarket then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				table.insert(trashCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(trashCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(trashCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function DolmusRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 418 then
				for _, marker in ipairs(trashCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updateDolmusRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							DolmusMarket = 0
							triggerServerEvent("DolmusParaVer", hitPlayer, hitPlayer)
							outputChatBox("[!] #FFFFFFAracınıza yeni benzin konulmakta, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, [/dolmusbitir] yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınıza yeni benzin konuldu. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateDolmusRota()
								end, 1000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("[!] #FFFFFFYolcu indiriliyor, lütfen biraz bekleyin..", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFYolcu başarıyla indirildi, devam edebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateDolmusRota()
								end, 1000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function DolmusBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local DolmusSoforu = getElementData(getLocalPlayer(), "DolmusSoforu")
	if pedVeh then
		if pedVehModel == 418 then
			if DolmusSoforu then
				exports["global"]:fadeToBlack()
				setElementData(getLocalPlayer(), "DolmusSoforu", false)
				for i,v in ipairs(trashCreatedMarkers) do
					destroyElement(v[1])
				end
				trashCreatedMarkers = {}
				DolmusMarket = 0
				triggerServerEvent("dolmus:bitir", getLocalPlayer(), getLocalPlayer())
				setVehicleLocked(oyuncuArac, false)
				removeEventHandler("onClientMarkerHit", resourceRoot, DolmusRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), DolmusAntiYabanci)
				setTimer(function() exports["global"]:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("dolmusbitir", DolmusBitir)

function DolmusAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 418 and vehicleJob == 3 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
			cancelEvent()
		elseif thePlayer == getLocalPlayer() and playerJob ~= 3 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFBu araca binmek için Dolmuş Şöförlüğü mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
			cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), DolmusAntiYabanci)

function DolmusAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		local vehicleModel = getElementModel(theVehicle)
		local vehicleJob = getElementData(theVehicle, "job")
		local playerJob = getElementData(thePlayer, "job")
		if seat ~= 0 and vehicleModel == 418 and vehicleJob == 3 and playerJob == 3 then
			triggerServerEvent("dolmus:bitir", thePlayer, thePlayer)
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), DolmusAntiAracTerketme)