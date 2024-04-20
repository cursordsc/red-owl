
function sigaraparaVer(thePlayer)
	local miktar = 650

	if getElementData(thePlayer, "vip") == 1 then
		ekpara = 125
	elseif getElementData(thePlayer, "vip") == 2 then
		ekpara = 250
	elseif getElementData(thePlayer, "vip") == 3 then
		ekpara = 375
	elseif getElementData(thePlayer, "vip") == 4 then
		ekpara = 500
	else
		ekpara = 0
	end

	exports["global"]:giveMoney(thePlayer, miktar+ekpara)
	--outputChatBox("[!] #FFFFFFTebrikler, bu turdan "..miktar.." $ kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("sigaraparaVer", true)
addEventHandler("sigaraparaVer", getRootElement(), sigaraparaVer)

function sigaraBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, -1895.681640625, -217.7109375, 23.097679138184)
	setElementRotation(thePlayer, 0, 0, 0)
end
addEvent("sigaraBitir", true)
addEventHandler("sigaraBitir", getRootElement(), sigaraBitir)