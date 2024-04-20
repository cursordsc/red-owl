-- RED:LUA Scripting
local vehicleCreatorPoint = {1660.453125, -1892.2724609375, 13.552103996277}
local screenX, screenY = guiGetScreenSize()
local wx, wy = 950, 600
local left = (screenX/2) - (wx/2)
local top = (screenY/2) - (wy/2)

local vehicleCreatorMarker = false
local jobId = 4
local jobVehicleId = 408
local carriedTrashes = {}
local timerFunction = {}
local trashBlips = {}
local carryStop = false
local trash = {}
local trashes = 0

local copGirisNPC = createPed(16, 1673.3369140625, -1884.2373046875, 13.546875, 90 ,true)
setElementData(copGirisNPC, "talk", 1)
setElementData(copGirisNPC, "name", "Emir Aslankurt")
setElementFrozen(copGirisNPC, true)

function copGirisGUI()
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	
	if (carlicense==1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Emir Aslankurt diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		copAcceptGUI(getLocalPlayer())
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Emir Aslankurt diyor ki: La genç, senin araba ehliyetin yok? Alıverip öyle gel hadi bakayim.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("meslek:copGUI", true)
addEventHandler("meslek:copGUI", getRootElement(), copGirisGUI)

function copAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Çöp Toplayıcısı", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			setElementData(localPlayer, "job", 4)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Emir Aslankurt diyor ki: Çöp arabalarından birini al ve hemen rota üzerindeki çöpleri topla!", 255, 255, 255, 3, {}, true)
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
			if not isElement(vehicleCreatorMarker) then
				vehicleCreatorMarker = createMarker(vehicleCreatorPoint[1], vehicleCreatorPoint[2], vehicleCreatorPoint[3]-1, "cylinder", 3, 208, 101, 29, 255)
			end

			setElementData(localPlayer, "meslek:aracta", false)
			setElementData(localPlayer, "meslek:cop_calisiyor", false)
		end
	end
)

addEventHandler("onClientMarkerHit", getRootElement(),
	function (hitElement)
		if hitElement == localPlayer then
			if source == vehicleCreatorMarker then
				if not isPedInVehicle(localPlayer) then
					if not getElementData(localPlayer, "meslek:aracta") then
						triggerServerEvent("onClientHitTrashMarker", localPlayer, localPlayer, jobVehicleId)
						setElementData(localPlayer, "meslek:aracta", true)
						setTimer(function()
							setElementData(localPlayer, "meslek:cop_calisiyor", true)
						end, 3000, 1)
						outputChatBox("[BİLGİ]:#ffffff İşe başlamak ve aracınızı teslim almak için haritada ki #6E6E6E'kamyon'#ffffff simgesine gidin.", 208, 101, 29, true)
						createTrash()
						createtrashblip()
						setMarkerColor(vehicleCreatorMarker, 124, 9, 9)
					else
						triggerServerEvent("destroyTrashVehicle", localPlayer)
						setElementData(localPlayer, "meslek:aracta", false)
						setElementData(localPlayer, "meslek:cop_calisiyor", false)
						setMarkerColor(vehicleCreatorMarker, 208, 101, 29)
					    exports["infobox"]:addBox("info", "İş aracın silindi!")
						destroyTrashElements()
					end
				else
					local theVehicle = getPedOccupiedVehicle(localPlayer)
					local communal = getElementData(localPlayer, "karisik")
					local paper = getElementData(localPlayer, "kagit")
					local glass = getElementData(localPlayer, "cam")
					if getElementData(localPlayer, "meslek:aracta") and getElementData(localPlayer, "meslek:cop_calisiyor") and getElementData(theVehicle, "meslek:aracim") == localPlayer and getElementData(theVehicle, "meslek") then
						triggerServerEvent("destroyTrashVehicle", localPlayer)
						local coppara = 1
						if getElementData(theVehicle, "meslek:cop_type") == 1 then
						    paid = communal*coppara
						    loss = (paper+glass)*10
						elseif getElementData(theVehicle, "meslek:cop_type") == 2 then
						    paid = paper*coppara
						    loss = (communal+glass)*10
						elseif getElementData(theVehicle, "meslek:cop_type") == 3 then
						    paid = glass*coppara
						    loss = (communal+paper)*10
						end

						if tonumber(paid) > 0 then
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

							triggerServerEvent("giveMoney", localPlayer, localPlayer, paid+ekpara)
							exports["infobox"]:addBox("info", "Aracı teslim ettin, net kazancın: ".. paid+ekpara .."$.")
						else
							exports["infobox"]:addBox("error", "Hiç iş yapmadığın için VIP kazancını alamadın!")
						end
						
						setElementData(localPlayer, "meslek:aracta", false)
						setElementData(localPlayer, "meslek:cop_calisiyor", false)
						setMarkerColor(vehicleCreatorMarker, 208, 101, 29)
						destroyTrashElements()
					end
				end
			end
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == localPlayer then
			if dataName == "job" then
				local newValue = getElementData(source, "job") or 0
				if newValue then
					if newValue == jobId then
						if not isElement(vehicleCreatorMarker) then
							vehicleCreatorMarker = createMarker(vehicleCreatorPoint[1], vehicleCreatorPoint[2], vehicleCreatorPoint[3], "checkpoint", 4, 208, 101, 29, 100)
						end
					
					else
						if isElement(vehicleCreatorMarker) then
							destroyElement(vehicleCreatorMarker)
						end

                        destroyTrashElements()
                        triggerServerEvent("deletePlayerVan", localPlayer, localPlayer)
						setElementData(localPlayer, "meslek:aracta", false)
						setElementData(localPlayer, "meslek:cop_calisiyor", false)
					end
				end
			end
		end
	end
)

function createTrash()
	for k, v in ipairs(trashPositions) do
		if not isElement(trash[k]) then
			trash[k] = createObject(1264, v[1], v[2], v[3]-0.8)

			setElementData(trash[k], "meslek:cop_obje", true)
			setElementData(trash[k], "meslek:cop_type", v[4])
			setObjectScale(trash[k], 0.6)
			setObjectBreakable(trash[k], false)
			setElementFrozen(trash[k], true)
			trashes = trashes + 1
			setElementData(trash[k], "meslek:cop_id", tonumber(trashes))
		end
	end
end

function createtrashblip()
	for k, v in ipairs(trashPositions) do
		if not isElement(trashBlips[k]) then
		
			trashBlips[k] = createBlip(v[1], v[2], v[3], 59)
			setElementData(trashBlips[k], 'meslek:cop_blip', true)
	  end
   end
end

addEvent("destroyCurrentPoints", true)
addEventHandler("destroyCurrentPoints", getRootElement(),
	function()
		if getElementData(localPlayer, "job") == jobId then
			setElementData(localPlayer, "meslek:aracta", false)
			setElementData(localPlayer, "meslek:cop_calisiyor", false)
		end
	end
)

clicked = false
addEventHandler("onClientClick", getRootElement(),
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if getElementData(localPlayer, "job") == jobId and clicked == false then
			if clickedElement and getElementModel (clickedElement) == 1264 and getElementData(clickedElement, "meslek:cop_obje") and button == "right" and state == "down" and getElementData(localPlayer, "meslek:cop_calisiyor") and not carryStop then
			
			clicked = true	
			local posX, posY, posZ = getElementPosition(localPlayer)
			local x, y, z = getElementPosition(clickedElement)
			local trashUID = getElementData(clickedElement, "meslek:cop_id")
			local trashType = getElementData(clickedElement, "meslek:cop_type")
			if trashType == 1 then
			    trashType = "karışık"
			elseif trashType == 2 then
				trashType = "kağıt"
			elseif trashType == 3 then
				trashType = "cam"
			end 
			
			if getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z) <= 2 then
            triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "çöp poşetinin yanına yavaşca eğilir ve poşeti açarak içine bakınır.")
			triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "BOMBER", "BOM_Plant")
			setElementData(localPlayer, "lockedAnimation", true)
			setTimer(function()
				triggerServerEvent("sendLocalDoAction", localPlayer, localPlayer, "Poşetin içinde "..trashType.." çöpler olduğunu gördüm.")
				triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
				setElementData(localPlayer, "lockedAnimation", false)
				clicked = false
				end, 5000, 1)
			end
		end
		
	if clickedElement and getElementModel (clickedElement) == 1264 and getElementData(clickedElement, "meslek:cop_obje") and button == "left" and state == "down" and getElementData(localPlayer, "meslek:cop_calisiyor") and not carryStop then
		
		local posX, posY, posZ = getElementPosition(localPlayer)
		local x, y, z = getElementPosition(clickedElement)
		local trashUID = getElementData(clickedElement, "meslek:cop_id")
		local trashType = getElementData(clickedElement, "meslek:cop_type")

	   if getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z) <= 2 then
		triggerServerEvent("onClientTakeOutTrash", localPlayer, trashUID)
		setElementData(localPlayer, "carry", true)
		if trashType == 1 then	
	        setElementData(localPlayer, "karisik", getElementData(localPlayer, "karisik") + 1)
        elseif trashType == 2 then
	        setElementData(localPlayer, "kagit", getElementData(localPlayer, "kagit") + 1)
        elseif trashType == 3 then
            setElementData(localPlayer, "cam", getElementData(localPlayer, "cam") + 1)
        end

			toggleControl("fire", false)
			toggleControl("sprint", false)
			toggleControl("crouch", false)
			toggleControl("jump", false)
			toggleControl("next_weapon", false)
			toggleControl("previous_weapon", false)
			carryStop = true
			destroyElement(clickedElement)						
	    for _,blip in pairs(getElementsByType('blip')) do
		    if getElementData(blip,"meslek:cop_blip") then
			    local blipX,blipY,blipZ = getElementPosition(blip)
			    local distance = getDistanceBetweenPoints3D(posX,posY,posZ,blipX,blipY,blipZ)
			if distance <= 5 and isElement(blip) then
				triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "çöp poşetini eline alır ve çöp kamyonuna yönelir.")
				setPedAnimation(localPlayer, "CARRY", "putdwn05", -1, false, false, false, false)
				destroyElement(blip)
		      end
		   end
	    end	
			end
		end	
	end
end
)

addEvent("startTrashCarrying", true)
addEventHandler("startTrashCarrying", getRootElement(),
	function()
		if isElement(source) then
			if isElement(carriedTrashes[source]) then
				destroyElement(carriedTrashes[source])
			end
			carriedTrashes[source] = createObject(1264, 0, 0, 0)
			setObjectScale(carriedTrashes[source], 0.6)
			if isElement(carriedTrashes[source]) then
				setElementCollisionsEnabled(carriedTrashes[source], false)
				exports["bone_attach"]:attachElementToBone(carriedTrashes[source], source, 11, 0, 0, 0.2, 0, 180, 0)
			end
		end
	end
)

addEvent("stopTrashCarrying", true)
addEventHandler("stopTrashCarrying", getRootElement(),
	function()
		if isElement(carriedTrashes[source]) then
			destroyElement(carriedTrashes[source])
		end
	end
)

function onClientRender()
	if getElementData(localPlayer, "job") == jobId then
		if getElementData(localPlayer, "carry") then
			if not carryStopped then
				local vehicles = getElementsByType("vehicle", getRootElement(), true)
				for k, v in ipairs(vehicles) do
					if getElementModel(v) == jobVehicleId then
						local x, y, z = getElementPosition(localPlayer)
						local vehicleX, vehicleY, vehicleZ = getElementPosition(v)

						if getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ) <= 7 then
							local rotX, rotY, rotZ = getElementRotation(v)

							local angle = math.rad(45 + rotZ)
							
							local cornerX, cornerY = vehicleX, vehicleY
							local pointX, pointY = vehicleX - 3.5, vehicleY - 3.5
							
							local rotatedX = math.cos(angle) * (pointX - cornerX) - math.sin(angle) * (pointY- cornerY) + cornerX
							local rotatedY = math.sin(angle) * (pointX - cornerX) + math.cos(angle) * (pointY - cornerY) + cornerY

							if getDistanceBetweenPoints3D(x, y, z, rotatedX, rotatedY, vehicleZ) <= 0.8 then
								if getElementData(v, "meslek") and getElementData(v, "meslek:aracim") == localPlayer then
			    			        if getElementData(v, "trunkUp") then
										dxDrawImage(left+400, top, 950, 600, "cop/files/key.png", 0, 0, 0, tocolor(255,255,255,255))
										bindKey("e", "down", endTrashProgress)
									end
                			    end
							end
						end
					end
				end
			end
		else
			carryStopped = false
		end
	end
end
addEventHandler("onClientRender", getRootElement(), onClientRender)

function onButtons()
	if getElementData(localPlayer, "job") == jobId then
				local vehicles = getElementsByType("vehicle", getRootElement(), true)
				for k, v in ipairs(vehicles) do
					if getElementModel(v) == jobVehicleId then
						local x, y, z = getElementPosition(localPlayer)
						local vehicleX, vehicleY, vehicleZ = getElementPosition(v)
						if getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ) <= 7 then
							local rotX, rotY, rotZ = getElementRotation(v)

							local angle = math.rad(45 + rotZ)
							
							local cornerX, cornerY = vehicleX, vehicleY
							local pointX, pointY = vehicleX - 3.5, vehicleY - 3.5
							
							local rotatedX = math.cos(angle) * (pointX - cornerX) - math.sin(angle) * (pointY- cornerY) + cornerX
							local rotatedY = math.sin(angle) * (pointX - cornerX) + math.cos(angle) * (pointY - cornerY) + cornerY

				if getDistanceBetweenPoints3D(x, y, z, rotatedX, rotatedY, vehicleZ) <= 0.8 then
					if getElementData(v, "meslek") and getElementData(v, "meslek:aracim") == localPlayer then
							dxDrawImage(left+400, top, 950, 600, "cop/files/button.png", 0, 0, 0, tocolor(255,255,255,255))
						if inbox(screenX/2-40+400, screenY/2-70, 60, 60) then
		                    if getKeyState("mouse1") then
                               if not clicked then							
							       if getElementData(v, "trunkUp") == false then
                                    triggerServerEvent("changeTrashDoorOpenRatio", localPlayer, v, 1, 1)
									trashDoorOpen(vehicleX, vehicleY, vehicleZ)
									triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "aracın arkasındaki panelden kapağı açma tuşuna basar.")
									setTimer(function()
                                        setElementData(v, "trunkUp", true)
										triggerServerEvent("sendLocalDoAction", localPlayer, localPlayer, "Aracın çöp kapağı yavaşca yukarı kalkarak tamamen açıldı!")
				                    end, 3000, 1)
                                  else
                                    exports["infobox"]:addBox("error", "Çöp kamyonunun arkası zaten açık!")								
								  end
								  clicked = true
								end
							else
			                    clicked = false
							  end
							end 
							
						    if inbox(screenX/2-40+400, screenY/2, 60, 60) then
		                        if getKeyState("mouse1") then
                                  if not clicked then								
							        if getElementData(v, "trunkUp") then
							        triggerServerEvent("changeTrashDoorCloseRatio", localPlayer, v, 1,0)
									trashDoorClose(vehicleX, vehicleY, vehicleZ)
									triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "aracın arkasındaki panelden kapağı kapatma tuşuna basar.")
									setTimer(function()
                                        setElementData(v, "trunkUp", false)
										triggerServerEvent("sendLocalDoAction", localPlayer, localPlayer, "Aracın çöp kapağı yavaşca aşağı inerek tamamen kapandı!")
				                    end, 3000, 1)
								  else
									exports["infobox"]:addBox("error", "Çöp kamyonunun arkası henüz açılmadı!")	
							  end
							clicked = true  
                           end
						else
			              clicked = false
                        end
                     end						 
                  end
			   end
			end
		 end
	  end
   end
end
addEventHandler("onClientRender", getRootElement(), onButtons)

function endTrashProgress()
	triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "elinde ki çöp poşetini çöp kamyonunun arka kabinine atar.")
    exports["infobox"]:addBox("info", "İşlemi başarıyla tamamladınız, işlem ücretini iş sonu alacaksınız!")
	triggerServerEvent("onClientDestroyTrash", localPlayer)
	setElementData(localPlayer, "carry", false)
	toggleControl("fire", true)
	toggleControl("sprint", true)
	toggleControl("crouch", true)
	toggleControl("jump", true)
	toggleControl("next_weapon", true)
	toggleControl("previous_weapon", true)
    carryStopped = true
	carryStop = false
    unbindKey("e", "down", endTrashProgress)
end

function inbox(sx, sy, bx, by)
	if isCursorShowing() then
		local mx, my = getCursorPosition()
		mx, my = mx*screenX, my*screenY
		bx, by = sx+bx, sy+by
		return sx <= mx and bx >= mx and sy <= my and by >= my
	end
end

function trashDoorOpen(vx, vy, vz)
    local sound = playSound3D("cop/files/open.mp3", vx, vy, vz, false)
    setSoundMaxDistance(sound, 30);
end

function trashDoorClose(vx, vy, vz)
    local sound = playSound3D("cop/files/close.mp3", vx, vy, vz, false)
    setSoundMaxDistance(sound, 30);
end

function destroyTrashElements()
local objects = getElementsByType("object", getRootElement(), true)
for k, v in ipairs(objects) do
	if getElementData(v, "meslek:cop_obje") and getElementModel(v) == 1264 then
		if isElement(v) then
			destroyElement(v)
		end
	end
end						
for k, v in ipairs(getElementsByType('blip')) do
	if getElementData(v, 'meslek:cop_blip') then
		if isElement(v) then
			if isElement(v) then
				destroyElement(v)
				end
			end
		end
	end 
end
addEvent("destroyTrashElements", true)
addEventHandler("destroyTrashElements", getRootElement(), destroyTrashElements)