validWalkingStyles = { [57]=true, [58]=true, [59]=true, [60]=true, [61]=true, [62]=true, [63]=true, [64]=true, [65]=true, [66]=true, [67]=true, [68]=true, [118]=true, [119]=true, [120]=true, [121]=true, [122]=true, [123]=true, [124]=true, [125]=true, [126]=true, [128]=true, [129]=true, [130]=true, [131]=true, [132]=true, [133]=true, [134]=true, [135]=true, [136]=true, [137]=true, [138]=true }

function setWalkingStyle(thePlayer, commandName, walkingStyle)
	if not walkingStyle or not validWalkingStyles[tonumber(walkingStyle)] or not tonumber(walkingStyle) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Walking Style ID]", thePlayer, 255, 194, 14)
		outputChatBox("'/walklist' to list all valid walking style IDs.", thePlayer, 255, 194, 14)
	else
		local dbid = getElementData(thePlayer, "dbid")
		local updateWalkingStyleSQL = dbExec(exports["mysql"]:getConnection(),"UPDATE `characters` SET `walkingstyle`='" .. tonumber(walkingStyle) .. "' WHERE `id`='".. tostring(dbid) .."'")
		if updateWalkingStyleSQL then
			exports["anticheat"]:changeProtectedElementDataEx(thePlayer, "walkingstyle", walkingStyle, true)
			setPedWalkingStyle(thePlayer, tonumber(walkingStyle))
			outputChatBox("Walking style successfully set to: " .. walkingStyle, thePlayer, 0, 255, 0)
		else
			outputChatBox("Walking style could not be set. Error 1337 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setwalkingstyle", setWalkingStyle)
addCommandHandler("setwalk", setWalkingStyle)

function applyWalkingStyle(style, ignoreSQL)
	local gender = getElementData(source, "gender")
	local charid = getElementData(source, "dbid")
	if not style or not validWalkingStyles[tonumber(style)] then
		if gender == 1 then
			style = 129
		else
			style = 128
		end
		ignoreSQL = true
	else
		ignoreSQL = false
	end

	if not ignoreSQL then
		dbExec(exports["mysql"]:getConnection(), "UPDATE `characters` SET `walkingstyle`='" .. (style) .. "' WHERE `id`='".. (charid) .."'")
	end
	exports["anticheat"]:changeProtectedElementDataEx(source, "walkingstyle", tonumber(style), true)
	setPedWalkingStyle(source, tonumber(style))
end
addEvent("realism:applyWalkingStyle", true)
addEventHandler("realism:applyWalkingStyle", root, applyWalkingStyle)

function switchWalkingStyle()
	local walkingStyle = getElementData(client, "walkingstyle")
	walkingStyle = tonumber(walkingStyle) or 57
	local nextStyle = getNextValidWalkingStype(walkingStyle)
	if not nextStyle then
		nextStyle = getNextValidWalkingStype(56)
	end
	triggerEvent("realism:applyWalkingStyle", client, nextStyle)
end
addEvent("realism:switchWalkingStyle", true)
addEventHandler("realism:switchWalkingStyle", root, switchWalkingStyle)

function getNextValidWalkingStype(cur)
	cur = tonumber(cur)
	local found = false
	for i = cur, 138 do
		if validWalkingStyles[i+1] then
			found = i+1
			break
		end
	end
	
	return found
end

function walkStyleList(thePlayer, commandName)
	outputChatBox("Walking style IDs list:", thePlayer, 255, 194, 14)
	outputChatBox("57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 118", thePlayer, 100, 194, 14)
	outputChatBox("119, 120, 121, 122, 123, 124, 125, 126, 128", thePlayer, 100, 194, 14)
	outputChatBox("129, 130, 131, 132, 133, 134, 135, 136, 137, 138", thePlayer, 100, 194, 14)
end
addCommandHandler("walklist", walkStyleList)