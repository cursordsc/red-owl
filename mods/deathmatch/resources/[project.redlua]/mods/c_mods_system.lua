local modsTable = {}
local index = 1314
modsTable[index] = {
	txd = "mods/icons.txd",
	dff = "mods/disabledicon.dff",
}

local index = 14776
modsTable[index] = {
	col = "mods/fixes/interior24.col",
}

local index = 3916
modsTable[index] = {
	txd = "items/armour.txd",
	dff = "items/armour.dff",
}

local index = 3027
modsTable[index] = {
	txd = "items/Ciggy1.txd",
	dff = "items/Ciggy1.dff",
}

local index = 2012
modsTable[index] = {
	dff = "items/exhale.dff",
}

local index = 494
modsTable[index] = {
	txd = "mods/hsu.txd",
	dff = "mods/hsu.dff",
}

local index = 417
modsTable[index] = {
	txd = "mods/levi.txd",
	dff = "mods/levi.dff",
}

local index = 470
modsTable[index] = {
	txd = "mods/vehicles/patriot.txd",
	dff = "mods/vehicles/patriot.dff",
}

local index = 578
modsTable[index] = {
	txd = "mods/vehicles/dft30.txd",
	dff = "mods/vehicles/dft30.dff",
}

local index = 538
modsTable[index] = {
	txd = "mods/vehicles/streak.txd",
	dff = "mods/vehicles/streak.dff",
}

local index = 570
modsTable[index] = {
	txd = "mods/vehicles/streakc.txd",
	dff = "mods/vehicles/streakc.dff",
}

local index = 611
modsTable[index] = {
	txd = "mods/vehicles/trailer.txd",
	dff = "mods/vehicles/trailer.dff",
}

local index = 582
modsTable[index] = {
	txd = "mods/vehicles/newsvan.txd",
}

local index = 488
modsTable[index] = {
	txd = "mods/vehicles/vcnmav.txd",
}

local index = 2287
modsTable[index] = {
	col = "mods/cols/frame_4.col",
}

local index = 330
modsTable[index] = {
	txd = "mods/items/cellphone.txd",
	dff = "mods/items/cellphone.dff",
}

local index = 2880
modsTable[index] = {
	txd = "items/cola.txd",
	dff = "items/cola.dff",
}

local index = 416
modsTable[index] = {
	txd = "mods/vehicles/ambulance.txd",
	dff = "mods/vehicles/ambulance.dff",
}

--create temp skin table
local skins = {292, 293, 153, 212, 159, 179, 250, 158, 291, 162, 182, 186, 223, 183, 163, 187, 222, 295, 184, 160, 180, 294, 181, 161, 185, 152, 150, 139, 151, 191, 178, 140, 169, 201, 207, 148, 141, 145, 157, 138}

function getModdedSkins()
	return skins or {}
end

function loadMods()
	for index, value in pairs(modsTable) do
		if value.txd and fileExists(value.txd) then
			txd = engineLoadTXD(value.txd)
			engineImportTXD(txd, index)
		end
		if value.dff and fileExists(value.dff) then
			dff = engineLoadDFF(value.dff)
			engineReplaceModel(dff, index)
		end
		if value.col and fileExists(value.col) then
			col = engineLoadCOL(value.col)
			engineReplaceCOL(col, index)
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		loadMods()
	end
)