
function givePlayerJob(thePlayer, commandName, targetPlayer, jobID, jobLevel, jobProgress)
	jobID = tonumber(jobID)
	if exports["integration"]:isPlayerLeadAdmin(thePlayer) then
		local jobTitle = getJobTitleFromID(jobID)
		if not (targetPlayer) then
			printSetJobSyntax(thePlayer, commandName)
			return
		else
			
			if jobTitle == "İşsiz" then
				jobID = 0
			end
			
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					
					dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='" .. (jobID) .. "' WHERE `id`='"..tostring(getElementData(targetPlayer, "dbid")).."' " )
					
					fetchJobInfoForOnePlayer(targetPlayer)
					
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
					if hiddenAdmin == 0 then
						outputChatBox("Your job has been set to '" .. jobTitle .. "' by "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer)..". ", targetPlayer, 0, 255,0)
					else
						outputChatBox("Your job has been set to '" .. jobTitle .. "' by a hidden admin. ", targetPlayer, 0, 255,0)
					end
					outputChatBox("You have set " .. targetPlayerName .. "'s job to '"..jobTitle.."'.", thePlayer)
				end
			end
		end
	end
end
addCommandHandler("setjob", givePlayerJob, false, false)

function printSetJobSyntax(thePlayer, commandName)
	outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Job ID, 0 = Unemployed]", thePlayer, 255, 194, 14)
	outputChatBox("ID#1: Kargo Şoförü", thePlayer)
	outputChatBox("ID#2: Taksi Şoförü", thePlayer)
	outputChatBox("ID#3: Dolmuş Şoförü", thePlayer)
	outputChatBox("ID#4: Çöp Şöförü", thePlayer)
	outputChatBox("ID#5: Tamirci", thePlayer)
	outputChatBox("ID#6: Pizza Dağıtımcısı", thePlayer)
	outputChatBox("ID#7: Kanalizasyon Görevlisi", thePlayer)
	outputChatBox("ID#8: Yemek Dağıtımcısı", thePlayer)
	outputChatBox("ID#9: Çekici", thePlayer)
	outputChatBox("ID#10: Sigara Kaçakcısı", thePlayer)
end

function delJob( thePlayer, commandName, targetPlayerName )
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer)) then
		if targetPlayerName then
			local targetPlayer, targetPlayerName = exports["global"]:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if targetPlayer then
				if getElementData( targetPlayer, "loggedin" ) == 1 then
					local result = dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='0' WHERE `id`='"..tostring(getElementData(targetPlayer, "dbid")).."' " )
					
					fetchJobInfoForOnePlayer(targetPlayer)
					if result then
						outputChatBox( "Deleted job for " .. targetPlayerName..".", thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
							outputChatBox("Your job has been deleted by "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer)..". Please relog (F10) to get it affected.", targetPlayer, 0, 255,0)
						else
							outputChatBox("Your job has been deleted by a hidden admin.", targetPlayer, 0, 255,0)
						end
					else
						outputChatBox( "Failed to delete job.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14 )
		end
	end
end
addCommandHandler("deljob", delJob, false, false)