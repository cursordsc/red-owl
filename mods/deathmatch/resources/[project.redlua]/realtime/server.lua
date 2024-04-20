addEvent("updateTime", true)

function zamaniGuncelle(specifiedPlayer)
	local offset = tonumber(get("offset")) or 0
	local realtime = getRealTime()
	hour = realtime.hour + offset
	if hour >= 24 then
		hour = hour - 24
	elseif hour < 0 then
		hour = hour + 24
	end

	minute = realtime.minute
	
	setTime(hour, minute)
	
	nextupdate = (60-realtime.second) * 1000
	setMinuteDuration( nextupdate )
	setTimer( setMinuteDuration, nextupdate + 5, 1, 60000 )
end
addEventHandler("updateTime", root, zamaniGuncelle)
addEventHandler("onResourceStart", getResourceRootElement(), zamaniGuncelle )

setTimer( zamaniGuncelle, 1800000, 0 )

function setGameTime(oyuncu, cmd, saat, dakika)
	if exports["integration"]:isPlayerAdmin(oyuncu) then
		if not tonumber(saat) or not tonumber(dakika) or (tonumber(saat) % 1 ~= 0) or (tonumber(dakika) % 1 ~= 0) or tonumber(saat) < 0 or tonumber(saat) > 23 or tonumber(dakika) > 60 or tonumber(saat) < 0 then
			outputChatBox( "Kullanım: /" .. commandName .. " [saat] [dakika]", oyuncu, 255, 194, 14 )
		else
			if setTime(saat, dakika) then
				local adminTitle = exports["global"]:getPlayerAdminTitle(oyuncu)
				local adminName = oyuncu:getData("account:username")
				exports["global"]:sendMessageToAdmins("[ZAMAN]: "..adminTitle.." "..adminName.." mevcut oyun saatini "..saat..":"..dakika.." olarak değiştirdi!")
			end
		end
	end
end
addCommandHandler("setgametime", setGameTime, false, false)

function getIt()
	local offset = tonumber(get("offset")) or 0
	local zaman = getRealTime()
	saat = zaman.hour + offset
	dakika = zaman.minute
	if saat >= 24 then
		saat = saat - 24
	elseif saat < 0 then
		saat = saat + 24
	end

	triggerClientEvent(source, "updateClientTime", resourceRoot, saat, dakika)
end
addEvent("s_updateClientTime", true)
addEventHandler("s_updateClientTime", getRootElement(), getIt)