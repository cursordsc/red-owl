local playerWeapons = {}

addEvent("createWeaponModel", true)
function createWeaponForPlayer(weaponID,bone,x,y,z,rx,ry,rz)
	if not playerWeapons[source] then
		playerWeapons[source] = {}
	end
	index = weaponID
	playerWeapons[source][index] = createObject(weaponModels[index], 0, 0, 0)
	if playerWeapons[source][index] then
	setElementInterior(playerWeapons[source][index], getElementInterior(source))
	setElementDimension(playerWeapons[source][index], getElementDimension(source))
	exports["bone_attach"]:attachElementToBone(playerWeapons[source][index],source,bone,x,y,z,rx,ry,rz)
	triggerClientEvent(source, "weaponSync.mode", source, playerWeapons[source][index], true)
	end
end
addEventHandler("createWeaponModel", root, createWeaponForPlayer)

addEvent("destroyWeaponModel", true)
function destroyWeaponForPlayer(weaponID)
	if not playerWeapons[source] then
		playerWeapons[source] = {}
	end
	if (playerWeapons[source][weaponID]) then
		exports["bone_attach"]:detachElementFromBone(playerWeapons[source][weaponID])
		if isElement(playerWeapons[source][weaponID]) then
			destroyElement(playerWeapons[source][weaponID])
		end
		triggerClientEvent(source, "weaponSync.mode", source, playerWeapons[source][index], false)
	end
end
addEventHandler("destroyWeaponModel", root, destroyWeaponForPlayer)

addEvent("alphaWeaponModel", true)
function alphaWeaponForPlayer(object, state)
end
addEventHandler("alphaWeaponModel", root, alphaWeaponForPlayer)

addEvent("setWeaponInteriorDimension", true)
addEventHandler("setWeaponInteriorDimension", root,
	function(weapon, int, dim)
		int, dim = tonumber(int), tonumber(dim)
		setElementInterior(weapon, int)
		setElementDimension(weapon, dim)
	end
)

addEventHandler("onPlayerCommand", root,
    function(cmd)
        if cmd == "togattach" then
        	cancelEvent()
        end
    end
)