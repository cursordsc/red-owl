
local vehicleCreatorPoint = {1250.896484375, -1820.2412109375, 13.408143997192}
local screenX, screenY = guiGetScreenSize()
local wx, wy = 950, 600
local left = (screenX/2) - (wx/2)
local top = (screenY/2) - (wy/2)

local vehicleCarJackCreatorMarker = false
local onRepair = false
local jobId = 11
local jobVehicleId = 552

function table.random(theTable)
    return theTable[math.random ( #theTable )]
end

local randomVehs = {551, 426, 585, 405, 565}
local carriedCars = {}
local carriedCars2 = {}
local timerFunction = {}
local carryStop = false
local jackObject = {}
local carBlips = {}
local car = {}
local cares = 0

txd = engineLoadTXD ( "otokurtarma/files/carJack.txd" ) 
engineImportTXD (txd, 1900) 

dff = engineLoadDFF("otokurtarma/files/carJack.dff", 1900) 
engineReplaceModel(dff, 1900) 

col = engineLoadCOL("otokurtarma/files/carJack.col", 1900) 
engineReplaceCOL(col, 1900) 

local lastikGirisNPC = createPed(16, 1236.5126953125, -1809.7939453125, 13.596261978149, 217 ,true)
setElementData(lastikGirisNPC, "talk", 1)
setElementData(lastikGirisNPC, "name", "Hakan Bolunmez")
setElementFrozen(lastikGirisNPC, true)

function lastikGirisGUI()
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	
	if (carlicense==1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Hakan Bolunmez diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		lastikAcceptGUI(getLocalPlayer())
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Hakan Bolunmez diyor ki: La genç, senin araba ehliyetin yok? Alıverip öyle gel hadi bakayim.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("meslek:otokurtarmaGUI", true)
addEventHandler("meslek:otokurtarmaGUI", getRootElement(), lastikGirisGUI)

function lastikAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Oto Kurtarma", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			setElementData(localPlayer, "job", 11)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Hakan Bolunmez diyor ki: Arabana bin ve navigasyonda işaretlenmiş yere git ve aracı tamir et!.", 255, 255, 255, 3, {}, true)
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
			if not isElement(vehicleCarJackCreatorMarker) then
				vehicleCarJackCreatorMarker = createMarker(vehicleCreatorPoint[1], vehicleCreatorPoint[2], vehicleCreatorPoint[3], "checkpoint", 4, 208, 101, 29)
			end

			setElementData(localPlayer, "onCarJackCar", false)
			setElementData(localPlayer, "meslek:lastik_calisma", false)
			setElementData(localPlayer, "onReadyStartJob", true)
		end
	end
)

addEventHandler("onClientMarkerHit", getRootElement(),
	function (hitElement)
		if hitElement == localPlayer then
			if source == vehicleCarJackCreatorMarker then
				if not isPedInVehicle(localPlayer) then
					if not getElementData(localPlayer, "onCarJackCar") then
					   --if getElementData(localPlayer, "onReadyStartJob") then
						triggerServerEvent("onClientHitCarJackMarkers", localPlayer, localPlayer, jobVehicleId)
						setElementData(localPlayer, "onReadyStartJob", false)
						setElementData(localPlayer, "upCar", false)
						setElementData(localPlayer, "onCarJackCar", true)
						setTimer(function()
							setElementData(localPlayer, "onReadyStartJob", true)
						end, (60000*3), 1)
						setTimer(function()
							setElementData(localPlayer, "meslek:lastik_calisma", true)
						end, 3000, 1)
						outputChatBox("#d0651d[BİLGİ]: #FFFFFFMesleğe başlamak için #6E6E6E'kamyon'#ffffff simgesine gidiniz.", 255, 255, 255, true)
						createcar()
						createcarblip()
						setElementData(localPlayer, "fixwheel", false)
						setElementData(localPlayer, "carry", false)
						setTimer(createcar, 30 * 30 * 1000, 0)
						setMarkerColor(vehicleCarJackCreatorMarker, 220, 91, 91)
					--else
                    	--exports["infobox"]:addBox("info", "İki işlem arasında 3 dakika beklemelisiniz!")				
					   --end
					else
						triggerServerEvent("destroyCarJackVehicle", localPlayer)
						setElementData(localPlayer, "onCarJackCar", false)
						setElementData(localPlayer, "meslek:lastik_calisma", false)
				        destroyCarElements()
						setMarkerColor(vehicleCarJackCreatorMarker, 254, 119, 29)
					    exports["infobox"]:addBox("info", "Mesleğinizi tamamladınız, iyi günler.")
					end
				else
					local theVehicle = getPedOccupiedVehicle(localPlayer)
					if getElementData(localPlayer, "onCarJackCar") and getElementData(localPlayer, "meslek:lastik_calisma") and getElementData(theVehicle, "meslek:lastik_sahip") == getElementData(localPlayer, "meslek:lastik_sahip") and getElementData(theVehicle, "isCarJackJobVehicle") then
						local para = 350
						local arac = tonumber(getElementData(localPlayer, "otokurtarma:araba_adet") or 0)
						local kazanc = arac*para
						if arac >= 3 then
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

							triggerServerEvent("giveMoney", localPlayer, localPlayer, kazanc+ekpara)
							exports["infobox"]:addBox("info", "İşi tamamladın, kazancın: ".. kazanc+ekpara .."$.")
						else
							exports["infobox"]:addBox("error", "En az 3 tane araç tamir etmediğinizden para kazanamadınız!")
						end
						setElementData(localPlayer, "onCarJackCar", false)
						setElementData(localPlayer, "meslek:lastik_calisma", false)
			            destroyCarElements()
						triggerServerEvent("destroyCarJackVehicle", localPlayer)
						setMarkerColor(vehicleCarJackCreatorMarker, 254, 119, 29)
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
						if not isElement(vehicleCarJackCreatorMarker) then
							vehicleCarJackCreatorMarker = createMarker(vehicleCreatorPoint[1], vehicleCreatorPoint[2], vehicleCreatorPoint[3], "checkpoint", 4, 208, 101, 29)
						end					
					else
						if isElement(vehicleCarJackCreatorMarker) then
							destroyElement(vehicleCarJackCreatorMarker)
						end
						if isElement(car[k]) then
							destroyElement(car[k])
						end

						if isElement(jackObject[localPlayer]) then
							destroyElement(jackObject[localPlayer])
						end

						if isElement(getElementData(localPlayer, "meslek:otoarac")) then
							destroyElement(getElementData(localPlayer, "meslek:otoarac"))
						end

						for k, v in ipairs(getElementsByType("vehicle")) do
							if getElementData(v, "otokurtarma:car") then
								if isElement(v) then
									destroyElement(v)
								end
							end
						end

                        destroyCarElements()
                        triggerServerEvent("deletePlayerVan", localPlayer, localPlayer)
						setElementData(localPlayer, "onCarJackCar", false)
						setElementData(localPlayer, "meslek:lastik_calisma", false)
					end
				end
			end
		end
	end
)

function createcar()
	for k, v in ipairs(carPositions) do
		if not isElement(car[k]) then
			car[k] = createVehicle(table.random(randomVehs), v[1], v[2], v[3], 0, 0, v[4])

			local letter1 = string.char(math.random(65,90))
			local letter2 = string.char(math.random(65,90)) -- TÜRK PLAKA
			local plate = "34 " .. letter1 .. letter2 .. " " .. tostring(math.random(100, 9999))

			setElementData(car[k], "otokurtarma:car", true)
			setElementData(car[k], "carType", v[5])
			cares = cares + 1
			setElementData(car[k], "dbid", -tonumber(cares))
			setElementData(car[k], "plate", plate)
			setElementData(car[k], "owner", -1)
			setElementData(car[k], "fuel", 100)
			setElementData(localPlayer, "meslek:otoarac", car[k])
		 setTimer(function()
			if v[4] == 1 then
			    setVehicleWheelStates(car[k], 1, 0, 0, 0)
			elseif v[4] == 2 then
				setVehicleWheelStates(car[k], 0, 1, 0, 0)
			end	
			    setElementFrozen(car[k], true)
		 end, 10000, 1)
	  end
   end
end

function createcarblip()
	for k, v in ipairs(carPositions) do
		if not isElement(carBlips[k]) then
		
			carBlips[k] = createBlip(v[1], v[2], v[3], 59)
			setElementData(carBlips[k], 'carBlip', true)
	  end
   end
end

addEvent("destroyCurrentPoints", true)
addEventHandler("destroyCurrentPoints", getRootElement(),
	function()
		if getElementData(localPlayer, "job") == jobId then
			setElementData(localPlayer, "onCarJackCar", false)
			setElementData(localPlayer, "meslek:lastik_calisma", false)
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if getElementData(localPlayer, "job") == jobId then
			if clickedElement and getElementModel (clickedElement) == 1264 and getElementData(clickedElement, "otokurtarma:car") and button == "insert" and state == "down" and getElementData(localPlayer, "meslek:lastik_calisma") and not carryStop then
				
				local posX, posY, posZ = getElementPosition(localPlayer)
				local x, y, z = getElementPosition(clickedElement)
				local carUID = getElementData(clickedElement, "dbid")
					
				if getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z) <= 2 then
						triggerServerEvent("onClientTakeOutcar", localPlayer, carUID)
						setElementData(localPlayer, "carry", true)
						toggleControl("fire", false)
						toggleControl("sprint", false)
						toggleControl("crouch", false)
						toggleControl("jump", false)
						toggleControl("next_weapon", false)
						toggleControl("previous_weapon", false)
						carryStop = true
						destroyElement(clickedElement)
						
	            for _,blip in pairs(getElementsByType('blip')) do
		            if getElementData(blip,"carBlip") then
			        local blipX,blipY,blipZ = getElementPosition(blip)
			        local distance = getDistanceBetweenPoints3D(posX,posY,posZ,blipX,blipY,blipZ)
			    if distance <= 5 and isElement(blip) then
				destroyElement(blip)
		        end
		      end
	        end	
				timerFunction = setTimer(function()
					createcar()
					createcarblip()
				end, (1000*60)*10, 0)
			end
		end
	end
end
)


addEvent("startcarCarrying", true)
addEventHandler("startcarCarrying", getRootElement(),
function()
	if isElement(source) then
		if isElement(carriedCars[source]) then
			destroyElement(carriedCars[source])
			destroyElement(carriedCars2[source])
		end
		carriedCars[source] = createObject(1096, 0, 0, 0)
		carriedCars2[source] = createObject(1096, 0, 0, 0)
		setObjectScale(carriedCars[source], 0.65)
		setObjectScale(carriedCars2[source], 0.65)
		if isElement(carriedCars[source]) then
			setElementCollisionsEnabled(carriedCars[source], false)
			setElementCollisionsEnabled(carriedCars2[source], false)
			exports["bone_attach"]:attachElementToBone(carriedCars[source], source, 11, -0.2, 0.27, 0.1, 0, 105, 0)
			exports["bone_attach"]:attachElementToBone(carriedCars2[source], source, 11, -0.2, 0.27, 0.085, 0, -76, 0)
		end
	end
end
)

addEvent("stopcarCarrying", true)
addEventHandler("stopcarCarrying", getRootElement(),
	function()
		if isElement(carriedCars[source]) then
			destroyElement(carriedCars[source])
			destroyElement(carriedCars2[source])
		end
	end
)

function onClientRender()
	if getElementData(localPlayer, "job") == jobId then
		if getElementData(localPlayer, "carry") and getElementData(localPlayer, "fixwheel") == false and onRepair == false then
			if not carryStopped then
				local vehicles = getElementsByType("vehicle", getRootElement(), true)
				for k, v in ipairs(vehicles) do
					if getElementModel(v) == jobVehicleId then
						local x, y, z = getElementPosition(localPlayer)
						local vehicleX, vehicleY, vehicleZ = getElementPosition(v)

					if getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ) <= 7 then
						local vcx,vcy,vcz = getVehicleComponentPosition (v,"boot_dummy","world")	
			            if getDistanceBetweenPoints3D(vcx,vcy,vcz, x, y, z) < 1.2 then 
					        if getElementData(v, "meslek:lastik_sahip") == getElementData(localPlayer, "meslek:lastik_sahip") and getElementData(v, "isCarJackJobVehicle") then
							    dxDrawImage(left+400, top, 950, 600, "otokurtarma/files/key.png", 0, 0, 0, tocolor(255,255,255,255))
								bindKey("e", "down", endcarProgress)
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

clickedButton = false
function onButtons()
    if getElementData(localPlayer, "job") == jobId then
	    for i,p in ipairs(getElementsByType("player")) do 
		  if p == localPlayer then
		  else
		    local mx, my, mz = getElementPosition(localPlayer)
		    local px, py, pz = getElementPosition(p)

	        if getDistanceBetweenPoints3D(mx,my,mz, px, py, pz) < 15 then
			  if getElementData(p, "upCar") == true and getElementData(localPlayer, "upCar") == false then
			  return
			end
	      end
	   end
	end
				local vehicles = getElementsByType("vehicle", getRootElement(), true)
				for k, v in ipairs(vehicles) do
					if getElementData(v, "otokurtarma:car") then
						local x, y, z = getElementPosition(localPlayer)
						local vehicleX, vehicleY, vehicleZ = getElementPosition(v)
						local vehicleRX, vehicleRY, vehicleRZ = getElementRotation(v)
						if getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ) <= 7 then

						local wheelType = getElementData(v, "carType")
			            if wheelType == 1 then
			                wheelType = "wheel_lf_dummy"
			            elseif wheelType == 2 then
				            wheelType = "wheel_lb_dummy"
			            end 
                local vcx,vcy,vcz = getVehicleComponentPosition (v,wheelType,"world")	
				if getDistanceBetweenPoints3D(vcx,vcy,vcz, x, y, z) < 1.2 then 
							dxDrawImage(left+400, top, 950, 600, "otokurtarma/files/button.png", 0, 0, 0, tocolor(255,255,255,255))
					if inbox(screenX/2-40+400, screenY/2-70, 60, 60) then
		                if getKeyState("mouse1") and clickedButton == false then
                            if not clicked then							
							    if getElementData(v, "trunkUp") == false then
								  if getElementData(localPlayer, "otokurtarma:araba_adet") < 8 then
							        setElementFrozen(v, true)
									triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "BOMBER", "BOM_Plant")
									setElementData(localPlayer, "lockedAnimation", true)
									triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "krikoyu aracın altına yerleştirir ve yavaşca aracı kaldırmaya başlar.")
									setElementData(localPlayer, "upCar", true)
									guiSetInputEnabled(true)
								    jackObject[localPlayer] = createObject(1900, vehicleX-0.7, vehicleY-1.25, vehicleZ-0.50, 0, 0, vehicleRZ+90)
									setObjectScale(jackObject[localPlayer], 0.9)
									setObjectBreakable(jackObject[localPlayer], false)
									setElementDoubleSided(jackObject[localPlayer], true)
									clickedButton = true
	                                setTimer(function()
	                                local rotX, rotY, rotZ = getElementRotation(v)
                                    local posX, posY, posZ = getElementPosition(v)
	                                setElementPosition(v,posX,posY,posZ+0.005)
	                                setElementRotation(v,rotX,rotY+0.5,rotZ)
									carDoorOpen(posX, posY, posZ)
	                                end, 1000, 20)
								
								    setTimer(function()
								    setElementData(v, "trunkUp", true)
								    triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
									setElementData(localPlayer, "lockedAnimation", false)
									guiSetInputEnabled(false)
									clickedButton = false
								    end, 21000, 1)
								else
									exports["infobox"]:addBox("error", "Yedek tekerleğin kalmamış, atolyeye dönerek yeni tekerlekler al!")
								  end
                                else
                                    exports["infobox"]:addBox("error", "Araç kaldırıldı")									
								  end
								  clicked = true
								end
							else
			                    clicked = false
							  end
							end 
							
						    if inbox(screenX/2-40+400, screenY/2, 60, 60) then
		                        if getKeyState("mouse1") and clickedButton == false then
                                  if not clicked then								
							        if getElementData(v, "trunkUp") then
							        setElementFrozen(v, true)
									triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "aracı yavaşca aşağı indirir ve krikoyu aracın altından çıkartır.")
									triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "BOMBER", "BOM_Plant")
									setElementData(localPlayer, "lockedAnimation", true)
									guiSetInputEnabled(true)
									clickedButton = true
									setElementData(v, "trunkUp", false)
	                            setTimer(function()
	                                local rotX, rotY, rotZ = getElementRotation(v)
                                    local posX, posY, posZ = getElementPosition(v)
	                                setElementPosition(v,posX,posY,posZ-0.01)
	                                setElementRotation(v,rotX,rotY-1,rotZ)
	                            end, 1000, 10)

							    setTimer(function()
								    triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
									setElementData(localPlayer, "lockedAnimation", false)
									guiSetInputEnabled(false)
									clickedButton = false
									setElementData(localPlayer, "upCar", false)								
								   if isElement(jackObject[localPlayer]) then
									destroyElement(jackObject[localPlayer])
								   end
								end, 21000, 1)
								  else
									exports["infobox"]:addBox("error", "Bu aracı kaldıramazsın!")	
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
addEventHandler("onClientRender", getRootElement(), onButtons)

function onWheelKeyFunctions()
	if getElementData(localPlayer, "job") == jobId then
				local vehicles = getElementsByType("vehicle", getRootElement(), true)
				for k, v in ipairs(vehicles) do
					if getElementData(v, "otokurtarma:car") then
						local x, y, z = getElementPosition(localPlayer)
						local vehicleX, vehicleY, vehicleZ = getElementPosition(v)
						if getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ) <= 7 then

						local wheelType = getElementData(v, "carType")
			            if wheelType == 1 then
			                wheelType = "wheel_lf_dummy"
			            elseif wheelType == 2 then
				            wheelType = "wheel_lb_dummy"
			            end 
                  local vcx,vcy,vcz = getVehicleComponentPosition (v,wheelType,"world")	
			      if getDistanceBetweenPoints3D(vcx,vcy,vcz, x, y, z) < 1.2 and getElementData(v, "trunkUp") and getElementData(v, "wheelFixed") == false then 
				    dxDrawImage(left+400, top, 950, 600, "otokurtarma/files/qkey.png", 0, 0, 0, tocolor(255,255,255,255))
                    bindKey("q", "down", endcarProgress2)
			   end
			end
		 end
	  end
   end
end
addEventHandler("onClientRender", getRootElement(), onWheelKeyFunctions)

function endcarProgress()
	local vehicles = getElementsByType("vehicle", getRootElement(), true)
	for k, v in ipairs(vehicles) do
        if getElementModel(v) == jobVehicleId then
	    local x, y, z = getElementPosition(localPlayer)
	    local vehicleX, vehicleY, vehicleZ = getElementPosition(v)

	    if getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ) <= 7 then	
	    local vcx,vcy,vcz = getVehicleComponentPosition (v,"boot_dummy","world")	
	        if getDistanceBetweenPoints3D(vcx,vcy,vcz, x, y, z) < 1.2 then 
	            triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "araca yönelir ve elindeki patlak lastiği aracın kasasına koyar.")
				guiSetInputEnabled(true)
				triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "CARRY", "crry_prtial")
	            onRepair = true
				setElementData(localPlayer, "lockedAnimation", true)
	            setTimer(function()
	            triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "araçtan yeni bir tekerlek alır ve araca yönelir.")
				triggerServerEvent("sendLocalDoAction", localPlayer, localPlayer, "Elimde yeni bir tekerlek tutmaktayım.")
	            setElementData(localPlayer, "fixwheel", true)
	            setElementData(localPlayer, "lockedAnimation", false)
				guiSetInputEnabled(false)
	            end, 5000, 1)
	            unbindKey("e", "down", endcarProgress)
	         end
	     end
	  end
   end
end

function endcarProgress2()
  if getElementData(localPlayer, "job") == jobId then
    local vehicles = getElementsByType("vehicle", getRootElement(), true)
    for k, v in ipairs(vehicles) do
      if getElementData(v, "otokurtarma:car") then 
	    if getElementData(localPlayer, "clickedWheel") == false and getElementData(v, "trunkUp") and getElementData(v, "wheelVisibleOff") == false and getElementData(v, "otokurtarma:car") and getElementData(localPlayer, "meslek:lastik_calisma") and not carryStop then	
			local posX, posY, posZ = getElementPosition(localPlayer)
			local x, y, z = getElementPosition(v)
			local carUID = getElementData(v, "dbid")
			local wheelType = getElementData(v, "carType")
		  if wheelType == 1 then
			    wheelType = "wheel_lf_dummy"
				wheelText = "sol ön"
		    elseif wheelType == 2 then
			    wheelType = "wheel_lb_dummy"
				wheelText = "sol arka"
		  end

		if getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z) <= 3 then
		   local vcx,vcy,vcz = getVehicleComponentPosition (v,wheelType,"world")		
		   if getDistanceBetweenPoints3D(vcx,vcy,vcz, posX, posY, posZ) < 1.2 then 
            triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "arabanın ".. wheelText .." tekerleğini sökmeye başlar.")
			setElementData(localPlayer, "clickedWheel", true)
			triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "BOMBER", "BOM_Plant")
			setElementData(localPlayer, "lockedAnimation", true)
			guiSetInputEnabled(true)
			   setTimer(function()
				triggerServerEvent("sendLocalDoAction", localPlayer, localPlayer, "Arabanın ".. wheelText .." tekerleğini söktüm.")
				triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
				setElementData(localPlayer, "clickedWheel", false)
				setVehicleComponentVisible(v, wheelType, false)
				setElementData(v, "wheelVisibleOff", true)
				setElementData(localPlayer, "lockedAnimation", false)
				guiSetInputEnabled(false)
				
				model = getElementModel(v)
				triggerServerEvent("onClientTakeOutcar", localPlayer, carUID, model)
				setElementData(localPlayer, "carry", true)
				toggleControl("fire", false)
				toggleControl("sprint", false)
				toggleControl("crouch", false)
				toggleControl("jump", false)
				toggleControl("next_weapon", false)
				toggleControl("previous_weapon", false)
				carryStop = true
				unbindKey("q", "down", endcarProgress2)
			   end, 15000, 1)
			end 
		 end
	  end
	if getElementData(localPlayer, "clickedWheel") == false and getElementData(v, "wheelVisibleOff") == true and getElementData(v, "otokurtarma:car") and getElementData(localPlayer, "meslek:lastik_calisma") then
			local posX, posY, posZ = getElementPosition(localPlayer)
			local x, y, z = getElementPosition(v)
			local carUID = getElementData(v, "dbid")
			local wheelType = getElementData(v, "carType")
		  if wheelType == 1 then
			    wheelType = "wheel_lf_dummy"
				wheelText = "sol ön"
		    elseif wheelType == 2 then
			    wheelType = "wheel_lb_dummy"
				wheelText = "sol arka"
		  end
			
		if getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z) <= 3 then
		   local vcx,vcy,vcz = getVehicleComponentPosition (v,wheelType,"world")	
		   if getDistanceBetweenPoints3D(vcx,vcy,vcz, posX, posY, posZ) < 1.2 then 
		     if getElementData(localPlayer, "fixwheel") == true then
		   	    triggerServerEvent("onClientDestroyCar", localPlayer)
	            setElementData(localPlayer, "carry", false)
	            toggleControl("fire", true)
	            toggleControl("sprint", true)
	            toggleControl("crouch", true)
	            toggleControl("jump", true)
				toggleControl("next_weapon", true)
				toggleControl("previous_weapon", true)
                carryStopped = true
	            carryStop = false
                triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "elindeki yeni tekerleği aracın ".. wheelText .." kısmına takmaya başlar.")
			    setElementData(localPlayer, "clickedWheel", true)
			    triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "BOMBER", "BOM_Plant")
			    setVehicleComponentVisible(v, wheelType, true)
				setElementData(localPlayer, "lockedAnimation", true)
				guiSetInputEnabled(true)
				
			    setTimer(function()
				triggerServerEvent("sendLocalDoAction", localPlayer, localPlayer, "Yeni tekerlek aracın ".. wheelText .." kısmına takıldı.")
				setVehicleWheelStates(v, 0, 0, 0, 0)
				triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
				setElementData(localPlayer, "lockedAnimation", false)
				guiSetInputEnabled(false)
				setElementData(localPlayer, "clickedWheel", false)
				setElementData(v, "wheelVisibleOff", false)
				setElementData(localPlayer, "fixwheel", false)
				unbindKey("q", "down", endcarProgress2)
				exports["infobox"]:addBox("info", "Başarıyla işlemi tamamladınız, mesleği teslim ederken ücretinizi alacaksınız!")
				onRepair = false
				local sondurum = getElementData(localPlayer, "otokurtarma:araba_adet") or 0
	            setElementData(localPlayer, "otokurtarma:araba_adet", sondurum + 1)
				setElementData(v, "wheelFixed", true)
			    end, 15000, 1)
		       else
			    exports["infobox"]:addBox("error", "Yedek lastiğiniz yok!")
		     end
		   end
		 end
	    end
	  end
	end  
  end
end

function inbox(sx, sy, bx, by)
	if isCursorShowing() then
		local mx, my = getCursorPosition()
		mx, my = mx*screenX, my*screenY
		bx, by = sx+bx, sy+by
		return sx <= mx and bx >= mx and sy <= my and by >= my
	end
end

function carDoorOpen(vx, vy, vz)
    local sound = playSound3D("otokurtarma/files/up.mp3", vx, vy, vz, false)
    setSoundMaxDistance(sound, 30);
end

function destroyCarElements()
local vehicles = getElementsByType("vehicle", getRootElement(), true)
for k, v in ipairs(vehicles) do
	if getElementData(v, "otokurtarma:car") then
		if isElement(v) then
			destroyElement(v)
		end
	end
end						
for k, v in ipairs(getElementsByType('blip')) do
	if getElementData(v, 'carBlip') then
		if isElement(v) then
			if isElement(v) then
				destroyElement(v)
				end
			end
		end
	end   
end