mysql = exports["mysql"]

local CKs = {}
local araces = {"White", "Asian", [0] = "Black"}
function addCharacterKillBody( x, y, z, rotation, skin, id, name, interior, dimension, age, race, weight, height, desc, cod, gender )
	local ped = createPed(skin, x, y, z)
	setElementFrozen(ped, true)
	setPedRotation(ped, rotation)
	setElementInterior(ped, interior)
	setElementDimension(ped, dimension)
	exports["anticheat"]:changeProtectedElementDataEx(ped, "ckid", id, false)
	killPed(ped)
	if cod then
		cod = cod
	else
		cod = "Belirsiz"
	end

	CKs[ped] = { name = name:gsub("_", " "), text = "Corpse appears to be a " .. araces[race] .. " " .. ( gender == 1 and "Female" or "Male" ) .. "  between the ages of " .. age - 2 .. " and " .. age + 2 .. ". The corpse weights around " .. weight .. "kg and looks about " .. height .. "cm tall. \n" .. desc .. "\n\n Possible Cause of Death: \n" .. cod }

	addEventHandler("onElementDestroy", ped, function() CKs[source] = nil end, false)
end

addEvent("ck:info", true)
addEventHandler("ck:info", getRootElement(),
	function()
		if CKs[source] then
			triggerClientEvent(client, "ck:show", client, CKs[source].text, exports["integration"]:isPlayerTrialAdmin(client) and CKs[source].name)
		end
	end
)

function loadAllCorpses(res)
dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do

				if (row) then
					local x = tonumber(row["x"])
					local y = tonumber(row["y"])
					local z = tonumber(row["z"])
					local skin = tonumber(row["skin"])
					local rotation = tonumber(row["rotation"])
					local id = tonumber(row["id"])
					local name = row["charactername"]
					if name == "NULL" then
						name = ""
					end
					local interior = tonumber(row["interior_id"])
					local dimension = tonumber(row["dimension_id"])
					local age = tonumber(row["age"])
					local race = tonumber(row["skincolor"])
					local weight = tonumber(row["weight"])
					local height = tonumber(row["height"])
					local cod = row["ck_info"]
					local desc = row["description"]
					if desc == "NULL" then
						desc = "Belirsiz"
					end
					if cod == "NULL" then
						cod = "Belirsiz"
					end
					local gender = tonumber(row["gender"])
					addCharacterKillBody(x, y, z, rotation, skin, id, name, interior, dimension, age, race, weight, height, desc, cod, gender)
				end
			end
		end 
	end,
exports["mysql"]:getConnection(), "SELECT x, y, z, skin, rotation, id, charactername, interior_id, dimension_id, age, weight, height, ck_info, description, skincolor, gender FROM characters WHERE cked = 1")

	
-- Garage Stuff
dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, value in ipairs(res) do
                local res = value["value"]
				local garages = fromJSON( res )
				if garages then
					for i = 0, 49 do
						setGarageOpen( i, garages[tostring(i)] )
					end
				else
					--outputDebugString( "Failed to load Garage States" )
				end
			end
		end
	end,
	mysql:getConnection(), "SELECT value FROM settings WHERE name = 'garagestates'" )
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllCorpses)

function getNearbyCKs(thePlayer, commandName)
local theTeam = getPlayerTeam(thePlayer)
local factionType = getElementData(theTeam, "type")
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) or factionType == 4 then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Character Kill Bodies:", thePlayer, 255, 126, 0)
		local count = 0
		
		for ped, data in pairs(CKs) do
			local x, y, z = getElementPosition(ped)
			local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
			if getElementDimension(ped) == getElementDimension(thePlayer) and (distance<=20) then
				outputChatBox("   " .. data.name, thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbycks", getNearbyCKs, false, false)

-- in remembrance of
local function showCKList( thePlayer, data )

dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
                local names = {}
				local continue = true
				while continue do
					if not row then
						break
					end
					local name = row["charactername"]
					if name ~= "NULL" then
						names[ #names + 1 ] = name
					end
				end
				triggerClientEvent( thePlayer, "showCKList", thePlayer, names, data )
			end
		end
	end,
	mysql:getConnection(), "SELECT charactername FROM characters WHERE cked = " .. (data) .. " ORDER BY charactername")
end

local ckBuried = createPickup( 815, -1100, 25.8, 3, 1254 )
addEventHandler( "onPickupHit", ckBuried,
	function( thePlayer )
		cancelEvent()
		showCKList( thePlayer, 2 )
	end
)

local ckMissing = createPickup( 819, -1100, 25.8, 3, 1314 )
addEventHandler( "onPickupHit", ckMissing,
	function( thePlayer )
		cancelEvent()
		showCKList( thePlayer, 1 )
	end
)