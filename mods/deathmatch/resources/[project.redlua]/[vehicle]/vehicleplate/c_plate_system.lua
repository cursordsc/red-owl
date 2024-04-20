--Warning, not sure who originally made this but it's very noobish and messy. If you're about to modify this, better remake a new one :< / maxime
local gabby = createPed(150, 1108.587890625, -767.5751953125, 976.25158691406)
setPedRotation(gabby, 180)
setElementDimension(gabby, 6)
setElementInterior(gabby, 5)
setElementData(gabby, "talk", 1)
setElementData(gabby, "name", "Gabrielle McCoy")
setElementFrozen(gabby, true)
setPedAnimation ( gabby, "FOOD", "FF_Sit_Look", -1, true, false, false )

local plateCheck, newplates, efinalWindow = nil

local tonny = createPed(120, 1111.3037109375, -776.2958984375, 976.25158691406)
setPedRotation(tonny, 90)
setElementDimension(tonny, 6)
setElementInterior(tonny, 5)
setElementData(tonny, "talk", 1)
setElementData(tonny, "name", "Tony Johnston")
setElementFrozen(tonny, true)
setPedAnimation ( tonny, "FOOD", "FF_Sit_Look", -1, true, false, false )

function getPaperFromTony(button, state, absX, absY, wx, wy, wz, element)
    if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") then --if it's a right-click on a object
		local pedName = getElementData(element, "name") or "The Storekeeper"
		pedName = tostring(pedName):gsub("_", " ")

        local rcMenu
        if(pedName == "Tony Johnston") then
            rcMenu = exports.rightclick:create(pedName)
            showCursor(true)
            local row = exports.rightclick:addRow("Buy DMV transaction paper - 100$")
            addEventHandler("onClientGUIClick", row,  function (button, state)
            	if exports["global"]:hasMoney(localPlayer, 100) and getElementData(localPlayer, "loggedin") == 1 then
                	triggerServerEvent("givePaperToSellVehicle", getResourceRootElement(), localPlayer)
					showCursor(false)
				else
					outputChatBox("You do not have 100$.")
					showCursor(false)
                end
            end, false)

            local row2 = exports.rightclick:addRow("Close")
            addEventHandler("onClientGUIClick", row2,  function (button, state)
                exports.rightclick:destroy(rcMenu)
                showCursor(false)
            end, false)
        end
    end
end
addEventHandler("onClientClick", getRootElement(), getPaperFromTony, true)

function cBeginGUI()
	local lplayer = getLocalPlayer()
	triggerServerEvent("platePedTalk", lplayer, 1)

	local width, height = 150, 175
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	--greetingWindow = guiCreateWindow(x, y, width, height, "Which are you here for?", false)
	greetingWindow = guiCreateStaticImage(x, y, width, height, ":resources/window_body.png", false)
	local width2, height2 = 10, 10
	local x = scrWidth/2 - (width2/2)
	local y = scrHeight/2 - (height2/2)

	--Buttons
	plates = guiCreateButton(0.1, 0.1, 0.75, 0.2, "Plaka Değiştirme", true, greetingWindow)
	addEventHandler("onClientGUIClick", plates, fetchPlateList)

	register = guiCreateButton(0.1, 0.4, 0.75, 0.2, "Plaka Tescil", true, greetingWindow)
	addEventHandler("onClientGUIClick", register, fetchRegisterList)

	neither = guiCreateButton(0.1, 0.7, 0.75, 0.2, "Çıkış", true, greetingWindow)
	addEventHandler("onClientGUIClick", neither, closeWindow)

	--Quick Settings
	--guiWindowSetSizable(greetingWindow, false)
	--guiWindowSetMovable(greetingWindow, true)
	guiSetVisible(greetingWindow, true)
	showCursor(true)
end
addEvent("cBeginPlate", true)
addEventHandler("cBeginPlate", getRootElement(), cBeginGUI)

function fetchPlateList()
	if (source==plates) then
		destroyElement(greetingWindow)
		triggerServerEvent("platePedTalk", getLocalPlayer(), 3)
		triggerServerEvent("vehicle-plate-system:list", getLocalPlayer())
		showCursor(false)
	end
end

function fetchRegisterList()
	if (source==register) then
		destroyElement(greetingWindow)
		triggerServerEvent("platePedTalk", getLocalPlayer(), 3)
		triggerServerEvent("vehicle-plate-system:registerlist", getLocalPlayer())
		showCursor(false)
	end
end

function PlateWindow(vehicleList)
	local lplayer = getLocalPlayer()

	local width, height = 500, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	mainVehWindow = guiCreateWindow(x, y, width, height, "Araç Plaka Değiştirme", false)

	guiCreateLabel(0.03, 0.08, 2.0, 0.1, "Hangi aracınızın plakasını değiştirmek istersiniz ?", true, mainVehWindow)
	vehlist = guiCreateGridList(0.03, 0.15, 1, 0.73, true, mainVehWindow)

	ovid = guiGridListAddColumn(vehlist, "ID", 0.1)
	ov = guiGridListAddColumn(vehlist, "Araçlar", 0.5)
	ovcp = guiGridListAddColumn(vehlist, "Plakalar", 0.3)


	for i,r in ipairs(vehicleList) do
		local row = guiGridListAddRow(vehlist)
		local vid = r[1]
		local v = r[2]
		--local vm = getElementModel(v)
		guiGridListSetItemText(vehlist, row, ovid, tostring(vid), false, false)
		guiGridListSetItemText(vehlist, row, ov, exports["global"]:getVehicleName(v) , false, false) --tostring(getVehicleNameFromModel(vm))
		guiGridListSetItemText(vehlist, row, ovcp, tostring(getVehiclePlateText(v) or ""), false, false)
	end

	--Buttons
	close = guiCreateButton(0.50, 0.90, 0.50, 0.10, "Çıkış Yap", true, mainVehWindow)
	addEventHandler("onClientGUIClick", close, closeWindow)

	--OnDoubleClick
	addEventHandler("onClientGUIDoubleClick", vehlist, editPlateWindow)

	--Quick Settings
	guiWindowSetSizable(mainVehWindow, false)
	guiWindowSetMovable(mainVehWindow, true)
	guiSetVisible(mainVehWindow, true)

	showCursor(true)
end
addEvent("vehicle-plate-system:clist", true)
addEventHandler("vehicle-plate-system:clist", getRootElement(), PlateWindow)

function registerWindow(vehicleList)
	local lplayer = getLocalPlayer()

	local width, height = 500, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	mainVehWindow = guiCreateWindow(x, y, width, height, "Araç Tescilleme", false)

	guiCreateLabel(0.03, 0.08, 2.0, 0.1, "Hangi aracı kaydettirmek / kaydını silmek istersiniz?", true, mainVehWindow)
	vehlist = guiCreateGridList(0.03, 0.15, 1, 0.73, true, mainVehWindow)

	ovid = guiGridListAddColumn(vehlist, "ID", 0.1)
	ov = guiGridListAddColumn(vehlist, "Araçlar", 0.5)
	ovcp = guiGridListAddColumn(vehlist, "Durum", 0.3)


	for i,r in ipairs(vehicleList) do
		local row = guiGridListAddRow(vehlist)
		local vid = r[1]
		local v = r[2]
		--local vm = getElementModel(v)
		local plateState = getElementData(v, "registered")
		guiGridListSetItemText(vehlist, row, ovid, tostring(vid), false, false)
		guiGridListSetItemText(vehlist, row, ov, exports["global"]:getVehicleName(v) , false, false) --tostring(getVehicleNameFromModel(vm))
		if plateState == 0 then
		guiGridListSetItemText(vehlist, row, ovcp, "Unregistered", false, false)
		else
		guiGridListSetItemText(vehlist, row, ovcp, "Registered", false, false)
		end
	end

	--Buttons
	close = guiCreateButton(0.50, 0.90, 0.50, 0.10, "Exit Screen", true, mainVehWindow)
	addEventHandler("onClientGUIClick", close, closeWindow)

	--OnDoubleClick
	addEventHandler("onClientGUIDoubleClick", vehlist, updateRegistration)

	--Quick Settings
	guiWindowSetSizable(mainVehWindow, false)
	guiWindowSetMovable(mainVehWindow, true)
	guiSetVisible(mainVehWindow, true)

	showCursor(true)
end
addEvent("vehicle-plate-system:rlist", true)
addEventHandler("vehicle-plate-system:rlist", getRootElement(), registerWindow)

function togMainVehWindow(state)
	if mainVehWindow and isElement(mainVehWindow) then
		guiSetEnabled(mainVehWindow, state)
	end
end

local plateCheck, submitNP = nil
function editPlateWindow()
	local sr, sc = guiGridListGetSelectedItem(vehlist)
	svnum = guiGridListGetItemText(vehlist, sr, 1)
	if (source == vehlist) and not (svnum == "") then
		togMainVehWindow(false)
		local width, height = 300, 210
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		efinalWindow = guiCreateStaticImage(x, y, width, height, ":resources/window_body.png", false)
		local mainT = guiCreateLabel(0.03, 0.08, 0.96, 0.2, "Kayıtlı olan araçların: " .. svnum .. ".\nLütfen yeni bir plaka girin:", true, efinalWindow)
		guiLabelSetHorizontalAlign(mainT, "center", true)

		newplates = guiCreateEdit(0.1, 0.3, 0.8, 0.15, "", true, efinalWindow)
		guiEditSetMaxLength(newplates, 9)

		addEventHandler("onClientGUIChanged", newplates, checkPlateBox)

		plateCheck = guiCreateLabel(0, 0.5, 1, 0.1, "Lütfen beğendiğiniz bir plaka seçin.", true, efinalWindow)
		guiLabelSetHorizontalAlign(plateCheck, "center", true)

		--Buttons

		submitNP = guiCreateButton(0.1, 0.60, 0.8, 0.15, "Satın Al!", true, efinalWindow)
		addEventHandler("onClientGUIClick", submitNP, function ()
			if source == submitNP then
				local data = guiGetText(newplates)
				local vehid = tonumber(svnum)
				triggerServerEvent("sNewPlates", getLocalPlayer(), data, vehid)
				guiSetInputEnabled(false)
				destroyElement(mainVehWindow)
				destroyElement(efinalWindow)
				showCursor(false)
			end
		end)
		guiSetEnabled(submitNP, false)

		finalx = guiCreateButton(0.1, 0.80, 0.8, 0.15, "Çıkış Yap", true, efinalWindow)
		addEventHandler("onClientGUIClick", finalx, closeWindow)

		--Quick Settings
		guiSetInputEnabled(true)
		guiSetVisible(efinalWindow, true)
		showCursor(true)

		--Disabled , moving to donor perk
		--guiSetEnabled(submitNP,false)
	end
end

function checkPlateBox()
	local theText = string.upper(guiGetText(source))
		guiSetText(source,theText)
	if checkPlate(theText) then
		guiSetText(plateCheck, "'"..theText.."' geçerli plaka!")
		guiLabelSetColor(plateCheck, 0, 255, 0)
		guiSetEnabled(submitNP, true)
	else
		guiSetText(plateCheck, "'"..theText.."' geçerli değil!")
		guiLabelSetColor(plateCheck, 255, 0, 0)
		guiSetEnabled(submitNP, false)
	end
end

function updateRegistration()
	local sr, sc = guiGridListGetSelectedItem(vehlist)
	svnum = guiGridListGetItemText(vehlist, sr, 1)
	local state = guiGridListGetItemText(vehlist, sr, 3)
	local carname = guiGridListGetItemText(vehlist, sr, 2)
	if (source == vehlist) and not (svnum == "") then
		togMainVehWindow(false)
		local width, height = 300, 210
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		efinalWindow = guiCreateStaticImage(x, y, width, height, ":resources/window_body.png", false)
		local mainT = guiCreateLabel(0.03, 0.08, 0.96, 0.2, (state == "Kayıtsız" and "Kayıtlı" or "Güncelleniyor")..("Araç ID: " .. svnum .. "."), true, efinalWindow)
		guiLabelSetHorizontalAlign(mainT, "center", true)

		local second = guiCreateLabel(0.03, 0.3, 0.96, 0.2, carname, true, efinalWindow)
		guiLabelSetHorizontalAlign(second, "center", true)
		guiSetFont(second, "default-bold-small")
		--Buttons

		local submitNP2 = guiCreateButton(0.1, 0.60, 0.8, 0.15, (state == "Kayıtsız" and "Kayıt Al ($175)" or "Kaydı Sİldir ($50)") , true, efinalWindow)
		addEventHandler("onClientGUIClick", submitNP2, function ()
			if source == submitNP2 then
				triggerServerEvent("sNewReg", getLocalPlayer(),  tonumber(svnum))
				guiSetInputEnabled(false)
				destroyElement(mainVehWindow)
				destroyElement(efinalWindow)
				showCursor(false)
			end
		end)


		if exports["global"]:hasMoney(localPlayer,  state == "Kayıtsız" and 175 or 50 ) then
			guiSetEnabled(submitNP2, true)
		else
			guiSetEnabled(submitNP2, false)
		end

		finalx = guiCreateButton(0.1, 0.80, 0.8, 0.15, "Çıkış Yap", true, efinalWindow)
		addEventHandler("onClientGUIClick", finalx, closeWindow)

		--Quick Settings
		guiSetInputEnabled(true)
		guiSetVisible(efinalWindow, true)
		showCursor(true)
	end
end

function setRegValue()
	if (source==submitNP) then
		local vehid =


		guiSetInputEnabled(false)
		destroyElement(mainVehWindow)
		destroyElement(efinalWindow)
		showCursor(false)
	end
end

function closeWindow()
	if (source==close) then
		showCursor(false)
		destroyElement(mainVehWindow)
		toggleAllControls(true)
		triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	elseif (source==neither) then
		showCursor(false)
		destroyElement(greetingWindow)
		toggleAllControls(true)
		triggerEvent("onClientPlayerWeaponCheck", localPlayer)
		triggerServerEvent("platePedTalk", getLocalPlayer(), 4)
	elseif (source==finalx) then
		guiSetInputEnabled(false)
		destroyElement(mainVehWindow)
		destroyElement(efinalWindow)
		showCursor(false)
		toggleAllControls(true)
		triggerEvent("onClientPlayerWeaponCheck", localPlayer)
		triggerServerEvent("platePedTalk", getLocalPlayer(), 4)
	end
end
