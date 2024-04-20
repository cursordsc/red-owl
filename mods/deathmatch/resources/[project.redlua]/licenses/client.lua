-- © 2018 needGaming
local renderData = {}

local skinID = 187
local panelState = false
local doingDrive = false 

renderData.sWidth, renderData.sHeight = guiGetScreenSize()
renderData.wWidth, renderData.wHeight = (renderData.sWidth/2) - (765/2), (renderData.sHeight/2) - (340/2)

local panelFont = dxCreateFont("files/font.ttf", 19, false, "cleartype")

local route = {}

route[1] = { 1091.5966796875, -1740.8828125, 13.507639884949 }	-- San Andreas Boulevard DoL near Exit
route[2] = { 1162.4326171875, -1743.6298828125, 13.056522369385 } -- San Andreas Boulevard DoL Exiting turning left
route[3] = { 1181.919921875, -1740.716796875, 13.056303024292 } 	-- Constituion Ave
route[4] = { 1182.11328125, -1724.6015625, 13.123280525208 } -- Constituion Ave, turn to St. Lawrence Blvd
route[5] = { 1246.9765625, -1714.966796875, 13.040835380554 } -- St. Lawrence Blvd
route[6] = { 1284.765625, -1715.24609375, 13.040912628174 } 	-- St. Lawrence Blvd, going to Panopticon Ave
route[7] = { 1294.70703125, -1735.7734375, 13.040860176086 } 	-- St. Lawrence Blvd, going to Panopticon Ave
route[8] = { 1299.7919921875, -1796.8583984375, 13.040873527527 } 	-- St. Lawrence Blvd, going to Panopticon Ave
route[9] = { 1299.63671875, -1839.908203125, 13.040887832642 }	-- St. Lawrence Blvd, turning on to Panopticon Ave
route[10] = { 1305.568359375, -1854.4638671875, 13.040900230408 }	-- Panopticon Ave
route[11] = { 1314.81640625, -1837.453125, 13.040904998779 }	-- Panopticon Ave back on to the opposite side of St. Lawrence Blvd
route[12] = { 1314.6875, -1780.0390625, 13.040893554688 }		-- St. Lawrence Blvd
route[13] = { 1314.81640625, -1746.6767578125, 13.040936470032 }	-- Turning on to City Hall Road
route[14] = { 1375.3037109375, -1734.568359375, 13.040926933289 }	-- City Hall Road
route[15] = { 1489.7236328125, -1734.796875, 13.040790557861 }	-- City Hall Road
route[16] = { 1603.630859375, -1735.201171875, 13.040933609009 }	-- City Hall Road
route[17] = { 1676.9462890625, -1734.8203125, 13.040908813477 }	-- City Hall Road
route[18] = { 1737.8876953125, -1734.48046875, 13.051963806152 }	-- City Hall Road
route[19] = { 1809.451171875, -1734.8310546875, 13.048633575439 }	-- City Hall Road
route[20] = { 1818.73046875, -1745.6708984375, 13.040826797485 } 	-- City Hall Road turning towards IGS
route[21] = { 1834.1904296875, -1754.5888671875, 13.04089641571 } 	-- 
route[22] = { 1897.080078125, -1754.6884765625, 13.040921211243 } 	-- 
route[23] = { 1950.6337890625, -1754.75, 13.040934562683 } 	-- IGS
route[24] = { 1958.93359375, -1765.388671875, 13.04093170166 } 	-- IGS
route[25] = { 1958.9501953125, -1796.953125, 13.040910720825 } -- IGS
route[26] = { 1959.318359375, -1864.236328125, 13.040975570679 } 			-- Mulholland parking, Turn to East Vinewood Blvd
route[27] = { 1959.5322265625, -1920.8408203125, 13.040843963623 } 	-- East Vinewood Blvd, turn to Sunset Blvd
route[28] = { 1975.5859375, -1934.55078125, 13.040920257568 } 	-- Sunset Blvd
route[29] = { 2035.345703125, -1934.552734375, 12.993081092834 } 	-- Sunset Blvd
route[30] = { 2081.056640625, -1933.259765625, 12.98653793335 } 	-- Sunset Blvd
route[31] = { 2084.0556640625, -1908.44140625, 13.040873527527 } 	-- Sunset Blvd, Turn to St. Lawrence Blvd
route[32] = { 2094.1103515625, -1896.759765625, 13.039360046387 } 	-- St. Lawrence Blvd
route[33] = { 2144.1513671875, -1896.83984375, 13.021877288818 } 	-- St. Lawrence Blvd, turn to West Broadway
route[34] = { 2209.2353515625, -1896.3642578125, 13.143925666809 } 	-- West Broadway
route[35] = { 2215.4794921875, -1909.1923828125, 13.018997192383 } -- West Broadway
route[36] = { 2211.541015625, -1954.705078125, 13.013573646545 } 	-- Interstate 25
route[37] = { 2226.396484375, -1974.455078125, 13.03962802887 } 	-- Interstate 25
route[38] = { 2275.2587890625, -1974.48828125, 13.031688690186 } 	-- Interstate 125
route[39] = { 2300.8291015625, -1974.3388671875, 13.052042961121 } 	-- Interstate 125
route[40] = { 2316.04296875, -1959.8779296875, 13.037763595581 } -- Interstate 125
route[41] = { 2314.220703125, -1894.837890625, 13.070441246033 } -- Interstate 125
route[42] = { 2231.1923828125, -1892.0986328125, 13.040887832642 } 	-- Interstate 125
route[43] = { 2221.3203125, -1880.55078125, 13.040870666504 } 		-- Interstate 125, turn to Saints Blvd
route[44] = { 2218.958984375, -1808.5107421875, 12.853454589844 } 	-- Saints Blvd, turn to St Anthony St.
route[45] = { 2218.8408203125, -1749.9638671875, 13.049014091492 } 		-- St Anthony St, turn to Saints Blvd
route[46] = { 2200.9423828125, -1729.6552734375, 13.080856323242 } 	-- Saints Blvd
route[47] = { 2182.611328125, -1737.7724609375, 13.033122062683 } 	-- Saints Blvd
route[48] = { 2171.9072265625, -1749.6826171875, 13.043260574341 } -- Saints Blvd, turn to Caesar Rd
route[49] = { 2106.447265625, -1749.7548828125, 13.059499740601 } 		-- mid turn
route[50] = { 2079.849609375, -1749.712890625, 13.043148994446 } 	-- Caesar Rd
route[51] = { 2015.9228515625, -1749.6708984375, 13.040927886963 } 	-- Caesar Rd
route[52] = { 1965.4052734375, -1749.634765625, 13.040921211243 } 	-- Caesar Rd, turn to Freedom St
route[53] = { 1920.6376953125, -1749.599609375, 13.040939331055 } -- Freedom St
route[54] = { 1867.8623046875, -1750.013671875, 13.040932655334 } 	-- Freedom St, turn to Carson St
route[55] = { 1834.431640625, -1749.693359375, 13.040906906128 } 	-- Carson St
route[56] = { 1824.6025390625, -1739.6240234375, 13.04088306427 } 		-- Carson St, turn to Atlantica Ave
route[57] = { 1824.03515625, -1686.99609375, 13.040928840637 } -- Atlantica Ave
route[58] = { 1823.7958984375, -1626.0556640625, 13.040854454041 } 	-- Atlantica Ave, turn to Pilon St
route[59] = { 1809.00390625, -1609.9560546875, 13.009611129761 } 	-- Pilon St
route[60] = { 1740.1572265625, -1595.8740234375, 13.039266586304 } -- Pilon St
route[61] = { 1646.84765625, -1590.0458984375, 13.055871009827 }	-- St. Joseph St
route[62] = { 1574.384765625, -1590.0244140625, 13.040942192078 }	-- St. Joseph St
route[63] = { 1506.5791015625, -1590.021484375, 13.040884971619 }	-- St. Joseph St
route[64] = { 1442.4072265625, -1590.015625, 13.040890693665 }	-- St. Joseph St, turn to Fremont St
route[65] = { 1417.1259765625, -1590.0146484375, 13.023401260376 }	-- Fremont St, turn to Fame St
route[66] = { 1325.158203125, -1570.3046875, 13.027077674866 }	-- Fame St
route[67] = { 1311.8212890625, -1558.4111328125, 13.3828125 }	-- ROUTE FIX
route[68] = { 1350.1328125, -1402.880859375, 13.320591926575 }	-- ROUTE FIX
route[69] = { 1295.3310546875, -1570.1083984375, 13.3828125 }	-- ROUTE FIX
route[70] = { 1285.12890625, -1569.9150390625, 13.040904998779 }	-- Belview Rd
route[71] = { 1207.41015625, -1570.0712890625, 13.045068740845 }	-- Howard Blvd
route[72] = { 1162.982421875, -1569.6962890625, 12.944114685059 }		-- Howard Blvd, turn to Carson St
route[73] = { 1147.5087890625, -1584.5966796875, 12.997039794922 }	-- Carson St
route[74] = { 1147.919921875, -1699.6806640625, 13.439339637756 }	-- Carson St
route[75] = { 1160.7841796875, -1714.4091796875, 13.433871269226 }	-- Majestic St
route[76] = { 1172.8017578125, -1724.697265625, 13.261546134949 }	-- Majestic St, turn to Park ave
route[77] = { 1162.5517578125, -1738.53515625, 13.150225639343 }		-- Park ave
route[78] = { 1109.314453125, -1738.59375, 13.147988319397 }	-- Park ave
route[79] = { 1085.056640625, -1740.5791015625, 13.152918815613 }	-- DoL End road

renderData.routeCounter = 1


generatedQuestion = false

local questions = {
	{"Yolun hangi tarafından sürmelisin?", "Sol.", "Sağ.", "Fark etmez.", 3},
	{"Trafik ışığı kırmızı yanınca ne yapmalısın?", "Aracı komple durdurmalısın.", "Devam etmelisin.", "Kimse gelmiyorsa devam etmelisin.", 2},
	{"Sürücüler yayalara nerelerde geçiş izni vermelidir?", "Her zaman.", "Özel mülklerde.", "Sadece kaldırımlarda.", 2},
	{"Kamyonun seni göremeyeceği zayıf nokta neresidir?", "Dorsenin arkası.", "Tırın solu.", "Hepsi." , 4},
	{"Arkadan bir acil durum aracı sirenleri yakık geliyor. Ne yapmalısın?", "Yavaşlayıp ilerlemelisin.", "Sağa çekip durmalısın.", "Hızını korumalısın.", 3},
	{"Aynı yönde iki ya da üç şeritli yolda nerede sürmelisin?", "Herhangi bir şeritte.", "Sol şeritte.", "Sollamadığın sürece sağda.", 4}
} 

addEventHandler("onClientResourceStart", getResourceRootElement(), 
	function() 
		local drivingLicensePed = createPed(skinID, -2035.09375, -117.4931640625, 1035.171875)
		setElementInterior(drivingLicensePed, 3)
		setElementDimension(drivingLicensePed, 14)
		setPedRotation(drivingLicensePed, 270)
		setElementFrozen(drivingLicensePed, true)
		setElementData(drivingLicensePed, "ehliyet:ped", true)
	end
)

function renderPanel()
	if panelState then
        exports["blur"]:createBlur()
		showChat(false)
		dxDrawImage(renderData.wWidth, renderData.wHeight, 765, 340, "files/license.png", 0, 0, 0, tocolor(255,255,255,255))

		dxDrawText(questions[generatedQuestion][1], renderData.wWidth + 370, renderData.wHeight + 85, renderData.wWidth + 370, renderData.wHeight + 70, tocolor(255, 255, 255, 204), 0.6, panelFont, "center", "top", false, false, true)
		dxDrawText(questions[generatedQuestion][2], renderData.wWidth + 200, renderData.wHeight + 180, renderData.wWidth + 140, renderData.wHeight + 230, tocolor(255, 255, 255, 153), 0.5, panelFont, "left", "top", false, false, true)
		dxDrawText(questions[generatedQuestion][3], renderData.wWidth + 200, renderData.wHeight + 230, renderData.wWidth + 370, renderData.wHeight + 230, tocolor(255, 255, 255, 153), 0.5, panelFont, "left", "top", false, false, true)
		dxDrawText(questions[generatedQuestion][4], renderData.wWidth + 200, renderData.wHeight + 275, renderData.wWidth + 600, renderData.wHeight + 230, tocolor(255, 255, 255, 153), 0.5, panelFont, "left", "top", false, false, true)
	end 
end

local startedName = false
addEventHandler("onClientClick", getRootElement(), 
	function(button, state, x, y, wx, wy, wz, element) 
		if button and state and state == "down" and isElement(element) and getElementData(element, "ehliyet:ped") and not panelState and not doingDrive then
			if getElementData(localPlayer, "license.car") == 0 and getElementData(localPlayer, "license.bike") == 0 then
				if exports["global"]:hasMoney(localPlayer, 500) then
					addEventHandler("onClientRender", getRootElement(), renderPanel)
					panelState = true 
					generateQuestion()
					exports["infobox"]:addBox("info", "Size çok başarılar diliyoruz...")
					startedName = getElementData(localPlayer, "visibleName")
				else 
					exports["infobox"]:addBox("error", "Yeterli paranız yok!")
				end
			else 
				exports["infobox"]:addBox("error", "Zaten bir ehliyetin var!")
			end 
		end 

		if button and state == "down" and panelState then
			if x >= renderData.wWidth + 160 and x <= renderData.wWidth + 725 then
				if y >= renderData.wHeight + 175 and y <= renderData.wHeight + 205 then
					processAnswering(2)
				end 
			end 

			if x >= renderData.wWidth + 160 and x <= renderData.wWidth + 725 then
				if y >= renderData.wHeight + 220 and y <= renderData.wHeight + 250 then
					processAnswering(3)
				end 
			end 

			if x >= renderData.wWidth + 160 and x <= renderData.wWidth + 725 then
				if y >= renderData.wHeight + 268 and y <= renderData.wHeight + 298 then
					processAnswering(4)
				end 
			end 

			if x >= renderData.wWidth + 700 and x <= renderData.wWidth + 730 then
				if y >= renderData.wHeight + 15 and y <= renderData.wHeight + 45 then
					closePanel()
				end 
			end 
		end 
	end 

)

oldBlip = false
currentMarker = 1

function nextMarker()

	currentMarker = currentMarker + 1
	for k, v in pairs(getElementsByType("marker")) do 
		if getElementData(v, "license") then
			destroyElement(v)
		end 
	end

	for k, v in pairs(getElementsByType("blip")) do 
		if getElementData(v, "license") then
			destroyElement(v)
		end 
	end


	if currentMarker < 80 then
		local startMarker = createMarker(route[currentMarker][1], route[currentMarker][2], route[currentMarker][3], "checkpoint", 4, 255, 255, 255, 255)
		local oldBlip = createBlip(route[currentMarker][1], route[currentMarker][2], route[currentMarker][3], 61)
		setElementData(startMarker, "license", true)
		setElementData(startMarker, "name", "Checkpoint")
		setElementData(oldBlip, "license", true)

		addEventHandler("onClientMarkerHit", startMarker, 
			function(hitPlayer)
				if hitPlayer == localPlayer and getElementModel(getPedOccupiedVehicle(localPlayer)) == 429 and getElementData(getPedOccupiedVehicle(localPlayer), "dbid") == -1 then 
					nextMarker()
					playSoundFrontEnd(12)
				end 
			end
		)
	else 
		finishLicense()
	end
end

function finishLicense()
	triggerServerEvent("finishLicense", getRootElement(), localPlayer)
	exports["infobox"]:addBox("info", "Tebrikler, testi başarıyla tamamladınız. İyi sürüşler!")
	currentMarker = 1
	renderData.routeCounter = 1
	generatedQuestion = false	
	setElementData(localPlayer, "license.car", 1)
	setElementData(localPlayer, "license.bike", 1)
	doPay(2)

	for k, v in pairs(getElementsByType("blip")) do
		if getElementData(v, "license") then
			destroyElement(v)
		end 
	end 

	for k, v in pairs(getElementsByType("marker")) do
		if getElementData(v, "license") then
			destroyElement(v)
		end 
	end
end

local counter = 0
function generateQuestion()
	if panelState then
		
		counter = counter + 1
		
		if counter < 7 then
			repeat
				generatedQuestion = math.random(6)
			until not questions[generatedQuestion][6]		
		else 

		end 
	end 
end

local totalPoints = 0

function processAnswering(number)
	if panelState and number then
		if tonumber(number) == tonumber(questions[generatedQuestion][5]) then
			totalPoints = totalPoints + 10
			playSoundFrontEnd(40)	
		else 
			playSoundFrontEnd(4)		
		end 
		questions[generatedQuestion][6] = true
		if counter < 6 then
			generateQuestion()
		else 
			
			if totalPoints >= 50 then
				exports["infobox"]:addBox("info", "Sınavı başarıyla tamamladın, şimdi test arabasına bin!")
				local startingMarker = createMarker(route[1][1], route[1][2], route[1][3], "checkpoint", 4, 255, 255, 255, 255)
				local startingBlip = createBlip(route[1][1], route[1][2], route[1][3], 61, 1)
				setElementData(startingMarker, "license", true)
				setElementData(startingMarker, "name", "Checkpoint")
				setElementData(startingBlip, "license", true)
				doPay(1)
				removeEventHandler("onClientRender", getRootElement(), renderPanel)
				totalPoints = 0
				panelState = false
				doingDrive = true
				showChat(true)

				addEventHandler("onClientMarkerHit", startingMarker, 
					function(hitPlayer)
						if hitPlayer == localPlayer then
							triggerServerEvent("createLicenseVehicle", getRootElement(), localPlayer)
							nextMarker()
						end
					end 
				)

			else
				exports["infobox"]:addBox("info", "Üzgünüm, sınavı başaramadın!")
				closePanel()
			end 
		end 
	end
end

function doPay(num)
	if num then
		if num == 1 then
			
			if exports["global"]:hasMoney(localPlayer, 250) then
				exports["global"]:takeMoney(localPlayer, 250)
			else 
				exports["infobox"]:addBox("error", "Yeterli paranız yok!")
			end 

		elseif num == 2 then
			
			if exports["global"]:hasMoney(localPlayer, 250) then
				exports["global"]:takeMoney(localPlayer, 250)
			else 
				exports["infobox"]:addBox("error", "Yeterli paranız yok!")
			end			
		end 
	end 
end 

function closePanel()
	if panelState then
	    showChat(true)
		panelState = false
		removeEventHandler("onClientRender", getRootElement(), renderPanel)
		currentMarker = 1
		renderData.routeCounter = 1
		generatedQuestion = false
		counter = 0

		local questions = {
			{"Yolun hangi tarafından sürmelisin?", "Sol.", "Sağ.", "Fark etmez.", 3},
			{"Trafik ışığı kırmızı yanınca ne yapmalısın?", "Aracı komple durdurmalısın.", "Devam etmelisin.", "Kimse gelmiyorsa devam etmelisin.", 2},
			{"Sürücüler yayalara nerelerde geçiş izni vermelidir?", "Her zaman.", "Özel mülklerde.", "Sadece kaldırımlarda.", 2},
			{"Kamyonun seni göremeyeceği zayıf nokta neresidir?", "Dorsenin arkası.", "Tırın solu.", "Hepsi." , 4},
			{"Arkadan bir acil durum aracı sirenleri yakık geliyor. Ne yapmalısın?", "Yavaşlayıp ilerlemelisin.", "Sağa çekip durmalısın.", "Hızını korumalısın.", 3},
			{"Aynı yönde iki ya da üç şeritli yolda nerede sürmelisin?", "Herhangi bir şeritte.", "Sol şeritte.", "Sollamadığın sürece sağda.", 4}
		} 

	end 
end

testVehicle = { [429]=true } 

function UpdateCheckpoints(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("Kontrol noktalarından geçerken bir eğitim aracında olmanız gerekiyor!", 255, 0, 0)
		end
		addEventHandler("onClientMarkerHit", route, UpdateCheckpoints)
	end
end