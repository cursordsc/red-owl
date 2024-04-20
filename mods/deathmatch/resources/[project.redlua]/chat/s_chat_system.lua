mysql = exports["mysql"]

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

local gpn = getPlayerName
function getPlayerName(p)
	local name = gpn(p) or getElementData(p, "name")
	if name then
		return string.gsub(name, "_", " ")
	else
		return string.gsub(p, "_", " ")
	end
end


function KarBilgi(thePlayer, cmd)
		outputChatBox("[!] #999999Kar yağışını kapatmak için [CTRL+S] yapınız.",thePlayer,255,255,255,true)
		outputChatBox("[!] #999999Etraftaki kar texturesini kaldırmak için [/karefekti] yazınız.",thePlayer,255,255,255,true)
end
addCommandHandler("kar",KarBilgi)

addCommandHandler("cevre", 
function(oyuncu, cmd, ...)
	if exports["integration"]:isPlayerAdminII(oyuncu) then
		if not (...) then
			oyuncu:outputChat("SÖZDİZİMİ: /" .. cmd .. " [Mesaj]")
			return
		end

		local mesaj = table.concat({ ... }, " ")
		for k, v in ipairs(getElementsByType("player")) do
			v:outputChat("#FFFFFF[#99FF00ÇEVRE#ffffff] : " .. mesaj .. " " , 196, 255, 255, true)
		end
	end
end)

addCommandHandler("soyun",
function(oyuncu)
	local saat = oyuncu:getData("hoursplayed")
	local cinsiyet = oyuncu:getData("gender") or 0

	if saat >= 10 then
		if tonumber(cinsiyet) == 0 then 
			oyuncu:setModel(154)
		elseif tonumber(cinsiyet) == 1 then
			oyuncu:setModel(138)
		end
		exports["global"]:sendLocalMeAction(oyuncu, "kıyafetlerini çıkartmıştır.")
	    exports["global"]:sendLocalDoAction(oyuncu, "Tamamen çıplak olduğu görülebilir.")
	else
		oyuncu:outputChat("[!]#ffffff Karakteri 10 oynama saatini geçmeyenler soyunamaz.", 255, 0, 0, true)
	end
end)



function yaralanmalar(attacker, weapon, bodypart, loss)
	
	if (weapon == 22 or weapon == 23 or weapon == 24 or weapon == 25 or weapon == 26 or weapon == 27 or weapon == 28 or weapon == 29 or weapon == 30 or weapon == 31 or weapon == 32 or weapon == 33 or weapon == 34) then
		if bodypart == 3 then
			if bodypart == 3 and getPedArmor(source) > 0 then
				outputChatBox("#ea0000[!] #e4e4e4Çelik yeleğinden vuruldun!", source, 255, 0, 0, true)
				cancelEvent()
				return
			else
				sendActionToNearbyPlayers(source, " * ".. getPlayerName(source):gsub("_", " ") .." göğüsüne mermi yedi.")
				setElementHealth(source,getElementHealth(source)-15)
				return
			end
		elseif bodypart == 4 then
			sendActionToNearbyPlayers(source, " * ".. getPlayerName(source):gsub("_", " ") .." kalça kısmına mermi yedi.")
			setElementHealth(source,getElementHealth(source)-7)
			return
		elseif bodypart == 5 then
			sendActionToNearbyPlayers(source, " * ".. getPlayerName(source):gsub("_", " ") .." sol kolundan mermi yedi.")
			setElementHealth(source,getElementHealth(source)-7)
			return
		elseif bodypart == 6 then
			sendActionToNearbyPlayers(source, " * ".. getPlayerName(source):gsub("_", " ") .." sağ kolundan mermi yedi.")
			setElementHealth(source,getElementHealth(source)-7)
			return
		elseif bodypart == 7 then
			sendActionToNearbyPlayers(source, " * ".. getPlayerName(source):gsub("_", " ") .." sol bacağından mermi yedi.")
			toggleControl( source, "sprint", false )
			toggleControl( source, "jump", false )
			setElementHealth(source,getElementHealth(source)-7)
			return
		elseif bodypart == 8 then
			sendActionToNearbyPlayers(source, " * ".. getPlayerName(source):gsub("_", " ") .." sağ bacağından mermi yedi.")
			toggleControl( source, "sprint", false )	
			toggleControl( source, "jump", false )			
			setElementHealth(source,getElementHealth(source)-7)
			return
		end
	end
	
	if weapon == 53 then
		return
	end
	

	if not bodypart and getPedOccupiedVehicle(source) then
		bodypart = 3
	end

	if bodypart == 9 then 
		 
		local x1, y1, z1 = getElementPosition(source)
		local x2, y2, z2 = getElementPosition(attacker)
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." kafasından mermi yedi.")
		
		if  (getDistanceBetweenPoints3D( x1, y1, z1, x2, y2, z2) < 6) then
			killPed(source, attacker, weapon, bodypart)
			return
		else

			chances = math.random(1, 7)
			if (chances == 1) then
				killPed(source, attacker, weapon, bodypart)
				return
			end	
		end
	end
end

addEventHandler( "onPlayerDamage", getRootElement(), yaralanmalar )

function sendActionToNearbyPlayers( thePlayer, action )
	local action = tostring(action)
	
	for i, nearbyPlayer in ipairs ( getElementsByType("player") ) do
		local px, py, pz = getElementPosition(nearbyPlayer)
		local x, y, z = getElementPosition(thePlayer)
		if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 20) then
			outputChatBox(action, nearbyPlayer, 208, 159, 213)
		end
	end
end

function trunklateText(thePlayer, text, factor)
	return (tostring(text):gsub("^%l", string.upper))
end

function getElementDistance( a, b )
	if not isElement(a) or not isElement(b) or getElementDimension(a) ~= getElementDimension(b) then
		return math.huge
	else
		local x, y, z = getElementPosition( a )
		return getDistanceBetweenPoints3D( x, y, z, getElementPosition( b ) )
	end
end

function icChatsToVoice(audience, msg, from) --Maxime
	if getElementData(audience, "text2speech_ic_chats") ~= "0" then 
	end
end
--accent --
local accent = {}
local accents = {
	"Karadeniz Şivesi",
	"Akdeniz Şivesi",
	"Ege Şivesi",
}
addCommandHandler ("şiveayarla", 
	function (player, cmd, ac)
		if ac and tonumber (ac) and accents[tonumber (ac)] then 
			local ac = tonumber (ac) 
			accent[player] = ac
			outputChatBox ("[!]#ffffffŞiveniz başarıyla ayarlanmıştır. Şive kullanmayı kapatmak için /şivekapat yazabilirsiniz.", player, 0, 255, 0, true)
		else	
			outputChatBox ("[!]#ffffffŞive tanımlanamadı, yardım için /şive komutunu giriniz.", player, 0, 255, 0, true)
		end
	end
)	

addCommandHandler ("şive", 
	function (player)
		outputChatBox ("[!]#ffffffŞive Listesi:", player, 0, 0, 255, true)
		for i, v in ipairs (accents) do 
			outputChatBox ("#FFFFCC"..i.." - "..v, player, 255, 255, 255, true)
		end
	end
)

addCommandHandler ("şivekapat", 
	function (player)
		accent[player] = nil
	end
)	

-- Main chat: Local IC, Me Actions & Faction IC Radio
function localIC(source, message, language, element)
	if exports['freecam-tv']:isPlayerFreecamEnabled(source) then return end
	local affectedElements = { }
	table.insert(affectedElements, source)
	local x, y, z = getElementPosition(source)
	local playerName = getPlayerName(source)
	local ac = accents[tonumber (accent[source])] and "["..accents[tonumber (accent[source])].."] " or ""

	message = string.gsub(message, "#%x%x%x%x%x%x", "") -- Remove colour codes
	local languagename = call(getResourceFromName("languages"), "getLanguageName", language)
	message = trunklateText( source, message )

	local color = {0xEE,0xEE,0xEE}

	local focus = getElementData(source, "focus")
	local focusColor = false
	if type(focus) == "table" then
		for player, color2 in pairs(focus) do
			if player == source then
				color = color2
			end
		end
	end
	

	-- Smiling Emotes by Almas | 8 Temmuz Çarşamba - 2015
	if message == ":)" then
		exports["global"]:sendLocalMeAction(source, "gülümser.")
		return
	elseif message == ":D" then
		exports["global"]:sendLocalMeAction(source, "kahkaha atar.")
		return
	elseif message == ";)" then
		exports["global"]:sendLocalMeAction(source, "göz kırpar.")
		return
	elseif message == "O.o" then
		exports["global"]:sendLocalMeAction(source, "sol kaşını havaya kaldırır.")
		return
	elseif message == "O.O" then
		exports["global"]:sendLocalMeAction(source, "sağ kaşını havaya kaldırır.")
		return
	elseif message == "X.x" then
		exports["global"]:sendLocalMeAction(source, "gözlerini kapatır.")
		return
	end
	-- End of Smiling Emotes
	
	local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")
	
	local playerVehicle = getPedOccupiedVehicle(source)
	if playerVehicle then
		if (exports['vehicle']:isVehicleWindowUp(playerVehicle)) then
			table.insert(affectedElements, playerVehicle)
			outputChatBox( " ["..realTime.."] " .. playerName .. " ((Araçta)) diyor ki : " ..ac.. message, source, unpack(color))
		else
			outputChatBox("  ["..realTime.."] " .. playerName .. " diyor ki : " .. ac.. message, source, unpack(color))
		end
		icChatsToVoice(source, message, source)
	else
		--setPedAnimation(source, "GANGS", "prtial_gngtlkA", 1, false, true, true)
		if getElementData(source, "talk_anim") == "1" then
			exports["global"]:applyAnimation(source, "GANGS", "prtial_gngtlkA", 1, false, true, false)
		end
		outputChatBox( " ["..realTime.."] " .. playerName .. " diyor ki : " ..ac.. message, source, unpack(color))
		icChatsToVoice(source, message, source)
	end

	local dimension = getElementDimension(source)
	local interior = getElementInterior(source)

	if dimension ~= 0 then
		table.insert(affectedElements, "in"..tostring(dimension))
	end

	-- Chat Commands tooltip
	if(getResourceFromName("tooltips-system"))then
		triggerClientEvent(source,"tooltips:showHelp", source,17)
	end

	for key, nearbyPlayer in ipairs(getElementsByType( "player" )) do
		local dist = getElementDistance( source, nearbyPlayer )

		if dist < 20 then
			local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
			local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

			if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
				local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
				if not (isPedDead(nearbyPlayer)) and (logged==1) and (nearbyPlayer~=source) then
					local message2 = call(getResourceFromName("languages"), "applyLanguage", source, nearbyPlayer, message, language)
					message2 = trunklateText( nearbyPlayer, message2 )

					local pveh = getPedOccupiedVehicle(source)
					local nbpveh = getPedOccupiedVehicle(nearbyPlayer)
					local color = {0xEE,0xEE,0xEE}

					local focus = getElementData(nearbyPlayer, "focus")
					local focusColor = false
					if type(focus) == "table" then
						for player, color2 in pairs(focus) do
							if player == source then
								focusColor = true
								color = color2
							end
						end
					end

					if pveh then
						if (exports['vehicle']:isVehicleWindowUp(pveh)) then
							for i = 0, getVehicleMaxPassengers(pveh) do
								local lp = getVehicleOccupant(pveh, i)

								if (lp) and (lp~=source) then
									outputChatBox(" ["..realTime.."] " .. playerName .. " ((araç)): ".. ac .. message2, lp, unpack(color))
									table.insert(affectedElements, lp)
									icChatsToVoice(lp, message2, source)
								end
							end
							table.insert(affectedElements, pveh)
							exports["logs"]:dbLog(source, 7, affectedElements, languagename..": INCAR ".. message)
							exports['freecam-tv']:add(affectedElements)
							return
						end
					end

					if nbpveh and exports['vehicle']:isVehicleWindowUp(nbpveh) == true then
						--[[if not focusColor then
							if dist < 3 then
							elseif dist < 6 then
								color = {0xDD,0xDD,0xDD}
							elseif dist < 9 then
								color = {0xCC,0xCC,0xCC}
							elseif dist < 12 then
								color = {0xBB,0xBB,0xBB}
							else
								color = {0xAA,0xAA,0xAA}
							end
						end
						-- for players in vehicle
						outputChatBox(" ["..realTime.."] " .. playerName .. " says: " .. message2, nearbyPlayer, unpack(color))]]
						--table.insert(affectedElements, nearbyPlayer)
					else
						if not focusColor then
							if dist < 4 then
							elseif dist < 8 then
								color = {0xDD,0xDD,0xDD}
							elseif dist < 12 then
								color = {0xCC,0xCC,0xCC}
							elseif dist < 16 then
								color = {0xBB,0xBB,0xBB}
							else
								color = {0xAA,0xAA,0xAA}
							end
						end
						outputChatBox(" ["..realTime.."] " .. playerName .. " : " .. ac .. message2, nearbyPlayer, unpack(color))
						table.insert(affectedElements, nearbyPlayer)
						icChatsToVoice(nearbyPlayer, message2, source)
					end
				end
			end
		end
	end
	exports["logs"]:dbLog(source, 7, affectedElements, languagename..": ".. message)
	exports['freecam-tv']:add(affectedElements)
end

for i = 1, 3 do
	addCommandHandler( tostring( i ),
		function( thePlayer, commandName, ... )
			local lang = tonumber( getElementData( thePlayer, "languages.lang" .. i ) )
			if lang ~= 0 then
				localIC( thePlayer, table.concat({...}, " "), lang )
			end
		end
	)
end

function meEmote(source, cmd, ...)
	local logged = getElementData(source, "loggedin")
	if logged == 1 then
		local message = table.concat({...}, " ")
		if not (...) then
			outputChatBox("SYNTAX: /me [Uygulama]", source, 255, 194, 14)
		else
			local result, affectedPlayers = exports["global"]:sendLocalMeAction(source, message, true, true)
			exports["logs"]:dbLog(source, 12, affectedPlayers, message)
			triggerClientEvent(root,"addChatBubblee",source,message,cmd)
			setElementData(source, "onClientSendIC", message)
			setTimer(function()
				setElementData(source, "onClientSendIC", nil)
			end, 5000, 1)
		end
	end
end
addCommandHandler("ME", meEmote, false, true)
addCommandHandler("Me", meEmote, false, true)



function outputChatBoxCar( vehicle, target, text1, text2, color )
	if vehicle and exports['vehicle']:isVehicleWindowUp( vehicle ) then
		if getPedOccupiedVehicle( target ) == vehicle then
			outputChatBox( text1 .. " ((araç))" .. text2, target, unpack(color))
			return true
		else
			return false
		end
	end
	outputChatBox( text1 .. text2, target, unpack(color))
	return true
end

function radio(source, radioID, message)
	local customSound = false
	local affectedElements = { }
	local indirectlyAffectedElements = { }
	table.insert(affectedElements, source)
	radioID = tonumber(radioID) or 1
	local hasRadio, itemKey, itemValue, itemID = exports["global"]:hasItem(source, 6)
	if hasRadio or getElementType(source) == "ped" or radioID == -2 then
		local theChannel = itemValue
		if radioID < 0 then
			theChannel = radioID
		elseif radioID == 1 and exports["integration"]:isPlayerTrialAdmin(source) and tonumber(message) and tonumber(message) >= 1 and tonumber(message) <= 10 then
			return
		elseif radioID ~= 1 then
			local count = 0
			local items = exports['items']:getItems(source)
			for k, v in ipairs(items) do
				if v[1] == 6 then
					count = count + 1
					if count == radioID then
						theChannel = v[2]
						break
					end
				end
			end
		end

		local isRestricted, factionID = isThisFreqRestricted(theChannel)
		local playerFaction = getElementData(source, "faction")
		if theChannel == 1 or theChannel == 0 then
			outputChatBox("[!] radyo kanaılını değiştirmek için lütfen /tuneradio", source, 255, 194, 14)
		elseif isRestricted and tonumber(playerFaction) ~= tonumber(factionID) then
			outputChatBox("You are not allowed to access this channel. Please retune your radio.", source, 255, 194, 14)
		elseif theChannel > 1 or radioID < 0 then
			--triggerClientEvent (source, "playRadioSound", getRootElement())
			local username = getPlayerName(source)
			local languageslot = getElementData(source, "languages.current")
			local language = getElementData(source, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("languages"), "getLanguageName", language)
			local channelName = "#" .. theChannel

			message = trunklateText( source, message )
			local r, g, b = 0, 102, 255
			local focus = getElementData(source, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == source then
						r, g, b = unpack(color)
					end
				end
			end

			if radioID == -1 then
				local teams = {
					getTeamFromName("Los Santos Polis Departmanı"),
					getTeamFromName("Los Santos Medical Departmanı"),
					getTeamFromName("Los Santos Government"),
					getTeamFromName("Los Santos Sheriff Departmanı"),
				}

				for _, faction in ipairs(teams) do
					if faction and isElement(faction) then
						for key, value in ipairs(getPlayersInTeam(faction)) do
							for _, itemRow in ipairs(exports['items']:getItems(value)) do
								----outputDebugString(tostring(itemRow[1]).." - "..tostring(itemRow[2]))
								if tonumber(itemRow[1]) and tonumber(itemRow[2]) and tonumber(itemRow[1]) == 6 and tonumber(itemRow[2]) > 0 then
									table.insert(affectedElements, value)
									break
								end
							end
						end
					end
				end

				channelName = "DEPARTMENT"
			elseif radioID == -2 then
				local a = {}
				for key, value in ipairs(exports["sfia"]:getPlayersInAircraft( )) do
					table.insert(affectedElements, value)
					a[value] = true
				end

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "paraVer" ) ) ) do
					if not a[value] then
						for _, itemRow in ipairs(exports['items']:getItems(value)) do
							if (itemRow[1] == 6 and itemRow[2] > 0) then
								table.insert(affectedElements, value)
								break
							end
						end
					end
				end

				channelName = "AIR"
			elseif radioID == -3 then --PA (speakers) in vehicles and interiors // Exciter
				local outputDim = getElementDimension(source)
				local vehicle
				if isPedInVehicle(source) then
					vehicle = getPedOccupiedVehicle(source)
					outputDim = tonumber(getElementData(vehicle, "dbid")) + 20000
				end
				if(outputDim > 0) then
					local canUsePA = false
					if(outputDim > 20000) then --vehicle interior
						local dbid = outputDim - 20000
						if not vehicle then
							for k,v in ipairs(exports["pool"]:getPoolElementsByType("vehicle")) do
								if getElementData( v, "dbid" ) == dbid then
									vehicle = v
									break
								end
							end
						end
						if vehicle then
							canUsePA = getElementData(source, "adminduty") == 1 or exports["global"]:hasItem(source, 3, tonumber(dbid)) or (getElementData(source, "faction") > 0 and getElementData(source, "faction") == getElementData(vehicle, "faction"))
						end
					else
						canUsePA = getElementData(source, "adminduty") == 1 or exports["global"]:hasItem(source, 4, outputDim) or exports["global"]:hasItem(source, 5,outputDim)
					end
					----outputDebugString("canUsePA="..tostring(canUsePA))
					if not canUsePA then
						return false
					end

					local outputInt = getElementInterior(source)
					for key, value in ipairs(exports["pool"]:getPoolElementsByType("player")) do
						if(getElementDimension(value) == outputDim) then
							if(getElementInterior(value) == outputInt or vehicle) then
								table.insert(affectedElements, value)
							end
						end
					end
					if vehicle then
						for i = 0, getVehicleMaxPassengers( vehicle ) do
							local player = getVehicleOccupant( vehicle, i )
							if player then
								table.insert(affectedElements, player)
							end
						end
					end
					r, g, b = 0,149,255
					channelName = "SPEAKERS"
					customSound = "pa.mp3"
				else
					return false
				end
			elseif radioID == -4 then --PA (speakers) at airports // Exciter
				local x,y,z = getElementPosition(source)
				local zonename = getZoneName(x,y,z,false)
				local outputDim = getElementDimension(source)
				local allowedFactions = {
					47, --FAA
				}
				local allowedAirports = {
					["Easter Bay Airport"]=true,
					["Los Santos International"]=true,
					["Las Venturas Airport"]=true
				}
				allowedAirportDimensions = {
					[1317]=true, --LSA terminal
					[2337]=true, --LSA deaprture hall
					[2340]=true, --LSA terminal 2
				}
				airportDimensionsSF = {}
				airportDimensionsLS = {
					[1317]=true, --terminal
					[2337]=true, --deaprture hall
					[2340]=true, --terminal 2
				}
				airportDimensionsLV = {}
				local airportDimensions = {}
				local targetAirport = zonename
				if(zonename == "Easter Bay Airport" or airportDimensionsSF[outputDim]) then
					airportDimensions = airportDimensionsSF
				elseif(zonename == "Los Santos International" or airportDimensionsLS[outputDim]) then
					airportDimensions = airportDimensionsLS
				elseif(zonename == "Las Venturas Airport" or airportDimensionsLV[outputDim]) then
					airportDimensions = airportDimensionsLV
				end

				local inAllowedFaction = false
				for k,v in ipairs(allowedFactions) do
					if exports["factions"]:isPlayerInFaction(source, v) then
						inAllowedFaction = true
					end
				end

				if(inAllowedFaction) then
					if(allowedAirportDimensions[outputDim] or outputDim == 0 and allowedAirports[zonename]) then
						for key, value in ipairs(getElementsByType("player")) do
							x,y,z = getElementPosition(value)
							zonename = getZoneName(x,y,z,false)
							local dim = getElementDimension(value)
							if(airportDimensions[dim] or dim == 0 and zonename == targetAirport) then
								table.insert(affectedElements, value)
							end
						end
						r, g, b = 0,149,255
						channelName = "AIRPORT SPEAKERS"
						customSound = "pa.mp3"
					else
						return false
					end
				else
					return false
				end
			else
				for key, value in ipairs(getElementsByType( "player" )) do
					if exports["global"]:hasItem(value, 6, theChannel) then
						local isRestricted, factionID = isThisFreqRestricted(theChannel)
						local playerFaction = getElementData(value, "faction")
						if (isRestricted and tonumber(playerFaction) == tonumber(factionID)) or not isRestricted then
							table.insert(affectedElements, value)
						end
					end
				end
			end
				local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")

			if channelName == "DEPARTMENT" then
			outputChatBoxCar(getPedOccupiedVehicle( source ), source, "["..realTime.."] [" .. channelName .. "] " .. username, " diyor ki: " .. message, {r,162,b})
			else
			outputChatBoxCar(getPedOccupiedVehicle( source ), source, "["..realTime.."] [" .. channelName .. "] " .. username, " diyor ki: " .. message, {r,g,b})
			end

			for i = #affectedElements, 1, -1 do
				if getElementData(affectedElements[i], "loggedin") ~= 1 then
					table.remove( affectedElements, i )
				end
			end

			for key, value in ipairs(affectedElements) do
				if customSound then
					triggerClientEvent(value, "playCustomChatSound", getRootElement(), customSound)
				else
					triggerClientEvent (value, "playRadioSound", getRootElement())
				end
				if value ~= source then
					local message2 = call(getResourceFromName("languages"), "applyLanguage", source, value, message, language)
					local r, g, b = 0, 102, 255
					local focus = getElementData(value, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == source then
								r, g, b = unpack(color)
							end
						end
					end
					if channelName == "DEPARTMENT" then
					outputChatBoxCar( getPedOccupiedVehicle( value ), value, "["..realTime.."] [" .. channelName .. "] " .. username, " diyor ki: " .. trunklateText( value, message2 ), {r,162,b} )
					else
					outputChatBoxCar( getPedOccupiedVehicle( value ), value, "["..realTime.."] [" .. channelName .. "] " .. username, " diyor ki: " .. trunklateText( value, message2 ), {r,g,b} )
					end

					--if not exports["global"]:hasItem(value, 88) == false then  ***Earpiece Fix***
					if exports["global"]:hasItem(value, 88) == false then
						-- Show it to people near who can hear his radio
						for k, v in ipairs(exports["global"]:getNearbyElements(value, "player",7)) do
							local logged2 = getElementData(v, "loggedin")
							if (logged2==1) then
								local found = false
								for kx, vx in ipairs(affectedElements) do
									if v == vx then
										found = true
										break
									end
								end

								if not found then
									local message2 = call(getResourceFromName("languages"), "applyLanguage", source, v, message, language)
									local text1 = "["..realTime.."] " .. getPlayerName(value) .. " telsiz konuşması"
									local text2 = ": " .. trunklateText( v, message2 )

									if outputChatBoxCar( getPedOccupiedVehicle( value ), v, text1, text2, {255, 255, 255} ) then
										table.insert(indirectlyAffectedElements, v)
									end
								end
							end
						end
					end
				end
			end
			--
			--Show the radio to nearby listening in people near the speaker
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDistance(source, value) < 10 then
					if (value~=source) then
						local message2 = call(getResourceFromName("languages"), "applyLanguage", source, value, message, language)
						local text1 = "["..realTime.."] " .. getPlayerName(source) .. " [TELSİZ KONUŞMASI]"
						local text2 = " diyor ki: " .. trunklateText( value, message2 )

						if outputChatBoxCar( getPedOccupiedVehicle( source ), value, text1, text2, {255, 255, 255} ) then
							table.insert(indirectlyAffectedElements, value)
						end
					end
				end
			end

			if #indirectlyAffectedElements > 0 then
				table.insert(affectedElements, "Indirectly Affected:")
				for k, v in ipairs(indirectlyAffectedElements) do
					table.insert(affectedElements, v)
				end
			end
			exports["logs"]:dbLog(source, radioID < 0 and 10 or 9, affectedElements, ( radioID < 0 and "" or ( theChannel .. " " ) ) ..languagename.." "..message)
		else
			outputChatBox("[!] Radyonuz kapalı.", source, 255, 0, 0)
		end
	else
		outputChatBox("[!] Radyonuz bulunmamaktadır.", source, 255, 0, 0)
	end
end

function chatMain(message, messageType)
	if exports['freecam-tv']:isPlayerFreecamEnabled(source) then cancelEvent() return end

	local logged = getElementData(source, "loggedin")

	if (messageType == 1 or not (isPedDead(source))) and (logged==1) and not (messageType==2) then -- Player cannot chat while dead or not logged in, unless its OOC
		local dimension = getElementDimension(source)
		local interior = getElementInterior(source)
		if (messageType==0) then
			local languageslot = getElementData(source, "languages.current")
			local language = getElementData(source, "languages.lang" .. languageslot)
			localIC(source, message, language)
			triggerClientEvent(root,"addChatBubble",source,message)
		elseif (messageType==1) then -- Local /me action
			meEmote(source, "me", message)
		end
	elseif (messageType==2) and (logged==1) then -- Radio
		radio(source, 1, message)
	end
end
addEventHandler("onPlayerChat", getRootElement(), chatMain)

function msgRadio(thePlayer, commandName, ...)
	if (...) then
		local message = table.concat({...}, " ")
		radio(thePlayer, 1, message)
	else
		outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("r", msgRadio, false, false)
addCommandHandler("radio", msgRadio, false, false)

for i = 1, 20 do
	addCommandHandler( "r" .. tostring( i ),
		function( thePlayer, commandName, ... )
			if i <= exports['items']:countItems(thePlayer, 6) then
				if (...) then
					radio( thePlayer, i, table.concat({...}, " ") )
				else
					outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
				end
			end
		end
	)
end

function govAnnouncement(thePlayer, commandName, ...)
		local theTeam = getPlayerTeam(thePlayer)

	if (theTeam) then
		local teamID = tonumber(getElementData(theTeam, "id"))

		if (teamID==1 or teamID==2 or teamID==3 or teamID==47 or teamID==59) then
			local message = table.concat({...}, " ")
			
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionBilgi = tostring(getTeamName(theTeam))
			local factionLeader = getElementData(thePlayer,"factionleader")

			if #message == 0 then
				outputChatBox("SYNTAX: /" .. commandName .. " [message]", thePlayer, 255, 194, 14)
				return false
			end

			if factionLeader>0 then
				local ranks = getElementData(theTeam,"ranks")
				local factionRankTitle = ranks[factionRank]

				--exports["logs"]:logMessage("[IC: Government Message] " .. factionRankTitle .. " " .. getPlayerName(thePlayer) .. ": " .. message, 6)
				exports["logs"]:dbLog(source, 16, source, message)
				for key, value in ipairs(exports["pool"]:getPoolElementsByType("player")) do
					local logged = getElementData(value, "loggedin")

					if (logged==1) then
						outputChatBox(">> "..factionBilgi.." - " .. factionRankTitle .. " " .. getPlayerName(thePlayer), value, 0, 183, 239)
						outputChatBox(message, value, 0, 183, 239)
					end
				end
			else
				outputChatBox("You do not have permission to use this command.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gov", govAnnouncement)

--[[function playerToggleDonatorChat(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	local hasPerk, perkValue = exports["donators"]:hasPlayerPerk(thePlayer, 9)
	if (logged==1 and hasPerk) then
		local enabled = getElementData(thePlayer, "donatorchat")
		if (tonumber(perkValue)==1) then
			outputChatBox("You have now hidden Donator Chat.", thePlayer, 255, 194, 14)
			exports["donators"]:updatePerkValue(thePlayer, 9, 0)
		else
			outputChatBox("You have now enabled Donator Chat.", thePlayer, 255, 194, 14)
			exports["donators"]:updatePerkValue(thePlayer, 9, 1)
		end
	end
end
addCommandHandler("toggledonatorchat", playerToggleDonatorChat, false, false)
addCommandHandler("toggledon", playerToggleDonatorChat, false, false)
addCommandHandler("toggledchat", playerToggleDonatorChat, false, false)

function donatorchat(thePlayer, commandName, ...) -- MAXIME
	local hasDonChat, togDonChatState = exports["donators"]:hasPlayerPerk(thePlayer, 10)
	if hasDonChat or exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerScripter(thePlayer) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local logged = tonumber(getElementData(thePlayer, "loggedin"))
			if (logged ~= 1) then
				return
			end

			local affectedElements = { }
			table.insert(affectedElements, thePlayer)
			local message = table.concat({...}, " ")
			local title = ""
			local hidden = getElementData(thePlayer, "hiddenadmin") or 0

			if (tonumber(togDonChatState) == 0) then
				outputChatBox("[Donator] You're sending a message while having your donator chat channel toggled off.", thePlayer, 200, 200, 200)
			end

			for key, value in ipairs(getElementsByType("player")) do
				local hasAccess, isEnabled = exports["donators"]:hasPlayerPerk(value, 10)
				local logged = tonumber(getElementData(value, "loggedin"))
				if (logged == 1) and (hasAccess or exports["integration"]:isPlayerTrialAdmin(value) or exports["integration"]:isPlayerScripter(value) ) then
					if ( tonumber(isEnabled) ~= 0 ) or (value == thePlayer) then
						table.insert(affectedElements, value)
						outputChatBox("[Donator] " .. exports["global"]:getPlayerFullIdentity(thePlayer) .. ": " .. message, value, 160, 164, 104)
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 17, affectedElements, message)
		end
	end
end
addCommandHandler("donator", donatorchat, false, false)
addCommandHandler("don", donatorchat, false, false)
addCommandHandler("dchat", donatorchat, false, false)]]

function departmentradio(thePlayer, commandName, ...)
	local theTeam = getElementType(thePlayer) == "player" and getPlayerTeam(thePlayer)
	local tollped = getElementType(thePlayer) == "ped" and getElementData(thePlayer, "toll:key")
	if (theTeam)  or (tollped) then
		local teamID = nil
		if not tollped then
			teamID = tonumber(getElementData(theTeam, "id"))
		end

		if (teamID==1 or teamID==2 or teamID==3 or teamID==4 or teamID==47 or teamID==50 or teamID==59 or teamID==64 or tollped) then --47=FAA 64=SAPT
			if (...) then
				local message = table.concat({...}, " ")
				radio(thePlayer, -1, message)
			elseif not tollped then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("dep", departmentradio, false, false)
addCommandHandler("department", departmentradio, false, false)

function airradio(thePlayer, commandName, ...)
	local playersInAir = exports["sfia"]:getPlayersInAircraft( )
	if playersInAir then
		local found = false
		if getPlayerTeam( thePlayer ) == getTeamFromName( "paraVer" ) then
			for _, itemRow in ipairs(exports['items']:getItems(thePlayer)) do
				if (itemRow[1] == 6 and itemRow[2] > 0) then
					found = true
					break
				end
			end
		end

		if not found then
			for k, v in ipairs( playersInAir ) do
				if v == thePlayer then
					found = true
					break
				end
			end
		end

		if found then
			if not ... then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
			else
				radio(thePlayer, -2, table.concat({...}, " "))
			end
		else
			outputChatBox("You weren't able to speak over the air frequency.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("air", airradio, false, false)
addCommandHandler("airradio", airradio, false, false)

 --PA (speakers) in vehicles and interiors // Exciter
function ICpublicAnnouncement(thePlayer, commandName, ...)
	if not ... then
		outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
	else
		radio(thePlayer, -3, table.concat({...}, " "))
	end
end
addCommandHandler("pa", ICpublicAnnouncement, false, false)

 --PA (speakers) at airports // Exciter
function ICAirportAnnouncement(thePlayer, commandName, ...)
	if not ... then
		outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
	else
		radio(thePlayer, -4, table.concat({...}, " "))
	end
end
addCommandHandler("airportpa", ICAirportAnnouncement, false, false)

function blockChatMessage()
	cancelEvent()
end
addEventHandler("onPlayerChat", getRootElement(), blockChatMessage)
-- End of Main Chat


function globalOOC(thePlayer, commandName, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))

	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local oocEnabled = exports["global"]:getOOCState()
			message = table.concat({...}, " ")
			local muted = getElementData(thePlayer, "muted")
			if (oocEnabled==0) and not exports["integration"]:isPlayerTrialAdmin(thePlayer) and not exports["integration"]:isPlayerScripter(thePlayer) then
				outputChatBox("OOC Chat is currently disabled.", thePlayer, 255, 0, 0)
			elseif (muted==1) then
				outputChatBox("You are currently muted from the OOC Chat.", thePlayer, 255, 0, 0)
			else
				local affectedElements = { }
				local players = exports["pool"]:getPoolElementsByType("player")
				local playerName = getPlayerName(thePlayer)
				local playerID = getElementData(thePlayer, "playerid")

				--exports["logs"]:logMessage("[OOC: Global Chat] " .. playerName .. ": " .. message, 1)
				for k, arrayPlayer in ipairs(players) do
					local logged = tonumber(getElementData(arrayPlayer, "loggedin"))
					local targetOOCEnabled = getElementData(arrayPlayer, "globalooc")

					if (logged==1) and (targetOOCEnabled==1) then
						table.insert(affectedElements, arrayPlayer)
						if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
                            local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
							if getElementData(thePlayer, "hiddenadmin") then
								outputChatBox("(( "..exports["global"]:getPlayerFullIdentity(thePlayer)..": " .. message .. " ))", arrayPlayer, 196, 255, 255)
							else
								outputChatBox("(( "..exports["global"]:getPlayerFullIdentity(thePlayer)..": " .. message .. " ))", arrayPlayer, 196, 255, 255)
							end
                        else
							outputChatBox("(( "..exports["global"]:getPlayerFullIdentity(thePlayer)..": " .. message .. " ))", arrayPlayer, 196, 255, 255)
                        end
					end
				end
				exports["logs"]:dbLog(thePlayer, 18, affectedElements, message)
			end
		end
	end
end
addCommandHandler("ooc", globalOOC, false, false)
addCommandHandler("GlobalOOC", globalOOC)


function playerToggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		local playerOOCEnabled = getElementData(thePlayer, "globalooc")

		if (playerOOCEnabled==1) then
			outputChatBox("You have now hidden Global OOC Chat.", thePlayer, 255, 194, 14)
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "globalooc", 0, false)
		else
			outputChatBox("You have now enabled Global OOC Chat.", thePlayer, 255, 194, 14)
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "globalooc", 1, false)
		end
		dbExec(mysql:getConnection(),"UPDATE hesaplar SET globalooc=" .. (getElementData(thePlayer, "globalooc")) .. " WHERE id = " .. (getElementData(thePlayer, "account:id")))
	end
end
addCommandHandler("toggleooc", playerToggleOOC, false, false)

local advertisementMessages = { "samp", "SA-MP", "Kye", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "www.", ".com", "co.cc", ".net", ".co.uk", "everlast", "neverlast", "www.everlastgaming.com", "trueliferp", "truelife", "mtarp", "mta:rp", "mta-rp"}

function isFriendOf(thePlayer, targetPlayer)
	return exports['social']:isFriendOf( getElementData( thePlayer, "account:id"), getElementData( targetPlayer, "account:id" ))
end

function scripterChat(thePlayer, commandName, ...)
    local logged = getElementData(thePlayer, "loggedin")

    if(logged==1) and (exports["integration"]:isPlayerScripter(thePlayer))  then
        if not (...) then
            outputChatBox("SYNTAX: /ss [Message]", thePlayer, 255, 194, 14)
        else
            local message = table.concat({...}, " ")
            local players = exports["pool"]:getPoolElementsByType("player")
            local username = getElementData(thePlayer,"account:username")

            for k, arrayPlayer in ipairs(players) do
                local logged = getElementData(arrayPlayer, "loggedin")

                if(exports["integration"]:isPlayerScripter(arrayPlayer)) and (logged==1) then
                    outputChatBox("[Scripter] ("..getElementData(thePlayer, "playerid")..") " .. username .. " : " .. message, arrayPlayer, 222, 222, 31)
                end
            end
        end
    end
end
addCommandHandler("ss", scripterChat, false, false)
addCommandHandler("sc", scripterChat, false, false)
addCommandHandler("u", scripterChat, false, false)

function vctChat(thePlayer, commandName, ...)
    local logged = getElementData(thePlayer, "loggedin")

    if(logged==1) and (exports["integration"]:isPlayerVCTMember(thePlayer))  then
        if not (...) then
            outputChatBox("SYNTAX: /v [Message]", thePlayer, 255, 194, 14)
        else
            local message = table.concat({...}, " ")
            local players = exports["pool"]:getPoolElementsByType("player")
            local username = getElementData(thePlayer,"account:username")

            for k, arrayPlayer in ipairs(players) do
                local logged = getElementData(arrayPlayer, "loggedin")

                if exports["integration"]:isPlayerVCTMember(arrayPlayer) and (logged==1) then
                    outputChatBox("[VCT] ("..getElementData(thePlayer, "playerid")..") "..(exports["integration"]:isPlayerVehicleConsultant(thePlayer) and "Leader" or "Member" ).." " .. username .. " : " .. message, arrayPlayer, 222, 222, 31)
                end
            end
        end
    end
end
addCommandHandler("v", vctChat, false, false)
addCommandHandler("vct", vctChat, false, false)

function mappingTeamChat(thePlayer, commandName, ...)
    local logged = getElementData(thePlayer, "loggedin")

    if(logged==1) and (exports["integration"]:isPlayerMappingTeamMember(thePlayer))  then
        if not (...) then
            outputChatBox("SYNTAX: /v [Message]", thePlayer, 255, 194, 14)
        else
            local message = table.concat({...}, " ")
            local players = exports["pool"]:getPoolElementsByType("player")
            local username = getElementData(thePlayer,"account:username")

            for k, arrayPlayer in ipairs(players) do
                local logged = getElementData(arrayPlayer, "loggedin")

                if exports["integration"]:isPlayerMappingTeamMember(arrayPlayer) and (logged==1) then
                    outputChatBox("[MT] ("..getElementData(thePlayer, "playerid")..") "..(exports["integration"]:isPlayerMappingTeamLeader(thePlayer) and "Leader" or "Member" ).." " .. username .. " : " .. message, arrayPlayer, 222, 222, 31)
                end
            end
        end
    end
end
addCommandHandler("mt", mappingTeamChat, false, false)


ignoreList = {}
function ignoreOnePlayer(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		if not (targetPlayerNick) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Kişinin ismi / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayerNick)
			if exports["integration"]:isPlayerTrialAdmin(targetPlayer) then
				outputChatBox("[!] Adminleri engelliyemezsiniz!", thePlayer, 255, 0, 0)
				return
			end

			local existed = false
			for k, v in ipairs(ignoreList) do
				if v[2] == targetPlayer then
					table.remove(ignoreList, k)
					outputChatBox("[!] Kişiden gelen PM'leri artık görmezden gelmektesiniz." .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
					existed = true
					break
				end
			end
			if not existed then
				table.insert(ignoreList, {thePlayer, targetPlayer})
				outputChatBox("[!] Fısıltıları görmezden geliyorsun" .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
				outputChatBox("[!] Engellediğiniz oyuncuların listesi için. /engelliler", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("engelle", ignoreOnePlayer)

function checkifiamfucked(thePlayer, commandName)
	outputChatBox(" ~~~~~~~~~ Engelliler Listesi ~~~~~~~~~ ", thePlayer, 237, 172, 19)
	outputChatBox("    --  --", thePlayer, 2, 172, 19)
	for k, v in ipairs(ignoreList) do
		if v[1] == thePlayer then
			outputChatBox(getPlayerName(v[2]):gsub("_"," "), thePlayer, 255, 255, 255)
		end
	end
	outputChatBox(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ", thePlayer, 237, 172, 19)
end
addCommandHandler("engelliler", checkifiamfucked)

addEventHandler('onPlayerQuit', root,
	function()
		ignoreList[source] = nil
		for k, v in pairs(ignoreList) do
			for kx, vx in ipairs(v) do
				if vx == source then
					table.remove(vx, kx)
					break
				end
			end
		end
	end)

-- QUICK PM REPLY + PM SOUND FX / MAXIME
function pmPlayer(thePlayer, commandName, who, ...)
	local message = nil
	if tostring(commandName):lower() == "quickreply" and who then
		local target = getElementData(thePlayer, "targetPMer")
		if not target or not isElement(target) or not (getElementType(target) == "player") or not (getElementData(target, "loggedin") == 1) then
			outputChatBox("No one is PM'ing you.", thePlayer, 200,200,200)
			return false
		end
		message = who.." "..table.concat({...}, " ")
		who = target
	else
		if not (who) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick] [Message]", thePlayer, 255, 194, 14)
			outputChatBox("Press 'U' to quickly reply PMs.", thePlayer)
			return false
		end
		message = table.concat({...}, " ")
	end



	if who and message then

		local loggedIn = getElementData(thePlayer, "loggedin")
		if (loggedIn==0) then
			return
		end

		local targetPlayer, targetPlayerName
		if (isElement(who)) then
			if (getElementType(who)=="player") then
				targetPlayer = who
				targetPlayerName = getPlayerName(who)
				message = string.gsub(message, string.gsub(targetPlayerName, " ", "_", 1) .. " ", "", 1)
			end
		else
			targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, who)
		end

		if (targetPlayer) then
			if getElementData(targetPlayer, "loggedin") ~= 1 then
				outputChatBox("Player is not logged in yet.", thePlayer, 255, 255, 0)
				return false
			end

			local senderPmState = getElementData(thePlayer, "vip:pm")
			local targetPmState = getElementData(targetPlayer, "vip:pm")

			if tonumber(targetPmState) == 1 then -- if target has pms off.
				if not exports["global"]:isStaffOnDuty(thePlayer) and not (getElementData(thePlayer, "reportadmin") == targetPlayer) and not call(getResourceFromName("social"), "isFriendOf", getElementData(thePlayer, 'account:id'), getElementData(targetPlayer, 'account:id')) then
					outputChatBox("İletişim Kurmaya Çalıştığınız Kişi Rolde / Afk.", thePlayer, 255, 255, 0)
					return false
				end
			end

			-- check if ignored
			for k, v in ipairs(ignoreList) do
				if v[2] == targetPlayer and v[1] == thePlayer then
					outputChatBox('You are currently ignoring ' .. targetPlayerName .. '. Remove him from your ignore list to PM.', thePlayer, 255, 0, 0)
					return false
				end
			end
			for k, v in ipairs(ignoreList) do
				if v[1] == thePlayer and v[2] == thePlayer then
					outputChatBox(targetPlayerName .. ' ignoring private messages from you.', thePlayer, 255, 0, 0)
					return false
				end
			end

			setElementData(targetPlayer, "targetPMer", thePlayer, false)

			local playerName = getPlayerName(thePlayer):gsub("_", " ")
			local targetUsername1, username1 = getElementData(targetPlayer, "account:username"), getElementData(thePlayer, "account:username")

			local targetUsername = " ("..targetUsername1..")"
			local username = " ("..username1..")"

			if not exports["integration"]:isPlayerTrialAdmin(targetPlayer) and not exports["integration"]:isPlayerScripter(targetPlayer) then
				username = ""
			end

			if not exports["integration"]:isPlayerTrialAdmin(thePlayer) and not exports["integration"]:isPlayerScripter(thePlayer) then
				targetUsername = ""
			end

			if not exports["integration"]:isPlayerSeniorAdmin(thePlayer) and not exports["integration"]:isPlayerSeniorAdmin(targetPlayer) then
				-- Check for advertisements
				for k,v in ipairs(advertisementMessages) do
					local found = string.find(string.lower(message), "%s" .. tostring(v))
					local found2 = string.find(string.lower(message), tostring(v) .. "%s")
					if (found) or (found2) or (string.lower(message)==tostring(v)) then
						exports["global"]:sendMessageToAdmins("AdmWrn: " .. tostring(playerName) .. " sent a possible advertisement PM to " .. tostring(targetPlayerName) .. ".")
						exports["global"]:sendMessageToAdmins("AdmWrn: Message: " .. tostring(message))
						break
					end
				end
			end

			-- Send the message
			local playerid = getElementData(thePlayer, "playerid")
			local targetid = getElementData(targetPlayer, "playerid")
			outputChatBox("#e8e8e8Gelen PM: #d4d400(" .. playerid .. ") " .. playerName ..username..": " .. message, targetPlayer, 234, 234, 0, true)
			outputChatBox("#e8e8e8Gönderilen PM: #e9e900(" .. targetid .. ") " .. targetPlayerName ..targetUsername.. ": " .. message, thePlayer, 234, 234, 0, true)

			triggerClientEvent(targetPlayer,"pmSoundFX",targetPlayer)
			triggerClientEvent(thePlayer,"pmSoundFX",thePlayer)

			exports["logs"]:dbLog(thePlayer, 15, { thePlayer, targetPlayer }, message)

			local received = {}
			received[thePlayer] = true
			received[targetPlayer] = true
			for key, value in pairs( getElementsByType( "player" ) ) do
				if isElement( value ) and not received[value] then
					local listening = getElementData( value, "bigears" )
					if listening == thePlayer or listening == targetPlayer then
						received[value] = true
						outputChatBox("(" .. playerid .. ") " .. playerName .. " -> (" .. targetid .. ") " .. targetPlayerName .. ": " .. message, value, 255, 255, 0)
						triggerClientEvent(value,"pmSoundFX",value)
					end
				end
			end

			if tonumber(senderPmState) == 1 and not (getElementData(targetPlayer, "reportadmin") == thePlayer) then -- if sender has pms off.
				outputChatBox("You're sending out private messages while ignoring incoming messages.", thePlayer, 200, 200, 200)
			end
		end
	end
end
addCommandHandler("pm", pmPlayer, false, false)
addCommandHandler("quickreply", pmPlayer, false, false)

addCommandHandler("oocdurum", function(oyuncu, komut, buyukluk)
	buyukluk = tonumber(buyukluk)

	if oyuncu:getData("loggedin") == 1 then
		if exports["integration"]:isPlayerTrialAdmin(oyuncu) and oyuncu:getData("duty_admin") == 1 then
			if not oyuncu:getData("oocalan:olusturma") and buyukluk then
				if buyukluk >= 26 then
					return
				end

				local konum = oyuncu:getPosition()
				local x, y, z = konum:getX(), konum:getY(), konum:getZ()

				local alan = createColSphere(x,y,z,buyukluk)
				alan:setData("oocalan", true)
				alan:setData("oocalan:yetkili", oyuncu)
				attachElements(alan, oyuncu, 0, 0, 5)

				oyuncu:setData("oocalan:olusturma", true)
				oyuncu:setData("oocalan", true)
				oyuncu:setData("oocalan:data", alan)
				exports["infobox"]:addBox(oyuncu, "info", "Başarıyla OOC konuşma alanını oluşturdun!")
			else
				if not buyukluk and not oyuncu:getData("oocalan:olusturma") then
					return
				end
				data = oyuncu:getData("oocalan:data")
				destroyElement(data)
				oyuncu:setData("oocalan:olusturma", false)
				oyuncu:setData("oocalan:data", nil)
				oyuncu:setData("oocalan", false)
				exports["infobox"]:addBox(oyuncu, "info", "Başarıyla OOC konuşma alanını kaldırdın!")
			end
		end
	end
end)

addCommandHandler("alan", function(oyuncu, komut)
	oyuncu:setData("oocalan", false)
end)
function oocAlanGiris ( oyuncu, dimension )
	if getElementData ( source, "oocalan" ) then
		local alanyetkili = getElementData (source, "oocalan:yetkili" )
		exports["infobox"]:addBox(oyuncu, "info", alanyetkili:getName().." isimli yetkilinin OOC konuşma alanına girdin.")
		oyuncu:setData("oocalan", true)
	end
end
addEventHandler ( "onColShapeHit", getRootElement(), oocAlanGiris)

function oocAlanCikis ( oyuncu, dimension )
	if getElementData ( source, "oocalan" ) then
		local alanyetkili = getElementData (source, "oocalan:yetkili" )
		exports["infobox"]:addBox(oyuncu, "info", alanyetkili:getName().." isimli yetkilinin OOC konuşma alanından çıktın.")
		oyuncu:setData("oocalan", false)
	end
end
addEventHandler ( "onColShapeLeave", getRootElement(), oocAlanCikis )

function localOOC(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
	--local alan = getElementData(thePlayer, "oocalan")

	if (logged==1) and not (isPedDead(thePlayer)) then

		--[[if not alan then
			exports["infobox"]:addBox(thePlayer, "info", "OOC Konuşma alanında değilsiniz!")
			return
		end]]

		local muted = getElementData(thePlayer, "muted")
		if not (...) then
			outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		elseif (muted==1) then
			outputChatBox("You are muted from Global OOC.", thePlayer, 255, 0, 0)
		else
			--MAXIME
			local r,b,g = 196, 255, 255

			if exports["integration"]:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and not getElementData(thePlayer, "supervising") then
				r,b,g = 255, 194, 14
				setElementData(thePlayer, "supervisorBchat", false)
			elseif exports["integration"]:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and getElementData(thePlayer, "supervising") then
				r,b,g = 100, 149, 237
				setElementData(thePlayer, "supervisorBchat", true)
			elseif exports["integration"]:isPlayerSupporter(thePlayer) and getElementData(thePlayer, "supervising") then
				r,b,g = 100, 149, 237
				setElementData(thePlayer, "supervisorBchat", true)
			elseif exports["integration"]:isPlayerSupporter(thePlayer)and getElementData(thePlayer, "duty_supporter") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and not getElementData(thePlayer, "supervising") then
				r,b,g = 72,244,14
				setElementData(thePlayer, "supervisorBchat", false)
			end

			local message = table.concat({...}, " ")
			if getElementData(thePlayer, "supervisorBchat") == false or nil then -- The below locals were contained in the if, else statements. Therefore returned nil to the export db //Chaos
				result, affectedElements = exports["global"]:sendLocalText(thePlayer, ((getElementData(thePlayer, "duty_admin") == 1) and exports["global"]:getPlayerFullIdentity(thePlayer) or getPlayerName(thePlayer)) .. ": (( " .. message .. " ))", r,b,g)
			elseif getElementData(thePlayer,"supervisorBchat") == false or nil then
				result, affectedElements = exports["global"]:sendLocalText(thePlayer, ((getElementData(thePlayer, "duty_supporter") == 1) and exports["global"]:getPlayerFullIdentity(thePlayer) or getPlayerName(thePlayer)) .. ": (( " .. message .. " ))", r,b,g)
			else
				result, affectedElements = exports["global"]:sendLocalText(thePlayer, exports["global"]:getPlayerFullIdentity(thePlayer) .. ": (( " .. message .. " ))", r,b,g)
			end
			exports["logs"]:dbLog(thePlayer, 8, affectedElements, message)
		end
	end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC)

function districtIC(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if (logged==1) and not (isPedDead(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local playerName = getPlayerName(thePlayer)
			local message = table.concat({...}, " ")
			local zonename = exports["global"]:getElementZoneName(thePlayer)
			local x, y = getElementPosition(thePlayer)

			for key, value in ipairs(exports["pool"]:getPoolElementsByType("player")) do
				local playerzone = exports["global"]:getElementZoneName(value)
				local playerdimension = getElementDimension(value)
				local playerinterior = getElementInterior(value)

				if (zonename==playerzone) and (dimension==playerdimension) and (interior==playerinterior) and getDistanceBetweenPoints2D(x, y, getElementPosition(value)) < 200 then
					local logged = getElementData(value, "loggedin")
					if (logged==1) then
						table.insert(affectedElements, value)
						if exports["integration"]:isPlayerTrialAdmin(value) then
							outputChatBox("Çevre IC: " .. message .. " ((".. playerName .."))", value, 255, 255, 255)
						else
							outputChatBox("Çevre IC: " .. message, value, 255, 255, 255)
						end
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 13, affectedElements, message)
		end
	end
end
addCommandHandler("district", districtIC, false, false)

function localDo(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if logged==1 then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Uygulama / Duygu ]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			--exports["logs"]:logMessage("[IC: Local Do] * " .. message .. " *      ((" .. getPlayerName(thePlayer) .. "))", 19)
			local result, affectedElements = exports["global"]:sendLocalDoAction(thePlayer, message, true)
			exports["logs"]:dbLog(thePlayer, 14, affectedElements, message)
			triggerClientEvent(root,"addChatBubblee",thePlayer,message,commandName)
		end
	end
end
addCommandHandler("do", localDo, false, false)


function localShout(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	local affectedElements = { }
	table.insert(affectedElements, thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if not (isPedDead(thePlayer)) and (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
		
			local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")
			local playerName = getPlayerName(thePlayer)

			local languageslot = getElementData(thePlayer, "languages.current")
			local language = getElementData(thePlayer, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("languages"), "getLanguageName", language)

			local message = trunklateText(thePlayer, table.concat({...}, " "))
			local r, g, b = 255, 255, 255
			local focus = getElementData(thePlayer, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == thePlayer then
						r, g, b = unpack(color)
					end
				end
			end
			outputChatBox("["..realTime.."] " .. playerName .. " bağırarak : " .. message .. "!", thePlayer, r, g, b)
			--exports["global"]:applyAnimation(thePlayer, "ON_LOOKERS","shout_01", 8000, false, true, false)			
			icChatsToVoice(thePlayer, message, thePlayer)
			--exports["logs"]:logMessage("[IC: Local Shout] " .. playerName .. ": " .. message, 1)
			-- triggerClientEvent(root,"addChatBubble",source,message)
			for index, nearbyPlayer in ipairs(getElementsByType("player")) do
				if getElementDistance( thePlayer, nearbyPlayer ) < 40 then
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

					if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) and (nearbyPlayer~=thePlayer) then
						local logged = getElementData(nearbyPlayer, "loggedin")

						if (logged==1) and not (isPedDead(nearbyPlayer)) then
							table.insert(affectedElements, nearbyPlayer)
							local message2 = call(getResourceFromName("languages"), "applyLanguage", thePlayer, nearbyPlayer, message, language)
							message2 = trunklateText(nearbyPlayer, message2)
							local r, g, b = 255, 255, 255
							local focus = getElementData(nearbyPlayer, "focus")
							if type(focus) == "table" then
								for player, color in pairs(focus) do
									if player == thePlayer then
										r, g, b = unpack(color)
									end
								end
							end
							outputChatBox("["..realTime.."] " .. playerName .. " ((Bağırma)) : " .. message2 .. "!", nearbyPlayer, r, g, b)
							icChatsToVoice(nearbyPlayer, message2, thePlayer)
							-- triggerClientEvent(root,"addChatBubble",source,message)
						end
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 19, affectedElements, languagename.." "..message)
		end
	end
end
addCommandHandler("s", localShout, false, false)

function megaphoneShout(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	local seat = getPedOccupiedVehicleSeat(thePlayer)

	if not (isPedDead(thePlayer)) and (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local factiontype = getElementData(faction, "type")

		if (factiontype==2) or (factiontype==3) or (factiontype==4) or (exports["global"]:hasItem(thePlayer, 141)) or ( isElement(vehicle) and exports["global"]:hasItem(vehicle, 141) and (seat==1 or seat==0)) then
			local affectedElements = { }

			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
			else
				local playerName = getPlayerName(thePlayer)
				local message = trunklateText(thePlayer, table.concat({...}, " "))

				local languageslot = getElementData(thePlayer, "languages.current")
				local language = getElementData(thePlayer, "languages.lang" .. languageslot)
				local langname = call(getResourceFromName("languages"), "getLanguageName", language)

				for index, nearbyPlayer in ipairs(getElementsByType("player")) do
					if getElementDistance( thePlayer, nearbyPlayer ) < 40 then
						local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
						local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

						if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
							local logged = getElementData(nearbyPlayer, "loggedin")

							if (logged==1) and not (isPedDead(nearbyPlayer)) then
								local message2 = message
								if nearbyPlayer ~= thePlayer then
									message2 = call(getResourceFromName("languages"), "applyLanguage", thePlayer, nearbyPlayer, message, language)
								end
								table.insert(affectedElements, nearbyPlayer)
								outputChatBox(" [" .. langname .. "] ((" .. playerName .. ")) Megaphone <O: " .. trunklateText(nearbyPlayer, message2), nearbyPlayer, 255, 255, 0)
								icChatsToVoice(nearbyPlayer, message2, thePlayer)
							end
						end
					end
				end
				exports["logs"]:dbLog(thePlayer, 20, affectedElements, langname.." "..message)
			end
		else
			outputChatBox("Believe it or not, it's hard to shout through a megaphone you do not have.", thePlayer, 255, 0 , 0)
		end
	end
end
addCommandHandler("m", megaphoneShout, false, false)

local togState = { }
function toggleFaction(thePlayer, commandName, State)
	local pF = getElementData(thePlayer, "faction")
	local fL = getElementData(thePlayer, "factionleader")
	local theTeam = getPlayerTeam(thePlayer)

	if fL == 1 then
		if togState[pF] == false or not togState[pF] then
			togState[pF] = true
			outputChatBox("Faction chat is now disabled.", thePlayer)
			for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
				if isElement( arrayPlayer ) then
					if getPlayerTeam( arrayPlayer ) == theTeam and getElementData(thePlayer, "loggedin") == 1 then
						outputChatBox("OOC Faction Chat Disabled", arrayPlayer, 255, 0, 0)
					end
				end
			end
		else
			togState[pF] = false
			outputChatBox("Faction chat is now enabled.", thePlayer)
			for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
				if isElement( arrayPlayer ) then
					if getPlayerTeam( arrayPlayer ) == theTeam and getElementData(thePlayer, "loggedin") == 1 then
						outputChatBox("OOC Faction Chat Enabled", arrayPlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("togglef", toggleFaction)
addCommandHandler("togf", toggleFaction)

function toggleFactionSelf(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) then
		local factionBlocked = getElementData(thePlayer, "chat-system:blockF")

		if (factionBlocked==1) then
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "chat-system:blockF", 0, false)
			outputChatBox("Faction chat is now enabled for yourself.", thePlayer, 0, 255, 0)
		else
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "chat-system:blockF", 1, false)
			outputChatBox("Faction chat is now disabled for yourself.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togglefactionchat", toggleFactionSelf)
addCommandHandler("togglefaction", toggleFactionSelf)
addCommandHandler("togfaction", toggleFactionSelf)

function factionOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local factionRank = tonumber(getElementData(thePlayer,"factionrank"))

	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else

			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			local playerName = getPlayerName(thePlayer)
			local playerFaction = getElementData(thePlayer, "faction")
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]


			if not(theTeam) or (theTeamName=="Citizen") then
				outputChatBox("You are not in a faction.", thePlayer)
			else
				local affectedElements = { }
				table.insert(affectedElements, theTeam)
				local message = table.concat({...}, " ")

				if (togState[playerFaction]) == true then
					return
				end

				for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
					if isElement( arrayPlayer ) then
						if getElementData( arrayPlayer, "bigearsfaction" ) == theTeam then
							outputChatBox("((" .. theTeamName .. ")) " .. playerName .. ": " .. message, arrayPlayer, 3, 157, 157)
						elseif getPlayerTeam( arrayPlayer ) == theTeam and getElementData(arrayPlayer, "loggedin") == 1 and getElementData(arrayPlayer, "chat-system:blockF") ~= 1 then
							table.insert(affectedElements, arrayPlayer)
							outputChatBox("#FF4E0EBirlik: [" .. factionRankTitle .. "] - " .. playerName .. ": " .. message, arrayPlayer, 3, 237, 237, true)
						end
					end
				end
				exports["logs"]:dbLog(thePlayer, 11, affectedElements, message)
			end
		end
	end
end
addCommandHandler("f", factionOOC, false, false)

--HQ CHAT FOR PD / MAXIME
function sfpdHq(thePlayer, commandName, ...)
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")

	if (factionType == 2) then
		local message = table.concat({...}, " ")
		local factionID = tonumber(getElementData(thePlayer, "faction"))

		if not exports["factions"]:isPlayerFactionLeader(thePlayer, factionID) then
			outputChatBox("You do not have permission to use this command.", thePlayer, 255, 0, 0)
		elseif #message == 0 then
			outputChatBox("SYNTAX: /"..commandName.." [message]", thePlayer, 255, 194, 14)
		else

			local teamPlayers = getPlayersInTeam(theTeam)
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local username = getPlayerName(thePlayer)

				for key, value in ipairs(teamPlayers) do
				triggerClientEvent (value, "playHQSound", getRootElement())
				outputChatBox("MERKEZ: ".. message .."", value, 0, 197, 205)
			end
		end
	end
end
addCommandHandler("hq", sfpdHq)
addCommandHandler("merkez", sfpdHq)

function factionLeaderOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			local playerName = getPlayerName(thePlayer)
			local playerLeader = getElementData(thePlayer, "factionleader")


			if not(theTeam) or (theTeamName=="Citizen") then
				outputChatBox("Bir birlikte değilsiniz.", thePlayer, 255, 0, 0)
			elseif tonumber(playerLeader) ~= 1 then
				outputChatBox("Bir birlik lideri değilsiniz.", thePlayer, 255, 0, 0)
			else
				local affectedElements = { }
				table.insert(affectedElements, theTeam)
				local message = table.concat({...}, " ")

				if (togState[playerFaction]) == true then
					return
				end
				--exports["logs"]:logMessage("[OOC: " .. theTeamName .. "] " .. playerName .. ": " .. message, 6)

				for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
					if isElement( arrayPlayer ) then
						if getElementData( arrayPlayer, "bigearsfaction" ) == theTeam then
							outputChatBox("((" .. theTeamName .. " Leader )) " .. playerName .. ": " .. message, arrayPlayer, 3, 157, 157)
						elseif getPlayerTeam( arrayPlayer ) == theTeam and getElementData(arrayPlayer, "loggedin") == 1 and getElementData(arrayPlayer, "chat-system:blockF") ~= 1 and getElementData(arrayPlayer, "factionleader") == 1 then
							table.insert(affectedElements, arrayPlayer)
							outputChatBox("((Birlik Lideri)) " .. playerName .. ": " .. message, arrayPlayer, 3, 180, 200)
						end
					end
				end
				exports["logs"]:dbLog(thePlayer, 11, affectedElements, "Leader: " .. message)
			end
		end
	end
end
addCommandHandler("fl", factionLeaderOOC, false, false)

local goocTogState = false
function togGovOOC(thePlayer, theCommand)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) then
		if (goocTogState == false) then
			outputChatBox("Government OOC has now been disabled.", thePlayer, 0, 255, 0)
			goocTogState = true
		elseif (goocTogState == true) then
			outputChatBox("Goverment OOC has been enabled.", thePlayer, 0, 255, 0)
			goocTogState = false
		else
			outputChatBox("[TG-G-C-ERR-545] Please report on mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("toggovooc", togGovOOC)
addCommandHandler("toggooc", togGovOOC)

function togGovOOCSelf(thePlayer, theCommand)
	local logged = getElementData(thePlayer, "loggedin")
	local team = getPlayerTeam(thePlayer)
	if (getTeamName(team) == "Los Santos Fire & Medical Department") or (getTeamName(team) == "Los Santos Police Department") or (getTeamName(team) == "Government of Los Santos") or (getTeamName(team) == "San Andreas Highway Patrol") or (getTeamName(team) == "Superior Court of San Andreas") or (getTeamName(team) == "paraVer") and (logged==1) then
		local selfState = getElementData(thePlayer, "chat.togGovOOCSelf") or false
		if (selfState == false) then
			outputChatBox("Government OOC has now been disabled for yourself. Use "..tostring(theCommand).." to re-enable.", thePlayer, 0, 255, 0)
			setElementData(thePlayer, "chat.togGovOOCSelf", true)
		elseif (selfState == true) then
			outputChatBox("Goverment OOC has been enabled for yourself.", thePlayer, 0, 255, 0)
			setElementData(thePlayer, "chat.togGovOOCSelf", false)
		else
			outputChatBox("[TG-G-C-ERR-546] Please report on mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("toggov", togGovOOCSelf)

-- /govooc
function govooc(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local team = getPlayerTeam(thePlayer)

	if (getTeamName(team) == "Los Santos Fire & Medical Department") or (getTeamName(team) == "Los Santos Police Department") or (getTeamName(team) == "Government of Los Santos") or (getTeamName(team) == "San Andreas Highway Patrol") or (getTeamName(team) == "Superior Court of San Andreas") or (getTeamName(team) == "paraVer") and (logged==1) then
		local selfState = getElementData(thePlayer, "chat.togGovOOCSelf") or false
		if selfState then
			outputChatBox("You have previously toggled government OOC chat off for yourself. Use /toggov to re-enable.", thePlayer, 255, 0, 0)
			return
		end
		if not (...) then
			outputChatBox("SYNTAX: /gooc [message]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports["pool"]:getPoolElementsByType("player")
			local username = getPlayerName(thePlayer)

			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				local team = getPlayerTeam(arrayPlayer)

			if goocTogState == true then
				outputChatBox("This chat is currently disabled.", thePlayer, 255, 0, 0)
				return
			end

				if team then
					if (getTeamName(team) == "Los Santos Fire & Medical Department") or (getTeamName(team) == "Los Santos Police Department") or (getTeamName(team) == "Government of Los Santos") or (getTeamName(team) == "San Andreas Highway Patrol") or (getTeamName(team) == "Superior Court of San Andreas") or (getTeamName(team) == "paraVer") and (logged==1) then
						local selfTog = getElementData(arrayPlayer, "chat.togGovOOCSelf") or false
						if not selfTog then
							table.insert(affectedElements, arrayPlayer)
							outputChatBox("[Government OOC] " .. username .. ": " .. message.."", arrayPlayer, 216, 191, 216)
						end
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 11, affectedElements, "GOV OOC: " .. message)
		end
	end
end
addCommandHandler("gooc", govooc)

function setRadioChannel(thePlayer, commandName, slot, channel)
	slot = tonumber( slot )
	channel = tonumber( channel )

	if not channel then
		channel = slot
		slot = 1
	end

	if not (channel) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Radio Slot] [Channel Number]", thePlayer, 255, 194, 14)
	else
		if (exports["global"]:hasItem(thePlayer, 6)) then
			local count = 0
			local items = exports['items']:getItems(thePlayer)
			for k, v in ipairs( items ) do
				if v[1] == 6 then
					count = count + 1
					if count == slot then
						if v[2] > 0 then
							local isRestricted, factionID = isThisFreqRestricted(channel)
							local playerFaction = getElementData(thePlayer, "faction")

							if channel > 1 and channel < 1000000000 and (not isRestricted or (tonumber(playerFaction) == tonumber(factionID) ) )then
								if exports['items']:updateItemValue(thePlayer, k, channel) then
									outputChatBox("You retuned your radio to channel #" .. channel .. ".", thePlayer)
									triggerEvent('sendAme', thePlayer, "retunes their radio.")
									setElementData(thePlayer, "radiofrequency", channel)
								end
							else
								outputChatBox("You can't tune your radio to that frequency!", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("Your radio is off. ((/toggleradio))", thePlayer, 255, 0, 0)
						end
						return
					end
				end
			end
			outputChatBox("You do not have that many radios.", thePlayer, 255, 0, 0)
		else
			outputChatBox("You do not have a radio!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("tuneradio", setRadioChannel, false, false)

function toggleRadio(thePlayer, commandName, slot)
	if (exports["global"]:hasItem(thePlayer, 6)) then
		local slot = tonumber( slot )
		local items = exports['items']:getItems(thePlayer)
		local titemValue = false
		local count = 0
		for k, v in ipairs( items ) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						titemValue = v[2]
						break
					end
				else
					titemValue = v[2]
					break
				end
			end
		end

		-- gender switch for /me
		local genderm = getElementData(thePlayer, "gender") == 1 and "her" or "his"

		if titemValue < 0 then
			outputChatBox("You turned your radio on.", thePlayer, 255, 194, 14)
			triggerEvent('sendAme', thePlayer, "turns " .. genderm .. " radio on.")
		else
			outputChatBox("You turned your radio off.", thePlayer, 255, 194, 14)
			triggerEvent('sendAme', thePlayer, "turns " .. genderm .. " radio off.")
		end

		local count = 0
		for k, v in ipairs( items ) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						exports['items']:updateItemValue(thePlayer, k, ( titemValue < 0 and 1 or -1 ) * math.abs( v[2] or 1))
						break
					end
				else
					exports['items']:updateItemValue(thePlayer, k, ( titemValue < 0 and 1 or -1 ) * math.abs( v[2] or 1))
				end
			end
		end
	else
		outputChatBox("You do not have a radio!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("toggleradio", toggleRadio, false, false)

-- Admin chat
function yetkiliChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports["integration"]:isPlayerTrialAdmin(thePlayer)  or exports["integration"]:isPlayerSupporter(thePlayer))  then
		if not (...) then
			outputChatBox("SÖZDİZİMİ: /".. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			if getElementData(thePlayer, "hidea") then
				setElementData(thePlayer, "hidea", false)
				outputChatBox("Admin Kanalı GÖSTERİLİYOR.",thePlayer)
			end
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports["pool"]:getPoolElementsByType("player")
			local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local accountName = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				if logged==1 and (exports["integration"]:isPlayerTrialAdmin(arrayPlayer) or exports["integration"]:isPlayerSupporter(arrayPlayer)) then
					local hidea = getElementData(arrayPlayer, "hidea")
					if hidea then
						local string = string.lower(message)
						local account = string.lower(getElementData(arrayPlayer, "account:username"))
						if string.find(string, account) then
							table.insert(affectedElements, arrayPlayer)
							triggerClientEvent ( "playNudgeSound", arrayPlayer)
							outputChatBox("Admin sohbet kanalında isminiz geçti. - "..accountName..": "..message, arrayPlayer)
						end
					else
						table.insert(affectedElements, arrayPlayer)
						outputChatBox("[YETKİLİ] ("..playerid..") "..adminTitle .. " " .. accountName..": " .. message, arrayPlayer,  250, 150, 10)
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 24, affectedElements, message)
		end
	end
end
addCommandHandler("a", yetkiliChat, false, false)

function udyChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports["integration"]:isPlayerAdminIII(thePlayer)) then
		if not (...) then
			outputChatBox("SÖZDİZİMİ: /".. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			if getElementData(thePlayer, "hideg") then
				setElementData(thePlayer, "hideg", false)
				--outputChatBox("Gamemaster Chat - SHOWING",thePlayer)
			end
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports["pool"]:getPoolElementsByType("player")
			local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local accountName = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				if logged==1 and (exports["integration"]:isPlayerAdminIII(arrayPlayer)) then
					local hideg = getElementData(arrayPlayer, "hideg")
					if hideg then
						local string = string.lower(message)
						local account = string.lower(getElementData(arrayPlayer, "account:username"))
						if string.find(string, account) then
							table.insert(affectedElements, arrayPlayer)
							--triggerClientEvent ( "playNudgeSound", arrayPlayer)
							--outputChatBox("Mentionned in /g chat - "..accountName..": "..message, arrayPlayer)
						end
					else
						table.insert(affectedElements, arrayPlayer)
				--triggerClientEvent ( "playNudgeSound", arrayPlayer)
						outputChatBox("[ÜDY] ("..playerid..") "..adminTitle .. " " .. accountName..": " .. message, arrayPlayer,  204, 102, 255)
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 24, affectedElements, message)
		end
	end
end
addCommandHandler("uat", udyChat, false, false)
addCommandHandler("arge", udyChat, false, false)

-- Misc
local function sortTable( a, b )
	if b[2] < a[2] then
		return true
	end

	if b[2] == a[2] and b[4] > a[4] then
		return true
	end

	return false
end

--[[
function showGMs(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) then
		local players = exports["global"]:getGameMasters()
		local counter = 0

		admins = {}
		outputChatBox("GAMEMASTERS:", thePlayer, 255, 255, 255)
		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")

			if logged == 1 then
				if exports["integration"]:isPlayerSupporter(arrayPlayer) then
					admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "account:gmlevel" ), getElementData( arrayPlayer, "duty_supporter" ), getPlayerName( arrayPlayer ) }
				end
			end
		end

		table.sort( admins, sortTable )

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = exports["global"]:getPlayerGMTitle(arrayPlayer)

			--if exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerScripter(thePlayer) then
				v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"
			--end

			if(v[3] == true)then
				outputChatBox("-    " .. tostring(adminTitle) .. " " .. v[4].." - On Duty", thePlayer, 0, 200, 10)
			else
				outputChatBox("-    " .. tostring(adminTitle) .. " " .. v[4].." - Off Duty", thePlayer, 100, 100, 100)
			end
		end

		if #admins == 0 then
			outputChatBox("-    Currently no game masters online.", thePlayer)
		end
		outputChatBox("Use /admins to see a list of administrators.", thePlayer)
	end
end
addCommandHandler("gms", showGMs, false, false)
]]

-- Admin chat
function geyikChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports["integration"]:isPlayerTrialAdmin(thePlayer)  or exports["integration"]:isPlayerSupporter(thePlayer))  then
		if not (...) then
			outputChatBox("SÖZDİZİMİ: /".. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			if getElementData(thePlayer, "hidegeyik") then
				setElementData(thePlayer, "hidegeyik", false)
				outputChatBox("Geyik Kanalı GÖSTERİLİYOR.",thePlayer)
			end
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports["pool"]:getPoolElementsByType("player")
			local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local accountName = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				if logged==1 and (exports["integration"]:isPlayerTrialAdmin(arrayPlayer) or exports["integration"]:isPlayerSupporter(arrayPlayer)) then
					local hideg = getElementData(arrayPlayer, "hidegeyik")
					if hideg then
						local string = string.lower(message)
						local account = string.lower(getElementData(arrayPlayer, "account:username"))
						if string.find(string, account) then
							table.insert(affectedElements, arrayPlayer)
							triggerClientEvent ( "playNudgeSound", arrayPlayer)
							outputChatBox("Geyik sohbet kanalında isminiz geçti. - "..accountName..": "..message, arrayPlayer)
						end
					else
						table.insert(affectedElements, arrayPlayer)
						outputChatBox("[GEYIK] ("..playerid..") "..adminTitle .. " " .. accountName..": " .. message, arrayPlayer,  255, 100, 150)
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 24, affectedElements, message)
		end
	end
end
addCommandHandler("geyik", geyikChat, false, false)
addCommandHandler("gey", geyikChat, false, false)
addCommandHandler("g", geyikChat, false, false)

function toggleGeyikChat(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	if logged==1 and (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer)) then
		local hideg = getElementData(thePlayer, "hidea") or false
		setElementData(thePlayer, "hidea", not hideg)
		outputChatBox("Admin kanalının mesajlarını "..(hideg and "açtınız." or "kapattınız.").." tekrar açıp kapatmak için [/toga] yazınız.",thePlayer)
	end
end
addCommandHandler("toga", toggleGeyikChat, false, false)
addCommandHandler("togglea", toggleGeyikChat, false, false)

function toggleGeyikChat(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	if logged==1 and (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer)) then
		local hideg = getElementData(thePlayer, "hidegeyik") or false
		setElementData(thePlayer, "hidegeyik", not hideg)
		outputChatBox("Geyik kanalının mesajlarını "..(hideg and "açtınız." or "kapattınız.").." tekrar açıp kapatmak için [/togg] yazınız.",thePlayer)
	end
end
addCommandHandler("togg", toggleGeyikChat, false, false)
addCommandHandler("toggleg", toggleGeyikChat, false, false)


function toggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports["integration"]:isPlayerTrialAdmin(thePlayer)) then
		local players = exports["pool"]:getPoolElementsByType("player")
		local oocEnabled = exports["global"]:getOOCState()
		if (commandName == "togooc") then
			if (oocEnabled==0) then
				exports["global"]:setOOCState(1)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")

					if	(logged==1) then
						outputChatBox("OOC Chat, Admin Tarafından Açıldı..", arrayPlayer, 0, 255, 0)
					end
				end
			elseif (oocEnabled==1) then
				exports["global"]:setOOCState(0)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")

					if	(logged==1) then
						outputChatBox("OOC Chat, Admin Tarafından Kapatıldı.", arrayPlayer, 255, 0, 0)
					end
				end
			end
		elseif (commandName == "stogooc") then
			if (oocEnabled==0) then
				exports["global"]:setOOCState(1)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					local admin = getElementData(arrayPlayer, "admin_level")

					if	(logged==1) and (tonumber(admin)>0)then
						outputChatBox("OOC Chat Enabled Silently by Admin " .. getPlayerName(thePlayer) .. ".", arrayPlayer, 0, 255, 0)
					end
				end
			elseif (oocEnabled==1) then
				exports["global"]:setOOCState(0)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					local admin = getElementData(arrayPlayer, "admin_level")

					if	(logged==1) and (tonumber(admin)>0)then
						outputChatBox("OOC Chat Disabled Silently by Admin " .. getPlayerName(thePlayer) .. ".", arrayPlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end

addCommandHandler("togooc", toggleOOC, false, false)
addCommandHandler("stogooc", toggleOOC, false, false)

function togglePM(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")

	if logged==0 then
		return false
	end

	local vip = getElementData(thePlayer, "vip") or 0
	local vippm = getElementData(thePlayer, "vip:pm") or 0

	if tonumber(vip)  or exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		if tonumber(vippm) == 1 then
			setElementData(thePlayer, "vip:pm", 0)
			exports["infobox"]:addBox(thePlayer, "info", "Özel Mesajlarınız açıldı!")
		else
			setElementData(thePlayer, "vip:pm", 1)
			exports["infobox"]:addBox(thePlayer, "info", "Özel Mesajlarınız kapatıldı!")
		end
	end
end
addEvent("chat:togpm", true)
addEventHandler("chat:togpm", root, togglePM)
addCommandHandler("togpm", togglePM)
addCommandHandler("togglepm", togglePM)

function toggleAds(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")

	if logged==0 then
		return false
	end

	local vip = getElementData(thePlayer, "vip") or 0
	local vipreklam = getElementData(thePlayer, "vip:reklam") or 0

	if tonumber(vip) ~= 0 or exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		if tonumber(vipreklam)== 1 then
			--outputChatBox("PM's are now enabled.", thePlayer, 0, 255, 0)
			setElementData(thePlayer, "vip:reklam", 0)
			exports["infobox"]:addBox(thePlayer, "info", "Reklamlar açıldı!")
		else
			--outputChatBox("PM's are now disabled.", thePlayer, 255, 0, 0)
			setElementData(thePlayer, "vip:reklam", 1)
			exports["infobox"]:addBox(thePlayer, "info", "Reklamlar kapatıldı!")
		end
	end
end
addEvent("chat:togad", true)
addEventHandler("chat:togad", root, toggleAds)
addCommandHandler("togad", toggleAds)
addCommandHandler("togglead", toggleAds)

-- /pay
function payPlayer(thePlayer, commandName, targetPlayerNick, amount)
if getElementData(thePlayer, "KafesDovusu") then return end
if getElementData(thePlayer, "kumar") == 1 then return end
if getElementData(thePlayer, "carshopkilit") then exports["infobox"]:addBox(thePlayer, "info", "Çok zekisin amın evladı!") return end
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not (targetPlayerNick) or not (amount) or not tonumber(amount) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Kişinin ID] [Miktar]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayerNick)

			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)

				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=10) then
					amount = math.floor(math.abs(tonumber(amount)))
					

					local hoursplayed = getElementData(thePlayer, "hoursplayed")

					if (targetPlayer==thePlayer) then
						outputChatBox("[!] Kendinize para veremezsiniz!", thePlayer, 255, 0, 0)
					elseif amount == 0 then
						outputChatBox("[!] 0'dan büyük bir miktar girmeniz gerekiyor.", thePlayer, 255, 0, 0)
					elseif (hoursplayed<5) and (amount>50) and not exports["integration"]:isPlayerTrialAdmin(thePlayer) and not exports["integration"]:isPlayerTrialAdmin(targetPlayer) and not exports["integration"]:isPlayerSupporter(thePlayer) and not exports["integration"]:isPlayerSupporter(targetPlayer) then
						outputChatBox("[!] En az 50 ₺ transfer etmeden önce en az 5 saat oynamanız gerekir.", thePlayer, 255, 0, 0)
					elseif exports["global"]:hasMoney(thePlayer, amount) then
						if hoursplayed < 5 and not exports["integration"]:isPlayerTrialAdmin(targetPlayer) and not exports["integration"]:isPlayerTrialAdmin(thePlayer) and not exports["integration"]:isPlayerSupporter(targetPlayer) and not exports["integration"]:isPlayerSupporter(thePlayer) then
							local totalAmount = ( getElementData(thePlayer, "payAmount") or 0 ) + amount
							if totalAmount > 200 then
								outputChatBox( "[!] henüz 200₺'den fazla ödeme yapamazsınız. Daha fazla miktar aktarmak için admin çağrınız.", thePlayer, 255, 0, 0 )
								return
							end
							exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "payAmount", totalAmount, false)
							setTimer(
								function(thePlayer, amount)
									if isElement(thePlayer) then
										local totalAmount = ( getElementData(thePlayer, "payAmount") or 0 ) - amount
										exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "payAmount", totalAmount <= 0 and false or totalAmount, false)
									end
								end,
								300000, 1, thePlayer, amount
							)
						end
						--exports["logs"]:logMessage("[Money Transfer From " .. getPlayerName(thePlayer) .. " To: " .. targetPlayerName .. "] Value: " .. amount .. "₺", 5)
						exports["logs"]:dbLog(thePlayer, 25, targetPlayer, "PAY " .. amount)

						
						if (hoursplayed<5) then
							exports["global"]:sendMessageToAdmins("AdmWarn: New Player '" .. getPlayerName(thePlayer) .. "' transferred ₺" .. exports["global"]:formatMoney(amount) .. " to '" .. targetPlayerName .. "'.")
						end

						-- DEAL!
						exports["global"]:takeMoney(thePlayer, amount)
						exports["global"]:giveMoney(targetPlayer, amount)

						local gender = getElementData(thePlayer, "gender")
						local genderm = "his"
						if (gender == 1) then
							genderm = "her"
						end
						triggerEvent('sendAme', thePlayer, " cüzdanını kavrar ve sol eli ile şahısa bir miktar para verir " .. targetPlayerName .. ".")
					    outputChatBox("#32f200[!] #eaeaea" .. targetPlayerName .. " adlı şahısa " .. exports["global"]:formatMoney(amount) .. "₺ para gönderdin.", thePlayer, 255, 0, 0, true)
						outputChatBox("#32f200[!] #eaeaea".. getPlayerName(thePlayer) .." adlı şahıs sana " .. exports["global"]:formatMoney(amount) .. "₺ para gönderdi.", targetPlayer, 255, 0, 0, true)
						--outputChatBox(getPlayerName(thePlayer) .. "#32f200[!] #eaeaea adlı şahıs sana" .. exports["global"]:formatMoney(amount) .. "₺ para gönderdi.", targetPlayer, 255, 0, 0, true)

						exports["global"]:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
					else
						outputChatBox("[!] Yeterli paranız bulunmamaktadır.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("[!] Kişiden çok uzaksınız." .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
	end
addCommandHandler("paraver", payPlayer, false, false)

function removeAnimation(thePlayer)
	exports["global"]:removeAnimation(thePlayer)
end

-- /w(hisper)
function localWhisper(thePlayer, commandName, targetPlayerNick, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = tonumber(getElementData(thePlayer, "loggedin"))

	if (logged==1) then
		if not (targetPlayerNick) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Message]", thePlayer, 255, 194, 14)
		else
		local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayerNick)

			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)

				if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<3) then
					local name = getPlayerName(thePlayer)
					local message = table.concat({...}, " ")
					--exports["logs"]:logMessage("[IC: Whisper] " .. name .. " to " .. targetPlayerName .. ": " .. message, 1)
					exports["logs"]:dbLog(thePlayer, 21, targetPlayer, message)
					message = trunklateText( thePlayer, message )

					local languageslot = getElementData(thePlayer, "languages.current")
					local language = getElementData(thePlayer, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("languages"), "getLanguageName", language)

					message2 = trunklateText( targetPlayer, message2 )
					local message2 = call(getResourceFromName("languages"), "applyLanguage", thePlayer, targetPlayer, message, language)

					triggerEvent('sendAme', thePlayer, "şu kişiye fısıldıyor " .. targetPlayerName .. ".")
					local r, g, b = 255, 255, 255
					local focus = getElementData(thePlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					outputChatBox("["..realTime.."] " .. name .. " fısıldıyor: " .. message, thePlayer, r, g, b)
					local r, g, b = 255, 255, 255
					local focus = getElementData(targetPlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					outputChatBox("["..realTime.."] " .. name .. " fısıldıyor: " .. message2, targetPlayer, r, g, b)
					for i,p in ipairs(getElementsByType( "player" )) do
						--if (getElementData(p, "duty_admin") == 1) then
							if p ~= targetPlayer and p ~= thePlayer then
								local ax, ay, az = getElementPosition(p)
								if (getDistanceBetweenPoints3D(x, y, z, ax, ay, az)<4) then
									local playerVeh = getPedOccupiedVehicle( thePlayer )
									local targetVeh = getPedOccupiedVehicle( targetPlayer )
									local pVeh = getPedOccupiedVehicle( p )
									if playerVeh then
										if pVeh then
											if pVeh==playerVeh then
												outputChatBox("["..realTime.."] " .. name .. " whispers to " .. getPlayerName(targetPlayer):gsub("_"," ") .. ": " .. message, p, 255, 255, 255)
											end
										end
									else
										outputChatBox("["..realTime.."] " .. name .. " whispers to " .. getPlayerName(targetPlayer):gsub("_"," ") .. ": " .. message, p, 255, 255, 255)
									end
								end
							end
						--end
					end
				else
					outputChatBox("" .. targetPlayerName .. " çok uzaksın.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("w", localWhisper, false, false)

-- /c(lose)
function localClose(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = tonumber(getElementData(thePlayer, "loggedin"))

	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
		local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")
			local affectedElements = { }
			local name = getPlayerName(thePlayer)
			local message = table.concat({...}, " ")
			--exports["logs"]:logMessage("[IC: Whisper] " .. name .. ": " .. message, 1)
			message = trunklateText( thePlayer, message )

			local languageslot = getElementData(thePlayer, "languages.current")
			local language = getElementData(thePlayer, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("languages"), "getLanguageName", language)
			local playerCar = getPedOccupiedVehicle(thePlayer)
			for index, targetPlayers in ipairs( getElementsByType( "player" ) ) do
				if getElementDistance( thePlayer, targetPlayers ) < 3 then
					local message2 = message
					if targetPlayers ~= thePlayer then
						message2 = call(getResourceFromName("languages"), "applyLanguage", thePlayer, targetPlayers, message, language)
						message2 = trunklateText( targetPlayers, message2 )
					end
					local r, g, b = 255, 255, 255
					local focus = getElementData(targetPlayers, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					
					local pveh = getPedOccupiedVehicle(targetPlayers)
					if playerCar then
						if not exports['vehicle']:isVehicleWindowUp(playerCar) then
							if pveh then
								if playerCar == pveh then
									table.insert(affectedElements, targetPlayers)
									outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
									exports["global"]:applyAnimation( thePlayer, "RIOT", "RIOT_shout", -1, true, false, false)									
									icChatsToVoice(targetPlayers, message2, thePlayer)
								elseif not (exports['vehicle']:isVehicleWindowUp(pveh)) then
									table.insert(affectedElements, targetPlayers)
									outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
							--exports["global"]:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)										
									icChatsToVoice(targetPlayers, message2, thePlayer)
								end
							else
								table.insert(affectedElements, targetPlayers)
							--exports["global"]:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)										
								outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
								icChatsToVoice(targetPlayers, message2, thePlayer)
							end
						else
							if pveh then
								if pveh == playerCar then
									table.insert(affectedElements, targetPlayers)
									outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
							--exports["global"]:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)																			
									icChatsToVoice(targetPlayers, message2, thePlayer)
								end
							end
						end
					else
						if pveh then
							if playerCar then
								if playerCar == pveh then
									table.insert(affectedElements, targetPlayers)
									outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
									icChatsToVoice(targetPlayers, message2, thePlayer)
							--exports["global"]:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)																			
								end
							elseif not (exports['vehicle']:isVehicleWindowUp(pveh)) then
								table.insert(affectedElements, targetPlayers)
								outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
								icChatsToVoice(targetPlayers, message2, thePlayer)
							--exports["global"]:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)																		
							end
						else
							table.insert(affectedElements, targetPlayers)
							outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
							icChatsToVoice(targetPlayers, message2, thePlayer)
							--exports["global"]:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)										
						end
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 22, affectedElements, languagename .. " "..message)
		end
	end
end
addCommandHandler("c", localClose, false, false)

------------------
-- News Faction --
------------------
-- /tognews
function togNews(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		local newsTog = getElementData(thePlayer, "tognews")

		if (newsTog~=1) then
			outputChatBox("[CANLI YAYIN] Konuşmaları Aktif!.", thePlayer, 255, 194, 14)
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "tognews", 1, false)
		else
			outputChatBox("[CANLI YAYIN] Konuşmaları Deaktif!.", thePlayer, 255, 194, 14)
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "tognews", 0, false)
		end
	end
end
addCommandHandler("tognews", togNews, false, false)
addCommandHandler("togglenews", togNews, false, false)
addCommandHandler("trtkapat", togNews, false, false)


-- /startinterview
function StartInterview(thePlayer, commandName, targetPartialPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		if(factionType==6)then -- news faction
			if not (targetPartialPlayer) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPartialPlayer)
				if targetPlayer then
					local targetLogged = getElementData(targetPlayer, "loggedin")
					if (targetLogged==1) then
						if(getElementData(targetPlayer,"interview"))then
							outputChatBox("Bu oyuncu zaten röportaj yapıyor.", thePlayer, 255, 0, 0)
						else
							exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "interview", true, false)
							local playerName = getPlayerName(thePlayer)
							outputChatBox(playerName .." size röportaj teklif etti.", targetPlayer, 0, 255, 0)
							outputChatBox("((Görüşme sırasında konuşmak için /i kullanın.))", targetPlayer, 0, 255, 0)
							local NewsFaction = getPlayersInTeam(getPlayerTeam(thePlayer))
							for key, value in ipairs(NewsFaction) do
								outputChatBox("((".. playerName ..", " .. targetPlayerName .. " röportaj yapmaya davet etti.))", value, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("interview", StartInterview, false, false)
addCommandHandler("roportajbasla", StartInterview, false, false)

-- /endinterview
function endInterview(thePlayer, commandName, targetPartialPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		if(factionType==6)then -- news faction
			if not (targetPartialPlayer) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPartialPlayer)
				if targetPlayer then
					local targetLogged = getElementData(targetPlayer, "loggedin")
					if (targetLogged==1) then
						if not(getElementData(targetPlayer,"interview"))then
							outputChatBox("Bu oyuncu ile röportaj yapılmıyor.", thePlayer, 255, 0, 0)
						else
							exports["anticheat"]:changeProtectedElementDataEx(targetPlayer, "interview", false, false)
							local playerName = getPlayerName(thePlayer)
							outputChatBox(playerName .." görüşmenizi sonlandırdı.", targetPlayer, 255, 0, 0)

							local NewsFaction = getPlayersInTeam(getPlayerTeam(thePlayer))
							for key, value in ipairs(NewsFaction) do
								outputChatBox("((".. playerName ..", " .. targetPlayerName .. " röportajını sonlandırdı.))", value, 255, 0, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("endinterview", endInterview, false, false)
addCommandHandler("roportajbitir", endInterview, false, false)

-- /i
function interviewChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		if(getElementData(thePlayer, "interview"))then
			if not(...)then
				outputChatBox("SYNTAX: /" .. commandName .. "[Message]", thePlayer, 255, 194, 14)
			else
				local message = table.concat({...}, " ")
				local name = getPlayerName(thePlayer)

				local finalmessage = "[CANLI YAYIN] Röportaj Konuğu " .. name .." konuşuyor: ".. message
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				if(factionType==6)then -- news faction
					finalmessage = "[CANLI YAYIN] " .. name .." konuşuyor: ".. message
				end

				for key, value in ipairs(exports["pool"]:getPoolElementsByType("player")) do
					if (getElementData(value, "loggedin")==1) then
						if not (getElementData(value, "tognews")==1) then
							outputChatBox(finalmessage, value, 200, 100, 200)
						end
					end
				end
				exports["logs"]:dbLog(thePlayer, 23, thePlayer, "[SanTV] " .. message)
				exports["global"]:giveMoney(getTeamFromName("SanTV"), 200)
			end
		end
	end
end
addCommandHandler("i", interviewChat, false, false)

-- /charity
function charityCash(thePlayer, commandName, amount)
	if not (amount) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Amount]", thePlayer, 255, 194, 14)
	else
		local donation = tonumber(amount)
		if (donation<=0) then
			outputChatBox("You must enter an amount greater than zero.", thePlayer, 255, 0, 0)
		else
			if not exports["global"]:takeMoney(thePlayer, donation) then
				outputChatBox("You don't have that much money to remove.", thePlayer, 255, 0, 0)
			else
				outputChatBox("You have donated ₺".. exports["global"]:formatMoney(donation) .." to charity.", thePlayer, 0, 255, 0)
				exports["global"]:sendMessageToAdmins("AdmWrn: " ..getPlayerName(thePlayer).. " charity'd ₺" ..exports["global"]:formatMoney(donation))
				exports["logs"]:dbLog(thePlayer, 25, thePlayer, "CHARITY ₺" .. amount)
			end
		end
	end
end
addCommandHandler("charity", charityCash, false, false)

-- /bigears
function bigEars(thePlayer, commandName, targetPlayerNick)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		local current = getElementData(thePlayer, "bigears")
		if not current and not targetPlayerNick then
			outputChatBox("SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
		elseif current and not targetPlayerNick then
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "bigears", false, false)
			outputChatBox("Big Ears turned off.", thePlayer, 255, 0, 0)
		else
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayerNick)

			if targetPlayer then
				outputChatBox("Now Listening to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
				exports["logs"]:dbLog(thePlayer, 4, targetPlayer, "BIGEARS "..targetPlayerName)
				exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "bigears", targetPlayer, false)
			end
		end
	end
end
addCommandHandler("bigears", bigEars)

function removeBigEars()
	for key, value in pairs( getElementsByType( "player" ) ) do
		if isElement( value ) and getElementData( value, "bigears" ) == source then
			exports["anticheat"]:changeProtectedElementDataEx( value, "bigears", false, false )
			outputChatBox("Big Ears turned off (Player Left).", value, 255, 0, 0)
		end
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), removeBigEars)

function bigEarsFaction(thePlayer, commandName, factionID)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		factionID = tonumber( factionID )
		local current = getElementData(thePlayer, "bigearsfaction")
		if not current and not factionID then
			outputChatBox("SYNTAX: /" .. commandName .. " [faction id]", thePlayer, 255, 194, 14)
		elseif current and not factionID then
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "bigearsfaction", false, false)
			outputChatBox("Big Ears turned off.", thePlayer, 255, 0, 0)
		else
			local team = exports["pool"]:getElement("team", factionID)
			if not team then
				outputChatBox("No faction with that ID found.", thePlayer, 255, 0, 0)
			else
				outputChatBox("Now Listening to " .. getTeamName(team) .. " OOC Chat.", thePlayer, 0, 255, 0)
				exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "bigearsfaction", team, false)
				exports["logs"]:dbLog(thePlayer, 4, team, "BIGEARSF "..getTeamName(team))
			end
		end
	end
end
addCommandHandler("bigearsf", bigEarsFaction)

function disableMsg(message, player)
	cancelEvent()
	-- send it using 	our own PM etiquette instead
	pmPlayer(source, "pm", player, message)
end
addEventHandler("onPlayerPrivateMessage", getRootElement(), disableMsg)

-- /focus
function focus(thePlayer, commandName, targetPlayer, r, g, b)
	local focus = getElementData(thePlayer, "focus")
	if targetPlayer then
		local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			if type(focus) ~= "table" then
				focus = {}
			end

			if focus[targetPlayer] and not r then
				outputChatBox( "You stopped highlighting " .. string.format("#%02x%02x%02x", unpack( focus[targetPlayer] ) ) .. targetPlayerName .. "#ffc20e.", thePlayer, 255, 194, 14, true )
				focus[targetPlayer] = nil
			else
				color = {tonumber(r) or math.random(63,255), tonumber(g) or math.random(63,255), tonumber(b) or math.random(63,255)}
				for _, v in ipairs(color) do
					if v < 0 or v > 255 then
						outputChatBox("Invalid Color: " .. v, thePlayer, 255, 0, 0)
						return
					end
				end

				focus[targetPlayer] = color
				outputChatBox( "You are now highlighting on " .. string.format("#%02x%02x%02x", unpack( focus[targetPlayer] ) ) .. targetPlayerName .. "#00ff00.", thePlayer, 0, 255, 0, true )
			end
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "focus", focus, false)
		end
	else
		if type(focus) == "table" then
			outputChatBox( "You are watching: ", thePlayer, 255, 194, 14 )
			for player, color in pairs( focus ) do
				outputChatBox( "  " .. getPlayerName( player ):gsub("_", " "), thePlayer, unpack( color ) )
			end
		end
		outputChatBox( "To add someone, /" .. commandName .. " [player] [optional red/green/blue], to remove just /" .. commandName .. " [player] again.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("focus", focus)
addCommandHandler("highlight", focus)

addEventHandler("onPlayerQuit", root,
	function( )
		for k, v in ipairs( getElementsByType( "player" ) ) do
			if v ~= source then
				local focus = getElementData( v, "focus" )
				if focus and focus[source] then
					focus[source] = nil
					exports["anticheat"]:changeProtectedElementDataEx(v, "focus", focus, false)
				end
			end
		end
	end
)

-- START of /st and /togglest and /togst

function isPlayerStaff(thePlayer)
	if exports["integration"]:isPlayerSupporter(thePlayer) then return true end
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then return true end
	if exports["integration"]:isPlayerScripter(thePlayer) then return true end
	if exports["integration"]:isPlayerVCTMember(thePlayer) then return true end
	if exports["integration"]:isPlayerMappingTeamMember(thePlayer) then return true
	else
		return false
	end
end

function staffChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and isPlayerStaff(thePlayer)  then
		if not (...) then
			outputChatBox("SYNTAX: /".. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			if getElementData(thePlayer, "hideStaffChat") then
				setElementData(thePlayer, "hideStaffChat", false)
				outputChatBox("Staff Chat - SHOWING",thePlayer)
			end
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports["pool"]:getPoolElementsByType("player")
			local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local accountName = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				if logged==1 and isPlayerStaff(arrayPlayer) then
					local hideStaffChat = getElementData(arrayPlayer, "hideStaffChat")
					if hideStaffChat then
						local string = string.lower(message)
						local account = string.lower(getElementData(arrayPlayer, "account:username"))
						if string.find(string, account) then
							table.insert(affectedElements, arrayPlayer)
							triggerClientEvent ( "playNudgeSound", arrayPlayer)
							outputChatBox("Mentionned in /st chat - "..accountName..": "..message, arrayPlayer)
						end
					else
						table.insert(affectedElements, arrayPlayer)
						outputChatBox("[STAFF] "..exports["global"]:getPlayerFullIdentity(thePlayer)..": "..message, arrayPlayer, 153, 51, 255)
					end
				end
			end
			exports["logs"]:dbLog(thePlayer, 4, affectedElements, "Staff chat - Msg: "..message)
		end
	end
end
addCommandHandler( "st", staffChat, false, false)

function toggleStaffChat(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	if logged==1 and isPlayerStaff(thePlayer) then
		local hideStaffChat = getElementData(thePlayer, "hideStaffChat") or false
		setElementData(thePlayer, "hideStaffChat", not hideStaffChat)
		outputChatBox("Staff Chat - "..(hideStaffChat and "SHOWING" or "HIDDEN").." /"..commandName.." to toggle it.",thePlayer)
	end
end
addCommandHandler("togglestaff", toggleStaffChat, false, false)
addCommandHandler("togst", toggleStaffChat, false, false)
addCommandHandler("togglest", toggleStaffChat, false, false)

--------------------------------------------------------------------------------------------------
-- Anadolu ROLEPLAY / ENTEGRE CHAT
--------------------------------------------------------------------------------------------------
function outputChatBoxRemote ( playerName, accountName, message )
	for _, player in ipairs (getElementsByType("player")) do
		if exports["integration"]:isPlayerAdmin(player) then
			MTAoutputChatBox ( "[ARP] " .. playerName .. " (" .. accountName .. "): " .. message, player, 63, 163, 196 )
		end
	end
	----outputDebugString( "callRemote: " .. message  )
    return "chat-ok"
end
 
function finishedCallback( responseData, errno )
    responseData = tostring(responseData)
    if responseData == "ERROR" then
    --    --outputDebugString( "callRemote: ERROR #" .. errno )
    elseif responseData ~= "chat-ok" then
    --    --outputDebugString( "callRemote: Unexpected reply: " .. responseData  )
    else
    --    --outputDebugString( "callRemote: sent msg")
    end
end
 
function playerChat ( thePlayer, commandName, ...)
	if not exports["integration"]:isPlayerAdmin(thePlayer) then
		return
	end
	if not (...) then
		MTAoutputChatBox("/" .. commandName .. " [MESAJ] - Bu komut Anadolu entrgre sohbeti sağlar.", thePlayer)
	end
	local message = table.concat({...}, " ")
    callRemote ( "185.126.178.55:22005", getResourceName(getThisResource()), "outputChatBoxRemote", finishedCallback, getPlayerName(thePlayer), getElementData(thePlayer, "account:username"), message )
	for _, player in ipairs (getElementsByType("player")) do
		if exports["integration"]:isPlayerAdmin(player) then
			MTAoutputChatBox ( "[ARP] " .. gpn(thePlayer) .. " (" .. getElementData(thePlayer, "account:username") .. "): " .. message, player, 63, 163, 196 )
		end
	end
end
addCommandHandler("ec", playerChat)

----------------------------------------------------------------------------------------------------------
