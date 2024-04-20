function SmallestID()
    local query = dbQuery(exports.mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

addEvent('carshop.close', true)
addEventHandler('carshop.close', root, function()
	if source then
		source:setPosition(1820.9351806641, -1438.5745849609, 13.958000183105)
		source.dimension = 0
		source.cameraInterior = 0
		source.cameraTarget = source
	end
end)

addEvent('carshop.buy', true)
addEventHandler('carshop.buy', root, function(id)
	if source and tonumber(id) then
		for index, value in ipairs(vehicles) do
			if index == id then
				if exports.global:takeMoney(source, value[5]) then
					local dbid = source:getData('dbid')
					local x, y, z = 1832.4873046875, -1453.42578125, 13.559859275818
					local rotZ = 267.53491210938
					local letter1 = string.char(math.random(65,90))
					local letter2 = string.char(math.random(65,90))
					local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
					local var1, var2 = exports['vehicle']:getRandomVariant(value[3])
					local color1 = toJSON( {255,255,255} )
					local color2 = toJSON( {0, 0, 0} )
					local color3 = toJSON( {0, 0, 0} )
					local color4 = toJSON( {0, 0, 0} )
					local tint = 0
					local factionVehicle = -1
					local smallestID = SmallestID()
					local veh = Vehicle(value[3], x,y,z)
		            veh:setColor(255, 255, 255)
					dbExec(exports.mysql:getConnection(), "INSERT INTO vehicles SET id='"..(smallestID).."', model='" .. (value[3]) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='0', roty='0', rotz='" .. (rotZ) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='" .. (factionVehicle) .. "', owner='" .. (dbid) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (rotZ) .. "', locked='1', interior='0', currinterior='0', dimension='0', currdimension='0', tintedwindows='" .. (tint) .. "',variant1='"..var1.."',variant2='"..var2.."', creationDate=NOW(), createdBy='-1', `vehicle_shop_id`='"..value[4].."' ")
					call(getResourceFromName("items" ), "deleteAll", 3, smallestID)
					exports.global:giveItem(source, 3, smallestID)
					veh:destroy()
					exports['vehicle']:reloadVehicle(smallestID)
					source:outputChat('►#D0D0D0 Başarıyla '..value[1]..' markalı aracı satın aldın!',195,184,116,true)
					exports.pass:completeTask(source, 5)
				else
					source:outputChat('►#D0D0D0 Bu aracı satın almak için paranız yeterli değil. Gerekli miktar: '..exports.global:formatMoney(value[5])..'$',195,184,116,true)
				end
			end
		end
	end
end)