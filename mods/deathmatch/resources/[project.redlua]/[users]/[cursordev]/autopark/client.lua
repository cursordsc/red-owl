local marker = createMarker (2112.4755859375, -1775.001953125, 12.391904830933, 'cylinder', 3, 30,255,200, 50 )

addEventHandler('onClientResourceStart', resourceRoot, 
    function()
		local ped = Ped(189, 2124.3818359375, -1775.162109375, 13.566202163696)
        ped:setRotation(0,0,87)
        ped:setData('autopark_ped',true)
        ped.frozen = true
    end
)

addEventHandler('onClientClick', root,
	function(b, s, _, _, _, _, _, element)
		if b == 'right' and s == 'down' and element and isElement(element) and element:getData('autopark_ped') then
			triggerEvent('autopark > ped',localPlayer)
		end
	end
)

addEvent('autopark > ped',true)
addEventHandler('autopark > ped',root,
    function()
    if isElement(listGUI) then destroyElement(listGUI) end
	listGUI = guiCreateWindow(0, 0, 500, 328, "Otopark Araçlarım", false)
	guiWindowSetSizable(listGUI, false)
	exports.global:centerWindow(listGUI)
	showCursor(true)
	gridlist = guiCreateGridList(9, 24, 480, 229, false, listGUI)
	guiGridListAddColumn(gridlist, "ID", 0.2)
	guiGridListAddColumn(gridlist, "Araç Adı", 0.5)
    guiGridListAddColumn(gridlist, "Plaka", 0.2)
	for index, value in ipairs(getElementsByType("vehicle")) do
		if (value and isElement(value) and value:getData("owner") == localPlayer:getData("dbid")) and (value.dimension == 333) then
			local row = guiGridListAddRow(gridlist)
			guiGridListSetItemText(gridlist, row, 1, value:getData("dbid"), false, false)
			guiGridListSetItemData(gridlist, row, 1, value, false, false)
			guiGridListSetItemText(gridlist, row, 2, exports.global:getVehicleName(value), false, false)
            guiGridListSetItemText(gridlist, row, 3, value:getData('plate'), false, false)
		end
	end
	requestVehicle = guiCreateButton(9, 256, 480, 29, "Otoparktan Çıkart", false, listGUI)
	closeArray = guiCreateButton(9, 289, 480, 29, "Arayüzü Kapat", false, listGUI)
    end
)

addEventHandler("onClientMarkerHit", marker,
	function(hitPlayer, matchingDimension)
		if (hitPlayer and hitPlayer.type == "player" and hitPlayer == localPlayer) then
			if localPlayer.vehicle then
	        	triggerEvent('autopark > query',hitPlayer)
			end
		end
	end
)

addEvent('autopark > query',true)
addEventHandler('autopark > query', root, 
    function()
        mainPage = guiCreateWindow(0, 0, 410,100, 'Aracınızı bırakacak mısınız?', false)
        exports['global']:centerWindow(mainPage)
        showCursor(true)
        guiWindowSetSizable(mainPage,false)
        text = guiCreateLabel(0.02, 0.3, 0.94, 0.2, "Merhaba eğerki aracınızı otopark'a bırakacaksanız onaylayın.", true, mainPage)
        accept = guiCreateButton(0.5, 0.6, 0.47, 0.3, 'Onayla >>', true, mainPage)
        decline = guiCreateButton(0.0, 0.6, 0.45, 0.3, '<< Reddet', true, mainPage)
        guiLabelSetHorizontalAlign(text,'center')
    end
)

addEventHandler('onClientGUIClick', root, 
    function(btn)
        if source == accept then
            mainPage:destroy()
            showCursor(false)
            triggerServerEvent('autopark > accept',localPlayer,localPlayer)
        elseif source == decline then
            mainPage:destroy()
            showCursor(false)
        elseif source == closeArray then 
            listGUI:destroy()
            showCursor(false)
        elseif source == requestVehicle then
            local selectedIndex = guiGridListGetSelectedItem(gridlist)
            if (selectedIndex) then
                local vehicleElement = guiGridListGetItemText(gridlist, selectedIndex, 1)
                if selectedIndex == -1 then
                    outputChatBox("RED:LUA Scripting:#FFFFFF Lütfen yukarıdan çıkartıcağınız aracı seçiniz.",57,57,57,true)
                else
                    triggerServerEvent('autopark > getcar', localPlayer, vehicleElement)
                    listGUI:destroy()
                    showCursor(false)
                end
            end
        end
    end
)