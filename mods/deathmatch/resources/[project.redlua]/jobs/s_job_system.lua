mysql = exports["mysql"]
local lockTimer = nil
chDimension = 125
chInterior = 3


-- EVENTS
addEvent("onPlayerAcceptJob", true)

function givePlayerJob(jobID)
	local oldJobID = getElementData(source, "job")
	local charname = getPlayerName(source)
	local charID = getElementData(source, "dbid")
	dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='"..tostring(jobID).."' WHERE `id`='"..(charID).."' ")

	fetchJobInfoForOnePlayer(source)
	triggerEvent("onPlayerAcceptJob", source, oldJobID, jobID)
end
addEvent("acceptJob", true)
addEventHandler("acceptJob", getRootElement(), givePlayerJob)

function fetchJobInfo()
	if not charID then
		for key, player in pairs(getElementsByType("player")) do
			fetchJobInfoForOnePlayer(player)
		end
	end
end
addEvent("job-system:fetchJobInfo", true)
addEventHandler("job-system:fetchJobInfo", getRootElement(), fetchJobInfo)

addEvent("meslek:event", true)
addEventHandler("meslek:event", root, function(arac)
	if isElement(arac) then
    	destroyElement(arac)
	end
end)

function fetchJobInfoForOnePlayer(thePlayer)
	local charID = getElementData(thePlayer, "dbid")
	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if row then
					local job = tonumber(row["job"])
					local jobID = tonumber(row["jobID"])
					if job and job == 0 then
						setElementData(thePlayer, "job", 0, true)
						setElementData(thePlayer, "jobLevel", 0 , true)
						setElementData(thePlayer, "jobProgress", 0, true)
						return true
					end

					if not jobID then
						dbExec(mysql:getConnection(),"INSERT INTO `jobs` SET `jobID`='"..tostring(job).."', `jobCharID`='"..(charID).."' ")
					end
				
					setElementData(thePlayer, "job", job, true)
					setElementData(thePlayer, "jobLevel", tonumber(row["jobLevel"]) or 1, true)
					setElementData(thePlayer, "jobProgress", tonumber(row["jobProgress"]) or 0, true)
				end
			end
		end
	end,
	mysql:getConnection(), "SELECT `job` , `jobID`, `jobLevel`, `jobProgress` FROM `characters` LEFT JOIN `jobs` ON `id` = `jobCharID` AND `job` = `jobID` WHERE `id`='" .. tostring(charID) .. "' ")
	return false
end
addEvent("job-system:fetchJobInfoForOnePlayer", true)
addEventHandler("job-system:fetchJobInfoForOnePlayer", getRootElement(), fetchJobInfo)

function printJobInfo(thePlayer)
	outputChatBox("~-~-~-~-~-~-~-~-~-~ Kariyer Bilgisi ~-~-~-~-~-~-~-~-~-~-~", thePlayer, 255, 194, 14)
	outputChatBox("İş: "..(getJobTitleFromID(getElementData(thePlayer, "job")) or "Unemployed") , thePlayer, 255, 194, 14)
	outputChatBox("Seviye: "..(tonumber(getElementData(thePlayer, "jobLevel")) or "0") , thePlayer, 255, 194, 14)
	outputChatBox("Süreç: "..(tonumber(getElementData(thePlayer, "jobProgress")) or "0") , thePlayer, 255, 194, 14)
	outputChatBox("~-~-~-~--~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-", thePlayer, 255, 194, 14)
end
addCommandHandler("myjob", printJobInfo)

function quitJob(source)
	local logged = getElementData(source, "loggedin")
	if logged == 1 then
		local job = getElementData(source, "job")
		if job == 0 then
			outputChatBox("Zaten bir meslekte değilsin.", source, 255, 0, 0)
		else
			local charID = getElementData(source, "dbid")
			dbExec(mysql:getConnection(),"UPDATE `characters` SET `job`='0' WHERE `id`='"..(charID).."' ")
			fetchJobInfoForOnePlayer(source)
			if job == 4 then
				exports["anticheat"]:changeProtectedElementDataEx(source, "tag", 1, false)
				dbExec(mysql:getConnection(),"UPDATE characters SET tag=1 WHERE id = " .. (charID) )
			end
		end
	end
end
addCommandHandler("endjob", quitJob, false, false)
addCommandHandler("quitjob", quitJob, false, false)


function setElementModel(skin)
	if skin then
		setElementModel(source, skin)
	end
end
addEvent("setElementModel", true)
addEventHandler("setElementModel", getRootElement(), setElementModel)

function deletePlayerVan(player)

	local aracim = getElementData(player, "meslek:aracim")
	if aracim and isElement(aracim) then
		destroyElement(aracim)
        triggerEvent("meslek:event", player, aracim)
	end
end
addEvent("deletePlayerVan", true)
addEventHandler("deletePlayerVan", getRootElement(), deletePlayerVan)

addEventHandler("onPlayerQuit", getRootElement(), 
function()
	local aracim = getElementData(source, "meslek:aracim") or false
	if aracim then
		if isElement(aracim) then
        	triggerEvent("meslek:event", source, aracim)
        	destroyElement(aracim)
   		end
	end
end)

addEventHandler("onVehicleStartEnter", getRootElement(), function(player, seat)
	if seat == 0 then
		local dbid = tonumber(getElementData(source, "dbid")) or 0
		if dbid < 0 then
			local owner = tonumber(getElementData(source, "meslek:arac_sahip")) or 0
			if owner > 0 then
				local myID = tonumber(getElementData(player, "dbid")) or 0
				if owner ~= myID then
					outputChatBox("[RED:LUA Scripting] #FFFFFFBu sizin iş aracınız değil!", player, 255, 0, 0, true)
					cancelEvent()
				end
			end
		end
	end
end)

addEvent("delJobCar", true)
addEventHandler("delJobCar", getRootElement(), function(jobcar)
	vehiclesToDelete[jobcar] = 10
end)

function deletePlayerVan(player)

	local aracim = getElementData(player, "meslek:aracim")
	if aracim and isElement(aracim) then
		destroyElement(aracim)
        triggerEvent("meslek:event", player, aracim)
	end
end
addEvent("deletePlayerVan", true)
addEventHandler("deletePlayerVan", getRootElement(), deletePlayerVan)

addCommandHandler("tamirci", 
function(oyuncu, cmd)
	if oyuncu:getData("loggedin") == 1 then 
		for _, v in ipairs(exports["pool"]:getPoolElementsByType("player")) do
			if v:getData("loggedin") == 1 and v:getData("job") == 5 then
				local playerItems = exports["items"]:getItems(player)
				for index, value in ipairs(playerItems) do
					if value[1] == 2 then
						TelefonNo = value[2]
					end
				end
	
				oyuncu:outputChat("["..v:getData("playerid").."] -#779292 "..getPlayerName(player):gsub("_"," ").." -#31dede "..TelefonNo.."", 200, 200, 200, true)
			end
		end
	end
end)