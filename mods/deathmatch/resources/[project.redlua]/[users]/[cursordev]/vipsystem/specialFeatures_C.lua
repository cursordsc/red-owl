
local silahlar = {
	[30] = {true, 2},
	[31] = {true, 4}
}

local izinlifactlar = {
	[1] = true,
	[59] = true,
	[163] = true,
	[148] = true,
}

function silahHata(eskislot)
	local suankisilahim = getPedWeapon(localPlayer)

	if silahlar[suankisilahim] then
		if silahlar[suankisilahim][1] then

			local myFaction = getElementData(source, "faction") or -1
			if izinlifactlar[myFaction] then
				return 
			end

			local vipdegerim = tonumber(getElementData(localPlayer, "vip")) or 0
			local izinlideger = silahlar[suankisilahim][2] or 1
			if not (vipdegerim >= izinlideger) then
				setPedWeaponSlot(localPlayer, eskislot)
				outputChatBox("[!] #FFFFFF"..getWeaponNameFromID(suankisilahim).." adlı silahı kullanabilmen için VIP ["..izinlideger.."] olmalısın.", 255, 0, 0, true)
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, silahHata)