addCommandHandler("clearvehs",
    function(player, cmd)
        if exports.integration:isPlayerLeadAdmin(player) then
            local count = 0
            for index, vehicle in ipairs(exports.global:getNearbyElements(player, "vehicle")) do
                if vehicle:getData("job") == 0 then
                    vehicle:setDimension(333)
                    count = count + 1
                end
            end
            if count > 0 then 
                outputChatBox("[-]#ffffff Çevrende bulunan "..count.." aracı gönderdin.", player, 30, 255, 200, true)
            end
        end
    end
)

addEvent('autopark > accept',true)
addEventHandler('autopark > accept', root, 
    function(player)
        local vehicle = getPedOccupiedVehicle(player)
        if player.vehicle then
            vehicle:setDimension(333)
            local occupants = getVehicleOccupants(vehicle)
            for index, player in pairs(occupants) do
                removePedFromVehicle(player)
                player:setInterior(0)
            	player:setDimension(0)
            end
            exports.infobox:addBox(player, 'info',"Başarıyla #"..vehicle:getData("dbid").." idli aracını otopark'a gönderdin.")
        end
    end
)

addEvent('autopark > getcar', true)
addEventHandler('autopark > getcar', root, 
    function(vehid)
        local vehicle = exports.pool:getElement("vehicle", tonumber(vehid))
        vehicle:setInterior(getElementInterior(source))
        vehicle:setDimension( getElementDimension(source))
        vehicle:setPosition(2101.318359375, -1783.54296875, 13.393859863281)
        vehicle:setRotation(0,0,269)
        exports.infobox:addBox(source, 'success',"Otoparktan #"..vehicle:getData("dbid").." idli aracını çıkarttın.")
    end
)
