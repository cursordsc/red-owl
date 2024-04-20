
local mysql = exports["mysql"]

addCommandHandler("vipver", function(oyuncu, cmdName, user, vipRank, days)
	if exports["integration"]:isPlayerEGO(oyuncu) then
		if (not user or not tonumber(vipRank) or not tonumber(days) or (tonumber(vipRank) < 0 or tonumber(vipRank) > 4)) then
			outputChatBox("[!] #ffffffKullanım: /"..cmdName.." <oyuncu id> <vip rank (1-2-3-4)> <gün>", oyuncu, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(oyuncu, user)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("[!] #ffffffOyuncu bulunamadı.", oyuncu, 255, 0, 0, true)
				end
				
				local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
				if not isPlayerVIP(charID) then
					local id = SmallestID()
					
					local success = dbExec(mysql:getConnection(), "INSERT INTO `vipler` (`id`, `dbid`, `vip`, `vip_sure`) VALUES ('"..id.."', '"..charID.."', '"..(vipRank).."', '"..(endTick).."')") or false
					if not success then
						return --outputDebugString("@vipsystem_Commands_S: mysql hatası. 26.satır")
					end
				
					outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla "..days.." günlük VIP verdiniz.", oyuncu, 0, 255, 0, true)
					outputChatBox("[!] #ffffff"..getPlayerName(oyuncu).." isimli yetkili size "..days.." günlük VIP ["..vipRank.."] verdi.", targetPlayer, 0, 255, 0, true)
				
					--exports["global"]:updateNametagColor(targetPlayer)
					loadVIP(charID)
				else
					local success = dbExec(mysql:getConnection(), "UPDATE `vipler` SET vip_sure= vip_sure + "..endTick.." WHERE dbid="..charID.." and vip="..vipRank.." LIMIT 1")
					if not success then
						return --outputDebugString("@vipsystem_Core_S: mysql hatası. 37.satır")
					end
					
					outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncunun VIP süresine "..days.." gün eklediniz.", oyuncu, 0, 255, 0, true)
					outputChatBox("[!] #ffffff"..getPlayerName(oyuncu).." isimli yetkili VIP ["..vipRank.."] sürenizi "..days.." gün uzattı.", targetPlayer, 0, 255, 0, true)
					
					loadVIP(charID)
				end
			else
				outputChatBox("[!] #ffffffOyuncu bulunamadı.", oyuncu, 255, 0, 0, true)
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", oyuncu, 255, 0, 0, true)
	end
end)

addCommandHandler("vipcekilis", function(oyuncu, cmdName)
	if exports["integration"]:isPlayerEGO(oyuncu) then
		--for i, player in ipairs(getElementsByType("player")) do
		Async:foreach(getElementsByType("player"), function(player)
			if getElementData(player, "loggedin") == 1 and (tonumber(getElementData(player, "vipver")) or 0) <= 2 then
				local charID = tonumber(getElementData(player, "dbid"))
				if not isPlayerVIP(charID) then
					addVIP(player, 2, 3) -- 3 gün VIP VER
					outputChatBox("[!]#ffffff Tebrikler, etkinlik tarafından 3 günlük VIP [2] kazandınız.", player, 0, 255, 0, true)
				elseif isPlayerVIP(charID) and tonumber(getElementData(player, "vipver")) == 2 then
					addVIP(player, 2, 3) -- 3 gün ekle
					outputChatBox("[!]#ffffff Etkinlik dolayısıyla VIP 2 kazandınız, sürenize 3 gün eklendi.", player, 0, 255, 0, true)
				elseif tonumber(getElementData(player, "vipver")) == 1 then
					local remaining = vipPlayers[charID].endTick/1000
					local vipDays = math.floor ( remaining /86400 )
			
					if tonumber(vipDays) <= 5 then
						removeVIP(charID)
						addVIP(player, 2, 3)
						outputChatBox("[!]#ffffff VIP 1'iniz 5 günden az olduğu için silindi ve 3 günlük VIP 2 kazandınız.", player, 0, 255, 0, true)
					end
				end
			end
		end)
		outputChatBox("[!]#ffffff Tüm oyunculara 3 günlük VIP 2 verildi.", oyuncu, 0, 255, 0, true)
	end
end)

addCommandHandler("vipal", function(oyuncu, cmdName, targetPlayer)
	if exports["integration"]:isPlayerEGO(oyuncu) then
		if (not targetPlayer) then
			outputChatBox("[!] #ffffffKullanım: /"..cmdName.." <oyuncu id/isim>", oyuncu, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(oyuncu, targetPlayer)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("[!] #ffffffOyuncu bulunamadı.", oyuncu, 255, 0, 0, true)
				end
				
				if isPlayerVIP(charID) then
					local success = removeVIP(charID)
					if success then
						outputChatBox("[!] #ffffff"..targetPlayerName.." adlı oyuncunun VIP üyeliğini aldınız.", oyuncu, 0, 255, 0, true)
					end
				else
					outputChatBox("[!] #ffffffOyuncunun VIP üyeliği yok.", oyuncu, 255, 0, 0, true)
				end
			else
				outputChatBox("[!] #ffffffOyuncu bulunamadı.", oyuncu, 255, 0, 0, true)
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", oyuncu, 255, 0, 0, true)
	end
end)

addCommandHandler("vipsure", function(oyuncu, cmd, id)
	if id then
	local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(oyuncu, id)
	local id = getElementData(targetPlayer, "dbid")
		if (exports.integration:isPlayerTrialAdmin(oyuncu)) then
			if vipPlayers[id] then
				local vipType = vipPlayers[id].type
				local remaining = vipPlayers[id].endTick
				local remainingInfo = secondsToTimeDesc(remaining/1000)
	
				return outputChatBox("[!] #ffffff"..getPlayerName(targetPlayer).." idli karakterin kalan VIP ["..vipType.."]  süresi: "..remainingInfo, oyuncu, 0, 125, 255, true)
			end
			return outputChatBox("[!] #ffffff"..getPlayerName(targetPlayer).." idli karakterin VIP üyeliği bulunmamaktadır.", oyuncu, 255, 0, 0, true)
		end
	end

	local charID = getElementData(oyuncu, "dbid")
	if not charID then return false end

	if vipPlayers[charID] then
		local vipType = vipPlayers[charID].type
		local remaining = vipPlayers[charID].endTick
		local remainingInfo = secondsToTimeDesc(remaining/1000)

		outputChatBox("[!] #ffffffKalan VIP ["..vipType.."] süreniz: "..remainingInfo, oyuncu, 0, 125, 255, true)
	else
		outputChatBox("[!] #ffffffVIP üyeliğiniz bulunmamaktadır.", oyuncu, 255, 0, 0, true)
	end
end)

function addVIP(targetPlayer, vipRank, days)
	if targetPlayer and vipRank and days then
		local charID = tonumber(getElementData(targetPlayer, "dbid"))
		if not charID then
			return false
		end
		
		local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
		if not isPlayerVIP(charID) then
			local id = SmallestID()
			local success = dbExec(mysql:getConnection(), "INSERT INTO `vipler` (`id`, `dbid`, `vip`, `vip_sure`) VALUES ('"..id.."', '"..charID.."', '"..(vipRank).."', '"..(endTick).."')") or false
			if not success then
				return
			end
			loadVIP(charID)
		else
		
			local success = dbExec(mysql:getConnection(), "UPDATE `vipler` SET vip_sure= vip_sure + "..endTick.." WHERE dbid="..charID.." and vip="..vipRank.." LIMIT 1")
			if not success then
				return
			end
			
			loadVIP(charID)
		end
	end
end