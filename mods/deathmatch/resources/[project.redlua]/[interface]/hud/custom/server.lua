local connection = exports.mysql:getConnection()
local updateSpam = {}
setTimer(function() updateSpam = {} end, 5000, 0) -- 5 saniyede bir table'ı temizliyor.

addEvent("update.custom_hud", true)
addEventHandler("update.custom_hud", root, function(thePlayer)
	if thePlayer then

		if (not updateSpam[thePlayer]) then
			updateSpam[thePlayer] = 1
		elseif (updateSpam[thePlayer] == 8) then
			exports.infobox:addBox(thePlayer, 'warning', 'Spam Koruması', 'Lütfen spam komut göndermekten kaçının!')
			--exports.hud:sendMessage("[INTERFACE] "..getPlayerName(thePlayer):gsub('_', " ").." adlı oyuncu arayüz kaydetmeyi spamlıyor! ")
			return
		else
			updateSpam[thePlayer] = updateSpam[thePlayer] + 1
		end

		local radar = getElementData(thePlayer, "interface.radar")
		local nametagBar = getElementData(thePlayer, "interface.nametagBar")
		local font = getElementData(thePlayer, "interface.nametagFont")
		local speedo = getElementData(thePlayer, "interface.speedo")
		local dbid = getElementData(thePlayer, "dbid")

		local interfaces = {
			["radar"] = radar,
			["nametagBar"] = nametagBar,
			["nametagFont"] = font,
			["speedo"] = speedo
		}

		dbExec(connection, "UPDATE characters SET interface=? WHERE id=?", toJSON(interfaces), dbid)
	end
end)
