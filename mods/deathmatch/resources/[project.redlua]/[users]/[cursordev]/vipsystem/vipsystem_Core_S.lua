
local mysql = exports["mysql"]
vipPlayers = {}

setTimer(function()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					loadVIP(row.dbid)
				end
			end
		end,
	mysql:getConnection(), "SELECT `dbid` FROM `vipler`")
end, 1800000, 0)

addEventHandler("onResourceStart", resourceRoot, function()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					loadVIP(row.dbid)
				end
			end
		end,
	mysql:getConnection(), "SELECT `dbid` FROM `vipler`")
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in pairs(getElementsByType("player")) do
		local charID = tonumber(getElementData(player, "dbid"))
		if charID then
			saveVIP(charID)
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	local charID = getElementData(source, "dbid")
	if not charID then return false end
	saveVIP(charID)
end)

function loadVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local vipType = tonumber(row["vip"]) or 0
					local endTick = tonumber(row["vip_sure"]) or 0
					if vipType > 0 then
						vipPlayers[charID] = {}
						vipPlayers[charID].type = vipType
						vipPlayers[charID].endTick = endTick
						local players = exports["pool"]:getPoolElementsByType("player")
						for k, v in ipairs(players) do
							if(tonumber(getElementData(v, "dbid")) == tonumber(charID)) then
								setElementData(v, "vip", vipType)
							end
						end
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `vip`, `vip_sure` FROM `vipler` WHERE dbid='"..charID.."'")
end

function saveVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	if not vipPlayers[charID] then return false end
	
	local success = dbExec(mysql:getConnection(), "UPDATE `vipler` SET vip_sure='"..(vipPlayers[charID].endTick).."' WHERE dbid="..charID.." LIMIT 1")
	if not success then
		return
	end
end

function removeVIP(charID)
	if not vipPlayers[charID] then return false end	
	local query = dbExec(mysql:getConnection(), "DELETE FROM `vipler` WHERE dbid="..charID.." LIMIT 1")
	if query then
		for k, v in ipairs(getElementsByType("player")) do
			if(tonumber(getElementData(v, "dbid")) == tonumber(charID)) then
				setElementData(v, "vip", 0)
				outputChatBox("[!] #ffffffVIP süreniz doldu veya bir yetkili tarafından alındı.", v, 0, 125, 255, true)
			end
		end
		vipPlayers[charID] = nil
		return true
	end
	return false
end

function checkExpireTime()
	for charID, data in pairs(vipPlayers) do
		if (charID and data) then
			if vipPlayers[charID] then
				if vipPlayers[charID].endTick and vipPlayers[charID].endTick <= 0 then

					local success = removeVIP(charID)
					if success then
					end

				elseif vipPlayers[charID].endTick and vipPlayers[charID].endTick > 0 then

					vipPlayers[charID].endTick = math.max(vipPlayers[charID].endTick - (60 * 1000), 0)
					saveVIP(charID)
					
					if vipPlayers[charID].endTick == 0 then
						local success = removeVIP(charID)
						if success then
						end
					end
				end
			end
		end
	end
end
setTimer(checkExpireTime, 300 * 1000, 0)

function vipMod(thePlayer)
	local vipseviye = tonumber(getElementData(thePlayer, "vip") or 0)
    local vipduty = getElementData(thePlayer, "vip"..vipseviye.."duty") or 0
	if (vipseviye >= 1) then
	    if tonumber(vipduty) == 0 then
			setElementData(thePlayer, "vip"..vipseviye.."duty", true)
			exports["infobox"]:addBox(thePlayer, "info", "VIP-"..vipseviye.." duty açıldı.")
	    else
			setElementData(thePlayer, "vip"..vipseviye.."duty", false)
			exports["infobox"]:addBox(thePlayer, "info", "VIP-"..vipseviye.." duty kapatıldı.")
	    end           			
	else
	    outputChatBox("[!]#ffffff VİP değilsiniz..", thePlayer, 255, 0, 0, true)
	end	
end
addCommandHandler ("vipduty", vipMod)