--[[local modsTable = {}

modsTable[356] = {
	txd = "models/m4.txd",
	dff = "models/m4.dff",
}

modsTable[355] = {
	txd = "models/ak47.txd",
	dff = "models/ak47.dff",
}

modsTable[358] = {
	txd = "models/sniper.txd",
	dff = "models/sniper.dff",
}

modsTable[348] = {
	txd = "models/desert_eagle.txd",
	dff = "models/desert_eagle.dff",
}

modsTable[353] = {
	txd = "models/mp5.txd",
	dff = "models/mp5.dff",
}

modsTable[352] = {
	txd = "models/uzi.txd",
	dff = "models/uzi.dff",
}

modsTable[346] = {
	txd = "models/colt45.txd",
	dff = "models/colt45.dff",
}

function loadMods()
	for index, value in pairs(modsTable) do
		if value.txd then
			txd = engineLoadTXD(value.txd)
			engineImportTXD(txd, index)
		end
		if value.dff then
			dff = engineLoadDFF(value.dff)
			engineReplaceModel(dff, index)
		end
		if value.col then
			col = engineLoadCOL(value.col)
			engineReplaceCOL(col, index)
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		loadMods()
		setTimer(loadMods, 1000, 1)
	end
)]]