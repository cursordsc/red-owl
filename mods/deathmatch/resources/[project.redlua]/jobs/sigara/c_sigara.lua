local sigaraPed = createPed(16, 2449.140625, -2643.3583984375, 13.662845611572, 270, true)
setElementData(sigaraPed, "talk", 1)
setElementData(sigaraPed, "name", "Cem Kayahan")
setElementFrozen(sigaraPed, true)

local levelEksikMsg = {
	"Şu sıralar pek iş yok, adamım.",
	"İşler biraz kötü, sonra gel."
}

local kabulEtMsg = {
	"Bana uyar, ahbap.",
	"Huh, güzel teklif.",
	"Ne zaman başlıyorum?",
}

local kabulEtmeMsg = {
	"İşim olmaz, adamım.",
	"Daha önemli işlerim var.",
	"Meşgulüm, ahbap.",
}

function sigaraGUI(thePlayer)
	local oyuncuBirlik = getPlayerTeam(thePlayer)
	local birlikTip = getElementData(oyuncuBirlik, "type")

	if (birlikTip) and (birlikTip == 0) or (birlikTip == 1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Cem Kayahan fısıldar: Hey, elimde bir sigara kaçakçılığı işi var. Ne dersin, ha?", 255, 255, 255, 3, {}, true)
		sigaraKabulGUI(thePlayer)
		return
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Cem Kayahan diyor ki: Seninle bir işim yok. Derhal toz ol buradan.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("sigaraGUI", true)
addEventHandler("sigaraGUI", getRootElement(), sigaraGUI)

function sigaraKabulGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local kacakcilikWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Arnisa Roleplay - Sigara Kaçakçılığı", false)
	guiWindowSetSizable(kacakcilikWindow, false)

	local isLbl = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, kacakcilikWindow)
	guiLabelSetHorizontalAlign(isLbl, "center", false)
	guiLabelSetVerticalAlign(isLbl, "center")
	
	local sigaraKabulBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, kacakcilikWindow)
	addEventHandler("onClientGUIClick", sigaraKabulBtn, 
		function()
			destroyElement(kacakcilikWindow)
			setElementData(localPlayer, "job", 10)
			--triggerServerEvent("acceptJob", getLocalPlayer(), 10)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. kabulEtMsg[math.random(#kabulEtMsg)], 255, 255, 255, 3, {}, true)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Cem Kayahan diyor ki: Yandaki arabalardan birini alarak işe başla, araçlar yüklü ve yola çıkmaya hazır. Bol şanslar, ahbap.", 255, 255, 255, 3, {}, true)
			setTimer(function() outputChatBox("[!] #FFFFFFYandaki beyaz kamyonlardan birini alıp, /sigarabasla yazarak işe başlayabilirsiniz!", 0, 0, 255, true) end, 500, 1)
			return	
		end
	)
	
	local line = guiCreateLabel(9, 32, 289, 19, "____________________________________________________", false, kacakcilikWindow)
	guiLabelSetHorizontalAlign(line, "center", false)
	guiLabelSetVerticalAlign(line, "center")
	local sigaraIptalBtn = guiCreateButton(159, 55, 139, 33, "İptal Et", false, kacakcilikWindow)
	addEventHandler("onClientGUIClick", sigaraIptalBtn, 
		function()
			destroyElement(kacakcilikWindow)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. kabulEtmeMsg[math.random(#kabulEtmeMsg)], 255, 255, 255, 3, {}, true)
			return	
		end
	)
end

-- ROTA --
local sigaraMarker = 0
local sigaraCreatedMarkers = {}
local sigaraRota = {
	{ 2482.03125, -2629.1064453125, 13.53261089325, false },
	{ 2446.9423828125, -2660.0361328125, 13.568248748779, false },
	{ 2319.27734375, -2660.283203125, 13.552651405334, false },
	{ 2232.25, -2654.3505859375, 13.425634384155, false },
	{ 2227.921875, -2569.0087890625, 13.446744918823, false },
	{ 2227.669921875, -2498.3359375, 13.398345947266, false },
	{ 2217.1533203125, -2493.4072265625, 13.450009346008, false },
	{ 2168.677734375, -2493.3203125, 13.425221443176, false },
	{ 2158.091796875, -2558.0947265625, 13.420516014099, false },
	{ 2135.1455078125, -2631.9580078125, 13.421311378479, false },
	{ 2065.990234375, -2667.0361328125, 13.430558204651, false },
	{ 1935.8671875, -2667.140625, 6.2325224876404, false },
	{ 1737.57421875, -2667.4599609375, 5.9438934326172, false },
	{ 1455.203125, -2667.34765625, 12.879189491272, false },
	{ 1384.8974609375, -2645.0419921875, 13.430183410645, false },
	{ 1348.373046875, -2505.87890625, 13.424523353577, false },
	{ 1349.3271484375, -2233.525390625, 13.431337356567, false },
	{ 1361.1533203125, -2185.2177734375, 13.432072639465, false },
	{ 1452.46484375, -2134.8291015625, 13.440541267395, false },
	{ 1575.818359375, -2118.7646484375, 16.475286483765, false },
	{ 1668.814453125, -2010.0107421875, 23.263813018799, false },
	{ 1616.3330078125, -1719.1259765625, 28.128015518188, false },
	{ 1612.8818359375, -1505.3984375, 28.637367248535, false },
	{ 1624.2578125, -1314.310546875, 35.424541473389, false },
	{ 1646.58984375, -1138.6865234375, 58.029808044434, false },
	{ 1691.8798828125, -848.744140625, 59.069862365723, false },
	{ 1718.8095703125, -651.8564453125, 42.245864868164, false },
	{ 1718.1591796875, -532.103515625, 34.901767730713, false },
	{ 1680.642578125, -244.5947265625, 42.840175628662, false },
	{ 1643.0146484375, -0.2412109375, 36.655075073242, false },
	{ 1629.6767578125, 138.4345703125, 35.991516113281, false },
	{ 1652.533203125, 234.013671875, 30.116388320923, false },
	{ 1687.546875, 343.0244140625, 30.119819641113, false },
	{ 1711.3828125, 409.4892578125, 30.726974487305, false },
	{ 1753.6484375, 525.1015625, 27.599632263184, false },
	{ 1795.185546875, 673.8310546875, 16.913660049438, false },
	{ 1808.5390625, 788.9404296875, 11.42549610137, false },
	{ 1805.5390625, 842.56640625, 10.69127368927, false },
	{ 1712.0380859375, 854.3876953125, 8.58176898956, false },
	{ 1535.5732421875, 854.3701171875, 6.8626480102539, false },
	{ 1379.6533203125, 859.6220703125, 6.8650703430176, false },
	{ 1277.548828125, 918.134765625, 6.8720278739929, false },
	{ 1228.5380859375, 1110.703125, 6.8634028434753, false },
	{ 1228.6630859375, 1306.384765625, 6.7926335334778, false },
	{ 1229.10546875, 1600.083984375, 6.7831659317017, false },
	{ 1252.6533203125, 1712.2265625, 7.0641078948975, false },
	{ 1299.26171875, 1797.482421875, 10.719590187073, false },
	{ 1151.65234375, 1815.1279296875, 10.725154876709, false },
	{ 1102.4228515625, 1814.978515625, 10.723394393921, false },
	{ 1021.9189453125, 1815.546875, 10.731421470642, false },
	{ 1010.0087890625, 1827.7490234375, 10.731310844421, false },
	{ 1009.849609375, 1937.8544921875, 10.729935646057, false },
	{ 1009.3447265625, 2039.2275390625, 10.720872879028, false },
	{ 1009.5380859375, 2119.2412109375, 10.717095375061, false },
	{ 1031.1376953125, 2130.6142578125, 10.870676040649, false },
	{ 1049.810546875, 2117.2841796875, 10.868873596191 , false },
	
	{ 1049.6455078125, 2087.7138671875, 10.874621391296, true },
	
	{ 1048.818359375, 2061.7236328125, 10.872281074524, false },
	{ 1022.107421875, 2055.6103515625, 10.726941108704, false },
	{ 1004.8486328125, 2029.7548828125, 10.722176551819, false },
	{ 1005.234375, 1969.30078125, 10.720944404602, false },
	{ 1005.1357421875, 1923.025390625, 10.724952697754, false },
	{ 1005.1728515625, 1868.51171875, 10.716765403748, false },
	{ 1005.2451171875, 1841.22265625, 10.712944984436, false },
	{ 1004.8662109375, 1814.748046875, 10.823489189148, false },
	{ 1019.8798828125, 1810.9990234375, 10.722046852112, false },
	{ 1122.6064453125, 1810.904296875, 10.716837882996, false },
	{ 1149.3603515625, 1759.75390625, 9.9823026657104, false },
	{ 1201.287109375, 1674.298828125, 6.7829179763794, false },
	{ 1205.673828125, 1564.9912109375, 6.7928972244263, false },
	{ 1205.3076171875, 1316.9638671875, 6.7846865653992, false },
	{ 1205.2646484375, 1050.3955078125, 6.8621463775635, false },
	{ 1218.8447265625, 969.2216796875, 6.8677387237549, false },
	{ 1337.673828125, 847.3447265625, 6.8671636581421, false },
	{ 1429.109375, 831.3828125, 6.8630113601685, false },
	{ 1611.5029296875, 830.515625, 6.7922797203064, false },
	{ 1770.755859375, 831.3095703125, 10.509192466736, false },
	{ 1785.28125, 799.3447265625, 11.209179878235, false },
	{ 1764.4873046875, 649.83984375, 19.002813339233, false },
	{ 1729.19921875, 533.083984375, 27.608406066895, false },
	{ 1712.173828125, 483.28515625, 30.142780303955, false },
	{ 1668.9130859375, 356.4921875, 30.290616989136, false },
	{ 1640.9306640625, 268.27734375, 30.204326629639, false },
	{ 1628.24609375, 219.720703125, 31.13885307312, false },
	{ 1605.265625, 122.7607421875, 37.06175994873, false },
	{ 1606.859375, 33.2158203125, 37.106342315674, false },
	{ 1652.03125, -80.826171875, 35.917865753174, false },
	{ 1658.228515625, -289.6064453125, 39.93518447876, false },
	{ 1684.9599609375, -448.974609375, 33.306518554688, false },
	{ 1702.095703125, -595.2998046875, 38.134910583496, false },
	{ 1696.1259765625, -680.5263671875, 44.972057342529, false },
	{ 1674.5966796875, -813.9990234375, 56.771564483643, false },
	{ 1624.162109375, -1143.2392578125, 57.515769958496, false },
	{ 1591.11328125, -1377.203125, 28.635932922363, false },
	{ 1590.8447265625, -1471.529296875, 28.637647628784, false },
	{ 1591.134765625, -1583.845703125, 28.631231307983, false },
	{ 1593.421875, -1721.59765625, 28.125461578369, false },
	{ 1625.9541015625, -1883.859375, 25.130577087402, false },
	{ 1640.712890625, -2035.7197265625, 22.227897644043, false },
	{ 1586.0966796875, -2091.2744140625, 17.843048095703, false },
	{ 1484.3720703125, -2114.29296875, 13.621311187744, false },
	{ 1373.4228515625, -2140.2763671875, 13.441955566406, false },
	{ 1329.763671875, -2222.23046875, 13.435853004456, false },
	{ 1329.880859375, -2309.373046875, 13.43249130249, false },
	{ 1329.630859375, -2362.3193359375, 13.42230796814, false },
	{ 1329.53515625, -2431.8291015625, 13.427621841431, false },
	{ 1329.4248046875, -2556.03515625, 13.41931438446, false },
	{ 1344.6015625, -2628.263671875, 13.424646377563, false },
	{ 1438.1494140625, -2686.8642578125, 13.430262565613, false },
	{ 1638.0595703125, -2687.3798828125, 5.9232587814331, false },
	{ 1749.9892578125, -2687.923828125, 5.9500617980957, false },
	{ 1924.3203125, -2687.318359375, 6.0006532669067, false },
	{ 2071.955078125, -2686.330078125, 13.429285049438, false },
	{ 2139.333984375, -2657.5029296875, 13.415898323059, false },
	{ 2177.0263671875, -2579.2880859375, 13.421334266663, false },
	{ 2177.447265625, -2509.16015625, 13.431623458862, false },
	{ 2210.7275390625, -2497.400390625, 13.474890708923, false },
	{ 2222.6044921875, -2580.9921875, 13.472516059875, false },
	{ 2227.16796875, -2656.203125, 13.437391281128, false },
	{ 2338.001953125, -2666.19921875, 13.55504322052, false },
	{ 2461.599609375, -2666.072265625, 13.528089523315, false }, --
	{ 2498.265625, -2612.7841796875, 13.698561668396, true, true }
}

function sigaraBasla(cmd)
	if not getElementData(getLocalPlayer(), "sigaraKacakciligi") then
		local oyuncuBirlik = getPlayerTeam(getLocalPlayer())
		local oyuncuBirlikType = getElementData(oyuncuBirlik, "type")
		local oyuncuBirlikLevel = getElementData(oyuncuBirlik, "birlik_level")
		local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 459
		
		if (oyuncuBirlikType == 0) or (oyuncuBirlikType == 1) and (oyuncuBirlikLevel >= 3) then
			if oyuncuAracModel == kacakciAracModel then
				setElementData(getLocalPlayer(), "sigaraKacakciligi", true)
				updateSigaraRota()
				addEventHandler("onClientMarkerHit", resourceRoot, sigaraRotaMarkerHit)
			end
		end
	else
		outputChatBox("[!] #FFFFFFZaten mesleğe başladınız!", 255, 0, 0, true)
	end
end
addCommandHandler("sigarabasla", sigaraBasla)

function updateSigaraRota()
	sigaraMarker = sigaraMarker + 1
	for i,v in ipairs(sigaraRota) do
		if i == sigaraMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				table.insert(sigaraCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(sigaraCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(sigaraCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function sigaraRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 459 then
				for _, marker in ipairs(sigaraCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updateSigaraRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							sigaraMarker = 0
							triggerServerEvent("sigaraparaVer", hitPlayer, hitPlayer)
							outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /sigarabitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateSigaraRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									updateSigaraRota()
								end, 12000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function sigaraBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local sigaraKacakciligi = getElementData(getLocalPlayer(), "sigaraKacakciligi")
	if pedVeh then
		if pedVehModel == 459 then
			if sigaraKacakciligi then
				exports["global"]:fadeToBlack()
				setElementData(getLocalPlayer(), "sigaraKacakciligi", false)
				for i,v in ipairs(sigaraCreatedMarkers) do
					destroyElement(v[1])
				end
				sigaraCreatedMarkers = {}
				sigaraMarker = 0
				triggerServerEvent("sigaraBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, sigaraRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), sigaraAntiYabanci)
				setTimer(function() exports["global"]:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("sigarabitir", sigaraBitir)

function sigaraAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 459 and vehicleJob == 10 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			cancelEvent()
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
		elseif thePlayer == getLocalPlayer() and playerJob ~= 10 then
			cancelEvent()
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFBu araca binmek için Sigara Kaçakçılığı mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), sigaraAntiYabanci)

function sigaraAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			sigaraBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), sigaraAntiAracTerketme)