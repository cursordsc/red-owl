
addEventHandler('onClientResourceStart', resourceRoot, function()     
	setElementData(localPlayer,"cekici",nil)
	setElementData(localPlayer,"rota:x",nil)
	setElementData(localPlayer,"rota:y",nil)

	local txd = engineLoadTXD('cekici/files/cekiciarac.txd',cekiciarac[1])
    engineImportTXD(txd,cekiciarac[1])
    local dff = engineLoadDFF('cekici/files/cekiciarac.dff',cekiciarac[1])
    engineReplaceModel(dff,cekiciarac[1])
end)

--------------------------------------------

local cekiciped = createPed(16, -2435.2724609375, 510.3232421875, 30.3828125, 0, true)
setPedRotation(cekiciped, 165)
setElementData(cekiciped, "talk", 1)
setElementData(cekiciped, "name", "Buğra Can")
setElementFrozen(cekiciped, true)

function cekiciKontrol()
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	
	if (carlicense==1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Buğra Can diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		cekiciKabul(getLocalPlayer())
    else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Buğra Can diyor ki: Ehliyetin yok la senin. Bir de gelmiş çekici olmak istiyor.", 255, 255, 255, 10, {}, true)
	end
end
addEvent("cekici:meslek", true)
addEventHandler("cekici:meslek", getRootElement(), cekiciKontrol)

function cekiciKabul(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Çekicilik", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			setElementData(localPlayer,"cekici",nil)
			setElementData(localPlayer, "job", 9)
			--triggerServerEvent("acceptJob", getLocalPlayer(), 9)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Buğra Can diyor ki: Çekici hemen ilerde, konumu telefonuna yolladık aracı al gel.", 255, 255, 255, 3, {}, true)
		end)
	
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


local cveh = nil
local cmarker = nil
local vid = nil
local lp = nil

function getElementMatrix(element)
    local rx, ry, rz = getElementRotation(element, "ZXY")
    rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
    local matrix = {}
    matrix[1] = {}
    matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][3] = -math.cos(rx)*math.sin(ry)
    matrix[1][4] = 1
    
    matrix[2] = {}
    matrix[2][1] = -math.cos(rx)*math.sin(rz)
    matrix[2][2] = math.cos(rz)*math.cos(rx)
    matrix[2][3] = math.sin(rx)
    matrix[2][4] = 1
	
    matrix[3] = {}
    matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
    matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
    matrix[3][3] = math.cos(rx)*math.cos(ry)
    matrix[3][4] = 1
	
    matrix[4] = {}
    matrix[4][1], matrix[4][2], matrix[4][3] = getElementPosition(element)
    matrix[4][4] = 1
	
    return matrix
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

function destroyClientElements()
	if isElement(cmarker) then destroyElement(cmarker) end
	--exports["navigation"]:findBestWay(1093.1728515625, 1287.54296875, 10.8203125)
end
addEvent("destroyClientElements",true)
addEventHandler("destroyClientElements",root,destroyClientElements)

function createVehicleMarker()
    local player = getLocalPlayer()
	destroyClientElements()
	vid = math.random(1,#cargoVehicles)
	lp = pickupPos[math.random(1,#pickupPos)]
	cveh = createVehicle(cargoVehicles[vid][1],lp[1],lp[2],lp[3],0,0,lp[4])
	setElementData(cveh, "cekici:arac", 1)
	setElementData(player,"cekici:para",lp[5])
	setElementData(player,"cekici",true)
    setElementFrozen(cveh, true)
	local x,y,z = getPositionFromElementOffset(cveh,0,0,-0.8)
	cmarker = createMarker(x,y,z,"cylinder",7,50,100,100,255)
	setElementData(player, "rota:x", x)
	setElementData(player, "rota:y", y)
	exports["navigation"]:findBestWay(x, y)
end
addEvent("createVehicleMarker",true)
addEventHandler("createVehicleMarker",root,createVehicleMarker)

function createCargoMarker()
	destroyClientElements()
	cmarker = createMarker(dropPos[1],dropPos[2],dropPos[3]-1,"cylinder",4,50,100,100)
end
addEvent("createCargoMarker",true)
addEventHandler("createCargoMarker",root,createCargoMarker)

addEventHandler ( "onClientMarkerHit", getRootElement(), function(oyuncu)
	local player = getLocalPlayer()
	local arac = getPedOccupiedVehicle(localPlayer)
	if oyuncu ~= localPlayer then return end
	if source == cmarker then
		if getElementData(arac, "job") ~= 9 then return end
		if isElement(cveh) then
            outputChatBox("#FF0000[!] #ffffffAraç yükleniyor bekleyiniz...",255,255,255,true)
			setElementFrozen(arac,true)
			toggleAllControls(false)
			setTimer(function(pl)
				triggerServerEvent("pickupVehicle",pl,vid )
				setElementData(player, "cekici:x", -2441.6328125)
				setElementData(player, "cekici:y", 523.00390625)
				exports["navigation"]:findBestWay(-2441.6328125, 523.00390625)
				setElementFrozen(arac,false)
				destroyElement(cmarker)
				destroyElement(cveh)
				toggleAllControls(true)
				exports["infobox"]:addBox("info", "Araç çekiciye yüklendi, otoparka gidiniz.")
			end,3000,1,oyuncu)
            
            if not getElementData(player,"cekici:tasima") then
                setElementData(player,"cekici:tasima",0)
            end
            if not getElementData(player,"cekici:para") then setElementData(player,"cekici:para",0) end
            setElementData(player,"cekici:tasima",getElementData(player,"cekici:tasima") + getElementData(player,"cekici:para"))
		else
            outputChatBox("#FF0000[!] #ffffff Araç indiriliyor bekleyiniz...",255,255,255,true)
			destroyElement(cmarker)
			setElementFrozen(arac,true)
			toggleAllControls(false)
			setTimer(function(pl)
				triggerServerEvent( "endRoute",pl,lp )
				setElementFrozen(arac,false)
				toggleAllControls(true)
				outputChatBox("#FF0000[!] #ffffff Aracı teslim ettin, kazancın :"..getElementData(player,"cekici:tasima").." TL!",255,255,255,true)
				outputChatBox("#FF0000[!] #ffffff Yeni rotaya ilerleyebilir veya /cekicibitir yazarak meslekten ayrılıp paranı alabilirsin!",255,255,255,true)
			end,3000,1,oyuncu)
		end
	end
end)