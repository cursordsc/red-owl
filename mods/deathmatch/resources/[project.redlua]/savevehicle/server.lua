mysql = exports["mysql"]:getConnection()

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function saveVehicle(source)
	local dbid = tonumber(source:getData("dbid")) or -1
	
	if isElement(source) and getElementType(source) == "vehicle" and dbid > 0 then
		local konum = source:getPosition()
		local yon = source:getRotation()
		local x, y, z = konum:getX(), konum:getY(), konum:getZ()
		local rx, ry, rz = yon:getX(), yon:getY(), yon:getZ()
		local dimension = source:getDimension()
		local interior = source:getInterior()
		local health = source:getHealth()
		local fuel = source:getData("fuel")
		local engine = source:getData("engine")
		local odometer = source:getData("odometer") or 0
		local Impounded = source:getData("Impounded") or 0
		local handbrake = source:getData("handbrake") or 0
		local locked = source:isLocked() and 1 or 0		
		local lights = source:getOverrideLights()
		local sirens = source:areSirensOn() and 1 or 0
		local wheel1, wheel2, wheel3, wheel4 = source:getWheelStates()
		local wheelState = toJSON( { wheel1, wheel2, wheel3, wheel4 } )
		
		local panel0 = source:getPanelState(0)
		local panel1 = source:getPanelState(1)
		local panel2 = source:getPanelState(2)
		local panel3 = source:getPanelState(3)
		local panel4 = source:getPanelState(4)
		local panel5 = source:getPanelState(5)
		local panel6 = source:getPanelState(6)
		local panelState = toJSON( { panel0, panel1, panel2, panel3, panel4, panel5, panel6 } )
		
		local door0 = source:getDoorState(0)
		local door1 = source:getDoorState(1)
		local door2 = source:getDoorState(2)
		local door3 = source:getDoorState(3)
		local door4 = source:getDoorState(4)
		local door5 = source:getDoorState(5)
		local doorState = toJSON( { door0, door1, door2, door3, door4, door5 } )
		
		mysql:exec("UPDATE vehicles SET `fuel`='" .. (fuel) ..
			"', `engine`='" .. (engine) ..
			"', `locked`='" .. (locked) ..
			"', `lights`='" .. (lights) ..
			"', `hp`='" .. (health) ..
			"', `sirens`='" .. (sirens) ..
			"', `Impounded`='" .. (tonumber(Impounded)) ..
			"', `handbrake`='" .. (tonumber(handbrake)) ..
			"', `currx`=" .. x .. 
			" , `curry`=" .. y ..
			" , `currz`=" .. z ..
			" , `currrx`=" .. rx ..
			" , `currry`=" .. ry ..
			" , `currrz`=" .. rz ..
			" WHERE id='" .. (dbid) .. "'")

		mysql:exec("UPDATE vehicles SET `panelStates`='" .. (panelState) .. "', `wheelStates`='" .. (wheelState) .. "', `doorStates`='" .. (doorState) .. "', `hp`='" .. (health) .. "', sirens='" .. (sirens) .. "', Impounded='" .. (tonumber(Impounded)) .. "', handbrake='" .. (tonumber(handbrake)) .. "', `odometer`='"..(tonumber(odometer)).."', `lastUsed`=NOW() WHERE id='" .. (dbid) .. "'")
	end
end

local function saveVehicleOnExit(thePlayer, seat)
	saveVehicle(source)
end
addEventHandler("onVehicleExit", getRootElement(), saveVehicleOnExit)

function saveVehicleMods(source)
	local dbid = tonumber(source:getData("dbid")) or -1
	local owner = tonumber(source:getData("owner")) or -1
	if isElement(source) and source:getType() == "vehicle" and dbid >= 0 then
		local col =  { source:getColor(true) }
		if source:getData("oldcolors") then
			col = unpack(source:getData("oldcolors"))
		end
		
		local color1 = toJSON( {col[1], col[2], col[3]} )
		local color2 = toJSON( {col[4], col[5], col[6]} )
		local color3 = toJSON( {col[7], col[8], col[9]} )
		local color4 = toJSON( {col[10], col[11], col[12]} )
		
		
		local hcol1, hcol2, hcol3 = source:getHeadLightColor()
		if source:getData("oldheadcolors") then
			hcol1, hcol2, hcol3 = unpack(source:getData("oldheadcolors"))
		end
		local headLightColors = toJSON( { hcol1, hcol2, hcol3 } )
		
		local upgrade0 = source:getData("oldupgrade" .. 0 ) or source:getUpgradeOnSlot(0)
		local upgrade1 = source:getData("oldupgrade" .. 1 ) or source:getUpgradeOnSlot(1)
		local upgrade2 = source:getData("oldupgrade" .. 2 ) or source:getUpgradeOnSlot(2)
		local upgrade3 = source:getData("oldupgrade" .. 3 ) or source:getUpgradeOnSlot(3)
		local upgrade4 = source:getData("oldupgrade" .. 4 ) or source:getUpgradeOnSlot(4)
		local upgrade5 = source:getData("oldupgrade" .. 5 ) or source:getUpgradeOnSlot(5)
		local upgrade6 = source:getData("oldupgrade" .. 6 ) or source:getUpgradeOnSlot(6)
		local upgrade7 = source:getData("oldupgrade" .. 7 ) or source:getUpgradeOnSlot(7)
		local upgrade8 = source:getData("oldupgrade" .. 8 ) or source:getUpgradeOnSlot(8)
		local upgrade9 = source:getData("oldupgrade" .. 9 ) or source:getUpgradeOnSlot(9)
		local upgrade10 = source:getData("oldupgrade" .. 10 ) or source:getUpgradeOnSlot(10)
		local upgrade11 = source:getData("oldupgrade" .. 11 ) or source:getUpgradeOnSlot(11)
		local upgrade12 = source:getData("oldupgrade" .. 12 ) or source:getUpgradeOnSlot(12)
		local upgrade13 = source:getData("oldupgrade" .. 13 ) or source:getUpgradeOnSlot(13)
		local upgrade14 = source:getData("oldupgrade" .. 14 ) or source:getUpgradeOnSlot(14)
		local upgrade15 = source:getData("oldupgrade" .. 15 ) or source:getUpgradeOnSlot(15)
		local upgrade16 = source:getData("oldupgrade" .. 16 ) or source:getUpgradeOnSlot(16)
		
		local paintjob =  source:getData("oldpaintjob") or source:getPaintjob()
		local variant1, variant2 = source:getVariant()
		
		local upgrades = toJSON( { upgrade0, upgrade1, upgrade2, upgrade3, upgrade4, upgrade5, upgrade6, upgrade7, upgrade8, upgrade9, upgrade10, upgrade11, upgrade12, upgrade13, upgrade14, upgrade15, upgrade16 } )
		mysql:exec("UPDATE vehicles SET `upgrades`='" .. (upgrades) .. "', paintjob='" .. (paintjob) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', `headlights`='"..(headLightColors).."',variant1="..variant1..",variant2="..variant2.." WHERE id='" .. (dbid) .. "'")
	end
end