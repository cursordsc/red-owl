--[[ BackWeapons script By Gothem

	Feel free to use and change it as you want,
	obviously keeping the credit to the creator.--]]

local jugadores = {}
local lplayer = getLocalPlayer()
local info = {}
local sx,sy = guiGetScreenSize()

--[[
local currentInterior, currentDimension = 0, 0
local check2 = false

function makeCheck() --This function checks continously for a player interior or dimension change, in order to move all attached objects with the player when changing int/dim
	local newInterior, newDimension = getElementInterior(lplayer), getElementDimension(lplayer)
	if currentInterior ~= newInterior or currentDimension ~= newDimension then
		triggerServerEvent('back-weapons:update', root, lplayer, newInterior, newDimension)
		currentInterior, currentDimension = newInterior, newDimension
	end
end

function startCheck(check) --This function starts the whole int/dim check, since we dont need to start this check before we know the player is wearing something
	check = check or false
	if check then
		if not check2 then
			currentInterior, currentDimension = getElementInterior(lplayer), getElementDimension(lplayer)
			addEventHandler('onClientPreRender', root, makeCheck)
			check2 = true
		end
	else
		if check2 then
			removeEventHandler('onClientPreRender', root, makeCheck)
			check2 = false
		end
	end
end
addEvent('back-weapons:startCheck', true)
addEventHandler('back-weapons:startCheck', root, startCheck)]]

function crearArma(jug,arma)
	local model = obtenerObjeto(arma)
	local slot = getSlotFromWeapon(arma)
	jugadores[jug][slot] = createObject(model,0,0,0)
	setElementCollisionsEnabled(jugadores[jug][slot],false)
end

function destruirArma(jug,slot)
	destroyElement(jugadores[jug][slot])
	jugadores[jug][slot] = nil
end

addEventHandler("onClientResourceStart",getResourceRootElement(),function()
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		for k,v in ipairs(getElementsByType("player",root,true)) do
			jugadores[v] = {}
			info[v] = {true,isPedInVehicle(v)}
		end
	end
end,false)

addEventHandler("onClientPlayerQuit",root,function()
	if jugadores[source] and source ~= lplayer then
		for k,v in pairs(jugadores[source]) do
			destroyElement(v)
		end
		jugadores[source] = nil
		info[source] = nil
	end
end)

addEventHandler("onClientElementStreamIn",root,function()
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if getElementType(source) == "player" and source ~= lplayer then
			jugadores[source] = {}
			info[source] = {true,isPedInVehicle(source)}
		end
	end
end)

addEventHandler("onClientElementStreamOut",root,function()
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if jugadores[source] and source ~= lplayer then
			for k,v in pairs(jugadores[source]) do
				destroyElement(v)
			end
			jugadores[source] = nil
			info[source] = nil
		end
	end
end)

addEventHandler("onClientPlayerSpawn",root,function()
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if jugadores[source] then
			for k,v in pairs(jugadores[source]) do
				destruirArma(source,k)
			end
			info[source][1] = true
		end
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if jugadores[source] then
			for k,v in pairs(jugadores[source]) do
				destruirArma(source,k)
			end
			info[source][1] = false
		end
	end
end)

addEventHandler("onClientPlayerVehicleEnter",root,function()
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if jugadores[source] then
			for k,v in pairs(jugadores[source]) do
				destruirArma(source,k)
			end
			info[source][2] = true
		end
	end
end)

addEventHandler("onClientPlayerVehicleExit",root,function()
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if jugadores[source] then
			info[source][2] = false
		end
	end
end)

addEventHandler("onClientPreRender",root,function()
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		for k,v in pairs(jugadores) do
			local x,y,z = getPedBonePosition(k,3)
			currentInterior, currentDimension = getElementInterior(k), getElementDimension(k)
			local rot = math.rad(90-getPedRotation(k))
			local i = 15
			local wep = getPedWeaponSlot(k)
			local ox,oy = math.cos(rot)*0.22,-math.sin(rot)*0.22
			local alpha = getElementAlpha(k)
			--triggerEvent("back-weapons:startCheck", getLocalPlayer(), true)
			--startCheck(true)
			for q,w in pairs(v) do
				if q == wep then
					destruirArma(k,q)
				else
					setElementRotation(w,0,70,getPedRotation(k)+90)
					setElementAlpha(w,alpha)
					if q==2 then
						local px,py,pz = getPedBonePosition(k,51)
						local qx,qy = math.sin(rot)*0.11,math.cos(rot)*0.11
						setElementPosition(w,px+qx,py+qy,pz)
					elseif q==4 then
						local px,py,pz = getPedBonePosition(k,41)
						local qx,qy = math.sin(rot)*0.06,math.cos(rot)*0.06
						setElementPosition(w,px-qx,py-qy,pz)
					else
						setElementPosition(w,x+ox,y+oy,z-0.2)
						setElementRotation(w,-17,-(50+i),getPedRotation(k))
						i=i+15
					end
					setElementInterior(w, currentInterior)
					setElementDimension(w, currentDimension)
				end
			end
			if info[k][1] and not info[k][2] then
				for i=1,7 do
					local arma = getPedWeapon(k,i)
					--if arma~=wep and arma>0 and not jugadores[k][i] then
					if (arma == 30 or arma == 31 or arma == 25 or arma == 27 or arma == 33 or arma == 34) and not jugadores[k][i] then
						crearArma(k,arma)
					end
				end
			end
		end
	end
end)

function obtenerObjeto(arma)
	local m
	if arma > 1 and arma < 9 then
		m = 331 + arma
	elseif arma == 9 then
		m = 341
	elseif arma == 15 then
		m = 326
	elseif (arma > 21 and arma < 30) or (arma > 32 and arma < 39) or (arma > 40 and arma < 44) then
		m = 324 + arma
	elseif arma > 29 and arma < 32 then
		m = 325 + arma
	elseif arma == 32 then
		m = 372
	end
	return m
end