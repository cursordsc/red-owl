-- configs
local scriptversion = "0.1"
local author = "anumaz"
local mysql = exports["mysql"]
-- vars

-- start of script

-- If the frequency is within that newly created table (from sql), then return true
function isThisFreqRestricted(freq)
	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, data in ipairs(res) do
				if data and data["frequency"] and data["frequency"] == tostring(freq) then
					return true, data["limitedto"]
				else
					return false
				end
			end
		end
	end,
	mysql:getConnection(), "SELECT `frequency`, `limitedto` FROM `restricted_freqs` WHERE `frequency`='"..(freq).."' ")
end

function openRestrictedFreqs(thePlayer)
	-- Is he an admin?
	if not exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		return nil
	end

	local freqs = {}

	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if not row then
					break
				end
		
				table.insert(freqs, row)
			end
		end
	end,
	mysql:getConnection(), "SELECT `id`, `frequency`, (SELECT `name` FROM `factions` WHERE `factions`.`id`=`restricted_freqs`.`limitedto`) AS `faction`, (SELECT `username` FROM `hesaplar` WHERE `hesaplar`.`id`=`addedby`) AS `addedby` FROM `restricted_freqs`")

	triggerClientEvent(thePlayer, "openRestrictedFreqs", thePlayer, freqs)
end
addCommandHandler("restrictfreqs", openRestrictedFreqs)
addCommandHandler("rf", openRestrictedFreqs)

function addNewFrequency(thePlayer, commandName, freq, factionID)
	-- Is he an admin?
	if not exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		return nil
	end

	-- Anything provided? Is it a number?
	if not freq or not factionID or not tonumber(factionID) then
		outputChatBox("SYNTAX: /" .. commandName .." [frequency] [factionID]", thePlayer)
		return nil
	end

	-- Does that faction exist?
	local theTeam = exports["pool"]:getElement("team", factionID)	
	if not theTeam then
		outputChatBox("That faction ID does not exist. Please check /showfactions", thePlayer)
		return nil
	end

	-- Is it already restricted? If yes, to whom?
	local existed, limitedTo = isThisFreqRestricted(freq)
	if existed then
		outputChatBox("This frequency is already restricted to faction ID #"..limitedTo..".", thePlayer)
		return nil
	end

	local accountID = getElementData(thePlayer, "account:id")
	if dbExec(mysql:getConnection(), "INSERT INTO `restricted_freqs` SET `frequency`='"..(freq).."', `limitedto`='"..(factionID).."', `addedby`='"..accountID.."'") then
		outputChatBox("A new frequency has been added to the restricted list:", thePlayer)
		outputChatBox("Frequency: " ..freq.." Restricted to faction: " ..getTeamName(theTeam), thePlayer)
	else
		outputChatBox("ERROR: An error occured when trying to update database. Contact a scripter.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("addfreq", addNewFrequency)
addEvent("addNewFrequency", true)
addEventHandler("addNewFrequency", root, addNewFrequency)

function displayFrequencies(thePlayer)
	-- Is he an admin?
	if not exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		return nil
	end

	local count = 0
	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if not row then
					break
				end
				count = count + 1
				outputChatBox("#"..row["id"]..". Freq: '"..row["frequency"].."' Limited to: '"..row["faction"].."' Added by: '"..row["addedby"].."' .", thePlayer)
			end
		end
	end,
	mysql:getConnection(), "SELECT `id`, `frequency`, (SELECT `name` FROM `factions` WHERE `factions`.`id`=`restricted_freqs`.`limitedto`) AS `faction`, (SELECT `username` FROM `hesaplar` WHERE `hesaplar`.`id`=`addedby`) AS `addedby` FROM `restricted_freqs`")

	if count <=0 then
		outputChatBox("None", thePlayer)
	end
end
addCommandHandler("freqs", displayFrequencies)

function deleteFrequency(thePlayer, commandName, id)
	-- Is he an admin?
	if not exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		return nil
	end

	-- Is there any id providen, is it a number?
	if not id and not tonumber(id) then
		outputChatBox("SYNTAX: /" .. commandName .. " [id] -- Use /freqs to display frequency IDs.", thePlayer)
		return nil
	end

	dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, freq in ipairs(res) do
				if not freq or not freq["frequency"] or not isThisFreqRestricted(freq["frequency"]) then
					outputChatBox("That frequency ID is not restricted. Use /freqs.", thePlayer)
					return nil
				end
			end
		end
	end,
	mysql:getConnection(), "SELECT `frequency` FROM `restricted_freqs` WHERE `id`='"..id.."'")

	if dbExec(mysql:getConnection(), "DELETE FROM `restricted_freqs` WHERE `id`='"..id.."'") then
		outputChatBox("Frequency with id #" ..id .. " was succesfully deleted.", thePlayer)
	else
		outputChatBox("ERROR: A mysql error happened. Contact a scripter with error code: #RF101", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("delfreq", deleteFrequency)
addEvent("deleteFrequency", true)
addEventHandler("deleteFrequency", root, deleteFrequency)