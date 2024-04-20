
local mysql = exports["mysql"]:getConnection()
local radius = 3

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local query = dbQuery(mysql, "SELECT MIN(e1.id+1) AS nextID FROM ramps AS e1 LEFT JOIN ramps AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

function ramp_add ( p, cmd )
    if exports["integration"]:isPlayerTrialAdmin(p) then
		local konum = p:getPosition()
		local yon = p:getRotation()
    	local x, y, z = konum:getX(), konum:getY(), konum:getZ()
    	local _, _, rz = yon:getX(), yon:getY(), yon:getZ()
		local interior = p:getInterior()
		local dimension = p:getDimension()
		local creator = p:getName():gsub("_", " ")
		local id = SmallestID ( )

    	local tx = x + - ( radius ) * math.sin ( math.rad ( rz ) )
    	local ty = y + radius * math.cos ( math.rad ( rz ) )
		local position = toJSON ( { tx, ty, z - 1.15 } )

		local kayit = mysql:exec("INSERT INTO ramps SET id=" .. id .. ",position='" .. position .. "',interior='" .. interior .. "',dimension='" .. dimension .. "',rotation=" .. math.ceil ( rz ) .. ",creator='" .. creator .. "', state=0" )
		
		if kayit then
			ramp_load ( id )
			p:outputChat("Lift başarıyla oluşturuldu! | ID: " .. id ..".", 0, 255, 0, false )
			exports["global"]:giveItem ( p, 151, id )
			exports["global"]:sendMessageToAdmins ( "AdmWarn: " .. creator .. " bir lift oluşturdu! | ID: " .. id )
		else
			p:outputChat("Lift oluşturulamadı! ERR#01", 255, 0, 0, false )
		end
	end
end
addCommandHandler ( "addramp", ramp_add )

function ramp_delete ( p, cmd, id )
	if exports["integration"]:isPlayerTrialAdmin(p) then
    	local kayit = mysql:exec("DELETE FROM ramps WHERE id = " .. id )
        
		if kayit then
			local deleter = p:getName():gsub("_", " ")
				
			for i,v in ipairs ( getElementsByType ( "object" ) ) do
				if isElement ( v ) and v:getData("garagelift" ) and v:getData("dbid" ) == tonumber ( id ) then
					local lift = v:getData("lift" )
					destroyElement ( lift )
					destroyElement ( v )
				end
			end
			
			p:outputChat("" .. id .." ID'li rampa başarıyla silindi!", 255, 0, 0, false )
			exports["global"]:sendMessageToAdmins ( "AdmWarn: " .. deleter .. " bir rampayı sildi! | ID: " .. id )
		else
			p:outputChat("Geçersiz Lift ID!", 255, 0, 0, false )
		end
	end
end
addCommandHandler ( "delramp", ramp_delete )

function ramp_init ( )
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			--while true do
				for index, row in ipairs(res) do
					if not row then 
						break 
					end
					ramp_load ( row.id )
				end
			--end
		else
			exports["global"]:sendMessageToAdmins ( "AdmWarn: Failed to select ramps from MySQL Database, please panic." )
		end
	end,
	mysql,  "SELECT * FROM ramps")
	
	removeWorldModel(2053, 10000, 0, 0, 0)
	removeWorldModel(2054, 10000, 0, 0, 0)
end

function ramp_load ( id )
dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				for k, v in pairs( row ) do
					if v == null then
						row[k] = nil
					else
						row[k] = tonumber(v) or v
					end
				end
				
				local x, y, z = unpack ( fromJSON ( row.position ) )
				local rz = row.rotation
				local int = row.interior
				local dim = row.dimension
				
				local frame = Object(2052, x, y, z, 0, 0, rz )
				local lift = Object(2053, x, y, z, 0, 0, rz )
				
				frame:setDimension(dim)
				frame:setInterior(int)
				lift:setDimension(dim)
				lift:setInterior(int)
				
				if tonumber ( row.state ) == 1 then
					lift:setPosition( x, y, z + 2.5 )
					frame:setData("lift.up", true )
				else
					lift:setPosition( lift, x, y, z + 0.17 )
				end
				
				frame:setData("garagelift", true )
				frame:setData("lift", lift )
				frame:setData("dbid", tonumber ( id ) )
				frame:setData("creator", row.creator )
			end
		end
	end,
	mysql, "SELECT * FROM ramps WHERE id = " .. id )
end

function getNearbyRamps ( p )
	if exports["integration"]:isPlayerTrialAdmin(p) then
		
		local konum = p:getPosition()
		local px, py, pz = konum:getX(), konum:getY(), konum:getZ()
		local dimension = p:getDimension()
		local count = 0
		
		p:outputChat("Çevrede ki Liftler:", 255, 126, 0, false )
		
		for i,v in ipairs ( getElementsByType ( "object" ) ) do
			if v:getData("garagelift" ) and v:getDimension() == dimension then
				local konum2 = v:getPosition()
				local x, y, z = konum2:getX(), konum2:getY(), konum2:getZ()
				local distance = getDistanceBetweenPoints3D ( px, py, pz, x, y, z )
				
				if distance < 11 then
					local dbid = v:getData("dbid" )
					local creator = v:getData("creator" )
					
					p:outputChat(" ID " .. dbid .. " | Oluşturan: " .. creator, 255, 126, 0, false )
					count = count + 1
				end
			end
		end
		
		if count == 0 then
			p:outputChat("   Hiç bulunmuyor.", 255, 126, 0, false )
		end
	end
end
addCommandHandler ( "nearbyramps", getNearbyRamps )

function gotoRamp ( p, commandName, target )
    if exports["integration"]:isPlayerTrialAdmin(p) then
	if not target then
		p:outputChat("SYNTAX: /" .. commandName .. " [Ramp ID]", 255, 194, 14)
		else
		for i,v in ipairs ( getElementsByType ( "object" ) ) do
			if v:getData("garagelift" ) then
				local dbid = v:getData("dbid" )
				if (tonumber(target) == tonumber(dbid)) then
				local konum = v:getPosition()
				local x, y, z = konum:getX(), konum:getY(), konum:getZ()
				local int = v:getInterior()
				local dim = v:getDimension()
					
				p:setPosition(x, y, z)
				p:setInterior(int)
				p:setDimension(dim)
				
				p:outputChat("Teleported to ramp ID " .. dbid .. ".", 255, 126, 0, false )
				end
			end
		end
	end
	end
end
addCommandHandler ( "gotoramp", gotoRamp )

addEventHandler ( "onResourceStart", resourceRoot, ramp_init )