-- © 2018 needGaming
function playerAnimationToServer (localPlayer, animName, animtoName, itemID)
	setPedAnimation(localPlayer, animName, animtoName, -1, true, false, false, false)
end
addEvent("playerAnimationToServer", true)
addEventHandler("playerAnimationToServer", getRootElement(), playerAnimationToServer)

function removeComponentFromVehicle (player, element,commandName)
	triggerClientEvent(getRootElement(), "player->removeComponentFromVehicleG", getRootElement(), element, commandName)
end
addEvent("player->removeComponentFromVehicle", true)
addEventHandler("player->removeComponentFromVehicle", getRootElement(), removeComponentFromVehicle)

function updateComponentVehicle (player, element,commandName)
	triggerClientEvent(getRootElement(), "player->updateComponentVehicleG", getRootElement(), element, commandName)
end
addEvent("player->updateComponentVehicle", true)
addEventHandler("player->updateComponentVehicle", getRootElement(), updateComponentVehicle)

function repairEngine (player, element)
	setElementHealth(element, 1000)
	setElementData(element, "veh.engineCrash", 0)
end
addEvent("player->repairEngine", true)
addEventHandler("player->repairEngine", getRootElement(), repairEngine)

function repairLights(player, element)
    setVehicleLightState(element, 0, 0)
	setVehicleLightState(element, 1, 0)
	setVehicleLightState(element, 2, 0)
	setVehicleLightState(element, 3, 0)
end
addEvent("player->repairLights", true)
addEventHandler("player->repairLights", getRootElement(), repairLights)

function attachFunction (vehicle, liftID)
	attachElements ( vehicle, object1[liftID], 0, 0, 0.12 , 0, 0, 90)
end
addEvent("attachFunction", true)
addEventHandler("attachFunction", root, attachFunction)

function detachFunction (liftID)
	setTimer(function()
		detachElements(liftID)
	end, 10000-10, 1)
end
addEvent("detachFunction", true)
addEventHandler("detachFunction", root, detachFunction)

function repairWheel(playerSource, element , fixComponentName)
	local fLeftWheel, rLeftWheel, fRightWheel, rRightWheel = getVehicleWheelStates(element)
	if (tostring(fixComponentName) == "wheel_lf_dummy") then
		fLeftWheel = 0
	elseif (tostring(fixComponentName) == "wheel_lb_dummy") then
		rLeftWheel = 0
	elseif (tostring(fixComponentName) == "wheel_rf_dummy") then
		fRightWheel = 0
	elseif (tostring(fixComponentName) == "wheel_rb_dummy") then
		rRightWheel = 0
	end
	setVehicleWheelStates(element, fLeftWheel, rLeftWheel, fRightWheel, rRightWheel)
end
addEvent("player->repairWheel", true)
addEventHandler("player->repairWheel", getRootElement(), repairWheel)

function repairPanel(playerSource, element , fixComponentID)
	if element and fixComponentID then 
		setVehiclePanelState(element, fixComponentID, 0)
	end
end
addEvent("player->repairPanel", true)
addEventHandler("player->repairPanel", getRootElement(), repairPanel)

function repairDoors(playerSource, element , fixComponentID)
	if element and fixComponentID then 
		setVehicleDoorState(element, fixComponentID, 0)
		setVehiclePanelState(element, fixComponentID, 0)
	end
end
addEvent("player->repairDoors", true)
addEventHandler("player->repairDoors", getRootElement(), repairDoors)
