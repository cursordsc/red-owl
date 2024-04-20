sx,sy = guiGetScreenSize()
barX, barY = sx /2-64, sy * 0.75 + 50
barW, barH = 128, 128

local saniye
local barDeger = 100

function dxDrawCircle(x,y,w,h,bar,ilerleme)
	for i = 1, bar do
		if i < ilerleme then
			r, g, b = 255, 127, 0
		else
			r, g, b = 10, 10, 10
		end
		dxDrawImage(x,y,w,h, "progress.png", 360 / bar * (i - 1), 0, 0, tocolor(r, g, b, 255))
	end
	for i = ilerleme - 3, ilerleme do
		if i > 0 then
			dxDrawImage(x,y,w,h, "progress.png", 360 / bar * i, 0, 0, tocolor(255, 127, 0, 255))
		end
	end
	if ilerleme < 7 then
		for i = bar - 3, bar - 1 do
			dxDrawImage(x,y,w,h, "progress.png", 360 / bar * i, 0, 0, tocolor(10, 10, 10, 255))
		end
	end
end	

deathTimer = 200
deathLabel = nil

function lowerTimer(isSuicide)
	-- local width, height = 201,54
	-- local scrWidth, scrHeight = guiGetScreenSize()
	-- local x = scrWidth/2 - (width/2)
	-- local y = scrHeight/1.1 - (height/2)
	-- deathLabel = guiCreateLabel(x, y, width, height, "", false)
	-- guiSetFont(deathLabel,"default-bold-small")
	-- guiLabelSetColor(deathLabel, 255, 0, 0)
	-- guiLabelSetVerticalAlign(deathLabel, "center")
	local isSuicide = isSuicide
	if (isSuicide == true) then
		deathTimer = 60
		--changeCountdownTimer = setTimer(lowerTimer2, 1000, 60)
		saniyeGoster(300000)
	else
		--changeCountdownTimer = setTimer(lowerTimer2, 1000, 200)	
		saniyeGoster(300000)		
	end
	addHPTimer = setTimer(setHP, 100, 0)
end
addEvent("es-system:lowerTimer", true)
addEventHandler("es-system:lowerTimer", getLocalPlayer(), lowerTimer)

function lowerTimer2()
	deathTimer = deathTimer - 1

	if (deathTimer>=1) then
		guiSetText(deathLabel, tostring(deathTimer) .. " saniye")
		if getElementHealth(getLocalPlayer()) <= 98 then
			setElementHealth(getLocalPlayer(), 100)
		end
	else
		if (isElement(deathLabel)) then
			destroyElement(deathLabel)
		end
		--triggerEvent("es-system:showRespawnButton",getLocalPlayer(), victimDropItem)
		triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
		triggerEvent("es-system:closeCountdownLabel",getLocalPlayer()) 
	end
end

function saniyeGoster(gelenSaniye)
	barDeger = gelenSaniye
	saniye = gelenSaniye
	saniyeTimer = setTimer(function()
		saniye = saniye -1 
		if saniye <= 0 then
			saniye = nil
			triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
			triggerEvent("es-system:closeCountdownLabel",getLocalPlayer()) 
		end	
	end,1000,saniye)
end

addEventHandler("onClientRender", root, function()
	if saniye then
		--[[local saniyee = math.ceil((saniye/barDeger)*100)
		dxDrawCircle(barX,barY,barW,barH,100,saniyee)
		local uzunluk = dxGetTextWidth(saniye,3,"default-bold-small")
		local x = ((barX+barW)-uzunluk)/2
		dxDrawText(saniye, barX+40,barY+35,barW+3,barH+3, tocolor(0, 0, 0, 200), 3, "default-bold-small")
		dxDrawText(saniye, barX+40,barY+35,barW,barH, tocolor(255, 255, 255, 255), 3, "default-bold-small")]]
	end	
end)	


function setHP()
	-- if getElementHealth(getLocalPlayer()) <= 98 then
		-- setElementHealth(getLocalPlayer(), 100)
	-- end
end

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", getLocalPlayer(),
	function()
		start = getTickCount()
	end
)
local bRespawn = nil
function showRespawnButton(victimDropItem)
	showCursor(true)
	local width, height = 201,54
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/1.1 - (height/2)
	bRespawn = guiCreateButton(x, y, width, height,"Tedavi Ol",false)
		guiSetFont(bRespawn,"sa-header")
	addEventHandler("onClientGUIClick", bRespawn, function () 
		if bRespawn then
			destroyElement(bRespawn)
			bRespawn = nil
			showCursor(false)
			guiSetInputEnabled(false)
		end
		triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
		triggerEvent("es-system:closeCountdownLabel",getLocalPlayer()) -- Burası SOrun Çıkartırsa Öbür Lua'daki acceptDeath Functionuna Koy!
		showCursor(false)
	end, false)
end
addEvent("es-system:showRespawnButton", true)
addEventHandler("es-system:showRespawnButton", getLocalPlayer(),showRespawnButton)

function closeRespawnButton()
	if bRespawn then
		destroyElement(bRespawn)
		bRespawn = nil
		showCursor(false)
		guiSetInputEnabled(false)
	end
end
addEvent("es-system:closeRespawnButton", true)
addEventHandler("es-system:closeRespawnButton", getLocalPlayer(),closeRespawnButton)

function closeCountdownLabel()
	if (isElement(deathLabel)) then
		destroyElement(deathLabel)
	end
	if isTimer(changeCountdownTimer) == true then
		killTimer(changeCountdownTimer)
	end
	if isTimer(addHPTimer) == true then
		killTimer(addHPTimer)
	end
	deathTimer = 200
	deathLabel = nil
	if isTimer(saniyeTimer) then killTimer(saniyeTimer) end
	saniye = nil
end
addEvent("es-system:closeCountdownLabel", true)
addEventHandler("es-system:closeCountdownLabel", getLocalPlayer(),closeCountdownLabel)

function makeImmortal(saldiran,silah)
	if getElementData(getLocalPlayer(), "dead") == 1 then
		if not isPlayerKinli(localPlayer,saldiran,silah) then
			cancelEvent()
		end	
	end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), makeImmortal )


local silahlar = {
	[22] = true,
	[23] = true, -- Handguns
	[24] = true,
	
	[25] = true,
	[26] = true, -- Shotguns
	[27] = true,
	
	[28] = true,
	[29] = true, -- Sub-Machine Guns
	[32] = true,
	
	[30] = true,
	[31] = true, -- Assault Rifles and Rifles
	[33] = true,
	[34] = true,
}

function isPlayerKinli(oyuncu,saldiran,silah)
	if not isElement(saldiran) then return end if saldiran == source then return  false end
	if getElementType(saldiran) ~= "player" then return false end
	if not silahlar[silah] then return false end
	
	local sikanlar = fromJSON(getElementData(oyuncu,"Sikanlar") or toJSON({}))
	local dbid = tostring(getElementData(saldiran,"dbid"))
	local sikanlar2 = fromJSON(getElementData(saldiran,"Sikanlar") or toJSON({}))
	local dbid2 = tostring(getElementData(oyuncu,"dbid"))
	local durum = false
	if sikanlar[dbid] and sikanlar2[dbid2] then
		durum = true
	end	
	return durum
end



-- local sikanlar = {}
addEventHandler("onClientPlayerDamage", getLocalPlayer(), function(saldiran,silah,kayip)
	if not isElement(saldiran) then return end if saldiran == source then return end
	if getElementType(saldiran) ~= "player" then return end
	if not silahlar[silah] then return end
	local olu = getElementData(localPlayer, "dead") or 0
	
	if olu == 0 then
		local sikanlar = fromJSON(getElementData(localPlayer,"Sikanlar") or toJSON({}))
		local dbid = getElementData(saldiran,"dbid")
		sikanlar[dbid] = true
		setElementData(localPlayer,"Sikanlar",toJSON(sikanlar))
	end
end)
