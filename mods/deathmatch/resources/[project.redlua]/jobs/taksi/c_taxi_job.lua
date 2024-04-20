local blip

local taxiguy = createPed(16, 1787.46484375, -1867.271484375, 13.570392608643, 0, true)
setElementData(taxiguy, "talk", 1)
setElementData(taxiguy, "name", "Kerem Kasikci")
setElementFrozen(taxiguy, true)

function taxiJobDisplayGUI()
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	
	if (carlicense==1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Kerem Kasikci diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		taxiAcceptGUI(getLocalPlayer())
    else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Kerem Kasikci diyor ki: Ehliyetin yok la senin. Bir de gelmiş taksi şoförü olmak istiyor.", 255, 255, 255, 10, {}, true)
	end
end
addEvent("taxi:displayJob", true)
addEventHandler("taxi:displayJob", getRootElement(), taxiJobDisplayGUI)

function taxiAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Taksi Şoförlüğü", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			setElementData(localPlayer, "job", 2)
			--triggerServerEvent("acceptJob", getLocalPlayer(), 2)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Turkce] Kerem Kasikci diyor ki: İlerdeki taksilerden birini alarak işe başlayabilirsin.", 255, 255, 255, 3, {}, true)
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


function resetTaxiJob()
	if (isElement(blip)) then
		destroyElement(blip)
		removeEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
	end
end

function displayTaxiJob()
	removeEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
	--exports.hud:sendBottomNotification(localPlayer, "Taxi Driver", "Approach the yellow blip on your radar and enter a Taxi to start your job.") --Text upon job selection and spawn
	addEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
end

function startTaxiJob(thePlayer)
	if (thePlayer==localPlayer) then
		if (getElementModel(source)==438 or getElementModel(source)==420) then
			removeEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
			--exports.hud:sendBottomNotification(localPlayer, "Taxi Driver", "You will be alerted when someone has ordered a Taxi. Use /taxilight to toggle your Taxi's light.") --When a taxi driver enters a taxi
			if (isElement(blip)) then
				destroyElement(blip)
			end
		end
	end
end

function taksiAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 420 and vehicleJob == 2 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			--outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
		elseif thePlayer == getLocalPlayer() and playerJob ~= 2 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFBu araca binmek için Taksi Şoförlüğü mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
		cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), taksiAntiYabanci)
--[[
-- taxi drivers occupied light
local keytime = 0
local function checkTaxiLights( key, state )
	local vehicle = getPedOccupiedVehicle( getLocalPlayer( ) )
	if getVehicleOccupant( vehicle ) == getLocalPlayer( ) and ( getElementModel( vehicle ) == 438 or getElementModel( vehicle ) == 420 ) then
		if state == "down" then
			keytime = getTickCount()
		elseif state == "up" and keytime ~= 0 then
			local delay = getTickCount() - keytime
			keytime = 0
			
			if delay < 200 then
				triggerServerEvent("toggleTaxiLights", getLocalPlayer( ), vehicle )
			end
		end
	else
		keytime = 0
	end
end
bindKey("horn", "both", checkTaxiLights)]]