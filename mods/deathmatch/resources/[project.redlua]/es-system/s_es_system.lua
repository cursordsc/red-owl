mysql = exports["mysql"]

function playerDeath(totalAmmo, killer, killerWeapon)
	if getElementData(source, "dbid") then
		if  getElementData(source, "KafesDovusu") then return end	
		if  getElementData(source, "SavasEtkinlik") then return end	
		if  getElementData(source, "dead") == 1 then return end	
		if getElementData(source, "adminjailed") then
			local x, y, z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			spawnPlayer(source, x, y, z, 270, getElementModel(source), int, dim, getPlayerTeam(source))
			setCameraInterior(source, int)
			setCameraTarget(source)
			
			exports["logs"]:dbLog(source, 34, source, "died in admin jail")
		elseif getElementData(source, "jailed") then
			exports["prison"]:checkForRelease(source)
			
			exports["logs"]:dbLog(source, 34, source, "Cezaevinde öldü")
		elseif getElementData(source, "pd.jailtimer") then
			local x, y, z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			spawnPlayer(source, x, y, z, 270, getElementModel(source), int, dim, getPlayerTeam(source))
			setCameraInterior(source, int)
			setCameraTarget(source)
			
			exports["logs"]:dbLog(source, 34, source, "Hücrede öldü")
		else
			local affected = { }
			table.insert(affected, source)
			local killstr = ' öldü'
			if (killer) then
				if getElementType(killer) == "player" then
					if (killerWeapon) then
						killstr = ', '..getPlayerName(killer):gsub("_", " ").. ' tarafından öldürüldü! ('..getWeaponNameFromID ( killerWeapon )..')'
					else
						killstr = ' öldü'
					end
					table.insert(affected, killer)
				else
				killstr = ' got killed by an unknown source'
				table.insert(affected, "Unknown")
				end
			end
			-- Remove seatbelt if theres one on
			if 	(getElementData(source, "seatbelt") == true) then
				exports["anticheat"]:changeProtectedElementDataEx(source, "seatbelt", false, true)
			end
			
			if 	(getElementData(source, "fishing") == true) then
				exports["anticheat"]:changeProtectedElementDataEx(source, "fishing", false, true)
				triggerClientEvent("fishing:killTimers", source)
			end
			
			if 	(getElementData(source, "restrain") == true) then
				exports["anticheat"]:changeProtectedElementDataEx(source, "restrain", false, true)
			end
			
			--craxeN
			local id = getElementData(source, "dbid") -- account:character:id
			if id then

				dbExec(mysql:getConnection(), "UPDATE `characters` SET `isDead`='1' WHERE `id`='"..id.."' ")
			end

			local victimDropItem = false
			

			if (killer) then
				changeDeathViewTimer = setTimer(changeDeathView, 3000, 1, source, victimDropItem, false)
			elseif (killer == source) then
				changeDeathViewTimer = setTimer(changeDeathView, 3000, 1, source, victimDropItem, true)
			else
				changeDeathViewTimer = setTimer(changeDeathView, 3000, 1, source, victimDropItem, true)
			end
			
			outputChatBox("#1a00ff[!] #dedede Bayıldınız, üzerinizde silah yok ise 60 saniye. Var ise 200 saniye bayılacaksınız..", source, 255, 255, 255, true)
			
			
			exports["logs"]:dbLog(source, 34, affected, killstr)
			exports["anticheat"]:changeProtectedElementDataEx(source, "lastdeath", " [KILL] "..getPlayerName(source):gsub("_", " ") .. killstr, true)
			--logMe(" [KILL] "..getPlayerName(source) .. killstr)
			setElementData(source, "dead", 1)
		end
	end
end
addEventHandler("onPlayerWasted", getRootElement(), playerDeath)

--craxeN
function changeDeathView(source, victimDropItem, isSuicide)
	if isPedDead(source) then
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getElementRotation(source)
		--setCameraMatrix(source, x+6, y+6, z+3, x, y, z)
		local x,y,z = getElementPosition(source)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)
		local skin = getElementModel(source)
		local team = getPlayerTeam(source)

		setPedHeadless(source, false)
		setCameraInterior(source, int)
		--spawnPlayer(source, x, y, z, 0, skin, int, dim, team)
		local isSuicide = isSuicide
		triggerClientEvent(source,"es-system:lowerTimer", source, isSuicide)
		--triggerClientEvent("Emekleme:Emeklet",source,"Ekle")	
	end
end
addEvent("changeDeathView", true)
addEventHandler("changeDeathView", getRootElement(), changeDeathView)

function acceptDeath(thePlayer, victimDropItem)
	if getElementData(thePlayer, "dead") == 1 then
		if victimDropItem then
			local x, y, z = getElementPosition(thePlayer)
			for key, item in pairs(exports["items"]:getItems(thePlayer)) do 
				itemID = tonumber(item[1])
				local ammo = false
				if itemID == 116 then 
					ammo = exports["global"]:explode( ":", item[2]  )[2]
				end
				local keepammo = false
				if itemID == 116 or itemID == 115 or itemID == 134 then
					triggerEvent("dropItemOnDead", thePlayer, itemID, item[2], x, y, z, ammo, false)
				end
			end
		end
		
		fadeCamera(thePlayer, true)
		--outputChatBox("Respawning...", thePlayer)
		if isTimer(changeDeathViewTimer) == true then
			killTimer(changeDeathViewTimer)
		end
		respawnPlayer(thePlayer, victimDropItem)
		local x, y, z = getElementPosition(thePlayer)
		spawnPlayer(thePlayer, x,y,z)
		setCameraTarget(thePlayer, thePlayer)
	else
		outputChatBox("Baygin Değilsiniz!", thePlayer, 255, 0, 0)
		respawnPlayer(thePlayer, victimDropItem) -- Fix these bug
		local x, y, z = getElementPosition(thePlayer)
		spawnPlayer(thePlayer, x,y,z)
		setCameraTarget(thePlayer, thePlayer)
	end
end
addEvent("es-system:acceptDeath", true)
addEventHandler("es-system:acceptDeath", getRootElement(), acceptDeath)
--addCommandHandler("acceptdeath", acceptDeath)
--addCommandHandler("spawn", acceptDeath)

function logMe( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	exports["global"]:sendMessageToAdmins(message)
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function logMeNoWrn( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function readLog(thePlayer)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "killog") or { }
		outputChatBox("Recent kill list:", thePlayer, 205, 201, 165)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer, 205, 201, 165, true)
		end
		outputChatBox("  END", thePlayer, 205, 201, 165)
	end
end
addCommandHandler("showkills", readLog)

function respawnPlayer(thePlayer, victimDropItem)
	if (isElement(thePlayer)) then
		if  getElementData(thePlayer, "KafesDovusu") then return end	
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports["global"]:sendMessageToAdmins("AC0x0000004: "..getPlayerName(thePlayer):gsub("_", " ").." died while not in character, triggering blackfade.")
			return
		end
		
		setPedHeadless(thePlayer, false)	
		
		local cost = math.random(175, 500)		
		local tax = exports["global"]:getTaxAmount()
		
		exports["global"]:giveMoney( getTeamFromName("Los Santos Medical Departmanı"), math.ceil((1-tax)*cost) )
		exports["global"]:takeMoney( getTeamFromName("Los Santos Medical Departmanı"), math.ceil((1-tax)*cost) )
			
		dbExec(mysql:getConnection(), "UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. (getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)

		setCameraTarget(thePlayer, thePlayer)

		outputChatBox("#1a00ff[!] #dedede Bayıldınız, üzerinizde silah yok ise 60 saniye. Var ise 200 saniye bayılacaksınız..", source, 255, 255, 255, true)
		
		local death = getElementData(thePlayer, "lastdeath")
		if removedWeapons ~= nil then
			logMe(death)
			exports["global"]:sendMessageToAdmins("/showkills to view lost weapons.")
		else
			logMe(death)
		end
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)

		setElementData(thePlayer, "dead", 0)
		if getElementData(source, "hunger") <= 0 then
			exports["anticheat"]:changeProtectedElementDataEx(source, "hunger", 5)
		end
		if getElementData(source, "thirst") <= 0 then
			exports["anticheat"]:changeProtectedElementDataEx(source, "thirst", 5)
		end
		triggerEvent("kaydet:aclikvesusuzluk", source, source)
		local id = getElementData(thePlayer, "dbid") -- account:character:id
		if id then
			--local preparedQuery = "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' "
			--exports["mysql"]:query_free(preparedQuery)
			dbExec(mysql:getConnection(), "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' ")
		end

		local x,y,z = getElementPosition(thePlayer)
		local int = getElementInterior(thePlayer)
		local dim = getElementDimension(thePlayer)
		local skin = getElementModel(thePlayer)
		local team = getPlayerTeam(thePlayer)

		spawnPlayer(thePlayer, x, y, z, 0, skin, int, dim, team)
		
		setCameraInterior(thePlayer, int)
		setCameraTarget(thePlayer, thePlayer)

		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)

		fadeCamera(thePlayer, true, 6)
		triggerClientEvent(thePlayer, "fadeCameraOnSpawn", thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
		triggerEvent("social-system:makecuffanim", thePlayer)
		--triggerClientEvent("Emekleme:Emeklet",source,"Kaldır")
	end
end

addEventHandler("onPlayerWasted", root, function(mermi,saldiran,silah)
	setTimer(function(olen,mermi,saldiran,silah)
		if not isElement(olen) then return end
		local olu = getElementData(olen, "dead")
		if olu == 1 then
			if isPlayerKinli(olen,saldiran,silah) then
				if  getElementData(olen, "KafesDovusu") then return end	
				if (getElementData(olen, "loggedin") == 0) then
					exports["global"]:sendMessageToAdmins("AC0x0000004: "..getPlayerName(olen):gsub("_", " ").." died while not in character, triggering blackfade.")
					return
				end
				setElementData(olen, "dead", 0)
				setPedHeadless(olen, false)	
				
				local cost = math.random(175, 500)		
				local tax = exports["global"]:getTaxAmount()
				
				exports["global"]:giveMoney( getTeamFromName("Los Santos Medical Departmanı"), math.ceil((1-tax)*cost) )
				exports["global"]:takeMoney( getTeamFromName("Los Santos Medical Departmanı"), math.ceil((1-tax)*cost) )
					
				dbExec(mysql:getConnection(), "UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. getPlayerName(olen) .. "'")
			

				if getElementData(olen, "hunger") <= 0 then
					exports["anticheat"]:changeProtectedElementDataEx(olen, "hunger", 5)
				end
				if getElementData(olen, "thirst") <= 0 then
					exports["anticheat"]:changeProtectedElementDataEx(olen, "thirst", 5)
				end
				triggerEvent("kaydet:aclikvesusuzluk", olen, olen)
				local id = getElementData(olen, "dbid") -- account:character:id
				if id then
					--local preparedQuery = "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' "
					--exports["mysql"]:query_free(preparedQuery)
					dbExec(mysql:getConnection(), "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' ")
				end
				

				local team = getPlayerTeam(olen)
				local factiontype = getElementData(team, "type")
				local items = exports['items']:getItems( olen ) -- [] [1] = itemID [2] = itemValue
				
				local formatedWeapons
				local correction = 0
				for itemSlot, itemCheck in ipairs(items) do
					if (itemCheck[1] == 115) or (itemCheck[1] == 116) then -- Weapon
						-- itemCheck[2]: [1] = gta weapon id, [2] = serial number/Amount of bullets, [3] = weapon/ammo name
						local itemCheckExplode = exports["global"]:explode(":", itemCheck[2])
						local weapon = tonumber(itemCheckExplode[1])
						local ammountOfAmmo
						if (weapon >= 16 and weapon <= 40) or (weapon == 29 or weapon == 30 or weapon == 32 or weapon ==31 or weapon == 34)  and factiontype ~= 2 or (weapon >= 35 and weapon <= 38)  then -- (weapon == 4 or weapon == 8)
							--exports['items']:takeItemFromSlot(olen, itemSlot - correction)
							correction = correction + 1
							
							if (itemCheck[1] == 115) then
								exports["logs"]:dbLog(olen, 34, olen, "lost a weapon (" ..  itemCheck[2] .. ")")
							else
								exports["logs"]:dbLog(olen, 34, olen, "lost a magazine of ammo (" ..  itemCheck[2] .. ")")
								local splitArray = split(itemCheck[2], ":")
								ammountOfAmmo = splitArray[2]
							end
						end
					end
				end	
			
				local int= 10 
				local dim= 180 
				local x,y,z= 1583.2712402344, 1800.6055908203, 2083.376953125
				local skin = getElementModel(olen)
				local team = getPlayerTeam(olen)
				local fat = getPedStat(olen, 21)
				local muscle = getPedStat(olen, 23) 
				
				setCameraInterior(olen, int)
				setCameraTarget(olen, olen)

				spawnPlayer(olen, x, y, z, 0, skin, int, dim, team)	
				setPedStat(olen, 21, fat)
				setPedStat(olen, 23, muscle)

				setCameraTarget(olen, olen)
				fadeCamera(olen, true, 6)
				triggerClientEvent(olen, "fadeCameraOnSpawn", olen)
				triggerEvent("updateLocalGuns", olen)
				triggerEvent("social-system:makecuffanim", olen)
				--triggerClientEvent("Emekleme:Emeklet",olen,"Kaldır")
				triggerClientEvent(olen,"es-system:closeCountdownLabel",olen)
				triggerClientEvent(olen, "onClientGettingBW", olen)
				outputChatBox("#1a00ff[!] #dedede "..getPlayerName(saldiran).." isimli kişi tarafından öldürüldünüz.",olen,255,0,0,true)
				local sikanlar = fromJSON(getElementData(saldiran,"Sikanlar") or toJSON({}))
				local dbid = tostring(getElementData(olen,"dbid"))
				setElementData(olen,"Sikanlar",toJSON({}))
				sikanlar[dbid] = nil
				setElementData(saldiran,"Sikanlar",toJSON(sikanlar))
				
			end
		end
	end,1000,1,source,mermi,saldiran,silah)
end)


local silahlar = {
	[22] = true,
	[23] = true, -- Handguns
	[24] = true,
	
	[25] = true,
	[26] = true, -- Shotguns
	[27] = true,
	
	[28] = true,
	[29] = true, -- Sub-Machine Guns
	[32] = true,
	
	[30] = true,
	[31] = true, -- Assault Rifles and Rifles
	[33] = true,
	[34] = true,
}

function isPlayerKinli(oyuncu,saldiran,silah)
	if not isElement(saldiran) then return end if saldiran == source then return  false end
	if getElementType(saldiran) ~= "player" then return false end
	if not silahlar[silah] then return false end
	
	local sikanlar = fromJSON(getElementData(oyuncu,"Sikanlar") or toJSON({}))
	local dbid = tostring(getElementData(saldiran,"dbid"))
	local sikanlar2 = fromJSON(getElementData(saldiran,"Sikanlar") or toJSON({}))
	local dbid2 = tostring(getElementData(oyuncu,"dbid"))
	local durum = false
	if sikanlar[dbid] and sikanlar2[dbid2] then
		durum = true
	end	
	return durum
end


function recoveryPlayer(thePlayer, commandName, targetPlayer, duration)
	if not (targetPlayer) or not (duration) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Hours]", thePlayer, 255, 194, 14)
	else
		local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			local logged = getElementData(thePlayer, "loggedin")
	
			if (logged==1) then
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				
				if (factionType==2) or (exports["integration"]:isPlayerTrialAdmin(thePlayer) == true) then
					local dimension = getElementDimension(thePlayer)
					totaltime = tonumber(duration)
					if totaltime < 12 then
						local money = exports["bank"]:takeBankMoney(targetPlayer, 100*totaltime)
						if not money then
							outputChatBox("Bu kişinin banka hesabında tedavi sürecini ödeyebilecek kadar parası yok!", thePlayer, 255, 0, 0)
							return 
						end
						exports["global"]:giveMoney( getTeamFromName("Los Santos Medical Departmanı"), 100*totaltime )
						local dbid = getElementData(targetPlayer, "dbid")
						dbExec(mysql:getConnection(), "UPDATE characters SET recovery='1' WHERE id = " .. dbid)
						setElementFrozen(targetPlayer, true)
						--outputChatBox("You have successfully put " .. targetPlayerName .. " in recovery for " .. duration .. " hour(s) and charged $".. 100*totaltime ..".", thePlayer, 255, 0, 0)
						exports["infobox"]:addBox(thePlayer, "success", "Başarıyla "..targetPlayerName.." isimli oyuncuyu tedavi altına aldın!")
						--outputChatBox("You were put in recovery by " .. getPlayerName(thePlayer) .. " for " .. duration .. " hour(s) and charged $".. 100*totaltime ..".", targetPlayer, 255, 0, 0)
						exports["infobox"]:addBox(targetPlayer, "info", getPlayerName(thePlayer).." tarafından tedavi altın alındınız...")
						local r = getRealTime()
						if r.hour + duration >= 24 then
							local timeString = ("%04d%02d%02d%02d%02d%02d"):format(r.year+1900, r.month + 1, r.monthday + 1, r.hour + duration - 24,r.minute, r.second)
							dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime='" ..timeString.. "' WHERE id = " .. dbid)
						else
							local timeString = ("%04d%02d%02d%02d%02d%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour + duration,r.minute, r.second)
							dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime='" ..timeString.. "' WHERE id = " .. dbid) 
						end
					else
						outputChatBox("Birini bu kadar uzun süre tedavi edemezsin.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Temel tıp beceriniz yok, Fakülte ile iletişime geçin.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Kişi giriş yapmamış.", thePlayer, 255,0,0)
			end
		end
	end
end
addCommandHandler("recovery", recoveryPlayer)

function scanForRecoveryRelease(player, eventname)
	local tick = getTickCount()
	local counter = 0
	local players = exports["pool"]:getPoolElementsByType("player")
	for key, value in ipairs(players) do 
		local logged = getElementData(value, "loggedin")
		if (logged==1) then -- Check all logged in players.
			local dbid = getElementData(value, "dbid")

			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local mm = tonumber(row["recovery"])
							if (mm==1) then
							dbQuery(
							function(qh)
								local res1, rows1, err1 = dbPoll(qh, 0)
								if rows1 > 0 then
									for index, row2 in ipairs(res1) do
										local nn = tonumber(row2["recoverytime"])
										local currenttime = getRealTime()
										local currenttimereal = ("%04d%02d%02d%02d%02d%02d"):format(currenttime.year+1900, currenttime.month + 1, currenttime.monthday, currenttime.hour,currenttime.minute, currenttime.second)
										local bb = tonumber(currenttimereal)
										if (nn<bb) then -- Is the time up? If yes:
											setElementFrozen(value, false)
											dbExec(mysql:getConnection(), "UPDATE characters SET recovery='0' WHERE id = " .. dbid) -- Allow them to move, and revert back to recovery type set to 0.
											dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime=NULL WHERE id = " .. dbid)
											outputChatBox("İyileşmen tamamlandı geçmiş olsun!.", value, 0, 255, 0) -- Let them know about it!
										else
											setElementFrozen(value, true) -- If they are still in recovery, then make sure they are frozen (if they login).
											if (player==value) and (eventname=="account:characters:spawn") then
												outputChatBox("Hala iyileşmektesin!", value, 255,0,0)
											end
										end
									end
								end
							end, mysql:getConnection(), "SELECT `recoverytime` FROM `characters` WHERE `id`=" .. (dbid) .. "")
						end
					end
				end
			end, mysql:getConnection(), "SELECT `recovery` FROM `characters` WHERE `id`=" .. (dbid) .. "")
		end
	end
	local tickend = getTickCount()
end
setTimer(scanForRecoveryRelease, 300000, 0) -- Check every 5 minutes.

function scanForRecoveryReleaseF10(player, eventname)
	local tick = getTickCount()
	local counter = 0
	local players = exports["pool"]:getPoolElementsByType("player")
	for key, value in ipairs(players) do 
		local logged = getElementData(value, "loggedin")
		if (logged==1) then -- Check all logged in players.
			local dbid = getElementData(value, "dbid")

			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							local mm = tonumber(row["recovery"])
							if (mm==1) then
							dbQuery(
							function(qh)
								local res1, rows1, err1 = dbPoll(qh, 0)
								if rows1 > 0 then
									for index, row2 in ipairs(res1) do
										local nn = tonumber(row2["recoverytime"])
										local currenttime = getRealTime()
										local currenttimereal = ("%04d%02d%02d%02d%02d%02d"):format(currenttime.year+1900, currenttime.month + 1, currenttime.monthday, currenttime.hour,currenttime.minute, currenttime.second)
										local bb = tonumber(currenttimereal)
										if (nn<bb) then -- Is the time up? If yes:
											setElementFrozen(value, false)
											dbExec(mysql:getConnection(), "UPDATE characters SET recovery='0' WHERE id = " .. dbid) -- Allow them to move, and revert back to recovery type set to 0.
											dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime=NULL WHERE id = " .. dbid)
											--outputChatBox("İyileşmen tamamlandı geçmiş olsun!.", value, 0, 255, 0) -- Let them know about it!
											exports["infobox"]:addBox(value, "info", "Tedavi sürecin tamamlandı.")
										else
											setElementFrozen(value, true) -- If they are still in recovery, then make sure they are frozen (if they login).
											if (player==value) and (eventname=="account:characters:spawn") then
												exports["infobox"]:addBox(value, "info", "Tedavi sürecin devam etmekte.")
											end
										end
									end
								end
							end, mysql:getConnection(), "SELECT `recoverytime` FROM `characters` WHERE `id`=" .. (dbid) .. "")
						end
					end
				end
			end, mysql:getConnection(), "SELECT `recovery` FROM `characters` WHERE `id`=" .. (dbid) )
		end
	end
	local tickend = getTickCount()
end
addEventHandler("account:characters:spawn", getRootElement(), scanForRecoveryReleaseF10)

function prescribe(thePlayer, commandName, ...)
    local team = getPlayerTeam(thePlayer)
	if (getTeamName(team)=="Los Santos Medical Departmanı") then
		if not (...) then
			outputChatBox("SYNTAX /" .. commandName .. " [İlaç İsmi]", thePlayer, 255, 184, 22)
		else
			local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue
			if not(itemValue=="") then
				exports["global"]:giveItem( thePlayer, 132, itemValue )

				exports["infobox"]:addBox(thePlayer, "success", itemValue.." isimli ilacı başarıyla oluşturdunuz!")
			end
		end
	end
end
addCommandHandler("ilacyaz", prescribe)

-- /revive
function revivePlayerFromPK(thePlayer, commandName, targetPlayer)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) or (exports["integration"]:isPlayerSupporter(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if getElementData(targetPlayer, "dead") == 1 then
					triggerClientEvent(targetPlayer,"es-system:closeRespawnButton",targetPlayer)
					triggerClientEvent(targetPlayer,"es-system:closeCountdownLabel",targetPlayer)
					triggerClientEvent(targetPlayer, "onClientGettingBW", targetPlayer)
					--fadeCamera(thePlayer, true)
					--outputChatBox("Respawning...", thePlayer)
					if isTimer(changeDeathViewTimer) == true then
						killTimer(changeDeathViewTimer)
					end
					
					local x,y,z = getElementPosition(targetPlayer)
					local int = getElementInterior(targetPlayer)
					local dim = getElementDimension(targetPlayer)
					local skin = getElementModel(targetPlayer)
					local team = getPlayerTeam(targetPlayer)
					
					setPedHeadless(targetPlayer, false)
					setCameraInterior(targetPlayer, int)
					setCameraTarget(targetPlayer, targetPlayer)
					setElementData(targetPlayer, "dead", 0)	
					if getElementData(targetPlayer, "hunger") <= 0 then
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "hunger", 5)
					end
					if getElementData(targetPlayer, "thirst") <= 0 then
						exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "thirst", 5)
					end
					triggerEvent("kaydet:aclikvesusuzluk", targetPlayer, targetPlayer)
					local id = getElementData(targetPlayer, "dbid") -- account:character:id
					if id then
						local preparedQuery = "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' "
						--exports["mysql"]:query_free(preparedQuery)
						dbExec(mysql:getConnection(), preparedQuery)
					end
					spawnPlayer(targetPlayer, x, y, z, 0)--, team)
					setCameraTarget(targetPlayer, targetPlayer)
					setElementModel(targetPlayer,skin)
					setPlayerTeam(targetPlayer, team)
					setElementInterior(targetPlayer, int)
					setElementDimension(targetPlayer, dim)
					triggerEvent("updateLocalGuns", targetPlayer)
					triggerEvent("social-system:makecuffanim", targetPlayer)
					local adminTitle = tostring(exports["global"]:getPlayerAdminTitle(thePlayer))
					outputChatBox("You have been revived by "..tostring(exports["global"]:getPlayerAdminTitle(thePlayer)).." "..tostring(getPlayerName(thePlayer):gsub("_"," "))..".", targetPlayer, 0, 255, 0)
					outputChatBox("You have revived "..tostring(getPlayerName(targetPlayer):gsub("_"," "))..".", thePlayer, 0, 255, 0)
					-- exports["global"]:sendMessageToAdmins("AdmCmd: "..tostring(exports["global"]:getPlayerAdminTitle(thePlayer)).." "..getPlayerName(thePlayer).." revived "..tostring(getPlayerName(targetPlayer))..".")
					-- exports["logs"]:dbLog(thePlayer, 4, targetPlayer, "REVIVED from PK")
					--triggerClientEvent("Emekleme:Emeklet",targetPlayer,"Kaldır")
				else
					outputChatBox(tostring(getPlayerName(targetPlayer):gsub("_"," ")).." is not dead.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("revive", revivePlayerFromPK, false, false)

function stabilizePlayer(thePlayer)
	if (isElement(thePlayer)) then
		
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports["global"]:sendMessageToAdmins("AC0x0000004: "..getPlayerName(thePlayer):gsub("_", " ").." died while not in character, triggering blackfade.")
			return
		end
		
		setPedHeadless(thePlayer, false)	
			
		dbExec(mysql:getConnection(), "UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. mysql:escape_string(getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)

		setCameraTarget(thePlayer, thePlayer)

		--local death = getElementData(thePlayer, "lastdeath")
		--if removedWeapons ~= nil then
		--	logMe(death)
		--	exports["global"]:sendMessageToAdmins("/showkills to view lost weapons.")
		--	logMeNoWrn("#FF0033 Lost Weapons: " .. removedWeapons)
	--	else
		--	logMe(death)
	--	end
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)

		setElementData(thePlayer, "dead", 0)
		if getElementData(source, "hunger") <= 0 then
			exports["anticheat"]:changeProtectedElementDataEx(source, "hunger", 5)
		end
		if getElementData(source, "thirst") <= 0 then
			exports["anticheat"]:changeProtectedElementDataEx(source, "thirst", 5)
		end
		triggerEvent("kaydet:aclikvesusuzluk", source, source)
		local id = getElementData(thePlayer, "dbid") -- account:character:id
		if id then
			dbExec(mysql:getConnection(), "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' ")
		end
		 
		--spawnPlayer(thePlayer, 1176.892578125, -1323.828125, 14.04377746582, 275)--, theTeam)
		local x,y,z = getElementPosition(thePlayer)
		local int = getElementInterior(thePlayer)
		local dim = getElementDimension(thePlayer)
		local skin = getElementModel(thePlayer)
		local team = getPlayerTeam(thePlayer)

		spawnPlayer(thePlayer, x, y, z, 0, skin, int, dim, team)

		setCameraInterior(thePlayer, int)
		setCameraTarget(thePlayer, thePlayer)
		--setElementModel(thePlayer,theSkin)
		--setPlayerTeam(thePlayer, theTeam)
		--setElementInterior(thePlayer, 0)
		--setElementDimension(thePlayer, 0)
				
		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)

		fadeCamera(thePlayer, true, 6)
		
		--triggerClientEvent("Emekleme:Emeklet",thePlayer,"Kaldır")
		
		triggerClientEvent(thePlayer,"es-system:closeRespawnButton",thePlayer)
		triggerClientEvent(thePlayer,"es-system:closeCountdownLabel",thePlayer)
		triggerClientEvent(thePlayer, "onClientGettingBW", thePlayer)
		triggerClientEvent(thePlayer, "fadeCameraOnSpawn", thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
		triggerEvent("social-system:makecuffanim", thePlayer)
	end
end
addEvent("es-system:makeStabilize", true)
addEventHandler("es-system:makeStabilize", root, stabilizePlayer)
