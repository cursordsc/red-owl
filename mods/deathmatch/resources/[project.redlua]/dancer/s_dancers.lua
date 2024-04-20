mysql = exports["mysql"]

local peds = { }

local currentcycle = 1

local dancingcycles = 
{
	{
		{ "DANCING", "DAN_Down_A" },
		{ "DANCING", "DAN_Loop_A" },
		{ "DANCING", "DAN_Right_A" },
		{ "DANCING", "dnce_M_d" }
	},
	{
		{ "STRIP", "STR_Loop_C" },
		{ "STRIP", "strip_D" },
		{ "STRIP", "Strip_Loop_B" },
		{ "STRIP", "STR_C2" }
	}
}

function SmallestID( )
	local query = dbQuery(mysql:getConnection(),"SELECT MIN(e1.id+1) AS nextID FROM dancers AS e1 LEFT JOIN dancers AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

addEventHandler( "onResourceStart", getResourceRootElement( ),
	function( )
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						if not row then break end
					
						local id = tonumber( row["id"] )
						local x = tonumber( row["x"] )
						local y = tonumber( row["y"] )
						local z = tonumber( row["z"] )
						local rotation = tonumber( row["rotation"] )
						local skin = tonumber( row["skin"] )
						local type = tonumber( row["type"] )
						local interior = tonumber( row["interior"] )
						local dimension = tonumber( row["dimension"] )
						local offset = tonumber( row["offset"] )
							
						local ped = createPed( skin, x, y, z )
						exports["anticheat"]:changeProtectedElementDataEx( ped, "dbid", id, false )
						exports["anticheat"]:changeProtectedElementDataEx( ped, "position", { x, y, z, rotation }, false )
						ped:setRotation(rotation)
						ped:setInterior(interior )
						ped:setDimension(dimension )
							
						peds[ ped ] = { type, offset }
					end
				end
			end,
		mysql:getConnection(), "SELECT id, x, y, z, rotation, skin, type, interior, dimension, offset FROM dancers")

		setTimer( updateDancing, 50, 1 )
		setTimer( updateDancing, 12000, 0 )
	end
)

addCommandHandler( "adddancer", 
	function( oyuncu, commandName, type, skin, offset )
		if exports["integration"]:isPlayerAdmin( oyuncu ) then
			type = math.floor( tonumber( type ) or 0 )
			skin = math.floor( tonumber( skin ) or -1 )
			offset = math.floor( tonumber( offset ) or -1 )
			if not type or not skin or type < 1 or type > 2 or offset < 0 or offset > 3 then
				oyuncu:outputChat("SYNTAX: /" .. commandName .. " [1=Dancer, 2=Stripper] [Skin] [Offset 0-3]", 255, 194, 14 )
			else
				local konum = oyuncu:getPosition()
				local x, y, z = konum:getX(), konum:getY(), konum:getZ()
				local yon = oyuncu:getRotation()
				local rx, ry, rotation = yon:getX(), yon:getY(), yon:getZ()
				local interior = oyuncu:getInterior()
				local dimension = oyuncu:getDimension()
				
				local query = dbPoll(dbQuery(mysql:getConnection(),  "SELECT COUNT(*) as number FROM dancers WHERE dimension = " .. dimension), -1)
				if query then
					local num = tonumber( query["number"] ) or 5
					if dimension == 0 or num < 3 or exports["integration"]:isPlayerSeniorAdmin( oyuncu ) then
						local ped = createPed( skin, x, y, z )
						if ped then
							local smallestID = SmallestID()
							local id = dbExec(mysql:getConnection(), "INSERT INTO dancers (id,x,y,z,rotation,skin,type,interior,dimension,offset) VALUES ("..smallestID.."," .. (x) .. "," .. (y) .. "," .. (z) .. "," .. (rotation) .. "," .. (skin) .. "," .. (type) .. "," .. (interior) .. "," .. (dimension) .. "," .. (offset) .. ")" )
							if id then
								exports["anticheat"]:changeProtectedElementDataEx( ped, "dbid", smallestID, false )
								exports["anticheat"]:changeProtectedElementDataEx( ped, "position", { x, y, z, rotation }, false )
								ped:setRotation(rotation)
								ped:setInterior(interior)
								ped:setDimension(dimension)
								
								peds[ ped ] = { type, offset }
								setTimer( updateDancing, 50, 1 )
								
								oyuncu:outputChat("" .. smallestID .. " ID'li dansçı başarıyla eklendi!", 0, 255, 0 )
							else
								destroyElement( ped )
								oyuncu:outputChat("MySQL Hatası!", 255, 0, 0 )
							end
						else
							oyuncu:outputChat("Geçersiz Skin ID!", 255, 0, 0 )
						end
					else
						oyuncu:outputChat("Bir interiora maksimum 3 adet dansçı ekleyebilirsin!", 255, 0, 0 )
					end
				else
					oyuncu:outputChat("MySQL Hatası!", 255, 0, 0 )
				end
			end
		end
	end
)

addCommandHandler( "nearbydancers", 
	function( oyuncu )
		if exports["integration"]:isPlayerTrialAdmin( oyuncu ) then
			oyuncu:outputChat("Çevrede ki Dansçılar:", 255, 126, 0 )
			local counter = 0
			for key, value in ipairs( exports["global"]:getNearbyElements( oyuncu, "ped" ) ) do
				if peds[ value ] then
					oyuncu:outputChat("   ID " .. getElementData( value, "dbid" ) .. ", Tip " .. peds[ value ][ 1 ] .. ", Skin " .. getElementModel( value ) .. ", Alan " .. peds[ value ][ 2 ], 255, 126, 0 )
					counter = counter + 1
				end
			end
			
			if counter == 0 then
				oyuncu:outputChat("   Hiç.", 255, 126, 0 )
			end
		end
	end
)

addCommandHandler( "deldancer",
	function( oyuncu, commandName, id )
		if exports["integration"]:isPlayerAdmin( oyuncu ) then
			id = tonumber( id )
			if not id then
				oyuncu:outputChat("SYNTAX: /" .. commandName .. " [ID]", 255, 194, 14 )
			else
				for ped in pairs( peds ) do
					if ped:getData("dbid" ) == tonumber( id ) then
						dbExec(mysql:getConnection(), "DELETE FROM dancers WHERE id = " .. (id) )
						
						destroyElement( ped )
						
						peds[ ped ] = nil
						oyuncu:outputChat("Danscı Silindi!.", 0, 255, 0 )
						return
					end
				end
				oyuncu:outputChat("Bu ID'de bir PED bulunamadı!", 255, 0, 0 )
			end
		end
	end
)

function updateDancing( )
	currentcycle = currentcycle + 1
	if currentcycle > 4 then
		currentcycle = 1
	end
	
	for ped, options in pairs( peds ) do
		if isElement( ped ) then
			ped:setPosition(ped:getPosition())
			local type, offset = unpack( options )
			local animid = ( currentcycle + offset ) % 4 + 1
			setPedAnimation( ped, dancingcycles[ type ][ animid ][ 1 ], dancingcycles[ type ][ animid ][ 2 ], -1, true, false, false )
		else
			peds[ ped ] = nil
		end
	end
end

addEventHandler("onPedWasted", getResourceRootElement(),
	function()
		peds[ source ] = nil
			
		local x, y, z, rotation = unpack( source:getData("position" ) )
		local yeniped = createPed(source:getModel(), x, y, z )
		yeniped:setRotation(rotation )
		exports["anticheat"]:changeProtectedElementDataEx( yeniped, "dbid", source:getData("dbid" ), false )
		exports["anticheat"]:changeProtectedElementDataEx( yeniped, "position", source:getData("position" ), false )
		
		peds[ yeniped ] = options
		yeniped:setInterior(source:getInterior())
		yeniped:setDimension(source:getDimension())
		
		destroyElement( source )
		
		currentcycle = currentcycle - 1
		updateDancing( )
	end
)

addCommandHandler( "updatedancers",
	function( oyuncu )
		if exports["integration"]:isPlayerTrialAdmin( oyuncu ) then
			updateDancing( )
		end
	end
)