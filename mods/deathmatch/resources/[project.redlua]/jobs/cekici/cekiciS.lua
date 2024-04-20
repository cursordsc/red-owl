local routes = {}

function aracYenile(vehicle)
	setElementCollisionsEnabled(vehicle, true)
	respawnVehicle(vehicle)
end

function meslekBasla(oyuncu)
    if getElementData(oyuncu, "loggedin") == 1 then
        if getElementData(oyuncu, "cekici") then
            exports["infobox"]:addBox(oyuncu, "error", "Zaten Başlamışın")
            return
        end

        local arac = getPedOccupiedVehicle(oyuncu)
        local meslek = getElementData(oyuncu, "job")
        if meslek == 9 and arac then 
            if getElementModel(arac) == 433 then
                triggerClientEvent(oyuncu,"createVehicleMarker",oyuncu)
                table.insert(routes,{oyuncu,arac})
                exports["infobox"]:addBox(oyuncu, "info", "Çekeceğin araç haritada işaretlendi!")
                setElementData(oyuncu,"routeVehicle",arac)
            end
        end
    end
end
addCommandHandler("cekicibasla", meslekBasla)

function meslekBitir(oyuncu)
    if getElementData(oyuncu, "loggedin") == 1 then
        if getElementData(oyuncu, "job") == 9 then

            local arac = getPedOccupiedVehicle(oyuncu)
            setElementData(oyuncu, "job", 0)
            exports["infobox"]:addBox(oyuncu, "info", "Başarıyla meslekten ayrıldın.")

            if arac then
                fadeCamera(oyuncu, true, 1.0, 0, 0, 0)
                removePedFromVehicle(oyuncu)
                setElementPosition(oyuncu, -2428.4248046875, 501.572265625, 30.078125)
                aracYenile(arac)
            end

            setElementData(oyuncu, "cekici", nil)
            if getPlayerRoute(oyuncu) then
                endRoutePlayer(oyuncu)
            end
        end
    end
end
addCommandHandler("cekicibitir", meslekBitir)

function binisEngel ( oyuncu )
    local aracmeslek = getElementData(source, "job")
    local aracmodel = getElementModel(source)
    local oyuncumeslek = getElementData(oyuncu, "job")

    if aracmodel == 433 then
	   if oyuncumeslek ~= aracmeslek then
	       cancelEvent()
            exports["infobox"]:addBox(oyuncu, "error", "Sen çekici değilsin!")
	   end
    end
end
addEventHandler ( "onVehicleStartEnter", getRootElement(), binisEngel )

function cekiciIptal ( oyuncu )
    local aracmeslek = getElementData(source, "job")
    local oyuncumeslek = getElementData(oyuncu, "job")

    if not aracmeslek then return end
    	if oyuncumeslek == aracmeslek then
    		if getPlayerRoute(oyuncu) then
    	    fadeCamera (oyuncu, true, 1.0, 0, 0, 0) 
    	    setElementPosition(oyuncu, -2428.4248046875, 501.572265625, 30.07812525)
    	    aracYenile(source)
    	    for k,v in pairs(routes) do
    	        if not isElement(v[1]) or not isElement(v[2]) or getVehicleController(v[2]) ~= v[1] then
    	            breakRoute(k) 
    	        end
    	    end
        end
	end
end
addEventHandler ( "onVehicleExit", getRootElement(), cekiciIptal)

function pickupVehicle(vid)
	local vdata = cargoVehicles[vid]
	local offsets = {0,0,0}
	local pveh = getPedOccupiedVehicle( source )
	if getElementModel(pveh) == cekiciarac[1] then
		offsets = {vdata[2][1],vdata[2][2],vdata[2][3]}
	end
	local veh = createVehicle(vdata[1],0,0,0)
	setElementCollisionsEnabled( veh, false )
	setVehicleDamageProof(veh,true)
	setVehicleLocked(veh,true)
    attachElements(veh,pveh,offsets[1],offsets[2],offsets[3])
    exports["infobox"]:addBox(source, "success", "Araç başarıyla yüklendi, şimdi otoparka dön.")
	triggerClientEvent(source,"createCargoMarker",source)
end
addEvent("pickupVehicle",true)
addEventHandler("pickupVehicle",root,pickupVehicle)

function endRoute(lp)
	local r, key = getPlayerRoute(source)
	for k,v in pairs(getAttachedElements( r[2] )) do
		destroyElement(v)
    end
    setElementData(source,"cekici",nil)
	setElementData(source,"cekici:x",nil)
	setElementData(source,"cekici:y",nil)
    triggerClientEvent(source,"createVehicleMarker",source)
end
addEvent("endRoute",true)
addEventHandler("endRoute",root,endRoute)

function endRoutePlayer(ply)
	local r, key = getPlayerRoute(ply)
	for k,v in pairs(getAttachedElements( r[2] )) do
		destroyElement(v)
	end
    exports["infobox"]:addBox(ply, "success", "İşi tamamladın, paran hesabına yatırıldı.")
	table.remove(routes,key)
	removeElementData(ply,"routeVehicle")
	triggerClientEvent(ply,"destroyClientElements",ply)
    
    local para = getElementData(ply,"cekici:tasima")
    if not para then para = 0 end
    
    setElementData(ply,"cekici:tasima",nil)
    setElementData(ply,"cekici:para",nil)
    exports["global"]:giveMoney(ply, para)
end

function breakRoute(id)
    if isElement(routes[id][1]) then
        exports["infobox"]:addBox(routes[id][1], "info", "Göreviniz iptal oldu.")
		triggerClientEvent(routes[id][1],"destroyClientElements",routes[id][1])
	end
    for k,v in pairs(getAttachedElements( routes[id][2] )) do
		destroyElement(v)
	end

	table.remove(routes,id)
end

function checkRoutes()
	for k,v in pairs(routes) do
		if not isElement(v[1]) or not isElement(v[2]) or getVehicleController(v[2]) ~= v[1] then
			breakRoute(k) 
		end
	end
end
setTimer(checkRoutes,60000,0)

function getPlayerRoute(oyuncu)
	for k,v in pairs(routes) do
		if v[1] == oyuncu then
			return v, k
		end
	end
end


local kapiobje = createObject(968, 1070.8000488281, 1358.3000488281, 10.699999809265, 0, 269, 0)
local kapimarker = createMarker(1067.4407958984,1358.673828125,10.676380157471, "cylinder", 8, 255, 255, 255, 0)

addEventHandler ("onMarkerHit", root, function (element)
    if source == kapimarker and not isTimer (kapizaman) then
        if getElementType (element) == "player" and isPedInVehicle (element) then
            local sourceVehicle = getPedOccupiedVehicle (element)
            setElementVelocity (sourceVehicle, 0, 0, 0)
            moveObject (kapiobje, 1000, 1070.8000488281, 1358.3000488281, 10.699999809265, 0, 90, 0)
            setTimer (moveObject, 3500, 1, kapiobje, 1000, 1070.8000488281, 1358.3000488281, 10.699999809265, 0, -90, 0)
            kapizaman = setTimer(function() end, 5000, 1)
        return
        end
    end
end)