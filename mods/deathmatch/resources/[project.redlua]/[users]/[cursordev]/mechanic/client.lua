-- © 2018 needGaming
local monitorSize = {guiGetScreenSize()}
local panelSize = {350, 15}
local vehicleComponents = {}
local damageComponents = {}
local damageParts = {}
local loadingVehicleDamage = false
local isPedinVehicle = false
local mechanic = false
local sound = false
local font = dxCreateFont("files/font.ttf", 19, false, "cleartype")
local mechanic_progress_tick = 0
local mechanic_progress_max = panelSize[1]
local mechanic_progress_text = ""
local mechanic_progress_arguments = {}
local object1 = {}
local objectCol = {}


function drawMechanicPanel ()
	if not isPedInVehicle(localPlayer) and getElementInterior(localPlayer) >= 1 and (getElementData(localPlayer, "job") == 5)  then 
		if #damageParts > 0 then
			dxDrawRectangle(monitorSize[1] - 200, monitorSize[2]/2 - (#damageParts*22 + 10)/2, 200, (#damageParts*22 + 10),tocolor(0,0,0,160))
			for partIndex, partValue in pairs(damageParts) do

				if isInSlot(monitorSize[1] - 190, monitorSize[2]/2 - (#damageParts*22 + 10)/2 + partIndex * 22 - 16, 180, 20) then
					dxDrawRectangle(monitorSize[1] - 190, monitorSize[2]/2 - (#damageParts*22 + 10)/2 + partIndex * 22 - 16, 180, 20,tocolor(254, 119, 29, 170))
					dxDrawText(partValue[1],monitorSize[1] - 190 +180/2, monitorSize[2]/2 - (#damageParts*22 + 8)/2 + partIndex * 22 - 16, monitorSize[1] - 190+180/2, 20 + monitorSize[2]/2 - (#damageParts*22 + 8)/2 + partIndex * 22 - 16, tocolor(0, 0, 0, 255), 0.5, font, "center", "center", false, false, false, true)
				else
					dxDrawRectangle(monitorSize[1] - 190, monitorSize[2]/2 - (#damageParts*22 + 10)/2 + partIndex * 22 - 16, 180, 20,tocolor(0,0,0,180))
					dxDrawText(partValue[1],monitorSize[1] - 190+180/2, monitorSize[2]/2 - (#damageParts*22 + 8)/2 + partIndex * 22 - 16,monitorSize[1] - 190+180/2, 20 + monitorSize[2]/2 - (#damageParts*22 + 8)/2 + partIndex * 22 - 16, tocolor(255, 255, 255, 255), 0.5, font, "center", "center", false, false, false, true)
				end
			end
		end
		
		local state = getVehicleTarget()[1]
		local veh = getVehicleTarget()[2]
		isPedinVehicle = veh
		if mechanic_progress_state then 
			mechanic_progress_tick = mechanic_progress_tick + 0.5
			if mechanic_progress_tick >= mechanic_progress_max then 
				mechanic_progress_state = false
				mechanic_progress_tick = 0
				callRightFunction(mechanic_progress_text, mechanic_progress_arguments)
				mechanic_progress_text = ""
			end
			dxDrawRectangle(monitorSize[1]/2 - panelSize[1]/2, monitorSize[2] - panelSize[2]-65, panelSize[1], panelSize[2]-13,tocolor(0, 0, 0,180))
			dxDrawRectangle(monitorSize[1]/2 - panelSize[1]/2, monitorSize[2] - panelSize[2]-65, mechanic_progress_tick, panelSize[2]-13,tocolor(254, 119, 29,180))
			dxCreateBorder(monitorSize[1]/2 - panelSize[1]/2, monitorSize[2] - panelSize[2]-65, panelSize[1], panelSize[2]-13,tocolor(0,0,0,255))
			dxDrawText(mechanic_progress_text, monitorSize[1]/2 - panelSize[1]/2 + panelSize[1]/2, monitorSize[2] - panelSize[2]-80 +panelSize[2]/2 , monitorSize[1]/2 - panelSize[1]/2 + panelSize[1]/2, monitorSize[2] - panelSize[2]-80 +panelSize[2]/2, tocolor(255, 255, 255, 204), 0.5, font, "center", "center", false, false, false, true)
		end
		if not state or getElementData(veh, "player->repairing") then return end
		for k,v in pairs (damageComponents) do
			if vehicleComponents[v[4]] then
				local text = v[1]
				local text_kieg = ""
				local x = vehicleComponents[v[4]][2]
				local y = vehicleComponents[v[4]][3]
				
				if getVehicleComponentVisible(veh, v[4]) then
					text_kieg = "sök"
				end
				if not getVehicleComponentVisible(veh, v[4]) then
					text_kieg = "tak"
				end
				
				local width = dxGetTextWidth(text .. " " .. text_kieg,1)*1.2
				
				if isInSlot(x-5 - (width+25)/2, y, width+25, 25) then
					dxDrawRectangle(x-5 - (width+25)/2, y, width+25, 25,tocolor(254, 119, 29,170))
					dxDrawText(text .. " " .. text_kieg, x - (width+25)/2, y+3, width+15 + x - (width+25)/2, 25 + y, tocolor(0, 0, 0, 255), 0.5, font, "center", "center", false, false, false, true)
				else
					dxDrawRectangle(x-5 - (width+25)/2, y, width+25, 25,tocolor(0, 0, 0,200))
					dxDrawText(text .. " " .. text_kieg, x - (width+25)/2, y+3, width+15 + x - (width+25)/2, 25 + y, tocolor(255, 255, 255, 255), 0.5, font, "center", "center", false, false, false, true)
				end
				dxCreateBorder(x-5 - (width+25)/2, y, width+25, 25,tocolor(0,0,0,255))
			end
		end
	end
end
addEventHandler("onClientRender", root, drawMechanicPanel)

function functionClick(Button, state, playerx, playery)
	if Button == "left" and state == "down" and loadingVehicleDamage then 
		if mechanic_progress_state then outputChatBox("#fe771d[Mechanic] #ffffffBir seferde yalnızca bir işlem yapabilirsiniz", 255, 255, 255, true) return end
		for k,v in pairs (damageComponents) do
			if vehicleComponents[v[4]] then
				local text = v[1]
				local x = vehicleComponents[v[4]][2]
				local y = vehicleComponents[v[4]][3]
				local ucret = v[7]
				local width = dxGetTextWidth(text,1)*1.4
				if dobozbaVan(x-5 - (width+25)/2, y, width+25, 25, playerx, playery) then
					if getVehicleComponentVisible(v[5], v[4]) then
						mechanic_progress_state = true
						mechanic_progress_text = v[1].." çıkartma işlemi devam ediyor.."
						mechanic_progress_tick = 0
						mechanic_progress_arguments = {v[1], v[5], v[4]}
						
						sound = playSound("files/mechanic.mp3", true)
						setSoundVolume(sound, 1)
						
						setElementData(v[5], "player->repairing", true)
						setElementData(localPlayer, "player->repairing", true)
						triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "BOMBER", "BOM_Plant")
						triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "araçta ki hasar almış ".. string.lower(v[1]) .. " sökmeye başlar.")
					else
						triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "BOMBER", "BOM_Plant", v[6])
						mechanic_progress_state = true
						mechanic_progress_text = v[1].." takma işlemi devam ediyor.."
						mechanic_progress_tick = 0
						mechanic_progress_arguments = {v[1], v[5], v[4]}
						sound = playSound("files/mechanic.mp3", true)
						setSoundVolume(sound, 1)
						triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "elindeki yeni ".. string.lower(v[1]) .. " araca takmaya başlar.")
						triggerServerEvent("takeMoney", localPlayer, localPlayer, ucret)

						setElementData(v[5], "player->repairing", true)
						setElementData(localPlayer, "player->repairing", true)
						updateVehicleComponent(v[5], v[4], "create")
					end
				end
			end
		end
		for partIndex, partValue in pairs(damageParts) do
			if dobozbaVan(monitorSize[1]- 110, monitorSize[2]/2 - (#damageParts*22 + 10)/2 + partIndex * 22 - 16, 100, 20, playerx, playery) then		
				if partValue[1] == "Motor Tamiri" then
					triggerServerEvent("player->repairEngine", localPlayer, localPlayer, isPedinVehicle)
				end
			end
		end
		for partIndex, partValue in pairs(damageParts) do
			if dobozbaVan(monitorSize[1]- 110, monitorSize[2]/2 - (#damageParts*22 + 10)/2 + partIndex * 22 - 16, 100, 20, playerx, playery) then		
				if partValue[1] == "Far Tamiri" then
					triggerServerEvent("player->repairLights", localPlayer, localPlayer, isPedinVehicle)
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), functionClick)

function callRightFunction(text, v)
	if text == v[1].." çıkartma işlemi devam ediyor.." then
		updateVehicleComponent(v[2], v[3], "remove")
		if isElement(sound) then destroyElement(sound) end
		
		triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
		setElementData(localPlayer, "player->repairing", false)
	elseif text == v[1].." takma işlemi devam ediyor.." then
		updateVehicleComponent(v[2], v[3], "create")
		if isElement(sound) then destroyElement(sound) end
		
		setElementData(localPlayer, "player->repairing", false)
		triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
	else
	
	end
	setElementData(v[2], "player->repairing", false)
end

function getVehicleTarget()
	if not isPedInVehicle(localPlayer) and getElementInterior(localPlayer) >= 1 and getElementData(localPlayer, "job") == 5 then 
		vehicleComponents = {}
		damageParts = {}
		loadingVehicleDamage = false
		isPedinVehicle = false
		local playerX, playerY, playerZ = getElementPosition(localPlayer)
		for index, value in ipairs (getElementsByType("vehicle")) do
			local vehicleX, vehicleY, VehicleZ = getElementPosition(value)
			if getDistanceBetweenPoints3D(playerX, playerY, playerZ, vehicleX, vehicleY, VehicleZ) < 5 then
				if not loadingVehicleDamage then 
					loadingVehicleDamage = true
					getVehicleDamagedComponent(value)
					for componentName in pairs (getVehicleComponents(value)) do
						local x,y,z = getVehicleComponentPosition (value,componentName,"world")
						local wx,wy,wz = getScreenFromWorldPosition (x,y,z)
						if wx and wy then
							vehicleComponents[componentName] = {componentName,wx,wy}
						end
						setElementData(value, "player->repairing", false)
					end
					if (getElementHealth(value) < 999) then
						damageParts[#damageParts + 1] = {"Motor Tamiri"}
					end
					if getVehicleLightState(value, 0) == 1 or getVehicleLightState(value, 1) == 1 or getVehicleLightState(value, 2) == 1 or getVehicleLightState(value, 3) == 1 then
						damageParts[#damageParts + 1] = {"Far Tamiri"}
					end
					loadingVehicleDamage = true
				end
				return {true,value}
			end
		end
		return {false,false}
	end
end
	
function getVehicleDamagedComponent(vehicle)
		if not isElement(vehicle) then
			return
		end
		damageComponents = {}

		local panelNames = {{"Sol ön panel","", 67, 500}, {"Sağ ön panel","", 68, 500}, {"Sol arka panel","", 69, 500}, {"Sağ arka panel","", 70, 500}, {"Ön cam", "windscreen_dummy", 71, 950}, {"Ön tampon","bump_front_dummy", 72, 600}, {"Arka tampon","bump_rear_dummy", 83, 600}}
		for i = 0, 6 do
			local panelState = getVehiclePanelState(vehicle, i)
			if (panelState ~= 0) then
				damageComponents[#damageComponents + 1] = {panelNames[i + 1][1], 1, i, panelNames[i + 1][2], vehicle, panelNames[i + 1][3],  panelNames[i + 1][4]}
			end
		end
		local doorNames = {{"Kaputu","bonnet_dummy", 73, 1200}, {"Bagajı","boot_dummy", 74, 1050}, {"Sol ön kapıyı","door_lf_dummy", 75, 750}, {"Sağ ön kapıyı","door_rf_dummy", 76, 750}, {"Sol arka kapıyı","door_lr_dummy", 77, 750}, {"Sağ arka kapıyı","door_rr_dummy", 78, 750}}
		for i = 0, 5 do
			local doorState = getVehicleDoorState(vehicle, i)
			if (doorState ~= 0) then
				damageComponents[#damageComponents + 1] = {doorNames[i + 1][1], 2, i, doorNames[i + 1][2], vehicle, doorNames[i + 1][3], doorNames[i + 1][4]}
				setElementData(vehicle, "player->door", 1) -- Beállítás Leszerelésre.
			end
		end
			local wheelNames = {{"Sol ön tekerleği","wheel_lf_dummy", 79, 250}, {"Sağ ön tekerleği","wheel_lb_dummy", 80, 250}, {"Sol arka tekerleği","wheel_rf_dummy", 81, 250}, {"Sağ arka tekerleği","wheel_rb_dummy", 82, 250}}
			local fLeftWheel, rLeftWheel, fRightWheel, rRightWheel = getVehicleWheelStates(vehicle)
			if (fLeftWheel ~= 0) then
				damageComponents[#damageComponents + 1] = {wheelNames[1][1], 3, 1, wheelNames[1][2], vehicle, wheelNames[1][3], wheelNames[1][4]}
				setElementData(vehicle, "player->fLeftWheel", 1) -- Beállítás Leszerelésre.
			end
			if (rLeftWheel ~= 0) then
				damageComponents[#damageComponents + 1] = {wheelNames[2][1], 3, 2, wheelNames[2][2], vehicle, wheelNames[2][3], wheelNames[2][4]}
				setElementData(vehicle, "player->rLeftWheel", 1) -- Beállítás Leszerelésre.
			end
			if (fRightWheel ~= 0) then
				damageComponents[#damageComponents + 1] = {wheelNames[3][1], 3, 3, wheelNames[3][2], vehicle, wheelNames[3][3], wheelNames[3][4]}
				setElementData(vehicle, "player->fRightWheel", 1) -- Beállítás Leszerelésre.
			end
			if (rRightWheel ~= 0) then
				damageComponents[#damageComponents + 1] = {wheelNames[4][1], 3, 4, wheelNames[4][2], vehicle, wheelNames[4][3], wheelNames[4][4]}	
				setElementData(vehicle, "player->rRightWheel", 1) -- Beállítás Leszerelésre.
			end	
			local lightNames = {"Sol ön farı", "Sağ ön farı", "Sol arka farı", "Sağ arka farı"}
	        for i = 0, 3 do
	            local lightState = getVehicleLightState(vehicle, i)
	            if (lightState ~= 0) then
		        damageComponents[#damageComponents + 1] = {lightNames[i + 1], 5, i}
				setElementData(vehicle, "player->light", 1)
		        end
	        end	
		return damageComponents
end

function updateVehicleComponent(element, componentName, type)
	if element and componentName then
		if type == "remove" then
			triggerServerEvent("player->removeComponentFromVehicle", localPlayer, localPlayer, element, componentName)
		else
			triggerServerEvent("player->updateComponentVehicle", localPlayer, localPlayer, element, componentName)
			
			if string.find(componentName, "wheel") then
				triggerServerEvent("player->repairWheel", localPlayer, localPlayer, element, componentName)
			end
			if componentName == "windscreen_dummy" or componentName == "bump_front_dummy" or componentName == "bump_rear_dummy" then
				triggerServerEvent("player->repairPanel", localPlayer, localPlayer, element, getDamagedPanelID(componentName))
			end
			if componentName == "bonnet_dummy" or componentName == "boot_dummy" or componentName == "door_lf_dummy" or componentName == "door_rf_dummy" or componentName == "door_lr_dummy" or componentName == "door_rr_dummy" then
				triggerServerEvent("player->repairDoors", localPlayer, localPlayer, element, getDamagedDoorID(componentName))
			end
		end
	end
end

function receiveRemove(element, componentName)
	if element and componentName then
		setVehicleComponentVisible(element, componentName, false)
	end
end
addEvent("player->removeComponentFromVehicleG", true)
addEventHandler("player->removeComponentFromVehicleG", root, receiveRemove)

function receiveCreate(element, componentName)
	if element and componentName then
		setVehicleComponentVisible(element, componentName, true)
	end
end
addEvent("player->updateComponentVehicleG", true)
addEventHandler("player->updateComponentVehicleG", root, receiveCreate)

local panelID = {
	{"Front-left panel", 0},
	{"Front-right panel", 1},
	{"Rear-left panel", 2},
	{"Rear-right panel", 3},
	{"windscreen_dummy", 4},
	{"bump_front_dummy", 5},
	{"bump_rear_dummy", 6},
}

local doorID = {
	{"bonnet_dummy", 0},
	{"boot_dummy", 1},
	{"door_lf_dummy", 2},
	{"door_rf_dummy", 3},
	{"door_lr_dummy", 4},
	{"door_rr_dummy", 5},
}

function getDamagedPanelID(componentName)
	for k, v in ipairs(panelID) do
		if tostring(componentName) == tostring(v[1]) then
			return v[2]
		end
	end
	return false
end

function getDamagedDoorID(componentName)
	for k, v in ipairs(doorID) do
		if tostring(componentName) == tostring(v[1]) then
			return v[2]
		end
	end
	return false
end

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(dobozbaVan(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end

function dobozbaVan(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

function dxCreateBorder(x,y,w,h,color)
	dxDrawRectangle(x,y,w+1,1,color)
	dxDrawRectangle(x,y+1,1,h,color)
	dxDrawRectangle(x+1,y+h,w,1,color)
	dxDrawRectangle(x+w,y+1,1,h,color)
end
