mysql = exports["mysql"]
reports = { }
local reportsToAward = 30
local gcToAward = 0

local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	if not (...) or not isElement((...)) then
		return "Bilinmiyor"
	else
		s = getPlayerName_( ... )
		return s and s:gsub( "_", " " ) or s
	end
end

MTAoutputChatBox = outputChatBox
local function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if showExternalReportBox(visibleTo) then
		showToAdminPanel(text, visibleTo, r,g,b)
		outputConsole ( text, visibleTo)
	else
		if string.len(text) > 128 then -- MTA Chatbox size limit
			MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
			outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
		else
			MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
		end
	end
end

local thisResourceElement = getResourceRootElement(getThisResource())

function showToAllAdminPanel(content, r,g,b)
	if string.len(content) > 105 then
		local content1 = string.sub(content,1,115)
		local content2 = string.sub(content,116)
		setElementData(thisResourceElement ,"reportPanel",  {content1, r, g, b} , true)
		showToAllAdminPanel(content2, r,g,b)
	else
		setElementData(thisResourceElement ,"reportPanel",  {content, r, g, b} , true)
	end
end

function showToAdminPanel(content, specifiedPlayer, r,g,b)
	if string.len(content) > 105 then
		local content1 = string.sub(content,1,115)
		local content2 = string.sub(content,116)
		triggerClientEvent(specifiedPlayer, "report-system:updateOverlay" , specifiedPlayer, {content1, r, g, b, 255,1, "default"})
		showToAdminPanel(content2,specifiedPlayer, r,g,b)
	else
		triggerClientEvent(specifiedPlayer, "report-system:updateOverlay" , specifiedPlayer, {content, r, g, b, 255,1, "default"})
	end
end

function getAdminCount()
	local online, duty, lead, leadduty, gm, gmduty = 0, 0, 0, 0,0,0
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) then
			local level = getElementData( value, "admin_level" ) or 0
			if level >= 1 and level <= 6 then
				online = online + 1

				local aod = getElementData( value, "duty_admin" ) or 0
				if aod == 1 then
					duty = duty + 1
				end

				if level >= 5 then
					lead = lead + 1
					if aod == 1 then
						leadduty = leadduty + 1
					end
				end
			end

			if exports["integration"]:isPlayerSupporter(value) then
				gm = gm + 1

				local aod = (getElementData( value, "duty_supporter" ) == 1 )
				if aod == true then
					gmduty = gmduty + 1
				end
			end
		end
	end
	return online, duty, lead, leadduty, gm, gmduty
end

function updateReportCount()
	local open = {}
	local handled = {}

	unanswered = {}
	local byadmin = {}
	local alreadyTold = {}

	for k, v in ipairs(getElementsByType("player")) do
		unanswered[v] = { }
		byadmin[v] = { }
		open[v] = 0
		handled[v] = 0
		if exports["integration"]:isPlayerStaff(v) and getElementData(v, "loggedin") == 1 then
			local alreadyTold = {}
			for key, value in pairs(reports) do
				local staff, _, n, abrv = getReportInfo(value[7])
				if staff then
					for g, u in ipairs(staff) do
						if (exports["integration"]:isPlayerTrialAdmin(v) or value[5] == v) and not alreadyTold[key] then
							open[v] = open[v] + 1
							alreadyTold[key] = true
							if value[5] then
								handled[v] = handled[v] + 1
								if not byadmin[v][value[5]] then
									byadmin[v][value[5]] = { key }
								else
									table.insert(byadmin[v][value[5]], key)
								end
							else
								table.insert(unanswered[v], abrv..""..tostring(key))
							end
						end
					end
				end
			end
		end
	end

	-- admstr
	--[[local online, duty, lead, leadduty, gm, gmduty = getAdminCount()

	for key, value in ipairs(getElementsByType("player")) do
		if exports["integration"]:isPlayerStaff(value) then
			if exports["integration"]:isPlayerTrialAdmin(value) then
				str = ":: "..gmduty.."/"..gm.." SUP :: " .. duty .."/".. online .." yetkili"
			elseif exports["integration"]:isPlayerSupporter(value) then
				str = ":: "..gmduty.."/"..gm.." SUP"
			else
				str = ""
			end
			triggerClientEvent( value, "updateReportsCount", value, open[value], handled[value], unanswered[value], byadmin[value][value], str)
		end
	end]]
end

addEventHandler( "onElementDataChange", getRootElement(),
	function(n)
		if getElementType(source) == "player" and ( n == "admin_level" or n == "duty_admin" or  n == "account:gmlevel" or n == "duty_supporter" ) then
			sortReports(false)
			updateReportCount()
		end
	end
)

function maximeReportsReminder()
	for key, value in ipairs(getElementsByType("player")) do
		local level = getElementData( value, "admin_level" ) or 0
		local aod = getElementData( value, "duty_admin" ) or 0
		local god = getElementData( value, "duty_supporter" ) or false
		if (exports["integration"]:isPlayerSupporter(value) and god == 1) or (exports["integration"]:isPlayerTrialAdmin(value) and aod == 1) then
			showUnansweredReports(value)
		end
	end
end
setTimer(maximeReportsReminder, 5 * 60 * 1000, 0) -- every 5 mins.

function sortReports(showMessage) --MAXIME
	-- reports[slot] = { }
	-- reports[slot][1] = source -- Reporter
	-- reports[slot][2] = reportedPlayer -- Reported Player
	-- reports[slot][3] = reportedReason -- Reported Reason
	-- reports[slot][4] = timestring -- Time reported at
	-- reports[slot][5] = nil -- Admin dealing with the report
	-- reports[slot][6] = alertTimer -- Alert timer of the report
	-- reports[slot][7] = reportType -- Type report
	-- reports[slot][8] = slot -- Report ID/Slot, used in rolling queue function / Maxime
	local sortedReports = {}
	local adminNotice = ""
	local gmNotice = ""
	local unsortedReports = reports

	for key , report in pairs(reports) do
		table.insert(sortedReports, report)
	end

	reports = sortedReports

	for key , report in pairs(reports) do
		if report[8] ~= key then
			if isSupporterReport(report[7]) then
				adminNotice = adminNotice.."#"..report[8]..", "
				if showMessage then
					outputChatBox("Raporunuz #"..report[8].." önceki raporların çözülmesi sonucunda #"..key.." sırasına kaydırılmıştır.", report[1], 70, 200, 30)
				end
			else -- Admin report
				adminNotice = adminNotice.."#"..report[8]..", "
				gmNotice = gmNotice.."#"..report[8]..", "
				if showMessage then
					outputChatBox(""..report[8].." önceki raporların çözülmesi sonucunda #"..key.." sırasına kaydırılmıştır.", report[1], 255, 195, 15)
				end
			end
			setElementData(report[1], "reportNum", key)
			report[8] = key
		end
	end

	if showMessage then
		if adminNotice ~= "" then
			adminNotice = string.sub(adminNotice, 1, (string.len(adminNotice) - 2))
			local admins = exports["global"]:getAdmins()
			for key, value in ipairs(admins) do
				local adminduty = getElementData(value, "duty_admin")
				if (adminduty==1) then
					outputChatBox(" ID'leri "..adminNotice.." olan raporlar öne kaydırılmıştır.", value, 255, 195, 15)
				end
			end
		end
		if gmNotice ~= "" then
			gmNotice = string.sub(gmNotice, 1, (string.len(gmNotice) - 2))
			local gms = exports["global"]:getGameMasters()
			for key, value in ipairs(gms) do
				local gmDuty = getElementData(value, "duty_supporter")
				if (gmDuty == 1) then
					outputChatBox(" Reports with ID "..gmNotice.." have been shifted up.", value, 70, 200, 30)
				end
			end
		end

	end

end

function showCKList(thePlayer)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		outputChatBox("~~~~~~~~~ Self-CK İstekleri ~~~~~~~~~", thePlayer, 255, 194, 15)

		local ckcount = 0
		local players = exports["pool"]:getPoolElementsByType("player")
		for key, value in ipairs(players) do
			local logged = getElementData(value, "loggedin")
			if (logged==1) then
				local requested = getElementData(value, "ckstatus")
				local reason = getElementData(value, "ckreason")
				local pname = getPlayerName(value):gsub("_", " ")
				local playerID = getElementData(value, "playerid")
				if requested=="requested" then
					ckcount = 1
					outputChatBox(" '" .. pname .. "' ("..playerID..") isimli oyuncudan Self-CK isteği var. Gerekçe '" .. reason .. "'.", thePlayer, 255, 195, 15)
				end
			end
		end

		if ckcount == 0 then
			outputChatBox("Yok.", thePlayer, 255, 194, 15)
		else
			outputChatBox("Use /cka [id] or /ckd [id] to answer the request(s).", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("cks", showCKList)

function reportInfo(thePlayer, commandName, id)
	if exports["integration"]:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("KOMUT: /" .. commandName .. " [ID]", thePlayer, 255, 194, 15)
		else
			local isOverlayDisabled = getElementData(thePlayer, "hud:isOverlayDisabled")
			id = tonumber(id)
			if reports[id] then
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local timestring = reports[id][4]
				local admin = reports[id][5]
				local staff, _, n, abrv, r, g, b = getReportInfo(reports[id][7])

				local playerID = getElementData(reporter, "playerid") or "Bilinmiyor"
				local reportedID = getElementData(reported, "playerid") or "Bilinmiyor"


				if staff then
					outputChatBox("[#" .. id .."] - (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " isimli oyuncu yardım talep ediyor. [Saat: " .. timestring .. "]", thePlayer, r, g, b)
					outputChatBox(" - Gerekçe: " .. reason, thePlayer, 70, 200, 30)
					----outputDebugString(getElementData(thePlayer, "report_panel_mod")) -- shit
					local handler = ""
					if (isElement(admin)) then
						local adminName = getElementData(admin, "account:username")
						outputChatBox("(!) [#" .. id .."] Bu rapor ile " .. getPlayerName(admin) .. " ("..adminName..") isimli yetkili ilgilenmektedir.", thePlayer, 70, 200, 30)
					else
						--outputChatBox("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", thePlayer, 255, 221, 117)
						--outputChatBox("   Type /ar " .. id .. " to accept this report. Type /togautocheck to turn on/off auto-check when accepting reports.", thePlayer, 255, 194, 15)
					end
				end


			else
				outputChatBox("(( Geçersiz rapor ID. ))", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("raporuoku", reportInfo, false, false)
addCommandHandler("ro", reportInfo, false, false)

function playerQuit()
	local originalReportID = getElementData(source, "adminreport")
	local update = false
	local alreadyTold = { }

	if originalReportID then
		-- find the actual report id
		local report = nil
		for i = 1, originalReportID do
			if reports[i] and reports[i][1] and reports[i][1] == source then
				report = i
				break
			end
		end
		if report and reports[report] then
			local theAdmin = reports[report][5]
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[report][7])


			if (isElement(theAdmin)) then
					outputChatBox("(!) ["..abrv.." #" .. report .."] " .. getPlayerName(source) .. " isimli oyuncu, oyundan çıkış yaptı.", theAdmin, 255, 126, 0)--200, 240, 120)
			else
				if staff then
					for k, usergroup in ipairs(staff) do
						if string.find(auxiliaryTeams, usergroup) then
							for key, value in ipairs(getElementsByType("players")) do
								if getElementData(value, "loggedin") == 1 then
									if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
										outputChatBox(" ["..abrv.." #" .. report .."] " .. getPlayerName(source) .. " isimli oyuncu, oyundan çıkış yaptı.", value, 255, 126, 0)
										alreadyTold[value] = true
									end
								end
							end
						else
							for key, value in ipairs(getElementsByType("players")) do
								if getElementData(value, "loggedin") == 1 then
									if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
										local gmduty = getElementData(value, "duty_supporter")
										local adminduty = getElementData(value, "duty_admin")
										if adminduty == 1 or gmduty == 1 then
											outputChatBox("(!) ["..abrv.." #" .. report .."] " .. getPlayerName(source) .. " isimli oyuncu, oyundan çıkış yaptı.", value, 255, 126, 0)
											alreadyTold[value] = true
										end
									end
								end
							end
						end
					end
				end
			end

			local alertTimer = reports[report][6]
			--local timeoutTimer = reports[report][7]

			if isTimer(alertTimer) then
				killTimer(alertTimer)
			end

			if reports[report] then
				reports[report] = nil
			end
			update = true
		else
			--outputDebugString('report/onPlayerQuit: ' .. getPlayerName(source) .. ' has undefined report pending')
		end
	end

	local alreadyTold = { }
	-- check for reports assigned to him, unassigned if neccessary
	for i = 1, #reports do
		if reports[i] and reports[i][5] == 5 then
			reports[i][5] = nil
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[i][7])
			if staff then -- Check if the aux players are online
				for k, usergroup in ipairs(staff) do
					if string.find(auxiliaryTeams, usergroup) then
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
									local adminName = getElementData(source, "account:username")
									outputChatBox("(!) ["..abrv.." #" .. i .."] Rapor düştü. (" .. adminName .. " isimli yetkili oyundan çıkış yaptı.)", value, 255, 126, 0)
									alreadyTold[value] = true
									update = true
								end
							end
						end
					else
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
									local gmduty = getElementData(value, "duty_supporter")
									local adminduty = getElementData(value, "duty_admin")
									if adminduty == 1 or gmduty == 1 then
										local adminName = getElementData(source, "account:username")
										outputChatBox("(!) ["..abrv.." #" .. i .."] Rapor düştü. (" .. adminName .. " isimli yetkili oyundan çıkış yaptı.)", value, 255, 126, 0)
										alreadyTold[value] = true
										update = true
									end
								end
							end
						end
					end
				end
			else
				update = true
			end
		elseif reports[i] and reports[i][2] == source then
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[i][7])
			if staff then -- Check if the aux players are online
				for k, usergroup in ipairs(staff) do
					if string.find(auxiliaryTeams, usergroup) then
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
									local adminName = getElementData(source, "account:username")
									outputChatBox("(!) ["..abrv.." #" .. i .."] Rapor düştü. Rapor edilen oyuncu '" .. getPlayerName(source) .. "' oyundan çıkış yaptı.", value, 255, 126, 0)
									alreadyTold[value] = true
									update = true
								end
							end
						end
					else
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
									local gmduty = getElementData(value, "duty_supporter")
									local adminduty = getElementData(value, "duty_admin")
									if adminduty == 1 or gmduty == 1 then
										outputChatBox(" ["..abrv.." #" .. i .."] Reported Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)--200, 240, 120)
										update = true
										alreadyTold[value] = true
									end
								end
							end
						end
					end
				end
			else
				update = true
			end
			local reporter = reports[i][1]
			if reporter ~= source then
				local adminName = getElementData(source, "account:username")
				outputChatBox("(( Raporunuz "..abrv.."#" .. i .. " kapatıldı. (" .. adminName .. " isimli yetkili oyundan çıkış yaptı.) ))", reporter, 255, 126, 0)--200, 240, 120)
				exports["anticheat"]:changeProtectedElementDataEx(reporter, "adminreport", false, true)
				exports["anticheat"]:changeProtectedElementDataEx(reporter, "gmreport", false, true)
				exports["anticheat"]:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
			end

			local alertTimer = reports[i][6]
			--local timeoutTimer = reports[i][7]
			if isTimer(alertTimer) then
				killTimer(alertTimer)
			end
			--[[if isTimer(timeoutTimer) then
				killTimer(timeoutTimer)
			end]]
			reports[i] = nil -- Destroy any reports made by the player
		end
	end

	if exports["integration"]:isPlayerStaff(source) then -- Check if a Aux staff member went offline and there is noone left to handle the report.
		for i = 1, #reports do
			if reports[i] then
				local staff, _ = getReportInfo(reports[i][7], source)
				if not staff then
					outputChatBox(_, reports[i][1], 255, 0, 0)
					outputChatBox("(( Raporunuz otomatik olarak kapatıldı. ))", reports[i][1], 255, 0, 0)
					reports[i] = nil
					update = true
				end
			end
		end
	end

	local requested = getElementData(source, "ckstatus") -- Clear any Self-CK requests the player may have.
	if (requested=="requested") then
		for key, value in ipairs(exports["global"]:getAdmins()) do
			triggerClientEvent( value, "subtractOneFromCKCount", value )
		end
		setElementData(source, "ckstatus", 0)
		setElementData(source, "ckreason", 0)
	end

	if update then
		sortReports(true)
		updateReportCount()
	end


end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)
addEventHandler("accounts:characters:change", getRootElement(), playerQuit)

function playerConnect()
	if exports["integration"]:isPlayerTrialAdmin(source) then
		local players = exports["pool"]:getPoolElementsByType("player")
		for key, value in ipairs(players) do
			local logged = getElementData(value, "loggedin")
			if (logged==1) then
				local requested = getElementData(value, "ckstatus")
				if requested=="requested" then
					triggerClientEvent( source, "addOneToCKCountFromSpawn", source )
				end
			end
		end
	end
end
addEventHandler("accounts:characters:spawn", getRootElement(), playerConnect)


function handleReport(reportedPlayer, reportedReason, reportType, includeSS)
	local staff, errors, name, abrv, r, g, b = getReportInfo(reportType)
	if not staff then
		outputChatBox(errors, source, 255, 0, 0)
		return
	end

	if getElementData(reportedPlayer, "loggedin") ~= 1 then
		outputChatBox("(( Şikayet ettiğiniz oyuncu henüz giriş yapmadı. ))", source, 255, 0, 0)
		return
	end
	-- Find a free report slot
	local slot = nil

	sortReports(false)

	for i = 1, getMaxPlayers() do
		if not reports[i] then
			slot = i
			break
		end
	end

	local hours, minutes = getTime()

	-- Fix hours
	if (hours<10) then
		hours = "0" .. hours
	end

	-- Fix minutes
	if (minutes<10) then
		minutes = "0" .. minutes
	end

	local timestring = hours .. ":" .. minutes


	--local alertTimer = setTimer(alertPendingReport, 123500, 2, slot)
	--local alertTimer = setTimer(alertPendingReport, 123500, 0, slot)
	--local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, slot)

	-- Store report information
	reports[slot] = { }
	reports[slot][1] = source -- Reporter
	reports[slot][2] = reportedPlayer -- Reported Player
	reports[slot][3] = reportedReason -- Reported Reason
	reports[slot][4] = timestring -- Time reported at
	reports[slot][5] = nil -- Admin dealing with the report
	reports[slot][6] = alertTimer -- Alert timer of the report
	reports[slot][7] = reportType -- Report Type, table row for new report types / Chaos
	reports[slot][8] = slot -- Report ID/Slot, used in rolling queue function / Maxime
	reports[slot][9] = includeSS -- Report ID/Slot, used in rolling queue function / Maxime

	local playerID = getElementData(source, "playerid")
	local reportedID = getElementData(reportedPlayer, "playerid")
	setElementData(source, "reportNum", slot)

	exports["anticheat"]:changeProtectedElementDataEx(source, "adminreport", slot, true)
	exports["anticheat"]:changeProtectedElementDataEx(source, "reportadmin", false)
	local count = 0
	local nigger = 0
	local skipadmin = false
	local gmsTold = false
	local playergotit = false
	local alreadyCalled	= { }

	for _, usergroup in ipairs(staff) do
		if string.find(SUPPORTER, usergroup) then -- Supporters
			exports["anticheat"]:changeProtectedElementDataEx(source, "gmreport", slot, true)
			local GMs = exports["global"]:getGameMasters()

			for key, value in ipairs(GMs) do
				local gmDuty = getElementData(value, "duty_supporter")
				if (gmDuty == 1) then
					nigger = nigger + 1
					outputChatBox("(!) ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " isimli oyuncu destek istiyor.", value, r, g, b)
					outputChatBox(" - Soru: " .. reportedReason, value, 200, 240, 120)
					if includeSS then
						outputChatBox(" - (*) Rapora ilişkin 1 ekran görüntüsü eklenmiştir.", value, 200, 240, 120)	
					end
					-- if reason2 and #reason2 > 0 then
						-- outputChatBox(reason2, value, 70, 220, 30)
					-- end
					skipadmin = true
				end
				count = count + 1
			end


			-- No GMS online
			if not skipadmin then
				local GMs = exports["global"]:getAdmins()
				-- Show to GMs
				--local reason1 = reportedReason:sub( 0, 70 )
				--local reason2 = reportedReason:sub( 71 )
				for key, value in ipairs(GMs) do
					local gmDuty = getElementData(value, "duty_admin")
					if (gmDuty == 1) then
						outputChatBox("(!) ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " isimli oyuncu destek istiyor.", value, r, g, b)--200, 240, 120)
						outputChatBox(" - Soru: " .. reportedReason, value, 200, 240, 120)
						skipadmin = true
						-- if reason2 and #reason2 > 0 then
							-- outputChatBox(reason2, value, 200, 240, 120)
						-- end
					end
					count = count - 1
				end
			end

			outputChatBox("(( Raporunuzu gönderdiğiniz için teşekkürler. (Sıra Numaranız: #" .. tostring(slot) .. "). ))", source, 70, 200, 30)

			outputChatBox("(( Raporunuzu /rs veya /raporsonlandir yazarak istediğiniz zaman sonlandırabilirsiniz. ))", source, 70, 200, 30)
		elseif string.find(auxiliaryTeams, usergroup) then -- Auxiliary Teams
			for key, value in ipairs(getElementsByType("player")) do
				if getElementData(value, "loggedin") == 1 then
					if exports["integration"]:isPlayerTrialAdmin(value) then -- Opens up functionality to have reports ONLY go to leaders or only members
						outputChatBox("(!) ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " isimli oyuncu yardım talep ediyor. [Saat: " .. timestring .. "]", value, r, g, b)--200, 240, 120)
						outputChatBox(" - Gerekçe: " .. reportedReason, value, 200, 240, 120)
						if includeSS then
							outputChatBox(" - (*) Rapora ilişkin 1 ekran görüntüsü eklenmiştir.", value, 200, 240, 120)	
						end
					end
				end
			end
			outputChatBox("(( Raporunuzu gönderdiğiniz için teşekkürler. (Sıra Numaranız: #" .. tostring(slot) .. "). ))", source, 200, 240, 120)
			outputChatBox("(( Şikayet ettiğiniz oyuncu: (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " ))", source, 237, 145, 33 )
			outputChatBox("(( - Gerekçe: " .. reportedReason .. " ))", source, 200, 240, 120)
			outputChatBox("(( Raporunuzu istediğiniz zaman /rs veya /raporsonlandir yazarak sonlandırabilirsiniz.)).", source, 200, 240, 120)
			break
		else -- Admins
			local admins = exports["global"]:getAdmins()
			local count = 0
			local faggots = 0

			if not skipadmin then
				for key, value in ipairs(admins) do
					local adminduty = getElementData(value, "duty_admin")
					if (adminduty==1) and not alreadyCalled[value] then
						faggots = faggots + 1
						outputChatBox("(!) ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " isimli oyuncu yardım talep ediyor. [Saat: " .. timestring .. "]", value, r, g, b)--200, 240, 120)
						outputChatBox(" - Gerekçe: " .. reportedReason, value, 200, 240, 120)
						alreadyCalled[value] = true
					end
					if getElementData(value, "hiddenadmin") ~= 1 then
						count = count + 1
					end
				end

				if not gmsTold then
					local GMs = exports["global"]:getGameMasters()
					for key, value in ipairs(GMs) do
						local gmDuty = getElementData(value, "duty_supporter")
						if (gmDuty == 1) and getElementData(value, "report-system:subcribeToAdminReports") then
							outputChatBox("(!) ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " isimli oyuncu yardım talep ediyor. [Saat: " .. timestring .. "]", value, r, g, b)--200, 240, 120)
							outputChatBox(" - Gerekçe: " .. reportedReason, value, 200, 240, 120)
							gmsTold = true
						end
					end
				end

				if not playergotit then
					outputChatBox("(( Raporunuzu gönderdiğiniz için teşekkürler. (Sıra Numaranız: #" .. tostring(slot) .. "). ))", source, 200, 240, 120)
					outputChatBox("(( Şikayet ettiğiniz oyuncu: (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. ". ))", source, 237, 145, 33 )
					outputChatBox("(( Gerekçe: " .. reportedReason .. " ))", source, 200, 240, 120)
					-- if reason2 and #reason2 > 0 then
						-- outputChatBox(reason2, source, 200, 240, 120)
					-- end
					outputChatBox("(( Bir yetkili en kısa zamanda raporunuzla ilgilenecektir. Şu anda toplam " .. faggots .. " yetkili uygun. ))", source, 200, 240, 120)
					outputChatBox("(( Raporunuzu istediğiniz zaman /rs veya /raporsonlandir yazarak sonlandırabilirsiniz. ))", source, 200, 240, 120)
					playergotit = true
				end
			end
		end
	end
	updateReportCount()
end

function subscribeToAdminsReports(thePlayer)
	if exports["integration"]:isPlayerSupporter(thePlayer) then
		if getElementData(thePlayer, "report-system:subcribeToAdminReports") then
			setElementData(thePlayer, "report-system:subcribeToAdminReports", false)
			outputChatBox("(( Raporları takip etmeyi bıraktınız. ))",thePlayer, 255,0,0)
		else
			setElementData(thePlayer, "report-system:subcribeToAdminReports", true)
			outputChatBox("(( Artık raporları takip ediyorsunuz. ))",thePlayer, 0,255,0)
		end
	end
end
addCommandHandler("showadminreports", subscribeToAdminsReports)
addCommandHandler("raportakip", subscribeToAdminsReports)

addEvent("clientSendReport", true)
addEventHandler("clientSendReport", getRootElement(), handleReport)

function alertPendingReport(id)
	if (reports[id]) then
		local reportingPlayer = reports[id][1]
		local reportedPlayer = reports[id][2]
		local reportedReason = reports[id][3]
		local timestring = reports[id][4]
		local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
		local playerID = getElementData(reportingPlayer, "playerid")
		local reportedID = getElementData(reportedPlayer, "playerid")
		local alreadyTold = { }

		if staff then
			for k, usergroup in ipairs(staff) do
				if string.find(auxiliaryTeams, usergroup) then
					for key, value in ipairs(getElementsByType("player")) do
						if getElementData(value, "loggedin") == 1 then
							if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
								outputChatBox("(!) [#" .. id .. "] sıra numaralı rapor hala yanıtlanmamıştır: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " isimli oyuncu (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " isimli oyuncuyu rapor ediyor. Saat: " .. timestring .. ".", value, 200, 240, 120)
								alreadyTold[value] = true
							end
						end
					end
				else
					for key, value in ipairs(getElementsByType("player")) do
						if getElementData(value, "loggedin") == 1 then
							if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
								local gmduty = getElementData(value, "duty_supporter")
								local adminduty = getElementData(value, "duty_admin")
								if (gmduty==1) or (adminduty==1) then
									outputChatBox("(!) [#" .. id .. "] sıra numaralı rapor hala yanıtlanmamıştır: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " isimli oyuncu (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " isimli oyuncuyu rapor ediyor. Saat: " .. timestring .. ".", value, 200, 240, 120)
								end
							end
						end
					end
				end
			end
		end
	end
end

--[[
function pendingReportTimeout(id)
	if (reports[id]) then

		local reportingPlayer = reports[id][1]
		local isGMreport = reports[id][8]
		-- Destroy the report
		local alertTimer = reports[id][6]
		local timeoutTimer = reports[id][7]

		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end

		if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end

		reports[id] = nil -- Destroy any reports made by the player


		exports["anticheat"]:changeProtectedElementDataEx(reportingPlayer, "reportadmin", false, false)

		local hours, minutes = getTime()

		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end

		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end

		local timestring = hours .. ":" .. minutes

		if isGMreport then
			exports["anticheat"]:changeProtectedElementDataEx(reportingPlayer, "gmreport", false, false)
			local GMs = exports["global"]:getGameMasters()
			for key, value in ipairs(GMs) do
				local gmduty = getElementData(value, "duty_supporter")
				if (gmduty== true) then
					outputChatBox(" [GM #" .. id .. "] - REPORT #" .. id .. " has expired!", value, 200, 240, 120)
				end
			end
		else
			exports["anticheat"]:changeProtectedElementDataEx(reportingPlayer, "report", false, false)
			local admins = exports["global"]:getAdmins()
			-- Show to admins
			for key, value in ipairs(admins) do
				local adminduty = getElementData(value, "duty_admin")
				if (adminduty==1) then
					outputChatBox(" [#" .. id .. "] - REPORT #" .. id .. " has expired!", value, 200, 240, 120)
				end
			end
		end

		outputChatBox("[" .. timestring .. "] Your report (#" .. id .. ") has expired.", reportingPlayer, 200, 240, 120)
		outputChatBox("[" .. timestring .. "] If you still require assistance, please resubmit your report or visit our forums (http://forums.owlgaming.net).", reportingPlayer, 200, 240, 120)
		sortReports(false)
		updateReportCount()
	end
end]]

function falseReport(thePlayer, commandName, id)
	if exports["integration"]:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("(( KOMUT: /" .. commandName .. " [Rapor ID] - Raporu iptal eder. ))", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("(( Geçersiz rapor ID. ))", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]

				if (reportHandler) then

					outputChatBox("(!) #" .. id .. " sıra numaralı rapor ile " .. getPlayerName(reportHandler) .. " ("..getElementData(reportHandler,"account:username")..") isimli yetkili ilgilenmektedir.", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]

					--[[
					if reportedPlayer == thePlayer and not exports["integration"]:isPlayerSeniorAdmin(thePlayer) and not isAuxiliaryReport(reports[id][7]) then
						outputChatBox("You better let someone else to handler this report because it's against you.",thePlayer, 255,0,0)
						return false
					end
					]] -- Disabled because staff report is not going to be handled in game anyway / MAXIME / 2015.1.26

					local reason = reports[id][3]
					local alertTimer = reports[id][6]
					--local timeoutTimer = reports[id][7]
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])

					local found = false
					
					--[[for k, userg in ipairs(staff) do
						if exports["integration"]:isPlayerTrialAdmin( userg ) then
							found = true
						end
					end]]
					if not found and not exports["integration"]:isPlayerSeniorAdmin(thePlayer) then
						outputChatBox("(!) Üzerinize vazife olmayan raporları iptal edemezsiniz.", thePlayer, 255, 0, 0)
						return
					end

					local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)

					local adminUsername = getElementData(thePlayer, "account:username")

					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end

					--[[if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end]]

					reports[id] = nil
					local alreadyTold = { }
					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					local timestring = hours .. ":" .. minutes
					exports["anticheat"]:changeProtectedElementDataEx(reportingPlayer, "adminreport", false, true)
					exports["anticheat"]:changeProtectedElementDataEx(reportingPlayer, "gmreport", false, true)
					exports["anticheat"]:changeProtectedElementDataEx(reportingPlayer, "reportadmin", true, true)


					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
											outputChatBox(" [#" .. id .. "] - "..adminTitle.." ".. getPlayerName(thePlayer) .. " ("..adminUsername..") isimli yetkili #" .. id .. " sıra numaralı raporu iptal etti. -", value, r, g, b)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox(" [#" .. id .. "] - "..adminTitle.." ".. getPlayerName(thePlayer) .. " ("..adminUsername..") isimli yetkili #" .. id .. " sıra numaralı raporu iptal etti. -", value, r, g, b)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					outputChatBox("(( [" .. timestring .. "] Raporunuz (#" .. id .. ") "..adminTitle.." ".. getPlayerName(thePlayer) .. " ("..adminUsername..") isimli yetkili tarafından iptal edilmiştir. [Lütfen tekrar rapor atarken rapor kurallarını inceleyiniz.] ))", reportingPlayer, r, g, b)--200, 240, 120)
					triggerClientEvent ( reportingPlayer, "playNudgeSound", reportingPlayer)
					--local accountID = getElementData(thePlayer, "account:id")
					--exports["logs"]:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " maked a report as false. Report: " .. reason )
					sortReports(true)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("falsereport", falseReport, false, false)
addCommandHandler("fr", falseReport, false, false)
addCommandHandler("ri", falseReport, false, false)
addCommandHandler("raporiptal", falseReport, false, false)

function arBind()
	if exports["integration"]:isPlayerTrialAdmin(client) then
		--[[for k, arrayPlayer in ipairs(exports["global"]:getAdmins()) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if (logged) then
				exports["integration"]:isPlayerAdmin(arrayPlayer) then
					outputChatBox( "LeadAdmWarn: " .. getPlayerName(client) .. " has accept report bound to keys. ", arrayPlayer, 200, 240, 120)
				end

			end
		end]]
		exports["global"]:sendMessageToAdmins("AdmWarn: ".. getPlayerName(client) .. " isimli kişinin rapor kabul etme bindi var.")
	end
end
addEvent("arBind", true)
addEventHandler("arBind", getRootElement(), arBind)

function acceptReport(thePlayer, commandName, id)
	if exports["integration"]:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("(( KOMUT: /" .. commandName .. " [Rapor ID] ))", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("(( Geçersiz rapor ID. ))", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]

				if (reportHandler) then
					outputChatBox("(( #" .. id .. " sıra numaralı rapor ile " .. getPlayerName(reportHandler) .. " isimli yetkili ilgilenmektedir.", thePlayer, 255, 0, 0)
				else

					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]

					if reportingPlayer == thePlayer and not exports["integration"]:isPlayerScripter(thePlayer) then
						outputChatBox("(( Kendi raporunuzu kabul edemezsiniz. ))",thePlayer, 255,0,0)
						return false
					--[[
					elseif reportedPlayer == thePlayer and not exports["integration"]:isPlayerSeniorAdmin(thePlayer) then
						outputChatBox("You better let someone else to handler this report because it's against you.",thePlayer, 255,0,0)
						return false
						]] -- Disabled because staff report is not going to be handled in game anyway / MAXIME / 2015.1.26
					end

					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])


					local reason = reports[id][3]
					local alertTimer = reports[id][6]
					--local timeoutTimer = reports[id][7]
					local alreadyTold = { }

					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end

					--[[if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end]]

					reports[id][5] = thePlayer -- Admin dealing with this report

					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					exports["anticheat"]:changeProtectedElementDataEx(reportingPlayer, "reportadmin", thePlayer, false)

					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")

					local adminName = getElementData(thePlayer,"account:username")
					local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)


					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
											outputChatBox(" ["..abrv.." #" .. id .. "] - "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") isimli yetkili #" .. id .. " sıra numaralı raporu kabul etti. -", value, r, g, b)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox(" ["..abrv.." #" .. id .. "] - "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") isimli yetkili #" .. id .. " sıra numaralı raporu kabul etti. -", value, r, g, b)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					outputChatBox("(( " .. adminTitle.." " .. getPlayerName(thePlayer) .. " ("..adminName..") isimli yetkili raporunuzu kabul etti. (#" .. id .. ") [Saat: "..timestring.."], lütfen ilgili yetkilinin size ulaşmasını bekleyin. ))", reportingPlayer, 255,126, 0)--200, 240, 120)
					triggerClientEvent ( reportingPlayer, "playNudgeSound", reportingPlayer)

					outputChatBox("(( #" .. id .. " sıra numaralı raporu devraldınız. Lütfen oyuncuya ulaşın. #" .. playerID .. " (" .. getPlayerName(reportingPlayer) .. ") ))", thePlayer, r, g, b)--200, 240, 120)

					if reports[id][9] then
						outputChatBox("(!) Bu rapora ilişkin 1 adet ekran görüntüsü eklenmiştir. /rekran yazarak görüntüleyebilir, aynı komutla tekrar kapatabilirsiniz.", thePlayer, 255, 150, 10)
					end
					
					if getElementData(thePlayer, "report:autocheck") then
						triggerClientEvent( thePlayer, "report:onOpenCheck", thePlayer, tostring(playerID) )
					end

					setElementData(thePlayer, "targetPMer", reportingPlayer, false)
					--setElementData(reportingPlayer, "targetPMed", thePlayer, false)

					--local accountID = getElementData(thePlayer, "account:id")
					--exports["logs"]:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " accepted a report. Report: " .. reason )
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("acceptreport", acceptReport, false, false)
addCommandHandler("ar", acceptReport, false, false)
addCommandHandler("kr", acceptReport, false, false)
addCommandHandler("raporkabul", acceptReport, false, false)

function toggleAutoCheck(thePlayer)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer)) then
		if getElementData(thePlayer, "report:autocheck") then
			setElementData(thePlayer, "report:autocheck", false)
			outputChatBox(" You've just disabled auto /check on /ar.", thePlayer, 255, 0,0)
		else
			setElementData(thePlayer, "report:autocheck", true)
			outputChatBox(" You've just enabled auto /check on /ar.", thePlayer, 0, 255,0)
		end
	end
end
addCommandHandler("toggleautocheck", toggleAutoCheck, false, false)
addCommandHandler("togautocheck", toggleAutoCheck, false, false)

function acceptAdminReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports["integration"]:isPlayerSeniorAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("(( KOMUT: /" .. commandName .. " [Rapor ID] [Yetkili İsmi] ))", thePlayer, 255, 194, 14)
		else
			local targetAdmin, username = exports["global"]:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("(( Geçersiz rapor ID. ))", thePlayer, 255, 0, 0)
				else
					local reportHandler = reports[id][5]

					if (reportHandler) then
						outputChatBox("(( #" .. id .. " sıra numaralı rapor ile " .. getPlayerName(reportHandler) .. " isimli yetkili ilgilenmektedir. ))", thePlayer, 255, 0, 0)
					else
						local reportingPlayer = reports[id][1]
						local reportedPlayer = reports[id][2]
						local reason = reports[id][3]
						local alertTimer = reports[id][6]
						--local timeoutTimer = reports[id][7]
						local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
						if isTimer(alertTimer) then
							killTimer(alertTimer)
						end

						--[[if isTimer(timeoutTimer) then
							killTimer(timeoutTimer)
						end]]

						reports[id][5] = targetAdmin -- Admin dealing with this report

						local hours, minutes = getTime()

						-- Fix hours
						if (hours<10) then
							hours = "0" .. hours
						end

						-- Fix minutes
						if (minutes<10) then
							minutes = "0" .. minutes
						end

						exports["anticheat"]:changeProtectedElementDataEx(reportingPlayer, "reportadmin", targetAdmin, false)

						local timestring = hours .. ":" .. minutes
						local playerID = getElementData(reportingPlayer, "playerid")
						local adminTitle = exports["global"]:getPlayerAdminTitle(targetAdmin)

						outputChatBox("(( [" .. timestring .. "] "..adminTitle.." " .. getPlayerName(targetAdmin) .. " isimli yetkili raporunuzu kabul etti (#" .. id .. "), lütfen ilgili yetkilinin size ulaşmasını bekleyin. ))", reportingPlayer, 200, 240, 120)
						outputChatBox("(( Bir Üst Düzey Yetkili #" .. id .. " sıra numaralı raporu size atadı. Lütfen oyuncuya ulaşın. ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ") ))", targetAdmin, 200, 240, 120)
						local alreadyTold = { }

						if staff then
							for k, usergroup in ipairs(staff) do
								if string.find(auxiliaryTeams, usergroup) then
									for key, value in ipairs(getElementsByType("player")) do
										if getElementData(value, "loggedin") == 1 then
											if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
												outputChatBox(" ["..abrv.." #" .. id .. "] - " .. getPlayerName(theAdmin) .. " isimli yetkili #" .. id .. " sıra numaralı raporu kabul etti. (Atandı) -", value, r, g, b)
												alreadyTold[value] = true
											end
										end
									end
								else
									for key, value in ipairs(getElementsByType("player")) do
										if getElementData(value, "loggedin") == 1 then
											if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
												local adminduty = getElementData(value, "duty_admin")
												local gmduty = getElementData(value, "duty_supporter")
												if (adminduty==1) or (gmduty==1) then
													outputChatBox(" ["..abrv.." #" .. id .. "] - " .. getPlayerName(theAdmin) .. " isimli yetkili #" .. id .. " sıra numaralı raporu kabul etti. (Atandı) -", value, r, g, b)--200, 240, 120)
													alreadyTold[value] = true
												end
											end
										end
									end
								end
							end
						end

						--local accountID = getElementData(thePlayer, "account:id")
						--exports["logs"]:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " was assigned a report. Report: " .. reason )
						sortReports(false)
						updateReportCount()
					end
				end
			end
		end
	end
end
addCommandHandler("ara", acceptAdminReport, false, false)
addCommandHandler("raporata", acceptAdminReport, false, false)
addCommandHandler("ata", acceptAdminReport, false, false)


function transferReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports["integration"]:isPlayerSeniorAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("(( KOMUT: /" .. commandName .. " [Rapor ID] [Yetkili Adı] ))", thePlayer, 200, 240, 120)
		else
			local targetAdmin, username = exports["global"]:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("(( Geçersiz rapor ID. ))", thePlayer, 255, 0, 0)
				elseif (reports[id][5] ~= thePlayer) and not (exports["integration"]:isPlayerAdmin(thePlayer)) then
					outputChatBox("(( Bu raporla siz ilgilenmiyorsunuz. ))", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local report = reports[id][3]
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
					reports[id][5] = targetAdmin -- Admin dealing with this report

					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					local alreadyTold = { }
					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")

					outputChatBox("(( [" .. timestring .. "] " .. getPlayerName(thePlayer) .. " isimli yetkili raporunuzu ".. getPlayerName(targetAdmin) .." isimli yetkiliye yönlendirdi. (#" .. id .. "), lütfen yeni yetkili size ulaşana kadar bekleyin. ))", reportingPlayer, 200, 240, 120)
					outputChatBox("(( " .. getPlayerName(thePlayer) .. " isimli yetkili #" .. id .. " sıra numaralı raporu size yönlendirdi. Lütfen raporu gönderen oyuncuya ulaşın. ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. "). ))", targetAdmin, 200, 240, 120)

					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
											outputChatBox("(( [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " isimli yetkili #" .. id .. " sıra numaralı raporu ".. getPlayerName(targetAdmin) .. " isimli yetkiliye yönlendirdi. ))", value, r, g, b)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox("(( [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " isimli yetkili #" .. id .. " sıra numaralı raporu  ".. getPlayerName(targetAdmin) .. " isimli yetkiliye yönlendirdi. ))", value, r, g, b)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("transferreport", transferReport, false, false)
addCommandHandler("tr", transferReport, false, false)

function closeReport(thePlayer, commandName, id)
	if exports["integration"]:isPlayerStaff(thePlayer) then
		if not (id) then
			closeAllReports(thePlayer)
			--outputChatBox("KOMUT: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
			if (reports[id]==nil) then
				outputChatBox("(( Geçersiz rapor ID. ))", thePlayer, 255, 0, 0)
			elseif (reports[id][5] ~= thePlayer) then
				outputChatBox("(( Bu raporla siz ilgilenmiyorsunuz. ))", thePlayer, 255, 0, 0)
			else
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local alertTimer = reports[id][6]
				local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
				local alreadyTold = { }

				if isTimer(alertTimer) then
					killTimer(alertTimer)
				end

				--[[if isTimer(timeoutTimer) then
					killTimer(timeoutTimer)
				end]]

				reports[id] = nil

				local adminName = getElementData(thePlayer,"account:username")
				local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)

				if (isElement(reporter)) then
					exports["anticheat"]:changeProtectedElementDataEx(reporter, "adminreport", false, true)
					exports["anticheat"]:changeProtectedElementDataEx(reporter, "gmreport", false, true)
					exports["anticheat"]:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
					removeElementData(reporter, "reportNum")
					outputChatBox("(( " .. adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") isimli yetkili raporunuzu kapattı. ))", reporter, r, g, b)
					triggerClientEvent(reporter, "feedback:form", thePlayer) -- Staff feedback / Maxime / 2015.1.29
				end

				if staff then
					for k, usergroup in ipairs(staff) do
						if string.find(auxiliaryTeams, usergroup) then
							for key, value in ipairs(getElementsByType("player")) do
								if getElementData(value, "loggedin") == 1 then
									if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
										outputChatBox(" ["..abrv.." #" .. id .. "] - "..adminTitle.." " .. getPlayerName(thePlayer) .. " ("..adminName..") has closed the report #" .. id .. ". -", value, r, g, b)
										alreadyTold[value] = true
									end
								end
							end
						else
							for key, value in ipairs(getElementsByType("player")) do
								if getElementData(value, "loggedin") == 1 then
									if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
										local adminduty = getElementData(value, "duty_admin")
										local gmduty = getElementData(value, "duty_supporter")
										if (adminduty==1) or (gmduty==1) then
											outputChatBox(" ["..abrv.." #" .. id .. "] - "..adminTitle.." " .. getPlayerName(thePlayer) .. " ("..adminName..") has closed the report #" .. id .. ". -", value, r, g, b)--200, 240, 120)
											alreadyTold[value] = true
										end
									end
								end
							end
						end
					end
				end

				--local accountID = getElementData(thePlayer, "account:id")
				--dbExec(exports["mysql"]:getConnection(), "INSERT INTO `raporlar` SET `yetkili` = ?, `sikayetci` = ?, `sebep` = ?", getPlayerName(thePlayer), reporter, reason)
				--exports["logs"]:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reporter, reported}, getPlayerName(thePlayer) .. " closed a report. Report: " .. reason )

				sortReports(true)
				updateReportCount()
				updateStaffReportCount(thePlayer)
			end
		end
	end
end
addCommandHandler("closereport", closeReport, false, false)
addCommandHandler("cr", closeReport, false, false)
addCommandHandler("rk", closeReport, false, false)
addCommandHandler("raporukapat", closeReport, false, false)

function closeAllReports(thePlayer)
	if exports["integration"]:isPlayerStaff(thePlayer) then
		--outputChatBox("~~~~~~~~~ Unanswered Reports ~~~~~~~~~", thePlayer, 0, 255, 15)
		--reports = sortReportsByTime(reports)
		local count = 0
		for i = 1, getMaxPlayers() do
			local report = reports[i]
			if report then
				local admin = report[5]
				if isElement(admin) and admin == thePlayer then
					closeReport(thePlayer, "cr" , i)
					count = count + 1
				end
			end
		end

		if count == 0 then
			outputChatBox("(!) Herhangi bir rapor kapatılmadı.", thePlayer, 255, 126, 0)--255, 194, 15)
		else
			outputChatBox("(!) Raporlarınızın "..count.." tanesini kapattınız.", thePlayer, 255, 126, 0)--255, 194, 15)
		end
	end
end
addCommandHandler("closeallreports", closeAllReports, false, false)
addCommandHandler("car", closeAllReports, false, false)
addCommandHandler("trk", closeAllReports, false, false)
addCommandHandler("tumraporlarikapat", closeAllReports, false, false)

function dropReport(thePlayer, commandName, id)
	if exports["integration"]:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("(( KOMUT: /" .. commandName .. " [ID] - Raporu düşürür/bırakır. ))", thePlayer, 255, 195, 14)
		else
			id = tonumber(id)
			if (reports[id] == nil) then
				outputChatBox("(( Geçersiz rapor ID. ))", thePlayer, 255, 0, 0)
			else
				if (reports[id][5] ~= thePlayer) then
					outputChatBox("(( Bu raporla siz ilgilenmiyorsunuz. )).", thePlayer, 255, 0, 0)
				else
					--local alertTimer = setTimer(alertPendingReport, 123500, 2, id)
					--local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, id)

					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local reason = reports[id][3]
					reports[id][5] = nil
					reports[id][6] = alertTimer
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
					--reports[id][7] = timeoutTimer

					local adminName = getElementData(thePlayer,"account:username")
					local adminTitle = exports["global"]:getPlayerAdminTitle(thePlayer)
					local alreadyTold = { }

					local reporter = reports[id][1]
					if (isElement(reporter)) then
						exports["anticheat"]:changeProtectedElementDataEx(reporter, "adminreport", id, true)
						exports["anticheat"]:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
						outputChatBox(adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") isimli yetkili raporunuzu bıraktı. Lütfen yeni bir yetkili raporunuzu devralana kadar bekleyin.", reporter, r, g, b)
					end

					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
											outputChatBox(" ["..abrv.." #" .. id .. "] - "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") isimli yetkili #" .. id .. " ID'li raporu bıraktı. -", value, r, g, b)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if exports["integration"]:isPlayerTrialAdmin(value) and not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox(" ["..abrv.." #" .. id .. "] - "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") isimli yetkili #" .. id .. " ID'li raporu bıraktı. -", value, r, g, b)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end
					--local accountID = getElementData(thePlayer, "account:id")
					--exports["logs"]:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " dropped a report. Report: " .. reason )
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("dropreport", dropReport, false, false)
addCommandHandler("dr", dropReport, false, false)
addCommandHandler("rb", dropReport, false, false)
addCommandHandler("raporubirak", dropReport, false, false)
addCommandHandler("raporubırak", dropReport, false, false)

function endReport(thePlayer, commandName)
	local adminreport = getElementData(thePlayer, "adminreport")
	local gmreport = getElementData(thePlayer, "gmreport")

	local report = false
	for i=1, getMaxPlayers() do
		if reports[i] and (reports[i][1] == thePlayer) then
			report = i
			break
		end
	end

	if not adminreport or not report then
		outputChatBox("(( Herhangi bir raporunuz bulunamadı. Yardım merkezinden (/rapor veya F2) yeni bir rapor gönderebilirsiniz. ))", thePlayer, 255, 0, 0)
		exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "adminreport", false, true)
		exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "gmreport", false, true)
		exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "reportadmin", false, false)
	else
		local hours, minutes = getTime()

		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end

		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end

		local timestring = hours .. ":" .. minutes
		local reportedPlayer = reports[report][2]
		--local reason = reports[report][3]
		local reportHandler = reports[report][5]
		local alertTimer = reports[report][6]
		--local timeoutTimer = reports[report][7]

		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end

		--[[if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end]]
		removeElementData(thePlayer, "reportNum")
		reports[report] = nil
		exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "adminreport", false, true)
		exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "gmreport", false, true)
		exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "reportadmin", false, false)

		outputChatBox("(( [" .. timestring .. "] Sıra numarası #"..report .. " olan raporunuzu başarıyla kapattınız. ))", thePlayer, 200, 240, 120)
		local otherAccountID = nil
		if (isElement(reportHandler)) then
			outputChatBox(getPlayerName(thePlayer) .. " kendi raporunu kapattı. (Sıra Numarası: #" .. report .. ")", reportHandler, 255, 126, 0)--200, 240, 120)
			otherAccountID = getElementData(reportHandler, "account:id")
			updateStaffReportCount(reportHandler)
			triggerClientEvent(thePlayer, "feedback:form", reportHandler) -- Staff feedback / Maxime / 2015.1.29
		end

		--local accountID = getElementData(thePlayer, "account:id")
		--local affected = { }
		-- table.insert(affected, reportedPlayer)
		-- if isElement(reportHandler) then
			-- table.insert(affected, reportHandler)
			-- table.insert(affected, "ac"..tostring(otherAccountID))
		-- end
		--exports["logs"]:dbLog({"ac"..tostring(accountID), thePlayer }, 38, affected, getPlayerName(thePlayer) .. " accepted a report. Report: " .. reason )
		sortReports(true)
		updateReportCount()
	end
end
addCommandHandler("endreport", endReport, false, false)
addCommandHandler("er", endReport, false, false)
addCommandHandler("raporusonlandir", endReport, false, false)
addCommandHandler("rs", endReport, false, false)

-- Output unanswered reports for staff.
function showUnansweredReports(thePlayer)
	if exports["integration"]:isPlayerStaff(thePlayer) then
		if showTopRightReportBox(thePlayer) then
			setElementData(thePlayer, "report:topRight", 1, true)
		else
			outputChatBox("~~~~~~~~~~ (!) YANITLANMAYAN RAPORLAR: ~~~~~~~~~~", thePlayer, 255, 50, 0) -- 255, 194, 15
			--reports = sortReportsByTime(reports)
			local count = 0
			local seenReport = { }
			for i = 1, #reports do
				local report = reports[i]
				if report then
					local reporter = report[1]
					local reported = report[2]
					local timestring = report[4]
					local admin = report[5]
					local staff, _, name, abrv, r, g, b = getReportInfo(report[7])

					local handler = ""
					if (isElement(admin)) then
						--handler = tostring(getPlayerName(admin))
					else
						handler = " - Yok."
						if staff then
							for k,v in ipairs(staff) do
								if not seenReport[i] then
									outputChatBox(" - Rapor "..abrv.."#" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' rapor ettiği oyuncu '" .. tostring(getPlayerName(reported)) .. "' rapor ettiği saat " .. timestring .. ".", thePlayer, r, g, b)
									count = count + 1
									seenReport[i] = true
								end
							end
						end
					end
				end
			end

			if count == 0 then
				outputChatBox(" - Yok.", thePlayer, 255, 194, 15)
			else
				outputChatBox("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", thePlayer, 0, 255, 15)
				outputChatBox("Rapor hakkında detaylı bilgi almak için /ro [Rapor ID] yazın.", thePlayer, 255, 194, 15)
			end
		end
	end
end
addCommandHandler("ur", showUnansweredReports, false, false)
addCommandHandler("yr", showUnansweredReports, false, false)

function showReports(thePlayer)
	if (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer)) then
		if showTopRightReportBox(thePlayer) then
			setElementData(thePlayer, "report:topRight", 3, true)
		else
			outputChatBox("~~~~~~~~~~ (!) RAPORLAR: ~~~~~~~~~~", thePlayer, 255, 50, 0) -- 255, 194, 15
			--reports = sortReportsByTime(reports)
			local count = 0
			for i = 1, #reports do
				local report = reports[i]
				if report then
					local reporter = report[1]
					local reported = report[2]
					local timestring = report[4]
					local admin = report[5]
					local staff, _, name, abrv, r, g, b = getReportInfo(report[7])
					local seenReport = { }
					local handler = ""

					if (isElement(admin)) then
						local adminName = getElementData(admin, "account:username")
						handler = tostring(getPlayerName(admin)).." ("..adminName..")"
					else
						handler = "- Yok."
					end
					if staff then
						for k,v in ipairs(staff) do
							if exports["integration"]:isPlayerTrialAdmin(thePlayer) and not seenReport[i] then
								outputChatBox("- Rapor "..abrv.."#" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' rapor ettiği oyuncu '" .. tostring(getPlayerName(reported)) .. "' rapor ettiği saat " .. timestring .. ". İlgilenen: " .. handler .. "", thePlayer, r, g, b)
								count = count + 1
								seenReport[i] = true
							end
						end
					end
				end
			end

			if count == 0 then
				outputChatBox("- Yok.", thePlayer, 255, 194, 15)
			else
				--outputChatBox("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", thePlayer, 255, 221, 117)
				--outputChatBox("Type /ri [id] to obtain more information about the report.", thePlayer, 255, 194, 15)
			end
		end
	end
end
addCommandHandler("reports", showReports, false, false)
addCommandHandler("raporlar", showReports, false, false)


function updateStaffReportCount(thePlayer)
	local adminreports = getElementData(thePlayer, "adminreports")
	adminreports = adminreports + 1
	exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "adminreports", adminreports, false)

	local adminreports_saved = getElementData(thePlayer, "adminreports_saved") or 0
	adminreports_saved = adminreports_saved + 1
	if adminreports_saved >= reportsToAward then
		exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "adminreports_saved", 0, false)
		exports["global"]:sendWrnToStaff(exports["global"]:getPlayerFullIdentity(thePlayer).." has won "..gcToAward.." GC for completing "..reportsToAward.." reports.", "ACHIEVEMENT")
	else
		exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "adminreports_saved", adminreports_saved, false)
	end
	getSavedReports(thePlayer)
end


function saveReportCount()
	local adminreports = getElementData(source, "adminreports")
	if tonumber(adminreports) then
		dbExec(mysql:getConnection(), "UPDATE `accounts` SET `adminreports`='"..adminreports.."' WHERE `id` = " .. (getElementData( source, "account:id" )) )
	end

	local adminreports_saved = getElementData(source, "adminreports_saved")
	if tonumber(adminreports_saved) then
		dbExec(mysql:getConnection(), "UPDATE `accounts` SET `adminreports_saved`='"..adminreports_saved.."' WHERE `id` = " .. (getElementData( source, "account:id" )) )
	end
end
addEventHandler("onPlayerQuit", getRootElement(), saveReportCount)


function getSavedReports(thePlayer)
	local adminreports_saved = getElementData(thePlayer, "adminreports_saved") or 0
	outputChatBox(" You have saved "..adminreports_saved.." reports. "..reportsToAward-adminreports_saved.." more to a reward!", thePlayer, 255, 126, 0)
end
addCommandHandler("getsavedreports", getSavedReports)

function setSavedReports(thePlayer, cmd, reports)
	if getElementData(thePlayer, "account:id") ~= 1 then
		return false
	end
	if reports and tonumber(reports) and tonumber(reports) >=0 then
		reports = tonumber(reports)
	else
		reports = 0
	end
	exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "adminreports_saved", reports , false)
	outputChatBox(" You have set saved report count to "..reports..".", thePlayer, 255, 126, 0)
end
addCommandHandler("setsavedreports", setSavedReports)

local thisResourceElement = getResourceRootElement(getThisResource())

--MAXIME MAGIC
function updateUnansweredReports()
	local info = {}
	table.insert(info, {string.upper(" Yanıtlanmayan Raporlar"), 255,194,14,255,1,"default-bold" })
	
	local count = 0
	for i = 1, 300 do
		local report = reports[i]
		if report then
			local reporter = report[1]
			local reported = report[2]
			local timestring = report[4]
			local admin = report[5]
			local staff, _, name, abrv, r, g, b = getReportInfo(report[7])
			local seenReport = { }
			
			local handler = ""
			if (isElement(admin)) then
			--handler = tostring(getPlayerName(admin))
			else
				handler = "Yok."
				if staff then
					for k,v in ipairs(staff) do
						if string.find(adminTeams, v) and not seenReport[i] then
							table.insert(info, {abrv.." Rapor #" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' reporting '" .. tostring(getPlayerName(reported)) .. "' at " .. timestring .. ". Handler: " .. handler .. "", r, g, b})
							seenReport[i] = true
						end
					end
					count = count + 1
				end
			end
		end
	end
	
	if count == 0 then
		table.insert(info, {"Yok."})
	else
		--
	end

	setElementData(thisResourceElement, "urAdmin", info, true)
end

function updateUnansweredReportsGMs()
	local info = {}
	table.insert(info, {string.upper(" Unanswered GameMaster Reports"), 255,194,14,255,1,"default-bold" })
	
	local count = 0
	for i = 1, 300 do
		local report = reports[i]
		if report then
			local reporter = report[1]
			local reported = report[2]
			local timestring = report[4]
			local admin = report[5]
			local staff, _, name, abrv, r, g, b = getReportInfo(report[7])
			local seenReport = { }
			
			local handler = ""
			if (isElement(admin)) then
			--handler = tostring(getPlayerName(admin))
			else
				handler = "None."
				if staff then
					for k,v in ipairs(staff) do
						if SUPPORTER == v and not seenReport[i] then
							table.insert(info, {abrv.." Report #" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' reporting '" .. tostring(getPlayerName(reported)) .. "' at " .. timestring .. ". Handler: " .. handler .. "", r, g, b})
							seenReport[i] = true
						end
					end
					count = count + 1
				end
			end
		end
	end
	
	if count == 0 then
		table.insert(info, {"None."})
	else
		--
	end
	
	setElementData(thisResourceElement, "urGM", info, true)
end

function updateReports()
	local info = {}
	table.insert(info, {string.upper(" All Reports"), 255,194,14,255,1,"default-bold" })
	
	local count = 0
	for i = 1, 300 do
		local report = reports[i]
		if report then
			local reporter = report[1]
			local reported = report[2]
			local timestring = report[4]
			local admin = report[5]
			local staff, _, name, abrv, r, g, b = getReportInfo(report[7])
			local seenReport = { }
			
			local handler = ""
			
			if (isElement(admin)) then
				local adminName = getElementData(admin, "account:username")
				handler = tostring(getPlayerName(admin)).." ("..adminName..")"
			else
				handler = "None."
			end
			if staff then
				for k,v in ipairs(staff) do
					if not seenReport[i] then
						table.insert(info, {abrv.." Report #" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' reporting '" .. tostring(getPlayerName(reported)) .. "' at " .. timestring .. ". Handler: " .. handler .. "", r, g, b})
						seenReport[i] = true
					end
				end
				count = count + 1
			end
		end
	end
	
	if count == 0 then
		table.insert(info, {"None."})
	end
	
	setElementData(thisResourceElement, "allReports", info, true)
	
end
setTimer(updateUnansweredReports, 4000, 0)
setTimer(updateUnansweredReportsGMs, 5000, 0)
setTimer(updateReports, 6000, 0)