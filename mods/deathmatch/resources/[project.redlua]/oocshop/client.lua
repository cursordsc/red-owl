
marketListesi = {
	{0, "Seviye 1 VIP", "20"},
	{1, "Seviye 2 VIP", "40"},
	{2, "Seviye 3 VIP", "60"},
	{3, "Seviye 4 VIP", "80"},
	{4, "10 Oyun Saati", "10"},
	{5, "Ek Ev Slotu +1", "5"},
	{6, "Ek Araç Slotu +1", "5"},
	{7, "History Sildirme", "2"},
	{8, "Araç Cam Filmi", "10"},
	{9, "Araç Texture Sistemi", "15"},
	{10, "Ek Karakter Slotu +1", "10"},
	{11, "Araç Plaka Değişikliği", "5"},
	{12, "Premium Silah Kasası", "60"},
	{13, "Karakter İsim Değişikliği", "10"},
	{14, "Kullanıcı Adı Değişikliği", "10"},
	{15, "Karakter Yasağı Kaldırma", "20"},
}


aracListesi = {
	-- vehname, price, model, owlmodel, maxspeed, tax
	{"2005 Model Bell 407 (Helikopter)", 250, 487, 413, 340, 0},
	{"Ferrari", 140, 411, 282, 310, 0},
	{"Range Rover", 110, 490, 1010, 290, 0},
	{"Bentley", 85, 503, 1033, 283, 0},
	{"BMW M5", 75, 445, 654, 271, 0},
	{"BMW i8", 65, 411, 282, 260, 0}
}

function getPrivateSettings(booling)
	if (booling == "vehicle") then
		return aracListesi
	end
end

restrictedWeapons = {}
for i=0, 15 do
	restrictedWeapons[i] = true
end
aracListesiRenk = {
	{"Siyah", {0,0,0}},
	{"Beyaz", {255,255,255}},
	{"Kırmızı", {255,0,0}},
	{"Yeşil", {0,255,0}},
	{"Mavi", {0,0,255}},
	{"Sarı", {255,135,0}},
	{"Gri", {90,90,90}}
}



silahListesi = {
	{1, "M4", 250},
	{2, "AK-47", 90},
	{3, "MP5", 65},
	{4, "Shotgun", 65},
	{5, "Tec-9", 65},
	{6, "Uzi", 55},
	{7, "Deagle", 50},
	{8, "Colt45", 30},

}

bandanaListesi = {
	{1, "Sarı Bandana", 30, 124},
	{2, "Yeşil Bandana", 30, 158},
	{3, "Mavi Bandana", 30, 135},
	{4, "Turuncu Bandana", 30, 168},
	{5, "Mor Bandana", 30, 125},
	{6, "Kahverengi Bandana", 30, 136},
	{7, "Açık Mavi Bandana", 30, 122},

}

petListesi = {
	{1, "Beyaz Pitbull", 30, 890},
	{2, "Siyah Pitbull", 30, 891},
	{3, "Gri Pitbull", 30, 892},
	{4, "Golden", 30, 893},
	{5, "Alman Kurdu", 30, 894},
	{6, "Husky", 30, 895},
}


local sx, sy = guiGetScreenSize()
local maintance = false
function marketSistemiAC()
	if getElementData(localPlayer, "loggedin") == 0 then outputChatBox("[-] #ffffffBu komutu karakterinizdeyken kullanabilirsiniz.", 255, 0, 0, true) return end
	triggerServerEvent("market->guncelleBakiye",localPlayer,localPlayer,1)

	setElementData(localPlayer, "marketSistemiAcik", 1)
	showCursor(true)
	guiSetInputEnabled(true)
	
	imageWindow = false
	normalWindow = guiCreateWindow(sx/2-510/2,sy/2-600/2,510,400, "RED:LUAMTA - [/market]", false)
	guiWindowSetSizable(normalWindow, false)
	guiWindowSetMovable(normalWindow, true)

	tab = guiCreateTabPanel(10,24,690,570,false, normalWindow)
	window = guiCreateTab("Premium Özellikler", tab)
	window2 = guiCreateTab("Donate Araçlar", tab)
	window4 = guiCreateTab("Silahlar", tab)
	window5 = guiCreateTab("Bandanalar", tab)


	
	--------------------- BAKIYE YAZISI ---------------------

	bakiyeMiktari = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiyeMiktar").." TL", true, window)

	guiLabelSetHorizontalAlign(bakiyeMiktari, "right", false)

	bakiyeMiktari2 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiyeMiktar").." TL", true, window2)

	guiLabelSetHorizontalAlign(bakiyeMiktari2, "right", false)

	
	bakiyeMiktari4 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiyeMiktar").." TL", true, window4)
	
	guiLabelSetHorizontalAlign(bakiyeMiktari4, "right", false)
	
	bakiyeMiktari5 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiyeMiktar").." TL", true, window5)
	
	guiLabelSetHorizontalAlign(bakiyeMiktari5, "right", false)
	
	---------------------------------------------------------
	
	gridlist5 = guiCreateGridList(0.030, 0.06, 0.94, 0.80, true, window5)
	guiGridListSetSortingEnabled(gridlist5, false)
	guiGridListAddColumn(gridlist5, "İsim", 0.70)
	guiGridListAddColumn(gridlist5, "Fiyat", 0.20)
	for index, value in ipairs(bandanaListesi) do
		local row = guiGridListAddRow(gridlist5)
		guiGridListSetItemText(gridlist5, row, 1, "("..value[1]..") "..value[2], false, false)
		guiGridListSetItemText(gridlist5, row, 2, value[3].." TL", false, false)
	end
	sad = guiCreateLabel(89, 415, 195+60+60, 15, "Üstten seçmiş olduğunuz bandanayı satın alabilirsiniz.", false, window5)
	--guiCreateStaticImage( 250-30-126, 235, 330/1.1, 192/1.0-10, "assets/images/bandana.png", false, window5 )



	onaylaButonu5 = guiCreateButton(0.03, 0.90, 0.45, 0.07, "Seçileni Al", true, window5)
	guiSetFont(onaylaButonu5, "default-bold-small")

	
	kapatButonu5 = guiCreateButton(0.52, 0.90, 0.45, 0.07, "Kapat", true, window5)
	guiSetFont(kapatButonu5, "default-bold-small")


-----
	
	--------------------- SATIS LISTESI ---------------------
	gridlist = guiCreateGridList(0.03, 0.07, 0.94, 0.80, true, window)
	guiGridListSetSortingEnabled(gridlist, false)
	guiGridListAddColumn(gridlist, "İsim", 0.75)
	guiGridListAddColumn(gridlist, "Fiyat", 0.20)
	--guiGridListAddRow(gridlist)
	local urunIndirimler = {}
	for index, value in ipairs(marketListesi) do
		local row = guiGridListAddRow(gridlist)
		guiGridListSetItemText(gridlist, row, 1, value[2], false, false)
		guiGridListSetItemText(gridlist, row, 2, value[3].." TL", false, false)
		if string.find(value[2]:lower(), "yerine") then
			urunIndirimler[#urunIndirimler + 1] = row
		end
	end
	
	stateColor = false
	
	
	onaylaButonu = guiCreateButton(0.03, 0.90, 0.45, 0.07, "Seçileni Al", true, window)
	guiSetFont(onaylaButonu, "default-bold-small")
	indirimTimer = setTimer(
		function()
			if isElement(normalWindow) then
				stateColor = not stateColor
				for i, v in ipairs(urunIndirimler) do
					if stateColor then
						for i=1, 2 do
							guiGridListSetItemColor(gridlist, v, i, 237, 184, 43)
						end
						guiSetProperty (onaylaButonu3, "NormalTextColour", "FFEDB82B")
						guiSetProperty (onaylaButonu4, "NormalTextColour", "FFEDB82B")
					else
						for i=1, 2 do
							guiGridListSetItemColor(gridlist, v, i, 255, 255, 255)
						end
						guiSetProperty (onaylaButonu3, "NormalTextColour", "FFFFFFFF")
						guiSetProperty (onaylaButonu4, "NormalTextColour", "FFFFFFFF")
					end
				end
			else
				killTimer(indirimTimer)
			end
		end,
	700, 0)

	
	kapatButonu = guiCreateButton(0.52, 0.90, 0.45, 0.07, "Kapat", true, window)
	guiSetFont(kapatButonu, "default-bold-small")


	--------------------- SATIS LISTESI VE TAB 2 ---------------------

	gridlist2 = guiCreateGridList(0.030, 0.06, 0.94, 0.60, true, window2)
	guiGridListSetSortingEnabled(gridlist2, false)
	guiGridListAddColumn(gridlist2, "İsim", 0.65)
	guiGridListAddColumn(gridlist2, "Fiyat", 0.24)

	for index, value in ipairs(aracListesi) do
		local row = guiGridListAddRow(gridlist2)
		guiGridListSetItemText(gridlist2, row, 1, value[1], false, false)
		guiGridListSetItemText(gridlist2, row, 2, value[2].." TL", false, false)
	end

	kapatButonu2 = guiCreateButton(0.52, 0.90, 0.45, 0.07, "Kapat", true, window2)
	guiSetFont(kapatButonu2, "default-bold-small")

	araciSatinAlmaButonu = guiCreateButton(0.03, 0.90, 0.45, 0.07, "Seçileni Al", true, window2)


	x,y,z = getCameraMatrix()
	previewObject = createVehicle(503, 0, 0, 0)

	setElementData(previewObject, "alpha", 255)
	setElementDimension(previewObject, 31)

	oPrevElement = exports["opreview"]:createObjectPreview(previewObject, 0, 0, 410, 0.419, 0.519, 0.16, 0.12, true, false)
	--guiSetProperty(scrollbar, "StepSize", "0.0028")


	vehColorCBox = guiCreateButton(0.03,0.70,0.95,0.10, "Araç Rengini Ayarla", true, window2)
	--guiEditSetMaxLength(plateEdit, 12)
	--guiSetEnabled(plateEdit, false)

	infoLabel = guiCreateLabel(0.33, 0.82,0.50, 0.10, "Araç Hız Limiti: Araç Seçilmedi", true, window2)
	
	-- ################################################################################################################
		
	-- ################################################################################################################
	
	--- ###### TAB 4 * SILAHLAR ######---
	
	gridlist41 = guiCreateGridList(0.030, 0.06, 0.94, 0.80, true, window4)
	guiGridListSetSortingEnabled(gridlist41, false)
	guiGridListAddColumn(gridlist41, "İsim", 0.70)
	guiGridListAddColumn(gridlist41, "Fiyat", 0.20)
	for index, value in ipairs(silahListesi) do
		local row = guiGridListAddRow(gridlist41)
		guiGridListSetItemText(gridlist41, row, 1, "("..value[1]..") "..value[2], false, false)
		guiGridListSetItemText(gridlist41, row, 2, value[3].." TL", false, false)
	--	guiGridListSetItemText(gridlist41, row, 3, math.floor(value[3]/3).." TL", false, false)
	end
	
	--guiCreateStaticImage( 256-30-126, 200, 330/1.1, 192/1.0-10, "assets/images/ak47.png", false, window4 )
	--sad = guiCreateLabel(95, 235, 195+90, 15, "Bu arayüzde şu an destek vermiyoruz. Belki yakında.", false, window4)



	onaylaButonu4 = guiCreateButton(0.03, 0.90, 0.45, 0.07, "Satın Al.", true, window4)
	guiSetFont(onaylaButonu4, "default-bold-small")
	guiSetEnabled(onaylaButonu4, true)

	
	kapatButonu4 = guiCreateButton(0.52, 0.90, 0.45, 0.07, "Kapat", true, window4)
	guiSetFont(kapatButonu4, "default-bold-small")

end
addCommandHandler("market", marketSistemiAC)
addCommandHandler("oocmarket", marketSistemiAC)
local inHeritsResource = {}
addEventHandler("onClientRender", root, 
	function()
		if not isElement(normalWindow) and isElement(imageWindow) then
			destroyElement(imageWindow)
		end
		if getElementData(localPlayer, "marketSistemiAcik") == 1 then

			if isElement(bakiyeMiktari) then guiSetText(bakiyeMiktari,  "Bakiye: "..getElementData(localPlayer, "bakiyeMiktar").." TL") end
			if isElement(bakiyeMiktari2) then guiSetText(bakiyeMiktari2,  "Bakiye: "..getElementData(localPlayer, "bakiyeMiktar").." TL") end
			if isElement(bakiyeMiktari3) then guiSetText(bakiyeMiktari3,  "Bakiye: "..getElementData(localPlayer, "bakiyeMiktar").." TL") end
			if isElement(bakiyeMiktari4) then guiSetText(bakiyeMiktari4,  "Bakiye: "..getElementData(localPlayer, "bakiyeMiktar").." TL") end
			if isElement(bakiyeMiktari5) then guiSetText(bakiyeMiktari5,  "Bakiye: "..getElementData(localPlayer, "bakiyeMiktar").." TL") end
			if isElement(bakiyeMiktari6) then guiSetText(bakiyeMiktari6,  "Bakiye: "..getElementData(localPlayer, "bakiyeMiktar").." TL") end
			if isElement(tab) then
				if guiGetSelectedTab(tab) == window2 then
					if getElementData(previewObject, "alpha") ~= 255 then
						setElementData(previewObject, "alpha", 255)
						setElementAlpha(previewObject, 255)
					end
				else
					setElementData(previewObject, "alpha", 0)
				end
			end
			if isElement(plate) then
				if guiCheckBoxGetSelected(plate) then
					guiSetEnabled(plateEdit, true)
				else
					guiSetEnabled(plateEdit, false)
				end
			end
			if isElement(bakiyeEdit) then
				local t = guiGetText(bakiyeEdit)
				
				if tonumber(t) then
					guiSetText(bakiyeDonusecek,"Dönüştürülecek para: $"..exports.global:formatMoney(tonumber(t)*1000))
				else
					guiSetText(bakiyeDonusecek,"Dönüştürülecek para: $0")
				end
			end
			
			for _, v in ipairs({"gui-scrollpane", "gui-checkbox", "gui-combobox", "gui-label", "gui-gridlist", "gui-radiobutton", "gui-edit", "gui-combobox", "gui-memo", "gui-staticimage"}) do
				for _, element in ipairs(getElementsByType(v,normalWindow)) do
					if not inHeritsResource[element] then
						guiSetProperty(element, "InheritsAlpha", "FF000000")
						if getElementType(element) == "gui-edit" or getElementType(element) == "gui-memo" then
							guiSetProperty(element, "NormalTextColour", "FF000000")
						else
							guiSetProperty(element, "NormalTextColour", "FFFFFFFF")
						end
						guiSetProperty(element, "ActiveSelectionColour", "FF545454")
						guiSetAlpha(element, guiGetAlpha(element))
						--guiSetFont(element, fonts[7])

						inHeritsResource[element] = true
					end
				end
			end
			
			
			if isElement(bakiyeCheck) then
				if guiCheckBoxGetSelected(bakiyeCheck) then
					guiSetEnabled(bakiyeDonusturButton, true)
				else
					guiSetEnabled(bakiyeDonusturButton, false)
				end
			end
			
			--[[
			local row = guiComboBoxGetSelected(vehColorCBox)
			local text = guiComboBoxGetItemText(vehColorCBox, row)
			row = row + 1
			if aracListesiRenk[row] then
				r,g,b = unpack(aracListesiRenk[row][2])
				setVehicleColor(previewObject, r or 255,g or 255,b or 255)
				
			end
			]]--
			if isElement(gridlist2) then
				local selectedVehID = guiGridListGetSelectedItem(gridlist2)

				selectedVehID = selectedVehID + 1
				exportedTable = aracListesi[selectedVehID] or false
				if exportedTable then
					guiSetText(infoLabel, "Araç Hızı: "..exportedTable[5].. " km/h - Araç Vergisi: $"..exportedTable[6])
					setElementModel(previewObject, exportedTable[3])

					odencekPara = exportedTable[2]
					--if guiCheckBoxGetSelected(plate) then
						--odencekPara = odencekPara + 5
					
					--end

					guiSetText(araciSatinAlmaButonu, "Seçileni Al ("..odencekPara.." TL)")
				end
			end
		end
	end
)
	
function historySilmeAc()
	historyGUI = guiCreateWindow(0, 0, 299, 116, "History Sildirme (1 Adet : 1 TL)", false)
	guiWindowSetSizable(historyGUI, false)
	exports.global:centerWindow(historyGUI)

	historyAdetEdit = guiCreateEdit(9, 35, 280, 24, "", false, historyGUI)
	addEventHandler("onClientGUIChanged", historyAdetEdit,
		function(edit)
			local text = tonumber(edit.text)
			guiSetText(historyOnayla, "Satın Al ("..text.." TL)")
		end
	)
	guiSetProperty(historyAdetEdit, "ValidationString", "^[0-9]*$")
	guiEditSetMaxLength(historyAdetEdit, 6)
	historyIptal = guiCreateButton(9, 72, 130, 29, "İptal Et", false, historyGUI)
	historyOnayla = guiCreateButton(145, 72, 144, 29, "Satın Al ( 1TL )", false, historyGUI)
end

function camFilmiAC()
	camFilmiGUI = guiCreateWindow(0, 0, 299, 116, "KennedyMTA - Cam Filmi", false)
	guiWindowSetSizable(camFilmiGUI, false)
	exports.global:centerWindow(camFilmiGUI)

	aracIDCamFilm = guiCreateEdit(9, 35, 280, 24, "AraçID", false, camFilmiGUI)
	guiSetProperty(aracIDCamFilm, "ValidationString", "^[0-9]*$")
	guiEditSetMaxLength(aracIDCamFilm, 6)
	camFilmIptal = guiCreateButton(9, 72, 130, 29, "İptal Et", false, camFilmiGUI)
	camFilmOnayla = guiCreateButton(145, 72, 144, 29, "Satın Al ( 10TL )", false, camFilmiGUI)
end

function privateSkinAC()
	privateSkinGUI = guiCreateWindow(0, 0, 299, 116, "KennedyMTA - Private Skin", false)
	guiWindowSetSizable(privateSkinGUI, false)
	exports.global:centerWindow(privateSkinGUI)

	privateSkinLabel = guiCreateLabel(9, 35, 280, 24, "Bir sonraki aşamaya geçmek istiyor musun?", false, privateSkinGUI)
	privateSkinIptal = guiCreateButton(9, 72, 130, 29, "İptal Et", false, privateSkinGUI)
	privateSkinOnayla = guiCreateButton(145, 72, 144, 29, "Satın Al (50 TL)", false, privateSkinGUI)
end

function plakaDegisikligiAC()
    plakaWINDOW = guiCreateWindow(0.38, 0.37, 0.24, 0.28, "KennedyMTA - Araç Plaka Değişikliği", true)
    guiWindowSetSizable(plakaWINDOW, false)
	guiSetInputEnabled(true)

    
    plakaAracID = guiCreateLabel(0.04, 0.09, 0.37, 0.07, "Araç ID:", true, plakaWINDOW)
    guiSetFont(plakaAracID, "default-bold-small")
    plakaAracIDedit = guiCreateEdit(0.04, 0.16, 0.93, 0.13, "", true, plakaWINDOW)
	guiEditSetMaxLength(plakaAracIDedit, 6)
	guiSetProperty(plakaAracIDedit, "ValidationString", "^[0-9]*$")
	
	
    plakaAracWHO = guiCreateLabel(0.04, 0.33, 0.97, 0.07, "Plakayı ne yapmak istersin?", true, plakaWINDOW)
    guiSetFont(plakaAracWHO, "default-bold-small")
    plakaAracYaziEdit = guiCreateEdit(0.04, 0.40, 0.93, 0.12, "", true, plakaWINDOW)
	
	
	
    plakaOnayBOX = guiCreateCheckBox(0.03, 0.69, 0.61, 0.07, "Üstte yazdıklarımı onaylıyorum.", false, true, plakaWINDOW)
	plakaOnayButon = guiCreateButton(0.03, 0.78, 0.46, 0.18, "ONAYLA", true, plakaWINDOW)
	guiSetFont(plakaOnayButon, "default-bold-small")
	
	plakaKapatButon = guiCreateButton(0.51, 0.78, 0.46, 0.18, "KAPAT", true, plakaWINDOW)
    guiSetFont(plakaKapatButon, "default-bold-small")    
end

addEventHandler("onColorPickerOK", root, function(id,hex,r,g,b)
	if isElement(previewObject) then
		setVehicleColor(previewObject, r,g,b)
		rgbTbl = {r,g,b}
		setElementData(localPlayer, "vehDonateColorTable", rgbTbl)
	end
end)

----------------------------- ISIM DEGISTIRME PANELI -----------------------------
function isimDegistirmePaneli()
	showCursor(true)
	guiSetInputEnabled(true)
    isimDegistirmeWINDOW = guiCreateWindow(0.35, 0.39, 0.30, 0.24, "KennedyMTA - İsim Değiştirme Paneli", true)
    guiWindowSetSizable(isimDegistirmeWINDOW, false)

    isimDegistirmeUyariYAZI = guiCreateLabel(0.02, 0.08, 0.97, 0.17, "Lütfen karakter Ad ve Soyadınızı aşağıdaki kutuya\nşu şekilde yazınız. \"Ad Soyad\"", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeUyariYAZI, "default-bold-small")
    guiLabelSetHorizontalAlign(isimDegistirmeUyariYAZI, "center", false)
    guiLabelSetVerticalAlign(isimDegistirmeUyariYAZI, "center")
    isimDegistirmeEditBOX = guiCreateEdit(0.02, 0.26, 0.96, 0.16, "", true, isimDegistirmeWINDOW)
	
	isimDegistirmeComboBOX1 = guiCreateComboBox(0.17, 0.43, 0.31, 0.25, "Cinsiyet Seçin", true, isimDegistirmeWINDOW)
    guiComboBoxAddItem(isimDegistirmeComboBOX1, "Erkek")
    guiComboBoxAddItem(isimDegistirmeComboBOX1, "Bayan")
    isimDegistirmeComboBOX2 = guiCreateComboBox(0.50, 0.43, 0.31, 0.30, "Irk Seçin", true, isimDegistirmeWINDOW)
    guiComboBoxAddItem(isimDegistirmeComboBOX2, "Siyahi")
    guiComboBoxAddItem(isimDegistirmeComboBOX2, "Beyaz")
	guiComboBoxAddItem(isimDegistirmeComboBOX2, "Asyalı")
	
    isimDegistirmeCheckBOX = guiCreateCheckBox(0.05, 0.67, 0.91, 0.10, "Üstteki isimin doğru olduğunu onaylıyorum ve değiştirmek istiyorum.", false, true, isimDegistirmeWINDOW)
    isimDegistirmeOnaylaBUTON = guiCreateButton(0.02, 0.80, 0.46, 0.12, "ONAYLA", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeOnaylaBUTON, "default-bold-small")
    isimDegistirmeKapatBUTON = guiCreateButton(0.51, 0.80, 0.47, 0.12, "KAPAT", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeKapatBUTON, "default-bold-small")
 
end
addEvent("market->isimDegistirmePaneli", true)
addEventHandler("market->isimDegistirmePaneli", root, isimDegistirmePaneli)

function sesler()
playSound("assets/sounds/second.mp3")
end
addEvent("kasa:ses1", true)
addEventHandler("kasa:ses1",root,sesler)
function sesler2()
playSound("assets/sounds/wah.mp3")
end
addEvent("kasa:ses2", true)
addEventHandler("kasa:ses2",root,sesler2)
function sesler3()
playSound("assets/sounds/sad.mp3")
end
addEvent("kasa:ses3", true)
addEventHandler("kasa:ses3",root,sesler3)
function sesler4()
playSound("assets/sounds/pumped.mp3")
end
addEvent("kasa:ses4", true)
addEventHandler("kasa:ses4",root,sesler4)
function sesler5()
playSound("assets/sounds/premiumpump.mp3")
end
addEvent("kasa:ses5", true)
addEventHandler("kasa:ses5",root,sesler5)


----------------------------- ISIM DEGISTIRME PANELI -----------------------------
function kisimDegistirmePaneli()
	showCursor(true)
	guiSetInputEnabled(true)
    isimDegistirmeWINDOW = guiCreateWindow(0.35, 0.39, 0.30, 0.24, "KennedyMTA - Kullanıcı Adı Değiştirme Paneli", true)
    guiWindowSetSizable(isimDegistirmeWINDOW, false)

    isimDegistirmeUyariYAZI = guiCreateLabel(0.02, 0.08, 0.97, 0.17, "Lütfen yeni bir kullanıcı adı belirleyin.", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeUyariYAZI, "default-bold-small")
    guiLabelSetHorizontalAlign(isimDegistirmeUyariYAZI, "center", false)
    guiLabelSetVerticalAlign(isimDegistirmeUyariYAZI, "center")
    isimDegistirmeEditBOX = guiCreateEdit(0.02, 0.26, 0.96, 0.16, "", true, isimDegistirmeWINDOW)
	
    isimDegistirmeCheckBOX = guiCreateCheckBox(0.05, 0.67, 0.91, 0.10, "Üstteki isimin doğru olduğunu onaylıyorum ve değiştirmek istiyorum.", false, true, isimDegistirmeWINDOW)
    kisimDegistirmeOnaylaBUTON = guiCreateButton(0.02, 0.80, 0.46, 0.12, "ONAYLA", true, isimDegistirmeWINDOW)
    guiSetFont(kisimDegistirmeOnaylaBUTON, "default-bold-small")
    isimDegistirmeKapatBUTON = guiCreateButton(0.51, 0.80, 0.47, 0.12, "KAPAT", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeKapatBUTON, "default-bold-small")
end
addEvent("market->kisimDegistirmePaneli", true)
addEventHandler("market->kisimDegistirmePaneli", root, kisimDegistirmePaneli)

function kisimDegistirmePanelAC()
	if exports.integration:isPlayerEGO(localPlayer) then
		triggerEvent("market->kisimDegistirmePaneli", localPlayer)
	end
end
addCommandHandler("kisimac", kisimDegistirmePanelAC)
----------------------------------------------------------------------------------


VIPNUMARA = nil
----------------------------- VIP SATIN ALMA PANEL -----------------------------
function vipSatinAlmaPANEL(vipNumara)
VIPNUMARA = vipNumara
	if getElementData(localPlayer, "vipver") == vipNumara or getElementData(localPlayer, "vipver") == 0 or not getElementData(localPlayer, "vipver") then
	
		setElementData(localPlayer, "vipSatinAlmaPanel", 1)
		showCursor(true)
		guiSetInputEnabled(true)
		
		vipSatinAlmaWINDOW = guiCreateWindow(0.36, 0.37, 0.29, 0.19, "KennedyMTA - VIP ["..vipNumara.."] Satın Alma Paneli", true)
        guiWindowSetSizable(vipSatinAlmaWINDOW, false)
		
		vipSatinAlmaYazi1 = guiCreateLabel(0.03, 0.15, 0.38, 0.19, "Kaç günlük VIP istiyorsun?", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaYazi1, "default-bold-small")
        guiLabelSetHorizontalAlign(vipSatinAlmaYazi1, "center", false)
        guiLabelSetVerticalAlign(vipSatinAlmaYazi1, "center")   
        vipSatinAlmaEditBOX = guiCreateEdit(0.43, 0.14, 0.12, 0.20, "", true, vipSatinAlmaWINDOW)
		
        vipSatinAlmaYazi2 = guiCreateLabel(0.02, 0.34, 0.95, 0.18, "* TL karşılığında, * günlük VIP ["..vipNumara.."] satın alacaksınız. \Kabul ediyor musunuz?", true, vipSatinAlmaWINDOW)
		
		addEventHandler("onClientRender", root, 
		function()
			if getElementData(localPlayer, "vipSatinAlmaPanel") == 1 then
				local gunSayisi = math.floor(tonumber(guiGetText(vipSatinAlmaEditBOX)))
				if not gunSayisi or gunSayisi < 0 then
					guiSetText(vipSatinAlmaEditBOX,"")
				end
				if vipNumara == 1 then
					if gunSayisi ~= nil then
						vipFiyat = 20 / 30 * gunSayisi
					end
				elseif vipNumara == 2 then
					if gunSayisi ~= nil then
						vipFiyat = 40 / 30 * gunSayisi
					end
				elseif vipNumara == 3 then
					if gunSayisi ~= nil then
						vipFiyat = 60 / 30 * gunSayisi
					end
				elseif vipNumara == 4 then
					if gunSayisi ~= nil then
						vipFiyat = 80 / 30 * gunSayisi
					end
				end
				if gunSayisi == nil then
					guiSetText(vipSatinAlmaYazi2, " TL karşılığında, * günlük VIP ["..vipNumara.."] alacaksınız. \nKabul ediyor musunuz?")
				else
					guiSetText(vipSatinAlmaYazi2, math.ceil(vipFiyat).." TL karşılığında, "..gunSayisi.." günlük VIP ["..vipNumara.."] alacaksınız. \nKabul ediyor musunuz?")
				end
			end
		end
		)
		
        guiSetFont(vipSatinAlmaYazi2, "default-bold-small")
        guiLabelSetHorizontalAlign(vipSatinAlmaYazi2, "center", false)
        guiLabelSetVerticalAlign(vipSatinAlmaYazi2, "center")
        vipSatinAlmaOnaylaBUTON = guiCreateButton(0.02, 0.55, 0.47, 0.38, "ONAYLA", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaOnaylaBUTON, "default-bold-small")
        vipSatinAlmaKapatBUTON = guiCreateButton(0.51, 0.55, 0.47, 0.38, "KAPAT", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaKapatBUTON, "default-bold-small")
	else
		outputChatBox("[-] #ffffffAncak sadece sahip olduğunuz VIP seviyesinin aynısını satın alabilir ve süre uzatabilirsiniz.", 255, 0, 0, true)
	end
end
addEvent("market->vipSatinAlma", true)
addEventHandler("market->vipSatinAlma", root, vipSatinAlmaPANEL)

addEventHandler("onClientGUIChanged", guiRoot, function() 
	if not(source == vipSatinAlmaEditBOX) then return false end
	local text = guiGetText(source) or "" 
	if not tonumber(text) then --if the text isn't a number (statement needed to prevent infinite loop) 
		guiSetText(source, string.gsub(text, "%a", "")) --Remove all letters 
	end
end)


function vipAlmaPanelAC()
	if exports.integration:isPlayerEGO(localPlayer) then
		triggerEvent("market->vipSatinAlma", localPlayer, 3)
	end
end
addCommandHandler("vipac", vipAlmaPanelAC)


addEventHandler("onClientGUIClick", guiRoot, function()
	------------------ MARKET ------------------
	if source == araciSatinAlmaButonu then

		-- araç satın alma
		local selectedVehID = guiGridListGetSelectedItem(gridlist2)
		
		if selectedVehID == -1 then
			outputChatBox("[-] #ffffffAlacak bir araba seçmediniz, ayrıca unutmayın alacağınız arabanın rengini ayarlayabilirsiniz.", 255, 0, 0, true)
			return false
		end
		selectedVehID = selectedVehID + 1
		exportedTable = aracListesi[selectedVehID] or false	-- vehname, price, model, owlmodel, maxspeed, tax

		if exportedTable then
			bakiye = getElementData(localPlayer, "bakiyeMiktar")
			alincakMiktar = exportedTable[2]
			if guiCheckBoxGetSelected(plate) then
				plateState = true
				alincakMiktar = alincakMiktar + 5
				if isElement(plateEdit) then
					plateText = guiGetText(plateEdit)
				else
					plateText = ""
				end
			else
				playerteState = false
				alincakMiktar = exportedTable[2]
				plateText = ""
			end

			if bakiye < alincakMiktar then
				outputChatBox("[-] #ffffffYeterli bakiyeniz bulunmadığı için aracı alamazsınız. [ Senin "..alincakMiktar-bakiye.." TL'ye daha ihtiyacın var. ]", 255, 0, 0, true)
				return
			end

			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
			
				if oPrevElement then
					exports["opreview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)

			--fonksiyon çıktısı: player, araçid, owlid, renk, kesilcek bakiye
			rgbTble = getElementData(localPlayer,"vehDonateColorTable")
			triggerServerEvent("market->donateSatinAl", localPlayer, exportedTable[3], exportedTable[4], rgbTble or {255, 255, 255}, alincakMiktar, exportedTable[1], plateState, plateText)
		else
			outputChatBox("[-] #ffffffAlacak bir araba seçmediniz, ayrıca unutmayın alacağınız arabanın rengini ayarlayabilirsiniz.", 255, 0, 0, true)
		end
	elseif source == kapatButonu or source == kapatButonu2 or source == kapatButonu3 or source == kapatButonu4 or source == kapatButonu5 or source == kapatButonu6 then
		destroyElement(normalWindow)
		showCursor(false)
		if isElement(previewObject) then
			destroyElement(previewObject)
			
			if oPrevElement then
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			
		end
		showCursor(false)
		guiSetInputEnabled(false)
		setElementData(localPlayer, "marketSistemiAcik", 0)
	elseif source == vehColorCBox then
		openPicker(1,"FFFFFF","Araç Rengini Ayarlayın")
	elseif source == onaylaButonu6 then
		local siraCek = guiGridListGetSelectedItem(gridlist6)
		local isimCek = guiGridListGetItemText(gridlist6, siraCek, 1)
		local fiyatCek = guiGridListGetItemText(gridlist6, siraCek, 2)
	elseif source == onaylaButonu then
		local siraCek = guiGridListGetSelectedItem(gridlist)
		local isimCek = guiGridListGetItemText(gridlist, siraCek, 1)
		local fiyatCek = guiGridListGetItemText(gridlist, siraCek, 2)
		
		if siraCek == 0 then --isimDegisikligi
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				if oPrevElement then
					exports["opreview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			setElementData(localPlayer, "marketSistemiAcik", 0)
			
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 10 then
				outputChatBox("[-] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
			return false
			end
			triggerEvent("market->isimDegistirmePaneli", localPlayer)
		return false
		elseif siraCek == 1 then --VIP 1
			triggerEvent("market->vipSatinAlma", localPlayer, 1)
		return false
		elseif siraCek == 2 then --VIP 2
			triggerEvent("market->vipSatinAlma", localPlayer, 2)
		return false
		elseif siraCek == 3 then --VIP 3
			triggerEvent("market->vipSatinAlma", localPlayer, 3)
		return false
		elseif siraCek == 4 then --VIP 4
			triggerEvent("market->vipSatinAlma", localPlayer, 4)
		return false
		elseif siraCek == 5 then --Kullanıcı Adı Değişikliği
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			
			setElementData(localPlayer, "marketSistemiAcik", 0)
			
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 10 then
				outputChatBox("[-] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
			return false
			end
			--triggerEvent("donators:showUsernameChange", localPlayer, 16)
			triggerEvent("market->kisimDegistirmePaneli", localPlayer)

			return
		elseif siraCek == 6 then
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			
			setElementData(localPlayer, "marketSistemiAcik", 0)
			
			plakaDegisikligiAC()
		elseif siraCek == 7 then--Araç Cam Filmi
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 10 then
				outputChatBox("[-] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
			return false
			end
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			
			setElementData(localPlayer, "marketSistemiAcik", 0)
			
			camFilmiAC()
		elseif siraCek == 8 then--Neon Sistemi
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
			triggerEvent('neon->showList', localPlayer)
		elseif siraCek == 9 then
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
			triggerEvent('vehicletexture->showList', localPlayer)

		elseif siraCek == 10 then -- Araç Limit Arttırma
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 5 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için 5 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			outputChatBox("[-] #ffffffTebrikler, başarıyla 5 TL karşılığı Araç Limiti arttırma satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("market->aracSlot", localPlayer, localPlayer, 5)
			return false
		elseif siraCek == 11 then
			local bakiyeCek = tonumber(getElementData(getLocalPlayer(), "bakiyeMiktar"))
			if bakiyeCek < 1 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için en az 1 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			
			setElementData(getLocalPlayer(), "marketSistemiAcik", 0)
			historySilmeAc()
		elseif siraCek == 12 then
			local bakiyeCek = tonumber(getElementData(getLocalPlayer(), "bakiyeMiktar"))
			if bakiyeCek < 20 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için en az 20 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			
			setElementData(getLocalPlayer(), "marketSistemiAcik", 0)
			ckActirma()
			return false
		elseif siraCek == 13 then -- Ev Limit Arttırma
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 5 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için 5 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			outputChatBox("[-] #ffffffTebrikler, başarıyla 5 TL karşılığı Ev Limiti arttırma satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("market->evSlot", localPlayer, localPlayer, 5)
			return false
		elseif siraCek == 14 then -- Silah Kasası
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 25 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için 25 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			outputChatBox("[-] #ffffffTebrikler, başarıyla 25 TL karşılığı 'Silah Kasası' satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("market->silahKasasi", localPlayer, localPlayer, 5)
			return false		
		elseif siraCek == 15 then -- Premium Silah Kasası
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 60 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için 60 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			outputChatBox("[-] #ffffffTebrikler, başarıyla 60 TL karşılığı 'Premium Silah Kasası' satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("market->premiumsilahKasasi", localPlayer, localPlayer, 5)
			return false				
		
		elseif siraCek == 16 then -- Sınırsız Tamir Kiti
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 25 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için 25 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			if getElementData(localPlayer, "tamirKit") == 1 then
				outputChatBox("[-] #ffffffZaten bu özelliğe sahipsiniz.", 255, 0, 0, true)
			return false
			end
			
			outputChatBox("[-] #f9f9f9Tebrikler, başarıyla 25 TL karşılığı 'Sınırsız Tamir Kiti' özelliği satın aldınız.", 0, 255, 0, true)
			outputChatBox("Kullanım: #f9f9f9Aracın içerisinde /tamirkit yazınız.", 255, 235, 102, true)
			triggerServerEvent("market->sinirsizTamirKiti", localPlayer, localPlayer, 5)
			return false	
		elseif siraCek == 17 then -- 10 Oyun Saati
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 10 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için 10 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			
			outputChatBox("[-] #f9f9f9Tebrikler, başarıyla 10 TL karşılığı '10 Oyun Saati' özelliği satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("market->anlikOyunSaati", localPlayer, localPlayer, 5)
			return false		
		elseif siraCek == 18 then -- Karakter Slotu
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 10 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için 10 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			outputChatBox("[-] #ffffffTebrikler, başarıyla 10 TL karşılığı Karakter Limiti arttırma satın aldınız.", 0, 255, 0, true)
			outputChatBox("[-] #f9f9f9Toplam Karakter Açabilme Hakkınız: "..(getElementData(localPlayer, "charlimit") or 1), 230, 14, 14, true)
			triggerServerEvent("market->karakterSlot", localPlayer, localPlayer, 5)
			return false	
		elseif siraCek == 19 then -- Private Skin
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 50 then
				outputChatBox("[-] #ffffffBu işlem için 50 TL ve üstünde bakiyenizin olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
			return false
			end
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			
			setElementData(localPlayer, "marketSistemiAcik", 0)
			
			privateSkinAC()
		elseif siraCek == 20 then -- Karakter Slotu
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < 15 then
				outputChatBox("[-] #ffffffBu işlemi yapabilmek için 15 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			outputChatBox("[-] #ffffffTebrikler, başarıyla 15 TL karşılığı Bilardo Masası satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("market->bilardoMasasi", localPlayer, localPlayer, 15)			
		end		
	elseif (source == gridlist3) then
		local selectedIndex = guiGridListGetSelectedItem(gridlist3)
		if selectedIndex ~= -1 then
			index = tostring(guiGridListGetItemData(gridlist3, selectedIndex, 1))
--			guiStaticImageLoadImage(image, ":cr_pet/files/"..index..".png")
			selectedPet = index
		end
	elseif source == onaylaButonu3 then
		--pet satın alma.
	
	    bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
		if bakiyeCek < 30 then
			outputChatBox("[-] #ffffffBu işlem için 30 TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
			return false
		end
		local petKutuID = guiGridListGetSelectedItem(gridlist3)
        if petKutuID < 0 then outputChatBox("[-] #ffffffLütfen alacağınız ürünü seçiniz.", 255, 0, 0, true) return end
        petKutuID = petKutuID+1
		tablecik = petListesi[petKutuID]
        triggerServerEvent( "bakiye:pet",localPlayer, tablecik[2], tablecik[4], tablecik[3])
		destroyElement(normalWindow)
		if isElement(previewObject) then
			destroyElement(previewObject)
			if oPrevElement then
				exports["opreview"]:destroyObjectPreview(oPrevElement)
			end
			
		end
		showCursor(false)
		guiSetInputEnabled(false)
		setElementData(localPlayer, "marketSistemiAcik", 0)
		triggerServerEvent("pet:create", localPlayer, localPlayer, skinID, pedName, false)
		----------------------------
		--triggerEvent("pet:create", localPlayer)
		--triggerServerEvent("market->petSatinAl", localPlayer, localPlayer, selectedPetID)
	elseif source == onaylaButonu4 then
		--silah satın alma
		--silahın sıra ID'sini çekme
			local selectedGunID, row = guiGridListGetSelectedItem(gridlist41)
			--eğer row 2 ise silah alma, 3 ise hak ekletme
			if selectedGunID == -1 then
				outputChatBox("[-] #ffffffAlmak ekletmek istediğiniz silahı seçmediniz.", 255, 0, 0, true)
				return
			end

			selectedGunID = selectedGunID + 1 -- tabloya eşitleme.

			gunTable = silahListesi[selectedGunID]-- gunTable[1] = pet'in idsi, gunTable[2] = pet'adı önemsiz, gunTable[3] = fiyatı yanii 30

			bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < gunTable[3] then
				outputChatBox("[-] #ffffffBu işlem için "..gunTable[3].." TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				return false
			end
			----------------------------
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				if oPrevElement then
					exports["opreview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
			----------------------------
			triggerServerEvent("market->silahSatinAl", localPlayer, localPlayer, gunTable[2], gunTable[3], selectedGunID, row)
	------------- BANDANA --------------
		elseif source == onaylaButonu5 then
        local bandanaKutuID = guiGridListGetSelectedItem(gridlist5)
        if bandanaKutuID < 0 then outputChatBox("[-] #ffffffLütfen alacağınız ürünü seçiniz.", 255, 0, 0, true) return end
        bandanaKutuID = bandanaKutuID+1
		bTable = bandanaListesi[bandanaKutuID]
        triggerServerEvent( "bakiye:bandana",localPlayer, bTable[2], bTable[4], bTable[3])
		--bakiye:kasa
	------------------ ISIM DEGISTIRME PANEL ------------------
	elseif source == isimDegistirmeKapatBUTON then
		destroyElement(isimDegistirmeWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == kisimDegistirmeOnaylaBUTON then
		local editBOX = tostring(guiGetText(isimDegistirmeEditBOX))
		if editBOX == "" then
			outputChatBox("[-] #ffffffLütfen bir kullanıcı adı girin.", 255, 0, 0, true)
		return
		end
		if guiCheckBoxGetSelected(isimDegistirmeCheckBOX) then
			triggerServerEvent( "market->kisimDegistirOnayla", localPlayer, editBOX )
			destroyElement(isimDegistirmeWINDOW)
			guiSetInputEnabled(false)
			showCursor(false)
		else
			outputChatBox("[-] #ffffffKutucuğu işaretlemeniz gerekmektedir.", 255, 0, 0, true)
		end
	elseif source == isimDegistirmeOnaylaBUTON then
		local editBOX = tostring(guiGetText(isimDegistirmeEditBOX))
		if editBOX == "" then
			outputChatBox("[-] #ffffffKarakter Ad ve Soyad giriniz.", 255, 0, 0, true)
		return
		end


		
		--local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
		--if bakiyeCek <= 10 then
		--	outputChatBox("[-] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
		--	return
		--end
		local secim1 = guiComboBoxGetSelected(isimDegistirmeComboBOX1)
		local text1 = guiComboBoxGetItemText(isimDegistirmeComboBOX1, secim1)
		
		if text1 == "Cinsiyet Seçin" then
			outputChatBox("[-] #ffffffLütfen Cinsiyet seçimi yapınız.", 255, 0, 0, true)
		return
		end
		
		local secim2 = guiComboBoxGetSelected(isimDegistirmeComboBOX2)
		local text2 = guiComboBoxGetItemText(isimDegistirmeComboBOX2, secim2)
		
		if text2 == "Irk Seçin" then
			outputChatBox("[-] #ffffffLütfen Irk seçimi yapınız.", 255, 0, 0, true)
		return
		end
		
		if guiCheckBoxGetSelected(isimDegistirmeCheckBOX) then
			if text1 == "Erkek" then
				setElementData(localPlayer, "gender", 0)
			elseif text1 == "Bayan" then
				setElementData(localPlayer, "gender", 1)
			end
			
			if text2 == "Siyahi" then
				setElementData(localPlayer, "race", 0)
			elseif text2 == "Beyaz" then
				setElementData(localPlayer, "race", 1)
			elseif text2 == "Asyalı" then
				setElementData(localPlayer, "race", 2)
			end
			
			triggerServerEvent( "market->isimDegistirOnayla", localPlayer, editBOX )
			destroyElement(isimDegistirmeWINDOW)
			guiSetInputEnabled(false)
		else
			outputChatBox("[-] #ffffffKutucuğu işaretlemeniz gerekmektedir.", 255, 0, 0, true)
		end
	------------------ VIP ALMA PANEL ------------------
	elseif source == vipSatinAlmaKapatBUTON then
		setElementData(localPlayer, "vipSatinAlmaPanel", 0)
		destroyElement(vipSatinAlmaWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == vipSatinAlmaOnaylaBUTON then
		--triggerServerEvent("market->vipVer", localPlayer, vipSeviye, vipGun)
		local gunSayisi = math.floor(tonumber(guiGetText(vipSatinAlmaEditBOX)))
				if not gunSayisi or gunSayisi < 0 then
					guiSetText(vipSatinAlmaEditBOX,"")
					gunSayisi = 0
				end
		if VIPNUMARA == 1 then
			if gunSayisi ~= nil then
				vipFiyat = 20 / 30 * gunSayisi
			end
		elseif VIPNUMARA == 2 then
			if gunSayisi ~= nil then
				vipFiyat = 40 / 30 * gunSayisi
			end
		elseif VIPNUMARA == 3 then
			if gunSayisi ~= nil then
				vipFiyat = 60 / 30 * gunSayisi
			end
		elseif VIPNUMARA == 4 then
			if gunSayisi ~= nil then
				vipFiyat = 80 / 30 * gunSayisi
			end
		end
		if VIPNUMARA >= 1 and VIPNUMARA <= 4 then
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCek < math.ceil(vipFiyat) then
				outputChatBox("[-] #ffffffBu işlem için "..math.ceil(vipFiyat).." TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
				destroyElement(vipSatinAlmaWINDOW)
				setElementData(localPlayer, "vipSatinAlmaPanel", 0)
			return false
			end
			if gunSayisi == 0 then
				outputChatBox("[-] #ffffffGün sayısı 0 olamaz.", 255, 0, 0, true)
			return
			end
			
			if gunSayisi < 10 then
				outputChatBox("[-] #ffffffGün sayısı 10'dan küçük olamaz.", 255, 0, 0, true)
			return
			end
			
			setElementData(localPlayer, "vipSatinAlmaPanel", 0)
			triggerServerEvent("market->vipVer", localPlayer, VIPNUMARA, gunSayisi, math.ceil(vipFiyat))
			outputChatBox("[-] #ffffffTebrikler, "..math.ceil(vipFiyat).." TL karşılığında "..gunSayisi.." günlük VIP ["..VIPNUMARA.."] satın aldınız.", 0, 255, 0, true)
			
			--triggerServerEvent("market->vipVer", localPlayer, VIPNUMARA, math.floor(gunSayisi*1.5), math.ceil(vipFiyat))
			--outputChatBox("[-] #ffffffTebrikler, "..math.ceil(vipFiyat).." TL karşılığında "..math.floor(gunSayisi*1.5).." günlük VIP ["..VIPNUMARA.."] satın aldınız.", 0, 255, 0, true)
			showCursor(false)
			guiSetInputEnabled(false)
			destroyElement(vipSatinAlmaWINDOW)
		end
	elseif source == camFilmIptal then
		destroyElement(camFilmiGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == privateSkinIptal then
		destroyElement(privateSkinGUI)
		showCursor(false)
		guiSetInputEnabled(false)	
	elseif source == historyIptal then
		destroyElement(historyGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == historyOnayla then
		triggerServerEvent("market->clearHistory", localPlayer, localPlayer, guiGetText(historyAdetEdit))
		destroyElement(historyGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == camFilmOnayla then
		local plakaEditBOX = tostring(guiGetText(aracIDCamFilm))
		if plakaEditBOX == "" then
			outputChatBox("[-] #ffffffAraç ID kısmını doldurunuz.", 255, 0, 0, true)
			return
		end
		local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
		if bakiyeCek < 10 then
			outputChatBox("[-] #ffffffYeterli paranız yok.", 255, 0, 0, true)
			return
		end
		triggerServerEvent("market->camFilm", localPlayer, plakaEditBOX)
		destroyElement(camFilmiGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == privateSkinOnayla then
		local bakiyeCek = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
		if bakiyeCek < 50 then
			outputChatBox("[-]#f9f9f9 Bunu yapabilecek paranız yok. Bakiye yüklemek için sitemize ulaşınız.", 255, 0, 0, true)
			return
		end
		triggerServerEvent("market->privateSkin", localPlayer, localPlayer, 5)
		destroyElement(privateSkinGUI)
		showCursor(false)
		guiSetInputEnabled(false)		
	elseif source == plakaKapatButon then 
		destroyElement(plakaWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == plakaOnayButon then
		--onay islemleri 
		local plakaEditBOX = tostring(guiGetText(plakaAracIDedit))
		if plakaEditBOX == "" then
			outputChatBox("[-] #ffffffAraç ID kısmını doldurunuz.", 255, 0, 0, true)
		return
		end
		
		local plakaEditBOX2 = tostring(guiGetText(plakaAracYaziEdit))
		if plakaEditBOX2 == "" then
			outputChatBox("[-] #ffffffPlakaya yazılacak yazı kısmını doldurunuz.", 255, 0, 0, true)
		return
		end
		
		if guiCheckBoxGetSelected(plakaOnayBOX) == true then
			local bakiyeCekPlaka = tonumber(getElementData(localPlayer, "bakiyeMiktar"))
			if bakiyeCekPlaka < 5 then
				outputChatBox("[-] #ffffffBakiye yetersiz.", 255, 0, 0, true)
			return
			end
			destroyElement(plakaWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
			triggerServerEvent("market->setVehiclePlate", localPlayer, localPlayer, plakaEditBOX2, plakaEditBOX, 5)--buraya
			
		else
			outputChatBox("[-] #ffffffKutucuğu işaretlemeniz gerekmektedir.", 255, 0, 0, true)
		end
	end
	-----------------------------------------------------
end)

function isimnextStage(stage)
	if stage == 1 then
		if isElement(isimDegistirmeWINDOW) then
			destroyElement(isimDegistirmeWINDOW)
		end
		triggerEvent("ulkePaneliniAc", localPlayer)
		showCursor(false)
	end
end
addEvent("market->isimDegistirmeAsama",true)
addEventHandler("market->isimDegistirmeAsama",root,isimnextStage)

addEventHandler("onClientResourceStop", resourceRoot, function()
if isElement(previewObject) then
	destroyElement(previewObject)
	
	if oPrevElement then
		exports["opreview"]:destroyObjectPreview(oPrevElement)
	end
	
end
end)


function isInBox(xS,yS,wS,hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*sx, cursorY*sy
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end

local find = {}
local supportedVehicles = {
    ["Blade"] = "",
    ["Broadway"] = "",
    ["Elegy"] = "",
    ["Flash"] = "",
    ["Jester"] = "",
    ["Remington"] = "",
    ["Savanna"] = "",
    ["Slamvan"] = "",
    ["Sultan"] = "",
    ["Tornado"] = "",
    ["Uranus"] = "",
}
function find:vehicle(vehicleID)
	for i,v in ipairs(getElementsByType('vehicle')) do
		if (tonumber(v:getData('dbid')) == tonumber(vehicleID)) then
			return v
		end
	end
	return false
end
local function checkLength( value )
	return value and #value >= 0 and #value <= 165
end

local allowedImageHosts = {
	["imgim.com"] = true,
}
local imageExtensions = {
	[".jpg"] = true,
	[".jpeg"] = true,
	[".png"] = true,
}
function verifyImageURL(url)
	if string.find(url, "http://", 1, true) or string.find(url, "https://", 1, true) then
		local domain = url:match("[%w%.]*%.(%w+%.%w+)") or url:match("^%w+://([^/]+)")
		if allowedImageHosts[domain] then
			local _extensions = ""
			for extension, _ in pairs(imageExtensions) do
				if _extensions ~= "" then
					_extensions = _extensions..", "..extension
				else
					_extensions = extension
				end
				if string.find(url, extension, 1, true) then
					return true
				end
			end			
		end
	end
	return false
end
addCommandHandler("arackaplama",
	function(cmd)
		if getElementData(localPlayer, "loggedin") == 1 and localPlayer.vehicle then
			if tonumber(localPlayer.vehicle:getData("owner")) == tonumber(localPlayer:getData("dbid")) then
			
				if #localPlayer.vehicle:getData("textures") > 0 then
					triggerEvent("vehicletexture->showList", localPlayer, localPlayer.vehicle:getData("dbid"))
				end
			end
		end
	end
)
addEvent("vehicletexture->showList", true)
addEventHandler("vehicletexture->showList", root,
    function(vehID)
        if isElement(vehicleTextureGUI) then return end
		--if not exports.integration:isPlayerEGO(localPlayer) then return end
        vehicleTextureGUI = guiCreateWindow(0, 0, 571, 246, "Araç Kaplama Sistemi", false)
        guiWindowSetSizable(vehicleTextureGUI, false)
		exports.global:centerWindow(vehicleTextureGUI)
		guiSetInputEnabled(true)
        linkLabel = guiCreateLabel(10, 27, 83, 25, "Kaplama Linki:", false, vehicleTextureGUI)
        guiLabelSetVerticalAlign(linkLabel, "center")
        linkEdit = guiCreateEdit(95, 24, 275, 28, "", false, vehicleTextureGUI)
        linkLabel2 = guiCreateLabel(380, 27, 47, 25, "Araç ID:", false, vehicleTextureGUI)
        guiLabelSetVerticalAlign(linkLabel2, "center")
        vehEdit = guiCreateEdit(432, 24, 129, 28, "", false, vehicleTextureGUI)
        letsTry = guiCreateButton(375, 60, 186, 31, "Hemen Dene", false, vehicleTextureGUI)
        linkLabel3 = guiCreateLabel(98, 65, 267, 20, "Aracında nasıl gözüktüğünü merak mı ediyorsun?", false, vehicleTextureGUI)
        order = guiCreateButton(278, 203, 283, 33, "Satın Al (20TL)", false, vehicleTextureGUI)
        close = guiCreateButton(9, 204, 263, 32, "Arayüzü Kapat", false, vehicleTextureGUI)
        linkLabel4 = guiCreateLabel(5, 91, 566, 19, "------------------------------------------------------------------------------------------------------------------------------------------", false, vehicleTextureGUI)
        guiSetFont(linkLabel4, "default-bold-small")
        linkLabel5 = guiCreateLabel(8, 110, 396, 16, "Kendin mi düzenlemek istiyorsun? Desteklenen araçların linki işte burada:", false, vehicleTextureGUI)
        supportedCombobox = guiCreateComboBox(9, 130, 198, 74, "", false, vehicleTextureGUI)
        for i, v in pairs(supportedVehicles) do
            guiComboBoxAddItem(supportedCombobox, i)
        end
        copyLink = guiCreateButton(217, 126, 205, 27, "Linki Kopyala", false, vehicleTextureGUI)    
		if vehID then
			guiSetEnabled(copyLink, false)
			guiSetEnabled(supportedCombobox, false)
			guiSetEnabled(vehEdit, false)
			vehEdit.text = vehID;
			guiSetEnabled(letsTry, false)
			guiSetText(order, "Değiştir (5TL)")
		end
        addEventHandler("onClientGUIClick", root,
            function(b)
                if (b == "left") then
                    if (source == close) then
                        destroyElement(vehicleTextureGUI)
						guiSetInputEnabled(false)
						if isElement(tempVehicle) then
							destroyElement(tempVehicle)
							if isTimer(tempVehicleTimer) then
								killTimer(tempVehicleTimer)
							end
						end
                    elseif (source == order) then
                        local link, vehID = guiGetText(linkEdit), tonumber(guiGetText(vehEdit))
                        if verifyImageURL(link) then
                            if find:vehicle(vehID) then
                                local vehicle = find:vehicle(vehID);
                                if (tonumber(vehicle:getData("owner")) == tonumber(localPlayer:getData("dbid"))) then
									if isElement(tempVehicle) then
										destroyElement(tempVehicle)
										if isTimer(tempVehicleTimer) then
											killTimer(tempVehicleTimer)
										end
									end
									guiSetInputEnabled(false)
									destroyElement(vehicleTextureGUI)
									local texnames = engineGetModelTextureNames(tostring(vehicle.model))
									for k,v in ipairs(texnames) do
										if string.find(v:lower(), "#") then
											foundedTexture = v
										end
									end
									triggerServerEvent("market->setVehicleTexture", localPlayer, localPlayer, vehID, link, foundedTexture)
                                else
                                    outputChatBox("[-]#ffffff Araç size ait değil.", 255, 0, 0, true)
                                end
                            else
                                outputChatBox("[-]#ffffff Araç bulunamadı.", 255, 0, 0, true)
                            end
                        else
                            outputChatBox("[-]#ffffff Geçersiz bir URL girdiniz veya girdiğiniz site sunucuyu desteklemiyor.", 255, 0, 0, true)
                            outputChatBox("[-]#ffffff Desteklenen resim yükleme sunucuları: ", 255, 0, 0, true)
                            for i, v in pairs(allowedImageHosts) do
                                outputChatBox("[-]#ffffff "..i, 255, 0, 0, true)
                            end
                        end
                    elseif (source == letsTry) then
                        local link, vehID = guiGetText(linkEdit), tonumber(guiGetText(vehEdit))
                        if verifyImageURL(link) then
                            if find:vehicle(vehID) then
                                local vehicle = find:vehicle(vehID);
                                if (tonumber(vehicle:getData("owner")) == tonumber(localPlayer:getData("dbid"))) then
									if isTimer(tempVehicleTimer) or isElement(tempVehicle) then outputChatBox("[-]#ffffff Zaten önizlemede bir aracın var, 30 saniye sonra silinecek.", 255, 0, 0, true) return end --killTimer(tempVehicle) end
									local x, y, z = getElementPosition(localPlayer)
									local rx, ry, rz = getElementRotation(localPlayer)
									x = x + ( ( math.cos ( math.rad (  rz ) ) ) * 1.5 )
									y = y + ( ( math.sin ( math.rad (  rz ) ) ) * 1.5 )
									tempVehicle = createVehicle(vehicle.model, x, y, z)
									tempVehicle.frozen = true
									tempVehicle.dimension = localPlayer.dimension
									setElementCollisionsEnabled(tempVehicle, false)
									setVehicleColor(tempVehicle, 255, 255, 255)
									local texnames = engineGetModelTextureNames(tostring(tempVehicle.model))
									for k,v in ipairs(texnames) do
										if string.find(v:lower(), "#") then
											foundedTexture = v
										end
									end
									exports['item-texture']:addTexture(tempVehicle, foundedTexture, link)
									tempVehicleTimer = Timer(destroyElement, 1000*30, 1, tempVehicle)
                                else
                                    outputChatBox("[-]#ffffff Araç size ait değil.", 255, 0, 0, true)
                                end
                            else
                                outputChatBox("[-]#ffffff Araç bulunamadı.", 255, 0, 0, true)
                            end
                        else
                            outputChatBox("[-]#ffffff Girdiğiniz site çerezleri bu sunucuyu desteklemiyor.", 255, 0, 0, true)
                            outputChatBox("[-]#ffffff Desteklenen resim yükleme siteleri; ", 255, 0, 0, true)
                            for i, v in pairs(allowedImageHosts) do
                                outputChatBox("[-]#ffffff "..i, 255, 0, 0, true)
                            end
                        end
                    elseif (source == copyLink) then
                        local item = guiComboBoxGetSelected(supportedCombobox)
                        local selectedVehicle = tostring(guiComboBoxGetItemText(supportedCombobox, item))
                        setClipboard(supportedVehicles[selectedVehicle])
                        outputChatBox("[-]#ffffff Resim linki başarıyla kopyalandı.", 0, 255, 0, true)
                    end
                end
            end
        )
	end
)
local birlikDuzenleme = {
    edit = {},
    button = {},
    window = {},
    label = {},
    radiobutton = {}
}

function uncbanPlayer()
	
end

function birlikAdiDuzenle()
	birlikDuzenleme.window[1] = guiCreateWindow(0, 0, 359, 292, "Birliğini Yeniden Adlandır", false)
	guiWindowSetSizable(birlikDuzenleme.window[1], false)
	exports.global:centerWindow(birlikDuzenleme.window[1])
	local team = getPlayerTeam(localPlayer)
	local teamName = getElementData(team, "name")
	local teamType = getElementData(team, "type")
	if teamType == 0 then
		turAdi = "Çete"
	elseif teamType == 1 then
		turAdi = "Mafya"
	elseif teamType == 6 then
		turAdi = "Haber"
	elseif teamType == 7 then
		turAdi = "Sanayi"
	elseif teamType == 5 then
		turAdi = "Diğer"
	end

	birlikDuzenleme.button[1] = guiCreateButton(184, 251, 165, 31, "Satın Al (10TL)", false, birlikDuzenleme.window[1])
	birlikDuzenleme.button[2] = guiCreateButton(9, 251, 165, 31, "İptal Et", false, birlikDuzenleme.window[1])
	birlikDuzenleme.label[1] = guiCreateLabel(170, 46, 14, 177, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n", false, birlikDuzenleme.window[1])
	guiLabelSetHorizontalAlign(birlikDuzenleme.label[1], "center", false)
	birlikDuzenleme.label[2] = guiCreateLabel(26, 29, 111, 17, "Eski Özellikler:", false, birlikDuzenleme.window[1])
	guiLabelSetHorizontalAlign(birlikDuzenleme.label[2], "center", false)
	birlikDuzenleme.label[3] = guiCreateLabel(213, 29, 111, 17, "Yeni Özellikler:", false, birlikDuzenleme.window[1])
	guiLabelSetHorizontalAlign(birlikDuzenleme.label[3], "center", false)
	birlikDuzenleme.label[4] = guiCreateLabel(10, 59, 150, 36, "Birlik Adı: "..teamName, false, birlikDuzenleme.window[1])
	birlikDuzenleme.edit[1] = guiCreateEdit(190, 75, 159, 21, "", false, birlikDuzenleme.window[1])
	birlikDuzenleme.label[5] = guiCreateLabel(189, 53, 160, 17, "Birlik Adı:", false, birlikDuzenleme.window[1])
	birlikDuzenleme.label[6] = guiCreateLabel(10, 105, 150, 36, "Birlik Türü: "..turAdi, false, birlikDuzenleme.window[1])
	birlikDuzenleme.label[7] = guiCreateLabel(189, 106, 160, 17, "Birlik Türü:", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[1] = guiCreateRadioButton(187, 131, 162, 15, "Çete", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[2] = guiCreateRadioButton(187, 152, 162, 17, "Mafya", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[3] = guiCreateRadioButton(187, 175, 162, 17, "Haber", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[4] = guiCreateRadioButton(187, 196, 162, 17, "Sanayi", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[5] = guiCreateRadioButton(187, 216, 162, 17, "Diğer", false, birlikDuzenleme.window[1])
	guiRadioButtonSetSelected(birlikDuzenleme.radiobutton[5], true)
	addEventHandler("onClientGUIClick", root, 
		function(b)
			if b == "left" then
				if source == birlikDuzenleme.button[1] then
					if birlikDuzenleme.edit[1].text == "" then
						outputChatBox("[-]#ffffff Birlik adını giriniz.", 255, 0, 0, true)
					return end
					if guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[1]) then
						birlikType = 0
					elseif guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[2]) then
						birlikType = 1
					elseif guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[3]) then
						birlikType = 6
					elseif guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[4]) then
						birlikType = 7
					elseif guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[5]) then
						birlikType = 5
					end
					triggerServerEvent("market->changeFactionSettings", localPlayer, localPlayer, birlikDuzenleme.edit[1].text, birlikType) 
					destroyElement(birlikDuzenleme.window[1])
					showCursor(false)
					guiSetInputEnabled(false)
				elseif source == birlikDuzenleme.button[2] then
					destroyElement(birlikDuzenleme.window[1])
					showCursor(false)
					guiSetInputEnabled(false)
				end
			end
		end
	)
end

local CKClass = {
	edit = {},
	button = {},
	window = {},
	label = {},
	gridlist = {}
}

function ckActirma()
	if not isElement(CKClass.window[1]) then
		CKClass.window[1] = guiCreateWindow(676, 413, 579, 225, "Karakter Yasaklaması Açtırma", false)
		guiWindowSetSizable(CKClass.window[1], false)
		exports.global:centerWindow(CKClass.window[1])
		guiSetInputEnabled(true)
		triggerServerEvent("market->receiveInactiveCharacters", localPlayer)
		CKClass.button[1] = guiCreateButton(10, 183, 261, 32, "Arayüzü Kapat", false, CKClass.window[1])
		CKClass.button[2] = guiCreateButton(281, 183, 288, 32, "Karakter Yasaklamasını Aç", false, CKClass.window[1])
		CKClass.label[1] = guiCreateLabel(9, 29, 262, 18, "Yasaklı Karakterlerinin Listesi:", false, CKClass.window[1])
		guiLabelSetHorizontalAlign(CKClass.label[1], "center", false)
		CKClass.gridlist[1] = guiCreateGridList(9, 53, 262, 120, false, CKClass.window[1])
		guiGridListAddColumn(CKClass.gridlist[1], "Karakter Adı", 0.5)
		guiGridListAddColumn(CKClass.gridlist[1], "Yasaklama Sebebi", 0.5)
		CKClass.label[2] = guiCreateLabel(294, 29, 262, 18, "Seçili Karaktere Göz Atalım:", false, CKClass.window[1])
		guiLabelSetHorizontalAlign(CKClass.label[2], "center", false)
		CKClass.label[3] = guiCreateLabel(288, 153, 271, 20, "Ödenecek Tutar: N/A TL", false, CKClass.window[1])
		guiLabelSetHorizontalAlign(CKClass.label[3], "center", false)
		CKClass.edit[1] = guiCreateEdit(292, 116, 267, 27, "Yeni Karakter Adı", false, CKClass.window[1])
		guiSetEnabled(CKClass.edit[1], false)
		CKClass.label[4] = guiCreateLabel(292, 55, 264, 47, "Karakter yasaklanma admin banı\nise 20TL, rolsel ölüm ise isim\ndeğişikliği ile beraber 30TL alınır.", false, CKClass.window[1])
		guiLabelSetHorizontalAlign(CKClass.label[4], "center", false)
	end
end

addEvent("market->sendInactiveCharacters", true)
addEventHandler("market->sendInactiveCharacters", root,
	function(tbl)
		for i, v in ipairs(tbl) do
			local row = guiGridListAddRow(CKClass.gridlist[1])
			guiGridListSetItemText(CKClass.gridlist[1], row, 1, v.charactername, false, false)
			guiGridListSetItemData(CKClass.gridlist[1], row, 1, v.id, false, false)
			guiGridListSetItemText(CKClass.gridlist[1], row, 2, v.activeDescription, false, false)
			
		end
	end
)

addEventHandler("onClientGUIClick", root,
	function(b)
		if (b == "left") then
			if (source == closeBrowser) then
				destroyElement(browserWindow)
				guiSetInputEnabled(false)
				showCursor(false)
			elseif (source == CKClass.button[1]) then
				destroyElement(CKClass.window[1])
				guiSetInputEnabled(false)
				showCursor(false)
			elseif (source == CKClass.edit[1]) then
				guiSetText(CKClass.edit[1], "")
			elseif (source == CKClass.button[2]) then
				local row = guiGridListGetSelectedItem( CKClass.gridlist[1])
				if row ~= -1 then
					local name = guiGridListGetItemText( CKClass.gridlist[1], row, 1)
					local charid = guiGridListGetItemData( CKClass.gridlist[1], row, 1)
					local reason = guiGridListGetItemText( CKClass.gridlist[1], row, 2)
					if guiGetEnabled(CKClass.edit[1]) == true then
						editBOX = tostring(guiGetText(CKClass.edit[1]))
						if editBOX == "" then
							outputChatBox("[-] #ffffffLütfen bir karakter adı girin.", 255, 0, 0, true)
						return
						end
					else
						editBOX = false
					end
					destroyElement(CKClass.window[1])
					guiSetInputEnabled(false)
					showCursor(false)


					triggerServerEvent("market->unBanCK", localPlayer, localPlayer, editBOX, charid, reason, name)
				end
			elseif (source == CKClass.gridlist[1]) then
				local row = guiGridListGetSelectedItem( CKClass.gridlist[1])
				if row ~= -1 then
					local name = guiGridListGetItemText( CKClass.gridlist[1], row, 1)
					local reason = guiGridListGetItemText( CKClass.gridlist[1], row, 2)
					if reason == "CK" or reason == "Karakter Ölümü" then
						guiSetEnabled(CKClass.edit[1], true)
						guiSetText(CKClass.label[3], "Ödenecek Tutar: 30 TL")
					else
						guiSetEnabled(CKClass.edit[1], false)
						guiSetText(CKClass.label[3], "Ödenecek Tutar: 20 TL")
					end
					guiSetText(CKClass.label[2], "Seçili Karaktere Göz Atalım: "..name)
				else
					guiSetEnabled(CKClass.edit[1], false)
					guiSetText(CKClass.label[3], "Ödenecek Tutar: N/A TL")
					guiSetText(CKClass.label[2], "Seçili Karaktere Göz Atalım: ")
				end
				guiSetText(CKClass.edit[1], "Karakter Adınızı Girin")
			else
				if isElement(CKClass.edit[1]) then
					guiSetText(CKClass.edit[1], "Karakter Adınızı Girin")
				end
			end
		end
	end
)