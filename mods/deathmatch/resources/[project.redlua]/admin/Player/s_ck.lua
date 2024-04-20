mysql = exports["mysql"]


-- /CK
addCommandHandler("ck",
	function(thePlayer, commandName, id, ...)
		if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
			if not (id) or not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Cause of Death]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, id)
				local reason = table.concat({...}, " ")
				if targetPlayer then
					local time = getRealTime()
					local hours = time.hour
					local minutes = time.minute
					local seconds = time.second
					local charactername = getPlayerName(targetPlayer)
					dbExec(mysql:getConnection(), "UPDATE characters SET cked = ? WHERE id = ?", 1, getElementData(targetPlayer, "dbid"))
					redirectPlayer(targetPlayer,"",0)
					for key, value in ipairs(exports["global"]:getAdmins()) do
						local adminduty = getElementData(value, "duty_admin")
						if adminduty == 1 then
							outputChatBox("You have CK'ed ".. targetPlayerName ..".", value, 255, 0, 0)
						end
					end
				end
			end
		end
	end
)

-- /UNCK
addCommandHandler("unck",
	function(thePlayer, commandName, id)
		if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
			if not (id) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
			else
				local charactername = id
				local kayit = dbExec(mysql:getConnection(), "UPDATE characters SET cked = ? WHERE charactername = ?", 0, id)

				if kayit then
					for key, value in ipairs(exports["global"]:getAdmins()) do
						local adminduty = getElementData(value, "duty_admin")
						if adminduty == 1 then
							outputChatBox(targetPlayer .. " is no longer CK'ed.", thePlayer, 0, 255, 0)
						end
					end
				end
			end
		end
	end
)

function buryPlayer(thePlayer, commandName, ...)
local theTeam = getPlayerTeam(thePlayer)
local factionType = getElementData(theTeam, "type")
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")

			dbQuery(
				function(qh, oyuncu)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 1 then
						outputChatBox("Birden fazla sonuç çıktı, doğru isim girdiğinizden emin olun.", oyuncu, 255, 0, 0)
					elseif rows == 0 then
						outputChatBox("Sonuç bulunamadı, doğru isim girdiğinizden emin olun.", oyuncu, 255, 0, 0)
					else
						for index, row in ipairs(res) do
							local dbid = tonumber(row["id"]) or 0
							local cked = tonumber(row["cked"]) or 0
							if cked == 0 then
								outputChatBox("Bu oyuncu ölü değil!.", oyuncu, 255, 0, 0)
							elseif cked == 2 then
								outputChatBox("Bu oyuncunun cesedi zaten gizlenmiş.", oyuncu, 255, 0, 0)
							else
								dbExec(mysql:getConnection(), "UPDATE `characters` SET `cked`='2' WHERE `id` = " .. dbid .. " LIMIT 1")
								
								-- delete all peds for him
								for key, value in pairs( getElementsByType( "ped" ) ) do
									if isElement( value ) and getElementData( value, "ckid" ) then
										if getElementData( value, "ckid" ) == dbid then
											destroyElement( value )
										end
									end
								end
								
								outputChatBox(targetPlayer .. " was buried.", oyuncu, 0, 255, 0)
								exports["logs"]:logMessage("[/BURY] " .. getElementData(oyuncu, "account:username") .. "/".. getPlayerName(oyuncu) .." buried ".. targetPlayer , 4)
								exports["logs"]:dbLog(oyuncu, 4, "ch"..row["id"], "CK-BURY")
							end
						end
					end
				end,
			{thePlayer}, mysql:getConnection(), "SELECT id, cked FROM characters WHERE charactername='" .. tostring(targetPlayer) .. "'")
		end
	end
end
addCommandHandler("bury", buryPlayer)