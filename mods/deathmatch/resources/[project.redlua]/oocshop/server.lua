mysql = exports.mysql
_sdn = setElementData
function setElementData(element, data, key)
	if isElement(element) then
		if (data == "bakiyeMiktar") and getElementData(element, "account:id") and getElementData(element, "account:id") > 0 then
			dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = '"..key.."' WHERE id='"..getElementData(element, "account:id").."'")
		end
		return _sdn(element, data, key)
	end
end

function bakiyeEkle(thePlayer, commandName, targetPlayer, bakiyeMiktari)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then		
	if (not tonumber(bakiyeMiktari)) then
			outputChatBox("[-] #ffffffBirşey yazmadınız. /bakiyever <id> <miktar>", thePlayer, 255, 94, 94, true)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local dbid = getElementData(targetPlayer, "account:id")
				local escapedID = (dbid)
				outputChatBox("[-] #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla ["..bakiyeMiktari.." TL] bakiye eklediniz.", thePlayer, 66, 155, 245, true)
				outputChatBox("[-] #ffffff"..getPlayerName(thePlayer).." isimli yetkili size ["..bakiyeMiktari.." TL] bakiye ekledi.", targetPlayer, 66, 155, 245, true)
				setElementData(targetPlayer, "bakiyeMiktar", tonumber(getElementData(targetPlayer, "bakiyeMiktar") + bakiyeMiktari))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari + " ..bakiyeMiktari.. " WHERE id = '" .. escapedID .. "'")
				local from, to, action = thePlayer:getData('account:id'), targetPlayer:getData('account:id'), "/bakiyever"
			end
		end
	else 
		outputChatBox("[-] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 94, 94, true)
	end
end
addCommandHandler("bakiyever", bakiyeEkle)

function giveBalance(username, balanceAdded)
	local foundedPlayer = nil
	for index, player in ipairs(exports.pool:getPoolElementsByType("player")) do
		--if getElementData(player, "loggedin") == 1 then
			if tostring(getElementData(player, "account:username")) == tostring(username) then
				foundedPlayer = player
			end
		--end
	end
	
	if isElement(foundedPlayer) then
		outputChatBox("[-] #ffffffweb sitesi üzerinden ["..balanceAdded.." TL] bakiye satın aldınız.", foundedPlayer, 66, 155, 245, true)
		_sdn(foundedPlayer, "bakiyeMiktar", getElementData(foundedPlayer, "bakiyeMiktar")+balanceAdded)

		return "Kullanıcı oyunda ve kullanıcının bakiyesi değiştirildi, infobox gönderildi."
	end
	return "Kullanıcı oyunda değil fakat yine de kullanıcının verisi işlendi."
end

function callbackGive(givenUsername, username, balance, balanceAdded, type)
	local foundedPlayer = nil
	for index, player in ipairs(exports.pool:getPoolElementsByType("player")) do
		if getElementData(player, "loggedin") == 1 then
			if tostring(getElementData(player, "account:username")) == tostring(username) then
				foundedPlayer = player
			end
		end
	end
	if isElement(foundedPlayer) then
		if (type == "+") then
			outputChatBox("[-] #ffffff"..givenUsername.." isimli yetkili size ["..balanceAdded.." TL] bakiye ekledi.", foundedPlayer, 66, 155, 245, true)
			_sdn(foundedPlayer, "bakiyeMiktar", balance)
		else
			outputChatBox("[-] #ffffff"..givenUsername.." isimli yetkili sizin bakiyenizden ["..balanceAdded.." TL] kesti.", foundedPlayer, 66, 155, 245, true)
			_sdn(foundedPlayer, "bakiyeMiktar", balance)
		end
		return "Kullanıcı oyunda ve kullanıcının bakiyesi değiştirildi, infobox gönderildi."
	end
	return "Kullanıcı oyunda değil fakat yine de kullanıcının verisi işlendi."
end

function bakiyeCikar(thePlayer, commandName, targetPlayer, bakiyeMiktari)
		if exports.integration:isPlayerEGO(thePlayer) then
		if (not tonumber(bakiyeMiktari)) then
			outputChatBox("[-] #ffffffBirşey yazmadınız. /bakiyecikar <id> <miktar>", thePlayer, 255, 94, 94, true)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local dbid = getElementData(targetPlayer, "account:id")
				local escapedID = (dbid)
				outputChatBox("[-] #ffffff"..targetPlayerName.." isimli oyuncunun başarıyla ["..bakiyeMiktari.." TL] bakiyesini eksilttiniz.", thePlayer, 66, 155, 245, true)
				outputChatBox("[-] #ffffff"..getPlayerName(thePlayer).." isimli yetkili sizden ["..bakiyeMiktari.." TL] bakiye eksiltti.", targetPlayer, 66, 155, 245, true)
				setElementData(targetPlayer, "bakiyeMiktar", tonumber(getElementData(targetPlayer, "bakiyeMiktar") - bakiyeMiktari))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari - " ..bakiyeMiktari.. " WHERE id = '" .. escapedID .. "'")
				local from, to, action = thePlayer:getData('account:id'), targetPlayer:getData('account:id'), "/bakiyecikar"
				addActionLog(from, to, action, bakiyeMiktari)
			end
		end
	else 
		outputChatBox("[-] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 94, 94, true)
	end
end
addCommandHandler("bakiyeal", bakiyeCikar)

function bakiyeGoster(thePlayer)
	bakiyeBilgim = getElementData(thePlayer, "bakiyeMiktar")
	exports["infobox"]:addBox(thePlayer, "info", "Toplam Bakiyeniz: "..bakiyeBilgim.." TL olarak görüntüleniyor.")
end
addCommandHandler("bakiyem", bakiyeGoster)

function bakiyeKontrol(thePlayer, commandName, targetPlayer, bakiyeBilgim)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
		bakiyeBilgim = getElementData(targetPlayer, "bakiyeMiktar")
		outputChatBox("[-] #ffffff"..targetPlayerName.." Isimli oyuncunun bakiye bilgisi ["..bakiyeBilgim.." TL] olarak görüntüleniyor.", thePlayer, 0, 0, 255, true)
		end
	else
		outputChatBox("[-] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 94, 94, true)
	end
end
addCommandHandler("bakiyekontrol", bakiyeKontrol)



function isimDegistirOnayla(isim)
	local stat,errort = checkValidCharacterName(isim)
	if not stat then
		outputChatBox("[-] #ffffff"..errort, source, 255, 94, 94, true)
		return false
	end
	isim = string.gsub(tostring(isim), " ", "_")
	dbQuery(
		function(qh, source)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				outputChatBox("[-] #ffffffBu isim zaten kullanımda.", source, 255, 94, 94, true)
			else
				local bakiyeCek = tonumber(getElementData(source, "bakiyeMiktar"))
				if bakiyeCek < 10 then
					outputChatBox("[-] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", source,255, 94, 94, true)
					return false
				end
				local charid = getElementData(source, "dbid")
				dbQuery(
					function(qh, player)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							for i, v in ipairs(res) do
								dbExec(mysql:getConnection(), "DELETE FROM `mdc_crimes` WHERE `id`='"..v.id.."' ")
							end
						end
					end,
				{source}, mysql:getConnection(), "SELECT id FROM `mdc_crimes` WHERE `character`='"..tonumber(charid).."'")

				
				setElementData(source, "bakiyeMiktar", bakiyeCek - 10)
				triggerClientEvent( source, "market->isimDegistirmeAsama", source, 1 )
				outputChatBox("[-] #ffffffBaşarıyla isim değiştirdiniz.", source, 66, 155, 245, true)
				setElementData(source, "OOCHapisKontrol", 0)
				if not getElementData(source, "adminjailed") then
					setElementPosition(source, 2092.373046875, -1779.6650390625, 13.746875)
					setElementRotation(source, 0, 0, 75.315185546875)
					setElementInterior(source, 0)
					setElementDimension(source, 0)
				end
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = "Isim Degisikligi"
				local ucret = "10"
				--dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
				outputChatBox("(( " ..getPlayerName(source):gsub("_", " ").. " sunucudan yasaklandı. Sure: Sınırsız Gerekce: İsim Değişikliği - " ..string.format("%02d", hours)..":"..string.format("%02d", minutes).. " ))", arrarPlayer, 255, 0, 0)
				exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(source) .. "' isimli oyuncu ismini '" .. isim .. "' olarak değiştirildi.")
				outputChatBox("[-] #ffffff'"..getPlayerName(source) .. "' olan isminizi '" .. tostring(isim) .. "' olarak değiştirdiniz.", source, 66, 155, 245, true)
				changeName(source, isim)
			end
		end,
	{source}, mysql:getConnection(), "SELECT charactername FROM characters WHERE charactername='" .. (isim) .. "'")

	
end
addEvent("market->isimDegistirOnayla",true)
addEventHandler("market->isimDegistirOnayla", root, isimDegistirOnayla)

addCommandHandler("customanimsave",
	function(player, cmd)
		if (getElementData(player, "loggedin") == 1) then
			local customtable = getElementData(player, "custom_animations") or {} -- tablo yapısı: {['fortnite_1'] = true}
			local success = dbExec(mysql:getConnection(), "UPDATE `accounts` SET custom_animations='".. toJSON(customtable) .."' WHERE id="..getElementData(player, "account:id").." LIMIT 1")
		end
	end
)

addEvent('market->addCustomAnimation', true)
addEventHandler('market->addCustomAnimation', root,
	function(player, anim_index, price)
		local bakiyeCek = tonumber(getElementData(player, "bakiyeMiktar"))
		if bakiyeCek < math.ceil(price) then
			outputChatBox("#575757KennedyMTA: #ffffffBakiyeniz yetersiz.", player, 255, 0, 0, true)
		return
		end
		local customtable = getElementData(player, "custom_animations") or {} -- tablo yapısı: {['fortnite_1'] = true}
		
		if (customtable[tostring(anim_index)]) then -- Zaten animasyon oyuncuda var.
			--customtable[index] = true
			outputChatBox("#575757KennedyMTA: #ffffffZaten bu animasyona sahipsin.", player, 255, 0, 0, true)
			outputChatBox("#575757KennedyMTA: #ffffffÖzel animasyon arayüzünü açmak için /animpanel.", player, 0, 255, 0, true)
			return false
		end
		customtable[tostring(anim_index)] = true

		setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar") - price)
		outputChatBox("#575757KennedyMTA: #ffffffYeni özel animasyon başarıyla satın alındı.", player, 0, 255, 0, true)
		outputChatBox("#575757KennedyMTA: #ffffffÖzel animasyon arayüzünü açmak için /animpanel.", player, 0, 255, 0, true)

		local success = dbExec(mysql:getConnection(), "UPDATE `accounts` SET custom_animations='".. toJSON(customtable) .."' WHERE id="..getElementData(player, "account:id").." LIMIT 1")
		setElementData(player, "custom_animations", customtable)
		-------------- TEMI --------------
			local hours = getRealTime().hour
			local minutes = getRealTime().minute
			local seconds = getRealTime().second
			local day = getRealTime().monthday
			local month = getRealTime().month+1
			local year = getRealTime().year+1900
			local alinanUrun = "[Ozel Animasyon - "..tostring(anim_index).."]"
			local ucret = price
			--dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")

		-----------------------------------------
	end
)

function kisimDegistirOnayla(isim)
	local stat,errort = checkValidUsername(isim)
	if not stat then
		outputChatBox("[-] #ffffff"..errort, source, 255, 94, 94, true)
		return false
	end
	--isim = string.gsub(tostring(isim), " ", "_")
	dbQuery(
		function(qh, source)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				outputChatBox("[-] #ffffffBu isim zaten kullanımda.", source, 255, 94, 94, true)
			else
			
				local bakiyeCek = tonumber(getElementData(source, "bakiyeMiktar"))
				if bakiyeCek < 10 then
					outputChatBox("[-] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", source,255, 94, 94, true)
					return false
				end
				
				
				setElementData(source, "bakiyeMiktar", bakiyeCek - 10)
				outputChatBox("[-] #ffffffBaşarıyla isim değiştirdiniz.", source, 66, 155, 245, true)
				setElementData(source, "OOCHapisKontrol", 0)

				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = "Kullanici adi Degisikligi"
				local ucret = "10"
				--dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
				outputChatBox("(( " ..getPlayerName(source):gsub("_", " ").. " sunucudan yasaklandı. Sure: Sınırsız Gerekce: Kullanıcı Adı Değişikliği - " ..string.format("%02d", hours)..":"..string.format("%02d", minutes).. " ))", arrarPlayer, 255, 0, 0)
				exports.global:sendMessageToAdmins("[MARKET] '" .. getElementData(source, "account:username") .. "' isimli oyuncu ismini '" .. isim .. "' olarak değiştirildi.")
				outputChatBox("[-] #ffffff'"..getElementData(source, "account:username") .. "' olan isminizi '" .. tostring(isim) .. "' olarak değiştirdiniz.", source, 66, 155, 245, true)
				
				local dbid = getElementData(source, "account:id")
				setElementData(source, "account:username", isim)
				dbExec(mysql:getConnection(), "UPDATE accounts SET username='" .. (isim) .. "' WHERE id = " .. (dbid))
				setElementData(source, "account:username", isim)
			end
		end,
	{source}, mysql:getConnection(), "SELECT username FROM accounts WHERE username='" .. (isim) .. "'")
	
	

end
addEvent("market->kisimDegistirOnayla",true)
addEventHandler("market->kisimDegistirOnayla", root, kisimDegistirOnayla)

function changeName(targetPlayer,newName)
	exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 1, false)
	local name = setPlayerName(targetPlayer, tostring(newName))
	local dbid = getElementData(targetPlayer, "dbid")
	local targetPlayerName = getPlayerName(targetPlayer)
	if (name) then
		exports['cache']:clearCharacterName( dbid )
		dbExec(mysql:getConnection(), "UPDATE characters SET charactername='" .. (newName) .. "' WHERE id = " .. (dbid))

		local adminTitle = "[MARKET]"
		local processedNewName = string.gsub(tostring(newName), "_", " ")
		

		exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)

		exports.logs:dbLog(thePlayer, 4, targetPlayer, "MARKET ISIM DEGISIKLIGI "..targetPlayerName.." -> "..tostring(newName))
		triggerClientEvent(targetPlayer, "updateName", targetPlayer, getElementData(targetPlayer, "dbid"))
	else
		outputChatBox("[-] #ffffffBaşarısız oldu.", thePlayer, 255, 94, 94, true)
	end
	exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
end

function vipVerdirtme(vipSeviye, vipGun, vipFiyat)
	exports["vipsystem"]:addVIP(source, vipSeviye, vipGun)
	setElementData(source, "bakiyeMiktar", getElementData(source, "bakiyeMiktar") - math.ceil(vipFiyat))
	outputChatBox("[-] #ffffffTebrikler, başarıyla "..vipGun.." günlük VIP ["..vipSeviye.."] aldınız.", source, 66, 155, 245, true)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(source) .. "' isimli oyuncu "..vipGun.." günlük VIP [" .. vipSeviye .. "] aldı.")
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = ""..vipGun.." gunluk VIP ["..vipSeviye.."]"
	--dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..vipFiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->vipVer", true)
addEventHandler("market->vipVer", root, vipVerdirtme)

function aracSlotArttirmaLOG(player, fiyat)
	
	dbExec(mysql:getConnection(), "UPDATE characters SET maxvehicles = maxvehicles+1 WHERE id = " .. (getElementData(player, "dbid")))
	setElementData(player, "maxvehicles", tonumber(getElementData(player, "maxvehicles"))+1)
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-5)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu +1 araç slotu arttırma aldı.")
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Arac Slotu Arttirma"
	----dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..fiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->aracSlot", true)
addEventHandler("market->aracSlot", root, aracSlotArttirmaLOG)

function evSlotArttirmaLOG(player, fiyat)
	
	dbExec(mysql:getConnection(), "UPDATE characters SET maxinteriors = maxinteriors+1 WHERE id = " .. (getElementData(player, "dbid")))
	setElementData(player, "maxinteriors", tonumber(getElementData(player, "maxinteriors"))+1)
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-5)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu +1 ev slotu arttırma aldı.")
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Ev Slotu Arttirma"
	--dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..fiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->evSlot", true)
addEventHandler("market->evSlot", root, evSlotArttirmaLOG)

function karakterSlotArttirmaLOG(player, fiyat)
	
	dbExec(mysql:getConnection(), "UPDATE accounts SET charlimit = charlimit+1 WHERE id = " .. (getElementData(player, "dbid")))
	setElementData(player, "charlimit", tonumber(getElementData(player, "charlimit"))+1)
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-10)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu +1 Karakter Slotu arttırma aldı.")
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Karakter Slotu Arttirma"
	--dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..fiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->karakterSlot", true)
addEventHandler("market->karakterSlot", root, karakterSlotArttirmaLOG)

function anlikSaatLOG(player, fiyat)
	
	dbExec(mysql:getConnection(), "UPDATE characters SET hoursplayed = hoursplayed+10 WHERE id = " .. (getElementData(player, "dbid")))
	setElementData(player, "hoursplayed", tonumber(getElementData(player, "hoursplayed"))+10)
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-15)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu +10 Oyun Saati satın aldı.")
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "10 Oyun Saati"
	----dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..fiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->anlikOyunSaati", true)
addEventHandler("market->anlikOyunSaati", root, anlikSaatLOG)


function silahKasasiLOG(player, fiyat)
	
	exports.global:giveItem(player, 582, 1)
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-25)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu 'Silah Kasası' aldı.")
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Silah Kasasi"
	----dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..fiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->silahKasasi", true)
addEventHandler("market->silahKasasi", root, silahKasasiLOG)

function premiumsilahKasasiLOG(player, fiyat)
	
	exports.global:giveItem(player, 583, 1)
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-60)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu 'Premium Silah Kasası' aldı.")
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Premium Silah Kasasi"
	dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` ='65 TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->premiumsilahKasasi", true)
addEventHandler("market->premiumsilahKasasi", root, premiumsilahKasasiLOG)

function bilardoMasasiLOG(player, fiyat)
	
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-15)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu bir adet Bilardo Masası satın aldı.")
	
	if exports["global"]:giveItem(player, 248, 1) then
		outputChatBox("#575757KennedyMTA:#f9f9f9 Bilardo Masası envanterine aktarıldı.", player, 30, 230, 30, true)
	else
		outputChatBox("#575757KennedyMTA:#f9f9f9 Telaşlanma! Bilardonu veremedik çünkü envanterin dolu. Hemen bu görüntüyü SS al ve yetkiliye bildir.", player, 255, 0, 0, true)
	end
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Bilardo Masasi"
	----dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..fiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->bilardoMasasi", true)
addEventHandler("market->bilardoMasasi", root, bilardoMasasiLOG)

function sinirsizTamirKiti(player, fiyat)
	-- accounts tamirKit = 1
	
	local dbid = getElementData(player, "account:id")
	dbExec(mysql:getConnection(), "UPDATE accounts SET tamirKit='1' WHERE id='" ..dbid.. "'")
	setElementData(player, "tamirKit", 1)
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-25)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu 'Sınırsız Tamir Kiti' aldı.")
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Sinirsiz Tamir Kiti"
	----dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..fiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->sinirsizTamirKiti", true)
addEventHandler("market->sinirsizTamirKiti", root, sinirsizTamirKiti)

function privateSkinLOG(player, fiyat)
	
	local dbid = getElementData(player, "account:id")
	dbExec(mysql:getConnection(), "UPDATE accounts SET privateSkin='1' WHERE id='" ..dbid.. "'")
	exports["infobox"]:addBox(player, "success", "Başarıyla Private Skin özelliğini satın aldınız. Sıradaki işlem için sohbeti okuyunuz.")
	outputChatBox("[-]#f9f9f9 Private Skin özelliğini başarıyla satın aldınız.", player, 0, 255, 0, true)
	outputChatBox("[-]#f9f9f9 İşlemlerinizi tamamlamak için sitemizin sayfasına gidip ne istediğinizi paylaşın.", player, 0, 255, 0, true)
	setElementData(player, "bakiyeMiktar", tonumber(getElementData(player, "bakiyeMiktar"))-50)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu 'Private Skin (Özel Yapım Skin)' satın aldı.")
	
	-------------- TEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Private Skin"
	--dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..fiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("market->privateSkin", true)
addEventHandler("market->privateSkin", root, privateSkinLOG)



function privateCarCreate(vehid, brandid, rgb, balance, vehname, plateState, plateEditText)
	local player = source

	-- BALANCE CONTROL
	local playerBalance = getElementData(player, "bakiyeMiktar") or 0
	if playerBalance < balance then
		return
	end


	local r, g, b = unpack(rgb)
	if tonumber(vehid) and tonumber(brandid) then
		setElementData(player, "bakiyeMiktar", playerBalance - balance)
		outputChatBox("[-]#ffffff Aracı başarıyla satın aldınız, /park yapmayı unutmayın!", player, 66, 155, 245, true)
		outputChatBox("[-]#ffffff Alınan Araç: "..vehname, player, 66, 155, 245, true)
		if tonumber(vehid) == 510 then
			outputChatBox("[-]#f9f9f9 Bisiklet aldığın için yanında Private Skin hediye ettik.", player, 30, 30, 230, true)
			exports.global:giveItem(player, 16, 51)
		end
		local hours = getRealTime().hour
		local minutes = getRealTime().minute
		local seconds = getRealTime().second
		local day = getRealTime().monthday
		local month = getRealTime().month+1
		local year = getRealTime().year+1900
		exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu "..vehname.." satın aldı.")
		
		--dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..vehname.."', `ucret` = '"..balance.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")



		local pr = getPedRotation(player)
		local dbid = getElementData(player, "dbid")
		local x, y, z = getElementPosition(player)
		x = x + ( ( math.cos ( math.rad ( pr ) ) ) * 5 )
		y = y + ( ( math.sin ( math.rad ( pr ) ) ) * 5 )
		local model = vehid
		local veh = createVehicle(model, x,y,z)
		setVehicleColor(veh, r,g,b)
		local rx, ry, rz = getElementRotation(veh)
		local var1, var2 = exports['vehicle']:getRandomVariant(vehid)
		local letter1 = string.char(math.random(65,90))
		local letter2 = string.char(math.random(65,90))

		if plateEditText == "" then
			plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
		else
			plate = plateEditText
		end
		local color1 = toJSON( {r,g,b} )
		local color2 = toJSON( {0, 0, 0} )
		local color3 = toJSON( {0, 0, 0} )
		local color4 = toJSON( {0, 0, 0} )
		local interior, dimension = getElementInterior(player), getElementDimension(player)
		local tint = 0
		local factionVehicle = -1
		local inserted = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET model='" .. (vehid) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='0', roty='0', rotz='" .. (pr) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='" .. (factionVehicle) .. "', owner='" .. (dbid) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (pr) .. "', locked='1', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "', tintedwindows='" .. (tint) .. "',variant1='"..var1.."',variant2='"..var2.."', creationDate=NOW(), createdBy='-1', `vehicle_shop_id`='"..brandid.."' ")
		if inserted then
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						local insertid = res[1].id
						if not insertid then
							setElementData(player, "bakiyeMiktar", playerBalance + balance)
							exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu "..vehname.." marka aldığı araç işlenemediği için parası iade edildi.")
							outputChatBox("Aldığın araç veritabanına işlenemediği için paran iade edildi!", player, 255,0,0)
							return false
						end
						call( getResourceFromName( "item-system" ), "deleteAll", 3, insertid )
						exports.global:giveItem( player, 3, insertid )
						--setElementData(veh, "dbid", insertid)
						destroyElement(veh)
						exports['vehicle']:reloadVehicle(insertid)
						
						-------------- TEMI --------------
						local hours = getRealTime().hour
						local minutes = getRealTime().minute
						local seconds = getRealTime().second
						local day = getRealTime().monthday
						local month = getRealTime().month+1
						local year = getRealTime().year+1900
						local alinanUrun = vehname.." Marka arac"
						local ucret = balance
						if exports.integration:isPlayerEGO(player) then return end
						dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
						-----------------------------------------
					end
				end,
			mysql:getConnection(), "SELECT id FROM vehicles WHERE id=LAST_INSERT_ID() LIMIT 1")
		end
	end
end
addEvent("market->donateSatinAl", true)
addEventHandler("market->donateSatinAl", root, privateCarCreate)

addEvent("bakiye:bandana",true)
addEventHandler( ("bakiye:bandana"),root, function (isim,id,fiyat)

	local player = source

	if (player:getData("bakiyeMiktar") or 0) < fiyat then
		outputChatBox("[-]#f9f9f9 Yeterli bakiyeniz kalmadı.",player,255,20,10,true)
	return end
		if exports.global:giveItem(player, id,1) then
		--exports["item-system"]:giveItem(source, id,1)
		local dbid = getElementData(player, "account:id")
		outputChatBox("[-]#f9f9f9 Başarıyla '"..isim.."' satın aldın.",player,55,100,80,true )
		outputChatBox("[►]#f9f9f9 Envanterine gelen öğeye tıklayarak kasayı açabilirsin.",player,155,20,10,true )
		exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu '"..isim.."' satın aldı.")
		setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar")-fiyat)
		-------------- TEMI --------------
		local hours = getRealTime().hour
		local minutes = getRealTime().minute
		local seconds = getRealTime().second
		local day = getRealTime().monthday
		local month = getRealTime().month+1
		local year = getRealTime().year+1900
		local alinanUrun = isim
		local ucret = fiyat
		dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
		-----------------------------------------


    else
    	outputChatBox("Şu ürünü almak için envanterinde yeterli alanın yok: "..isim, player,255,20,10,true)
    end

end)


addEvent("bakiye:pet",true)
addEventHandler( ("bakiye:pet"),root, function (isim,id,fiyat)

	local player = source

	if (player:getData("bakiyeMiktar") or 0) < fiyat then
		outputChatBox("[-]#f9f9f9 Yeterli bakiyeniz bulunmamaktadır.",player,255,20,10,true)
	return end
		if exports.global:giveItem(player, id, 1) then
		--exports["item-system"]:giveItem(source, id,1)
		local dbid = getElementData(player, "account:id")
		outputChatBox("#575757KennedyMTA:#f9f9f9 Başarıyla '"..isim.."' satın aldın.",player,55,100,80,true )
		outputChatBox("[►]#f9f9f9 Envanterine gelen öğeye tıklayarak hayvanını oluşturabilirsin.",player,155,20,10,true )
		exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu '"..isim.."' satın aldı.")
		setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar")-fiyat)
		-------------- TEMI --------------
		local hours = getRealTime().hour
		local minutes = getRealTime().minute
		local seconds = getRealTime().second
		local day = getRealTime().monthday
		local month = getRealTime().month+1
		local year = getRealTime().year+1900
		local alinanUrun = isim
		local ucret = fiyat
		dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
		-----------------------------------------


    else
    	outputChatBox("#575757KennedyMTA:#f9f9f9 Şu ürünü almak için envanterinde yeterli alanın yok: "..isim, player,255,20,10,true)
    end

end)

function orderPet(player, petID)
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	if getElementData(player, "bakiyeMiktar") < 30 then
		outputChatBox("[-]#ffffff Yeterli bakiyeniz yok.", player, 255, 94, 94, true)
		return
	end
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu marketten pet satın aldı.")
	dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = 'PET', `ucret` = '30 TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar")-30)
	outputChatBox("[-]#ffffff Başarıyla evcil hayvan satın aldınız, evcil hayvanı beslemezseniz bayılır ve kullanamazsınız.", player, 66, 155, 245, true)

	--targetPlayer = player
	--triggerClientEvent(targetPlayer, "pet:create", targetPlayer)
end
addEvent("market->petSatinAl", true)
addEventHandler("market->petSatinAl", root, orderPet)
restrictedWeapons = {}
for i=0, 15 do
	restrictedWeapons[i] = true
end
addEvent("market->silahHakEkle", true)
addEventHandler("market->silahHakEkle", root,
	function(player, itemIndex, price)
		
		
		local itemSlot = exports['items']:getItems(player)
		for i, v in ipairs(itemSlot) do
			if v[3] == itemIndex then
				if not v[1] == 115 or restrictedWeapons[tonumber(exports.global:explode(":", v[2])[1])] then
					return outputChatBox("[-] #ffffffBu komut sadece silahlar için kullanılabilir!", player, 255, 94, 94, true)
				end
				local eskiHak = (#tostring(exports.global:explode(":", v[2])[6])>0 and exports.global:explode(":", v[2])[6]) or 3
				eskiHak = not restrictedWeapons[tonumber(exports.global:explode(":", v[2])[1])] and eskiHak or "-"
				yeniHak = eskiHak + 1
				silahAdi = tostring(exports.global:explode(":", v[2])[3])
				local checkString = string.sub(exports.global:explode(":", v[2])[3], -4) == " (D)"
				if checkString then
					return outputChatBox("[-] #ffffffBu komut Duty silahlarında kullanılamaz!", player, 255, 94, 94, true)
				end
				
				exports.global:takeItem(player, 115, v[2])
				exports.global:giveItem(player, 115, tonumber(exports.global:explode(":", v[2])[1])..":"..tostring(exports.global:explode(":", v[2])[2])..":"..tostring(exports.global:explode(":", v[2])[3])..":"..tostring(exports.global:explode(":", v[2])[4])..":"..tostring(exports.global:explode(":", v[2])[5])..":"..tostring(yeniHak))
					

				outputChatBox("[-] #ffffff"..exports.global:explode(":", v[2])[3].." silahının hakkı arttırıldı. Eski Hak: "..eskiHak.." - Yeni Hak: "..yeniHak, player, 0, 55, 255, true)
				
			end
		end
		setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar")-price)
		-------------- TEMI --------------
		local hours = getRealTime().hour
		local minutes = getRealTime().minute
		local seconds = getRealTime().second
		local day = getRealTime().monthday
		local month = getRealTime().month+1
		local year = getRealTime().year+1900
		local alinanUrun = silahAdi.." Hak Ekletme"
		local ucret = price
		dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
		-----------------------------------------
	end
)

function orderGUN(player, silahIsmi, silahFiyati, tabloID)
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu marketten "..silahIsmi.." marka silah satın aldı.")

	local adminDBID, playerDBID = getElementData(player, "dbid"), getElementData(player, "dbid")
	local mySerial = exports.global:createWeaponSerial( 3, adminDBID, playerDBID)
	--[[
	{1, "M4", 250},
	{2, "AK-47", 90},
	{3, "MP5", 65},
	{4, "Shotgun", 65},
	{5, "Tec-9", 65},
	{6, "Uzi", 55},
	{7, "Deagle", 50},
	{8, "Colt45", 30},
	]]--
	targetPlayer = player
	
		if tonumber(tabloID) == 1 then
			if exports.global:giveItem(targetPlayer, 115, "31:"..mySerial..":"..getWeaponNameFromID(31).."::") then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		elseif tonumber(tabloID) == 2 then
			if exports.global:giveItem(targetPlayer, 115, "30:"..mySerial..":"..getWeaponNameFromID(30).."::") then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		elseif tonumber(tabloID) == 3 then
			if exports.global:giveItem(targetPlayer, 115, "29:"..mySerial..":"..getWeaponNameFromID(29).."::") then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		elseif tonumber(tabloID) == 4 then
			if exports.global:giveItem(targetPlayer, 115, "25:"..mySerial..":"..getWeaponNameFromID(25).."::") then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		elseif tonumber(tabloID) == 5 then
			if exports.global:giveItem(targetPlayer, 115, "32:"..mySerial..":"..getWeaponNameFromID(32).."::") then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		elseif tonumber(tabloID) == 6 then
			if exports.global:giveItem(targetPlayer, 115, "28:"..mySerial..":"..getWeaponNameFromID(28).."::") then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		elseif tonumber(tabloID) == 7 then
			if exports.global:giveItem(targetPlayer, 115, "24:"..mySerial..":"..getWeaponNameFromID(24).."::") then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		elseif tonumber(tabloID) == 8 then
			if exports.global:giveItem(targetPlayer, 115, "22:"..mySerial..":"..getWeaponNameFromID(22).."::") then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		elseif tonumber(tabloID) == 9 then
			if exports.global:giveItem(targetPlayer, 550, 1) then
				setElementData(targetPlayer, "bakiyeMiktar", getElementData(targetPlayer, "bakiyeMiktar")-silahFiyati)
				outputChatBox("[-] #ffffffBaşarıyla "..silahIsmi.." marka silah satın aldınız.", targetPlayer, 66, 155, 245, true)
				-------------- TEMI --------------
				local hours = getRealTime().hour
				local minutes = getRealTime().minute
				local seconds = getRealTime().second
				local day = getRealTime().monthday
				local month = getRealTime().month+1
				local year = getRealTime().year+1900
				local alinanUrun = silahIsmi
				local ucret = silahFiyati
				dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffEnvanteriniz dolu olduğundan silah teslim edilemedi.", targetPlayer, 255, 94, 94, true)
			end
		end
end
addEvent("market->silahSatinAl", true)
addEventHandler("market->silahSatinAl", root, orderGUN)

function vehTintPrivate(vehID)
	local vehicle = exports.pool:getElement("vehicle", vehID)
	if vehicle and isElement(vehicle) then
		if getElementData(vehicle, "owner") == getElementData(source, "dbid") then
			local bakiyeCek = tonumber(getElementData(source, "bakiyeMiktar"))
			local vid = tonumber(getElementData(vehicle, "dbid"))
			if bakiyeCek < 10 then
				outputChatBox("[-] #ffffffYeterli bakiyeniz yok.", source, 255, 94, 94, true)
				return
			end
			dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. (vid) .. "'")
			for i = 0, getVehicleMaxPassengers(vehicle) do
				local player = getVehicleOccupant(vehicle, i)
				if (player) then
					triggerEvent("setTintName", vehicle, player)
				end
			end

			exports.anticheat:changeProtectedElementDataEx(vehicle, "tinted", true, true)
			triggerClientEvent("tintWindows", vehicle)
			outputChatBox("[-] #ffffffAraca cam filmi başarıyla eklendi.", source, 66, 155, 245, true)
			setElementData(source, "bakiyeMiktar", bakiyeCek-10)
			-------------- TEMI --------------
			local hours = getRealTime().hour
			local minutes = getRealTime().minute
			local seconds = getRealTime().second
			local day = getRealTime().monthday
			local month = getRealTime().month+1
			local year = getRealTime().year+1900
			local alinanUrun = "Cam Filmi"
			local ucret = "10"
			dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
			-----------------------------------------
		else
			outputChatBox("[-] #ffffffAracın sahibi siz değilsiniz.", source, 255, 94, 94, true)
		end
	else
		outputChatBox("[-] #ffffffAraç bulunamadı.", source, 255, 94, 94, true)
	end
end
addEvent("market->camFilm", true)
addEventHandler("market->camFilm", root, vehTintPrivate)

function vehDoorPrivate(vehID)
	local vehicle = exports.pool:getElement("vehicle", vehID)
	if vehicle and isElement(vehicle) then
		if getElementData(vehicle, "owner") == getElementData(source, "dbid") then
			local bakiyeCek = tonumber(getElementData(source, "bakiyeMiktar"))
			local vid = tonumber(getElementData(vehicle, "dbid"))
			if bakiyeCek < 10 then
				outputChatBox("[-] #ffffffYeterli bakiyeniz yok.", source, 255, 94, 94, true)
				return
			end
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						dbExec(mysql:getConnection(), "UPDATE vehicles_custom SET doortype = '2' WHERE id='" .. (vid) .. "'")
						setTimer(function() exports["vehicle_manager"]:loadCustomVehProperties(tonumber(vehID), vehicle) end, 5000, 1)
						
					else
						dbQuery(
							function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									dbExec(mysql:getConnection(), "INSERT INTO vehicles_custom SET id='"..vid.."', doortype='2', brand='"..row.vehbrand.."', model='"..row.vehmodel.."', year='"..row.vehyear.."', handling='"..row.handling.."' ")
									setTimer(function() exports["vehicle_manager"]:loadCustomVehProperties(tonumber(vehID), vehicle) end, 5000, 1)
								end
							end,
						mysql:getConnection(), "SELECT * FROM vehicles_shop WHERE id='"..vehicle:getData("vehicle_shop_id").."'")
					end
				end,
			mysql:getConnection(), "SELECT id FROM vehicles_custom WHERE id='"..vid.."'")
			
			--exports['vehicle-system-system']:reloadVehicle(vid)
			
			outputChatBox("[-] #ffffffAraca kelebek kapı başarıyla eklendi. (10 saniye içerisinde aktif olur.)", source, 66, 155, 245, true)
			setElementData(source, "bakiyeMiktar", bakiyeCek-10)
			-------------- TEMI --------------
			local hours = getRealTime().hour
			local minutes = getRealTime().minute
			local seconds = getRealTime().second
			local day = getRealTime().monthday
			local month = getRealTime().month+1
			local year = getRealTime().year+1900
			local alinanUrun = "Arac Kelebek Kapi"
			local ucret = "10"
			dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
			-----------------------------------------
		else
			outputChatBox("[-] #ffffffAracın sahibi siz değilsiniz.", source, 255, 94, 94, true)
		end
	else
		outputChatBox("[-] #ffffffAraç bulunamadı.", source, 255, 94, 94, true)
	end
end
addEvent("market->kelebekKapi", true)
addEventHandler("market->kelebekKapi", root, vehDoorPrivate)

-- tablo yapısı

--[[

bakiyeTablosu

id --> int Auto increment
dbid --> int
start --> int
expiry --> int
converted --> int

--]]

----------------------------------
------- BAKIYE DÖNÜŞTÜRME --------
----------------------------------

local HAFTALIK_LIMIT = 125 -- bakiye
local BIR_HAFTA = 7*24*60*60
--local BIR_HAFTA = 1*60

function bakiyeDonustur(oyuncu, donusturulecekBakiye)
	if not isElement(oyuncu) then return end
	local dbid = tonumber(getElementData(oyuncu, "account:id"))
	if not dbid then return end
	local donusturulecekBakiye = tonumber(donusturulecekBakiye)
	if not donusturulecekBakiye then 
		return outputChatBox("[-] #ffffffGirilen miktar sayı değil.", oyuncu, 255, 94, 94, true)
	end
	
	local oyuncuBakiyesi = getElementData(oyuncu, "bakiyeMiktar") or 0
	if oyuncuBakiyesi < donusturulecekBakiye then
		return outputChatBox("[-] #ffffffBakiyeniz yetersiz.", oyuncu, 255, 94, 94, true)
	end
	
	local data = exports.mysql:select_one("bakiyeTablosu", {dbid = dbid})
	local donusturulenBakiye = 0
	if data then
		outputChatBox("[-] #ffffffHaftalık limitiniz doldu.", oyuncu, 255, 94, 94, true)
		
		if tonumber(data.expiry) >= tonumber(getRealTime().timestamp) then
			--outputChatBox("aynı hafta içinde", oyuncu)
			donusturulenBakiye = data.converted
		else
			--outputChatBox("aynı hafta içinde değil", oyuncu)
			donusturulenBakiye = 0
			local start = getRealTime().timestamp
			local expiry = start + BIR_HAFTA
			exports.mysql:update("bakiyeTablosu", {start = start, expiry = expiry, converted = 0}, {dbid = dbid})
		end
	else
		--outputChatBox("daha önceden dönüştürme yapılmamış", oyuncu)
		local start = getRealTime().timestamp
		local expiry = start + BIR_HAFTA
		exports.mysql:insert("bakiyeTablosu", {start = start, expiry = expiry, converted = 0, dbid = dbid})
	end
	
	local newConverted = donusturulenBakiye + donusturulecekBakiye
	if newConverted <= HAFTALIK_LIMIT then
		-- dönüştürme işlemi
		if exports.mysql:update("bakiyeTablosu", {converted = newConverted}, {dbid = dbid}) then
			setElementData(oyuncu, "bakiyeMiktar", oyuncuBakiyesi - donusturulecekBakiye)
			exports.global:giveMoney(oyuncu,donusturulecekBakiye * 1000)
			outputChatBox("[-] #ffffffDönüştürme başarılı. #ff0000|#ffffff Dönüştürülen bakiye: "..donusturulecekBakiye, oyuncu, 0, 55, 255, true)	
			outputChatBox("[-] #ffffff["..tonumber(HAFTALIK_LIMIT - newConverted).."] bakiye dönüştürme hakkınız kaldı.", oyuncu, 0, 55, 255, true)
			
			-------------- TEMI --------------
			local hours = getRealTime().hour
			local minutes = getRealTime().minute
			local seconds = getRealTime().second
			local day = getRealTime().monthday
			local month = getRealTime().month+1
			local year = getRealTime().year+1900
			local alinanUrun = exports.global:formatMoney(donusturulecekBakiye*1000).."$ Para"
			local ucret = donusturulecekBakiye
			dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(oyuncu, "account:id").."', `accountUsername` = '"..getElementData(oyuncu, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
			-----------------------------------------
		end
	else
		outputChatBox("[-] #ffffffHaftalık limitten daha fazla dönüştürme yapamazsınız.", oyuncu, 255, 94, 94, true)
		outputChatBox("[-] #ffffffBu haftaki dönüştürme hakkın: "..tonumber(HAFTALIK_LIMIT - donusturulenBakiye), oyuncu, 255, 94, 94, true)
	end
end
addEvent("market->paraDonustur", true)
addEventHandler("market->paraDonustur", root, bakiyeDonustur)
--addCommandHandler("donustest", bakiyeDonustur)


function plakaDegistirSERVER(oyuncu, plateText, aracID, fiyat)
	local bakiyeCek = tonumber(getElementData(oyuncu, "bakiyeMiktar"))
	if bakiyeCek < math.ceil(fiyat) then
		outputChatBox("[-] #ffffffBakiye yetersiz.", oyuncu, 255, 94, 94, true)
	return
	end
	
	
	local theVehicle = exports.pool:getElement("vehicle", aracID)
	if theVehicle then
		if getElementData(oyuncu, "dbid") ~= getElementData(theVehicle, "owner") then
			outputChatBox("[-] #ffffffAraç size ait değil.", oyuncu, 255, 94, 94, true)
		return
		end
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					if res[1].no == 0 then
						if (exports.vehicleplate:checkPlate(plateText)) and getVehiclePlateText(theVehicle) ~= plateText then
							local insertnplate = dbExec(mysql:getConnection(), "UPDATE vehicles SET plate='" .. (plateText) .. "' WHERE id = '" .. (aracID) .. "'")
							local x, y, z = getElementPosition(theVehicle)
							local int = getElementInterior(theVehicle)
							local dim = getElementDimension(theVehicle)
							exports.anticheat:changeProtectedElementDataEx(theVehicle, "plate", plateText)
							setVehiclePlateText(theVehicle, plateText)
							--exports['vehicle-system-system']:reloadVehicle(tonumber(aracID))
							local newVehicleElement = theVehicle--exports.pool:getElement("vehicle", aracID)
							setElementPosition(newVehicleElement, x, y, z)
							setElementInterior(newVehicleElement, int)
							setElementDimension(newVehicleElement, dim)
							setElementData(oyuncu, "bakiyeMiktar", getElementData(oyuncu, "bakiyeMiktar") - 5)
							outputChatBox("[-] #ffffffBaşarıyla [ID#"..aracID.."]'li aracın plakası ["..plateText.."] olarak değiştirildi.", oyuncu, 66, 155, 245, true)

							
							-------------- TEMI --------------
							local hours = getRealTime().hour
							local minutes = getRealTime().minute
							local seconds = getRealTime().second
							local day = getRealTime().monthday
							local month = getRealTime().month+1
							local year = getRealTime().year+1900
							local alinanUrun = "Plaka Degisikligi [ID#"..aracID..":"..plateText.."]"
							local ucret = 5
							dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(oyuncu, "account:id").."', `accountUsername` = '"..getElementData(oyuncu, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
							-----------------------------------------
						else
							outputChatBox("[-] #ffffffGeçersiz karakter içermekte.", oyuncu, 255, 94, 94, true)
						end
					else
						outputChatBox("[-] #ffffffSeçtiğiniz plaka kullanılıyor.", oyuncu, 255, 94, 94, true)
					end
				end
			end,
		mysql:getConnection(), "SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. (plateText).."'")
		
	end
end
addEvent("market->setVehiclePlate", true)
addEventHandler("market->setVehiclePlate", root, plakaDegistirSERVER)


addEvent("market->addVehicleNeon", true)
addEventHandler("market->addVehicleNeon", root,
	function(player, vehicleID, neonIndex)
		local vehicleID = tonumber(vehicleID)
		local vehicle = exports.pool:getElement("vehicle", vehicleID)
		if vehicle and isElement(vehicle) then
			if getElementData(vehicle, "owner") == getElementData(source, "dbid") then
				local vehicleNeon = getElementData(vehicle, "tuning.neon") or false
				if not vehicleNeon then
					local bakiyeCek = tonumber(getElementData(player, "bakiyeMiktar"))
					if bakiyeCek < 15 then
						outputChatBox("[-] #ffffffBakiyeniz yetersiz.", player, 255, 94, 94, true)
						return
					end
					setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar") - 15)
				else
					outputChatBox("[-] #ffffffDaha önce zaten bu araca neon satın alınmış.", player, 255, 94, 94, true)
				end
				outputChatBox("[-] #ffffffAracınıza neon başarıyla eklendi, N tuşu ile açıp/kapatabilirsiniz.", player, 255, 94, 94, true)
				dbExec(mysql:getConnection(), "UPDATE vehicles SET neon='"..neonIndex.."' WHERE id='"..vehicleID.."'")
				setElementData(vehicle, "tuning.neon", neonIndex)
				-------------- TEMI --------------
				if not vehicleNeon then
					local hours = getRealTime().hour
					local minutes = getRealTime().minute
					local seconds = getRealTime().second
					local day = getRealTime().monthday
					local month = getRealTime().month+1
					local year = getRealTime().year+1900
					local alinanUrun = "[Arac Neon - Arac ID: "..vehicleID.." - Neon Renk: "..tostring(neonIndex).."]"
					local ucret = 10
					dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
				end
				-----------------------------------------
			else
				outputChatBox("[-] #ffffffAracın sahibi siz değilsiniz.", player, 255, 94, 94, true)
			end
		else
			outputChatBox("[-] #ffffffAraç ID bulunamadı.", player, 255, 94, 94, true)
		end
	end
)

-- @@ Texture Sistemi:
addEvent("market->setVehicleTexture", true)
addEventHandler("market->setVehicleTexture", root,
	function(player, vehicle, link, texture_name)
		local vehicle = exports.pool:getElement("vehicle", vehicle)
		
		if vehicle and isElement(vehicle) then
			local vehicleID = getElementData(vehicle, "dbid")
			if getElementData(vehicle, "owner") == getElementData(source, "dbid") then
				local customTextures = getElementData(vehicle, "textures")--fromJSON(row.textures) or {}
				setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
				if #customTextures >= 1 then
					local bakiyeCek = tonumber(getElementData(player, "bakiyeMiktar"))
					if bakiyeCek < 5 then
						outputChatBox("[-] #ffffffBakiyeniz yetersiz.", player, 255, 94, 94, true)
						return
					end
					setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar") - 5)
					triggerEvent("vehtex:removeTexture", player, vehicle, texture_name, link)
					-------------- TEMI --------------
					local hours = getRealTime().hour
					local minutes = getRealTime().minute
					local seconds = getRealTime().second
					local day = getRealTime().monthday
					local month = getRealTime().month+1
					local year = getRealTime().year+1900
					local alinanUrun = "[(G) Arac Texture - Arac ID: "..vehicleID.." - Link: "..tostring(link).."]"
					local ucret = 5
					dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
					-----------------------------------------
					
					outputChatBox("[-] #ffffffAracınızdaki kaplama başarıyla değiştirildi.", player, 66, 155, 245, true)
				else
					local bakiyeCek = tonumber(getElementData(player, "bakiyeMiktar"))
					if bakiyeCek < 20 then
						outputChatBox("[-] #ffffffBakiyeniz yetersiz.", player, 255, 94, 94, true)
						return
					end
					setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar") - 20)
					outputChatBox("[-] #ffffffAracınıza kaplama başarıyla eklendi.", player, 66, 155, 245, true)
					-------------- TEMI --------------
					local hours = getRealTime().hour
					local minutes = getRealTime().minute
					local seconds = getRealTime().second
					local day = getRealTime().monthday
					local month = getRealTime().month+1
					local year = getRealTime().year+1900
					local alinanUrun = "[Arac Texture - Arac ID: "..vehicleID.." - Link: "..tostring(link).."]"
					local ucret = 20
					dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
					-----------------------------------------
				end
				
				triggerEvent("vehtex:addTexture", player, vehicle, texture_name, link)
				
				
			else
				outputChatBox("[-] #ffffffAracın sahibi siz değilsiniz.", player, 255, 94, 94, true)
			end
		else
			outputChatBox("[-] #ffffffAraç ID bulunamadı.", player, 255, 94, 94, true)
		end
	end
)
addEvent("market->receiveInactiveCharacters", true)
addEventHandler("market->receiveInactiveCharacters", root,
	function()
		dbQuery(
			function(qh, plr)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					triggerClientEvent(plr, "market->sendInactiveCharacters", plr, res)
				end
			end,
		{source}, mysql:getConnection(), "SELECT id, charactername, active, activeDescription FROM characters WHERE account='"..getElementData(source, "account:id").."' AND active='0'")
	end
)

addEvent("market->unBanCK", true)
addEventHandler("market->unBanCK", root,
	function(player, charname, charid, ckDescription, ckAcilacakIsim)
		if tostring(ckDescription) == "CK" or tostring(ckDescription) == "Karakter Ölümü" then
			local stat,errort = checkValidCharacterName(charname)
			if not stat then
				outputChatBox("[-] #ffffff"..errort, player, 255, 94, 94, true)
				return false
			end
			charname = string.gsub(tostring(charname), " ", "_")
			local row = exports.global:getCache("characters", charname, "charactername")
			if row then
				outputChatBox("[-] #ffffffBu isim zaten kullanımda.", player, 255, 94, 94, true)
				return false
			end
			mysql:free_result(mQuery1)
			local bakiyeCek = tonumber(getElementData(player, "bakiyeMiktar"))
			if bakiyeCek < 30 then
				outputChatBox("[-] #ffffffBu işlem için 30 TL bakiyeniz olması gerekmektedir.", player,255, 94, 94, true)
				return false
			end
			balance = 30
			dbExec(mysql:getConnection(), "UPDATE characters SET charactername='"..charname.."', active='1' WHERE id='"..charid.."'")
		else
			local bakiyeCek = tonumber(getElementData(player, "bakiyeMiktar"))
			if bakiyeCek < 20 then
				outputChatBox("[-] #ffffffBu işlem için 20 TL bakiyeniz olması gerekmektedir.", player,255, 94, 94, true)
				return false
			end
			balance = 20
			dbExec(mysql:getConnection(), "UPDATE characters SET active='1' WHERE id='"..charid.."'")
		end

		setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar")-balance)
		outputChatBox("[-] #ffffffCK Açma ücreti olarak ["..balance.." TL] kesilmiştir.", player, 66, 155, 245, true)
		outputChatBox("[-] #ffffffKarakter yasaklaması başarıyla açıldı, oyundan çıkıp giriniz.", player, 66, 155, 245, true)

		-------------- TEMI --------------
		local hours = getRealTime().hour
		local minutes = getRealTime().minute
		local seconds = getRealTime().second
		local day = getRealTime().monthday
		local month = getRealTime().month+1
		local year = getRealTime().year+1900
		local alinanUrun = "[CK Actirma] "..ckAcilacakIsim
		local ucret = balance
		dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
		-----------------------------------------
		
		outputChatBox("(( " ..(ckAcilacakIsim):gsub("_", " ").. " sunucudan yasaklandı. Sure: Sınırsız Gerekce: İsim Değişikliği - " ..string.format("%02d", hours)..":"..string.format("%02d", minutes).. " ))", arrarPlayer, 255, 0, 0)
		exports.global:sendMessageToAdmins("[MARKET] '" .. ckAcilacakIsim .. "' isimli oyuncu ismini '" .. charname .. "' olarak değiştirildi.")
	end
)

addEvent("market->clearHistory", true)
addEventHandler("market->clearHistory", root,
	function(player, balance)
		
		local balance = tonumber(balance)
		if balance < 0 then return end
		local bakiyeCek = tonumber(getElementData(player, "bakiyeMiktar"))
		if bakiyeCek < balance then
			outputChatBox("[-] #ffffffBakiyeniz yetersiz.", player, 255, 94, 94, true)
			return
		end

		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
			
				if rows > 0 then
					setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar") - balance)
					outputChatBox("[-] #ffffffHistory başarıyla silindi, "..balance.. " adet.", player, 66, 155, 245, true)
					for index, value in ipairs(res) do
						dbExec(mysql:getConnection(), "DELETE FROM adminhistory WHERE id='"..value.id.."'")
					end
				end
			end,
		mysql:getConnection(), "SELECT id, action FROM adminhistory WHERE user='"..getElementData(player, "account:id").."' ORDER BY date DESC LIMIT "..balance)
		-------------- TEMI --------------
		local hours = getRealTime().hour
		local minutes = getRealTime().minute
		local seconds = getRealTime().second
		local day = getRealTime().monthday
		local month = getRealTime().month+1
		local year = getRealTime().year+1900
		local alinanUrun = "[History Sildirme] "..balance.. " tane"
		local ucret = balance
		dbExec(mysql:getConnection(), "INSERT INTO `marketLogs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
		-----------------------------------------
	end
)

local hediyeler = {
        --{"Silah isim",yuzdeorani},
        {"Flower", 38},
        {"Colt 45",33},
		{"Deagle",27},
		{"Uzi",20},
		{"Shotgun",15},
		{"Combat Shotgun",20},
        {"Tec-9",30},
}
 
 
function silahKasa(oyuncu)
        if  exports.global:hasItem(oyuncu, 582) then
                local silahisim = unpack(hediyeler[randomHediye()])
                local silahid = getWeaponIDFromName(silahisim)
                local cid = tonumber(getElementData(oyuncu,"account:character:id"))
                local serial = exports.global:createWeaponSerial(1,cid)
               

                exports.global:takeItem(oyuncu, 582, 1)

                outputChatBox("☼#f9f9f9 Kasan açılıyor, bakalım şansına ne gelecek..",oyuncu,255,155,180,true)

                setTimer(function()
                	outputChatBox("► #f9f9f9Kasanın açılmasına son: 3 saniye...",oyuncu,255, 201, 84,true)
                		triggerClientEvent( oyuncu, "kasa:ses1", oyuncu, 1 )
            end,1000,1)
                setTimer(function()
                	outputChatBox("► #f9f9f9Kasanın açılmasına son: 2 saniye..",oyuncu,194, 150, 54,true)
                	   triggerClientEvent( oyuncu, "kasa:ses1", oyuncu, 1 )
            end,2000,1)  
                setTimer(function()
                		triggerClientEvent( oyuncu, "kasa:ses1", oyuncu, 1 )                	
                	outputChatBox("► #f9f9f9Kasanın açılmasına son: 1 saniye.",oyuncu,184, 131, 17,true)
            end,3000,1)



                setTimer(function()
                
                if(exports["items"]:giveItem(oyuncu, 115, silahid..":"..serial..":"..silahisim.."::")) then 


        		if(silahisim=="Flower") then
        			triggerClientEvent( oyuncu, "kasa:ses3", oyuncu, 1 )
        			outputChatBox("[-] #f9f9f9Üzgünüm dostum, boş çıktı ama biz sana yine de çiçek hediye edelim dedik. Bir dahakine artık.",oyuncu,255,54,80,true)
                exports.global:sendMessageToAdmins("[MARKET]: "..getPlayerName(oyuncu).." isimli oyuncu Silah Kutusundan 'BAŞ' çıkarttı!")
        		exports['admins']:addAdminHistory(oyuncu, oyuncu, "Silah Kasasından Boş Çıkarttı", 8, 1)        		
        		else
        		triggerClientEvent( oyuncu, "kasa:ses4", oyuncu, 1 )
        		exports['admins']:addAdminHistory(oyuncu, oyuncu, "Silah Kasasından "..silah.." Çıkarttı", 8, 1)
                outputChatBox("★ #f9f9f9'".. silahisim .."' markalı silah çıkarttın.", oyuncu, 229, 84, 255, true)
                exports.global:sendMessageToAdmins("[MARKET]: "..getPlayerName(oyuncu).." isimli oyuncu Silah Kutusundan "..silahisim.." çıkarttı!")
        end
            else
            triggerClientEvent( oyuncu, "kasa:ses2", oyuncu, 1 )
        outputChatBox("[-] #f9f9f9Envanterinde yeterli alan olmadığı için kasanı yeniden sana geri verdik.", oyuncu, 255, 54, 80, true)
        outputChatBox("Tüyo: #f9f9f9Lütfen envanterini temizle.", oyuncu, 255, 54, 80, true)
        exports.global:giveItem(oyuncu,582,1)
    end
        end,4000,1)	
        else
        outputChatBox("[-] #f9f9f9Bu öğeyi kullanabilmek için 'Silah Kasası' ürününü satın almalısın. (( /market ))", oyuncu, 255, 54, 80, true)
        end


end
addCommandHandler("sks",silahKasa)

local premium = {
        --{"Silah isim",yuzdeorani},
        {"Uzi",35},
        {"Shotgun",30},
        {"Combat Shotgun",30},
        {"Tec-9",30},
        {"AK-47",5},
}
 
 
function premiumKasa(oyuncu)
        if  exports.global:hasItem(oyuncu, 583) then
                local silahisim = unpack(premium[randomHediye()])
                local silahid = getWeaponIDFromName(silahisim)
                local cid = tonumber(getElementData(oyuncu,"account:character:id"))
                local serial = exports.global:createWeaponSerial(1,cid)
               

                exports.global:takeItem(oyuncu, 583, 1)

                outputChatBox("☼#f9f9f9 Premium Kasan açılıyor, bakalım şansına ne gelecek..",oyuncu,255,155,180,true)


            
                setTimer(function()
                	outputChatBox("► #f9f9f9Kasanın açılmasına son: 3 saniye...",oyuncu,255, 12, 84,true)
                		triggerClientEvent( oyuncu, "kasa:ses1", oyuncu, 1 )
            end,1000,1)
                setTimer(function()
                	outputChatBox("► #f9f9f9Kasanın açılmasına son: 2 saniye..",oyuncu,194, 12, 54,true)
                	   triggerClientEvent( oyuncu, "kasa:ses1", oyuncu, 1 )
            end,2000,1)  
                setTimer(function()
                		triggerClientEvent( oyuncu, "kasa:ses1", oyuncu, 1 )                	
                	outputChatBox("► #f9f9f9Kasanın açılmasına son: 1 saniye.",oyuncu,184, 12, 17,true)
            end,3000,1)



                setTimer(function()
                
                if(exports["items"]:giveItem(oyuncu, 115, silahid..":"..serial..":"..silahisim.."::")) then 
        		triggerClientEvent( oyuncu, "kasa:ses5", oyuncu, 1 )
        		exports['admins']:addAdminHistory(oyuncu, oyuncu, "Premium Silah Kasasından "..silahisim.." Çıkarttı", 8, 1)
                outputChatBox("★ #f9f9f9'".. silahisim .."' markalı silah çıkarttın.", oyuncu, 229, 84, 255, true)
                exports.global:sendMessageToAdmins("[MARKET]: "..getPlayerName(oyuncu).." isimli oyuncu Premium Silah Kutusundan "..silahisim.." çıkarttı!")

            else
            triggerClientEvent( oyuncu, "kasa:ses2", oyuncu, 1 )
        outputChatBox("[-] #f9f9f9Envanterinde yeterli alan olmadığı için kasanı yeniden sana geri verdik.", oyuncu, 255, 54, 80, true)
        outputChatBox("Tüyo: #f9f9f9Lütfen envanterini temizle.", oyuncu, 255, 54, 80, true)
        exports.global:giveItem(oyuncu,583,1)
    end
        end,4000,1)	
        else
        outputChatBox("[-] #f9f9f9Bu öğeyi kullanabilmek için 'Premium Silah Kasası' ürününü satın almalısın. (( /market ))", oyuncu, 255, 54, 80, true)
        end


end
addCommandHandler("pks",premiumKasa)
 
function randomHediye()
        for i=1,#hediyeler do
                local yuzde = hediyeler[i][2]
                if randomChange(yuzde) then
                        return i
                end     
        end
        return randomHediye() 
end
 
 
function randomChange(percent) 
  assert(percent >= 0 and percent <= 100) 
  return percent >= math.random(1, 100)  
                                       
end



function otomatikYaziGecirt()
	local randomSayi = math.random(1,2)
	if randomSayi == 1 then
		outputChatBox("[-] #ffffff==============================================", arrarPlayer, 0, 125, 255, true)
		outputChatBox("[-] #ffffff/market yazarak bakiye yükleyip satın alabileceklerinizi görebilirsiniz.", arrarPlayer, 0, 125, 255, true)
		outputChatBox("[-] #ffffffBakiye yüklemesi yapmak için aşağıdaki linke giriş yapınız.", arrarPlayer, 0, 125, 255, true)
		outputChatBox("[-] #ffffffBakiye yükleme linki: YOK!", arrarPlayer, 0, 125, 255, true)
		outputChatBox("[-] #ffffff=============================================", arrarPlayer, 0, 125, 255, true)
	elseif randomSayi == 2 then
		outputChatBox("[-] #ffffff=============================================", arrarPlayer, 0, 125, 255, true)
		outputChatBox("[-] #ffffffKredi Kartı (taksit var), Ininal, Mobil Ödeme (kontür veya TL) ile bakiye yüklemesi yapabilirsiniz.", arrarPlayer, 0, 125, 255, true)
		outputChatBox("[-] #ffffffBakiye yükleme linki: YOK!", arrarPlayer, 0, 125, 255, true)
		outputChatBox("[-] #ffffffWeb sitemizden yapacağınız bakiye yüklemeleri otomatik olarak anında yüklenir.", arrarPlayer, 237, 202, 42, true)
		outputChatBox("[-] #ffffff=============================================", arrarPlayer, 0, 125, 255, true)
	end
end
setTimer(otomatikYaziGecirt, 1000*60*60, 0)

function otomatikYaziGecirtQuery(thePlayer)
	if exports.integration:isPlayerEGO(thePlayer) then
		otomatikYaziGecirt()
	end
end
addCommandHandler("donate", otomatikYaziGecirtQuery)


function guncelleBakiye(source)

	local dbid = getElementData(source, "account:id")
	dbQuery(
		function(qh, source)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				local row = res[1]
				local bakiye = row["bakiyeMiktari"]
				setElementData(source, "bakiyeMiktar", tonumber(bakiye))
				local b = getElementData(source, "bakiyeMiktar")
				--outputChatBox("[-] #f9f9f9Güncel Bakiyeniz: "..b.." TL",source,255,194,14,true)
				exports["infobox"]:addBox(source, "info", "Güncel Bakiyeniz: "..b.." TL")
			end
		end,
	{source}, mysql:getConnection(), "SELECT bakiyeMiktari,username FROM accounts WHERE id='" .. dbid .. "'")
	

	
end
addEvent("market->guncelleBakiye",true)
addEventHandler("market->guncelleBakiye", root, guncelleBakiye)


