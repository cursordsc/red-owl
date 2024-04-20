local mysql = exports["mysql"]

-- towing impound lot
--local towSphere = createColPolygon(2512.4189453125, -2622.16015625, 2512.4189453125, -2622.16015625, 2651.7905273438, -2621.8083496094, 2652.5529785156, -2522.259765625,  2512.416015625, -2522.3994140625)
--createColPolygon(-2097.544921875, -110.19140625, -2155.9931640625, -110.19140625, -2155.9873046875, -159.1455078125, -2158.908203125, -173.857421875, -2167.888671875, -188.4033203125, -2180.955078125, -197.376953125, -2196.6479492188, -200.7822265625, -2200.9301757813, -200.8916015625, -2200.8256835938, -280.0537109375, -2097.5439453125, -280.072265625, -2097.5458984375, -110.1904296875)
local towSphere = createColPolygon(2116.2353515625, 2367.7177734375, 2116.890625, 2367.220703125,
2054.142578125, 2367.57226562,
2054.1416015625, 2437.1279296875,
2116.2587890625, 2436.5400390625
)

local towImpoundSphere = createColCircle (2071.212890625, 2373.7548828125, 10)

local towSphere2 = createColPolygon(1245.8515625, -1651.591796875, 1279.8330078125, -1644.9619140625, 1279.8349609375, -1659.2939453125, 1268.767578125, -1659.517578125, 1268.771484375, -1677.0888671875, 1213.4970703125, -1677.193359375, 1213.4970703125, -1638.1162109375, 1268.7724609375, -1638.115234375, 1268.7939453125, -1644.833984375)

-- IGS - no /park zone
local towSphere3 = createColPolygon(2122.037109375, 2027.509765625, 2122.2119140625, 2027.5927734375, 1932.7294921875, 2027.2265625, 1932.3037109375, 2107.794921875, 2122.4150390625, 2108.4140625)

-- RS Haul no /park zone
local RSHaulSphere = createColPolygon(-78.111328125, -1100.345703125,-78.111328125, -1100.345703125, -91.4736328125, -1136.875, -54.2373046875, -1154.4375, -72.560157775879, -1195.5007324219, -44.3681640625, -1206.439453125, -30.9501953125, -1173.603515625, -22.3837890625, -1171.2099609375, -21.838672637939, -1150.0283203125, -24.0087890625, -1145.3431396484, -17.029296875, -1121.83984375)


function cannotVehpos(thePlayer, theVehicle)
    return isElementWithinColShape(thePlayer, towSphere) and getElementData(thePlayer,"faction") ~= 4 or isElementWithinColShape(thePlayer, towSphere3) or isElementWithinColShape(thePlayer, RSHaulSphere)
end

-- generic function to check if a guy is in the col polygon and the right team
function CanTowTruckDriverVehPos(thePlayer, commandName)
    local ret = 0
    if (isElementWithinColShape(thePlayer, towSphere) or isElementWithinColShape(thePlayer,towSphere2)) then
        if (getElementData(thePlayer,"faction") == 4) then
            ret = 2
        else
            ret = 1
        end
    end
    return ret
end

--Auto Pay for PD
function CanTowTruckDriverGetPaid(thePlayer, commandName)
    if (isElementWithinColShape(thePlayer,towSphere2)) then
        if (getElementData(thePlayer,"faction") == 4) then
            return true
        end
    end
    return false
end

function UnlockVehicle(element, matchingdimension) 
    if (getElementType(element) == "vehicle" and getVehicleOccupant(element) and getElementData(getVehicleOccupant(element),"faction") == 4 and getElementModel(element) == 525 and getVehicleTowedByVehicle(element)) then
        local temp = element
        while (getVehicleTowedByVehicle(temp)) do
            temp = getVehicleTowedByVehicle(temp)
            local owner = getElementData(temp, "owner")
            local faction = getElementData(temp, "faction")
            local dbid = getElementData(temp, "dbid")
            local impounded = getElementData(temp, "Impounded")
            local thePlayer = getVehicleOccupant(element)
            if (owner > 0) then
                if (faction > 3 or faction < 0) then
                    if (source == towSphere2) then
                        --PD make sure its not marked as impounded so it cannot be recovered and unlock/undp it
                        setVehicleLocked(temp, false)
                        exports["anticheat"]:changeProtectedElementDataEx(temp, "Impounded", 0)
                        exports["anticheat"]:changeProtectedElementDataEx(temp, "enginebroke", 0, false)
                        setVehicleDamageProof(temp, false)
                        setVehicleEngineState(temp, false)
                        outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", thePlayer, 255, 194, 14)
                    else
                        if (getElementData(temp, "faction") ~= 4) then
                            if (impounded == 0) then
                                --unlock it and impound it
                                exports["anticheat"]:changeProtectedElementDataEx(temp, "Impounded", getRealTime().yearday)
                                setVehicleLocked(temp, false)
                                exports["anticheat"]:changeProtectedElementDataEx(temp, "enginebroke", 1, false)
                                setVehicleEngineState(temp, false)
                                setElementDimension(temp, 450)
                                local query = dbExec(exports["mysql"]:getConnection(),"UPDATE vehicles SET dimension='450', currdimension='450' WHERE id='" .. (dbid) .. "'")
								exports['anticheat']:changeProtectedElementDataEx(temp, "dimension", 450)

                                local time = getRealTime()
                                -- fix trailing 0's
                                local hour = tostring(time.hour)
                                local mins = tostring(time.minute)
                                
                                if ( time.hour < 10 ) then
                                    hour = "0" .. hour
                                end
                                
                                if ( time.minute < 10 ) then
                                    mins = "0" .. mins
                                end
                                local datestr = time.monthday .. "/" .. time.month .." " .. hour .. ":" .. mins
                                
                                local theTeam = exports["pool"]:getElement("team", 4)
                                local factionRanks = getElementData(theTeam, "ranks")
                                local factionRank = factionRanks[ getElementData(thePlayer, "factionrank") ] or ""
                                
                                exports["global"]:giveItem(temp, 72, "İTV - Çeken Kişi ".. factionRank .." '".. getPlayerName(thePlayer) .."' - Tarih: "..datestr)
                                outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", thePlayer, 255, 194, 14)
                                local factionName = getTeamName(theTeam)
                                local owner = getElementData(temp, "owner")
                                local account = exports["cache"]:getAccountFromCharacterId(owner) or {id = 0, username="No-one"}
                                local characterName = exports["cache"]:getCharacterNameFromID(owner) or "No-one"
                            end
                        end
                    end
                else
                    outputChatBox("This faction's vehicle cannot be impounded.", thePlayer, 255, 194, 14)
                end
            end
        end
    end
end
addEventHandler("onColShapeHit", towImpoundSphere, UnlockVehicle)
addEventHandler("onColShapeHit", towSphere2, UnlockVehicle)

-- Command to impound Bikes:
function setbikeimpound(player, matchingDimension)
    local leader = tonumber( getElementData(player, "factionleader") ) or 0
    local rank = tonumber( getElementData(player, "factionrank") ) or 0

    local veh = getPedOccupiedVehicle(player)
    if (getElementData(player,"faction")) == 4 then
        if (isPedInVehicle(player)) then
            if (getVehicleType(veh) == "Bike") or (getVehicleType(veh) == "BMX") then
                local owner = getElementData(veh, "owner")
                local faction = getElementData(veh, "faction")
                local dbid = getElementData(veh, "dbid")
                local impounded = getElementData(veh, "Impounded")
                if (owner > 0) then
                    if (faction > 3 or faction < 0) then
                        if (source == towSphere2) then
                            --PD make sure its not marked as impounded so it cannot be recovered and unlock/undp it
                            setVehicleLocked(veh, false)
                            exports["anticheat"]:changeProtectedElementDataEx(veh, "Impounded", 0)
                            exports["anticheat"]:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
                            setVehicleDamageProof(veh, false)
                            setVehicleEngineState(veh, false)
                            outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", player, 255, 194, 14)
                        else
                            if rank >= 5 then
                                if (getElementData(veh, "faction") ~= 4) then
                                    if (impounded == 0) then
                                        exports["anticheat"]:changeProtectedElementDataEx(veh, "Impounded", getRealTime().yearday)
                                        setVehicleLocked(veh, false)
                                        exports["anticheat"]:changeProtectedElementDataEx(veh, "enginebroke", 1, false)
                                        setVehicleEngineState(veh, false)
                                        outputChatBox("(( The bike has been successfully impounded. ))", player, 50, 205, 50)
                                        outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", player, 255, 194, 14)
                                        isin = false
                                        
                                        exports["logs"]:logMessage("[IMPOUNDED BIKE] " .. getPlayerName(player) .. " impounded vehicle #" .. dbid .. ", owned by " .. tostring(exports['cache']:getCharacterName(owner)) .. ", in " .. table.concat({exports["global"]:getElementZoneName(veh)}, ", ") .. " (pos = " .. table.concat({getElementPosition(veh)}, ", ") .. ", rot = ".. table.concat({getVehicleRotation(veh)}, ", ") .. ", health = " .. getElementHealth(veh) .. ")", 14)
                                    end
                                end
                            else
                                local factionRanks = getElementData(getPlayerTeam(player), "ranks")
                                local factionRank = factionRanks[ 5 ] or "awesome dudes"
                                outputChatBox("Command only usable by " .. factionRank .. " and above.", player, 255, 194, 14)
                            end
                        end
                    else
                        outputChatBox("This faction's vehicle cannot be impounded.", player, 255, 194, 14)
                    end
                end
            else
                outputChatBox("You can only use this command to impound motorcycles and bicycles.", player, 255, 194, 14)
            end
        else
            outputChatBox("You are not in a vehicle.", player, 255, 0, 0)
        end
    end
end
addCommandHandler("impoundbike", setbikeimpound)

function payRelease(vehID)
    if exports["global"]:takeMoney(source, 1000) then
        exports["global"]:giveMoney(getTeamFromName("Los Santos Vergi Dairesi"), 1000)
        --dbExec(mysql:getConnection(),  "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(source, "dbid") .. ", " .. -getElementData(getTeamFromName("Rapid Towing"), "id") .. ", " .. 1000 .. ", 'Vehicle Release', 5)" )
        setElementFrozen(vehID, false)
        local x, y, z, int, dim, rotation = getReleasePosition()
        setElementPosition(vehID, x, y, z)
        setVehicleRotation(vehID, 0, 0, rotation)
        setElementInterior(vehID, int)
        setElementDimension(vehID, dim)
        setVehicleLocked(vehID, true)
        unimpVeh(getElementData(vehID, "dbid"))
        exports["anticheat"]:changeProtectedElementDataEx(vehID, "enginebroke", 0, true)
        setVehicleDamageProof(vehID, false)
        setVehicleEngineState(vehID, false)
        exports["anticheat"]:changeProtectedElementDataEx(vehID, "handbrake", 0, true)
        exports["anticheat"]:changeProtectedElementDataEx(vehID, "Impounded", 0)

        --outputChatBox("Your vehicle has been released, it's out front. (( Please remember to /park your vehicle so it does not respawn back here. ))", source, 255, 194, 14)
        exports["infobox"]:addBox(source, "info", "Aracınız otoparkın önünde, tekrar park etmeyi unutmayınız...")
    else
        outputChatBox("Insufficient funds.", source, 255, 0, 0)
    end
end
addEvent("releaseCar", true)
addEventHandler("releaseCar", getRootElement(), payRelease)

function unimpoundVeh(thePlayer, commandName, vehid)
    if thePlayer then
        if not vehid then
            outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 255, 194, 14)
        else
            local vehID = exports["pool"]:getElement("vehicle", tonumber(vehid))
            if not vehID then
                outputChatBox("Invalid Vehicle.", thePlayer, 255, 0, 0)
            else
                if getElementData(vehID, "Impounded") and getElementData(vehID, "Impounded") ~= 0 then
                    if commandName == "unimpound" then
                        if (getElementData(thePlayer,"faction") == 4) then
                            if(getElementData(thePlayer, "factionleader") == 1) then
                                setElementFrozen(vehID, false)
                                local x, y, z, int, dim, rotation = getReleasePosition()
                                setElementPosition(vehID, x, y, z)
                                setVehicleRotation(vehID, 0, 0, rotation)
                                setElementInterior(vehID, int)
                                setElementDimension(vehID, dim)
                                setVehicleLocked(vehID, true)
                                exports["anticheat"]:changeProtectedElementDataEx(vehID, "enginebroke", 0, true)
                                setVehicleDamageProof(vehID, false)
                                setVehicleEngineState(vehID, false)
                                exports["anticheat"]:changeProtectedElementDataEx(vehID, "handbrake", 0, true)
                                exports["anticheat"]:changeProtectedElementDataEx(vehID, "Impounded", 0)
                                updateVehPos(vehID)
                                triggerEvent("parkVehicle", thePlayer, vehID)

                                outputChatBox("You have unimpounded vehicle #" .. vehid .. ".", thePlayer, 0, 255, 0)
                                
                                local theTeam = exports["pool"]:getElement("team", 4)
                                local teamPlayers = getPlayersInTeam(theTeam)
                                local username = getPlayerName(thePlayer):gsub("_", " ")
                                for key, value in ipairs(teamPlayers) do
                                    outputChatBox(username .. " has unimpounded vehicle #" .. vehid .. ".", value, 0, 255, 0)
                                end
                                
                                exports["logs"]:logMessage("[SFTR-UNIMPOUND] " .. username .. " has unimpounded vehicle #" .. vehid .. ".", 9)
                            else
                                outputChatBox("You must be the faction leader.", thePlayer, 255, 0, 0)
                            end
                        end
                    elseif commandName == "aunimpound" then
                        if exports["integration"]:isPlayerTrialAdmin(thePlayer)  then
                            local impounder = getElementData(vehID, "impounder")
                            if impounder == 1 or impounder == 59 then
                                local state, reason = unimpVeh(getElementData(vehID, "dbid"))
                                outputChatBox(reason, thePlayer)
                            else
                                setElementFrozen(vehID, false)
                                local x, y, z, int, dim, rotation = getReleasePosition(getElementData(vehID, "impounder"))
                                setElementPosition(vehID, x, y, z)
                                setVehicleRotation(vehID, 0, 0, rotation)
                                setElementInterior(vehID, int)
                                setElementDimension(vehID, dim)
                                setVehicleLocked(vehID, true)
                                exports["anticheat"]:changeProtectedElementDataEx(vehID, "enginebroke", 0, true)
                                setVehicleDamageProof(vehID, false)
                                setVehicleEngineState(vehID, false)
                                exports["anticheat"]:changeProtectedElementDataEx(vehID, "handbrake", 0, true)
                                exports["anticheat"]:changeProtectedElementDataEx(vehID, "Impounded", 0)
                                updateVehPos(vehID)
                                triggerEvent("parkVehicle", thePlayer, vehID)
                                
                                local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
                                local playerName = getPlayerName(thePlayer):gsub("_", " ")
                                outputChatBox("You have unimpounded vehicle #" .. vehid .. ".", thePlayer, 0, 255, 0)
                                exports["global"]:sendMessageToAdmins("AdmCmd: " .. adminTitle .. " " .. playerName .. " unimpounded vehicle #" .. vehid .. ".")
                                
                                exports["logs"]:logMessage("[ADMIN-UNIMPOUND] " .. playerName .. " has unimpounded vehicle #" .. vehid .. ".", 9)
                            end
                        end
                    end
                else
                    outputChatBox("Vehicle #" .. vehid .. " is not currently impounded.", thePlayer, 255, 0, 0)
                end
            end
        end
    end
end
addCommandHandler("unimpound", unimpoundVeh)
addCommandHandler("aunimpound", unimpoundVeh)

function disableEntryToTowedVehicles(thePlayer, seat, jacked, door) 
    if (getVehicleTowingVehicle(source)) then
        if seat == 0 then
            outputChatBox("You cannot enter a vehicle being towed!", thePlayer, 255, 0, 0)
            cancelEvent()
        end
    end
end
addEventHandler("onVehicleStartEnter", getRootElement(), disableEntryToTowedVehicles)

function releaseHandbrake(theTruck) -- Release handbrake on the vehicle being attached or being towed / Maxime
    if getElementData(source, "handbrake") ~= 0 then
        exports["anticheat"]:changeProtectedElementDataEx(source, "handbrake", 0, true)
        setElementFrozen(source, false) 
        triggerEvent("vehicle:handbrake:lifted", source)
    end
end
addEventHandler("onTrailerAttach", getRootElement(), releaseHandbrake)

function triggerShowImpound()
    element = client
    local vehElements = {}
    local count = 1
    for key, value in pairs(exports["pool"]:getPoolElementsByType("vehicle")) do
        local dbid = getElementData(value, "dbid")
        local impounded = getElementData(value, "Impounded") or 0
        local impounder = getElementData(value, "impounder") or 4
        local owner = getElementData(value, "owner")
        local charId = getElementData(element, "dbid")
        local charFaction = getElementData(element, "faction") 
        local vehFaction = getElementData(value, "faction")
        if dbid > 0 and impounded ~= 0 and impounder == 4 and (owner==charId or vehFaction==charFaction) then
            vehElements[count] = value
            count = count + 1
        end
    end
    triggerClientEvent( element, "ShowImpound", element, vehElements)
end
addEvent("onTowMisterTalk", true)
addEventHandler("onTowMisterTalk", getRootElement(), triggerShowImpound)

function updateVehPos(veh)
    local x, y, z = getElementPosition(veh)
    local rx, ry, rz = getVehicleRotation(veh)
        
    local interior = getElementInterior(veh)
    local dimension = getElementDimension(veh)
    local dbid = getElementData(veh, "dbid")
    dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
    setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
    exports["anticheat"]:changeProtectedElementDataEx(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
end

function updateTowingVehicle(theTruck)
    local thePlayer = getVehicleOccupant(theTruck)
    if (thePlayer) and not getElementData(theTruck, "tramvay") then
        if getElementType(thePlayer) == "player" then
            if (getElementData(thePlayer,"faction") == 4) or (getElementData(thePlayer,"faction") == 42) then
                local owner = getElementData(source, "owner")
                local faction = getElementData(source, "faction")
                local carName = exports["global"]:getVehicleName(source)

                if owner < 0 and faction == -1 then
                    outputChatBox("(( This " .. carName .. " is a civilian vehicle. ))", thePlayer, 255, 195, 14)
                elseif (faction==-1) and (owner>0) then
                    local ownerName = exports["cache"]:getCharacterName(owner)
                    outputChatBox("(( This " .. carName .. " belongs to " .. ownerName .. ". ))", thePlayer, 255, 195, 14)
                else
                    dbQuery(
		    	    function(qh)
		    	    	local res, rows, err = dbPoll(qh, 0)
		    	    	if rows > 0 then
		    	    		for index, row in ipairs(res) do
                                if not (row == false) then
                                    local ownerName = row.name
                                     outputChatBox("(( This " .. carName .. " belongs to the " .. ownerName .. " faction. ))", thePlayer, 255, 195, 14)
                                end
		    	    		end
		    	    	end
		    	    end,
		    	    mysql:getConnection(), "SELECT name FROM factions WHERE id='" .. (faction) .. "' LIMIT 1")
                end

                if (getElementData(source, "Impounded") > 0) then
                    local output = getRealTime().yearday-getElementData(source, "Impounded")
                    outputChatBox("(( This " .. carName .. " has been impounded for: " .. output .. (output == 1 and " Day." or " Days.") .. " ))", thePlayer, 255, 195, 14)
                end

                -- fix for handbraked vehicles
                local handbrake = getElementData(source, "handbrake")
                if (handbrake == 1) then
                    exports["anticheat"]:changeProtectedElementDataEx(source, "handbrake",0,true)
                    setElementFrozen(source, false)
                end
            end
            if thePlayer then
                exports["logs"]:logMessage("[TOW] " .. getPlayerName( thePlayer ) .. " started towing vehicle #" .. getElementData(source, "dbid") .. ", owned by " .. tostring(exports['cache']:getCharacterName(getElementData(source,"owner"))) .. ", from " .. table.concat({exports["global"]:getElementZoneName(source)}, ", ") .. " (pos = " .. table.concat({getElementPosition(source)}, ", ") .. ", rot = ".. table.concat({getVehicleRotation(source)}, ", ") .. ", health = " .. getElementHealth(source) .. ")", 14)
            end
        end
    end
end

addEventHandler("onTrailerAttach", getRootElement(), updateTowingVehicle)

function updateCivilianVehicles(theTruck)
    if (isElementWithinColShape(theTruck, towSphere)) then
        local owner = getElementData(source, "owner")
        local faction = getElementData(source, "faction")
        local dbid = getElementData(source, "dbid")

        if (dbid >= 0 and faction == -1 and owner < 0) then
            exports["global"]:giveMoney(exports["pool"]:getElement("team", 4), 200)
            outputChatBox("The state has unimpounded the vehicle you were towing.", getVehicleOccupant(theTruck), 255, 194, 14)
            respawnVehicle(source)
        end
    end
    
    if getVehicleOccupant(theTruck) then
        exports["logs"]:logMessage("[TOW STOP] " .. getPlayerName( getVehicleOccupant(theTruck) ) .. " stopped towing vehicle #" .. getElementData(source, "dbid") .. ", owned by " .. tostring(exports['cache']:getCharacterName(getElementData(source,"owner"))) .. ", in " .. table.concat({exports["global"]:getElementZoneName(source)}, ", ") .. " (pos = " .. table.concat({getElementPosition(source)}, ", ") .. ", rot = ".. table.concat({getVehicleRotation(source)}, ", ") .. ", health = " .. getElementHealth(source) .. ")", 14)
    end
end
addEventHandler("onTrailerDetach", getRootElement(), updateCivilianVehicles)
