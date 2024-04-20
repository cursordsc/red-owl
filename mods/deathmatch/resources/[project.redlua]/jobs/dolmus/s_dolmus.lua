
function DolmusParaVer(thePlayer)
	local miktar = 500

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
	--outputChatBox("[!] #FFFFFFTebrikler, bu turdan $"..miktar+ekpara.." kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("DolmusParaVer", true)
addEventHandler("DolmusParaVer", getRootElement(), DolmusParaVer)

function DolmusBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 1809.798828125, -1897.359375, 13.579377174377)
	setElementRotation(thePlayer, 0, 0, 43)
end
addEvent("dolmus:bitir", true)
addEventHandler("dolmus:bitir", getRootElement(), DolmusBitir)





