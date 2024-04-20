mysql = exports.mysql

addEvent("addFriend", true)
addEventHandler("addFriend", getRootElement(), function(player) new_addFriend(client, player) end)

-- FRISKING
function friskShowItems(player)
	--local items = exports['items']:getItems(player)
	--triggerClientEvent(source, "friskShowItems", player, items)
	triggerEvent("subscribeToInventoryChanges",source,player)
	triggerClientEvent(source,"showInventory",source,player)
end
addEvent("friskShowItems", true)
addEventHandler("friskShowItems", getRootElement(), friskShowItems)

-- CUFFS
function toggleCuffs(cuffed, player)
	if (cuffed) then
		toggleControl(player, "fire", false)
		toggleControl(player, "sprint", false)
		toggleControl(player, "jump", false)
		toggleControl(player, "next_weapon", false)
		toggleControl(player, "previous_weapon", false)
		toggleControl(player, "accelerate", false)
		toggleControl(player, "brake_reverse", false)
		toggleControl(player, "aim_weapon", false)
		toggleControl(player, "crouch", false)
	else
		toggleControl(player, "fire", true)
		toggleControl(player, "sprint", true)
		toggleControl(player, "jump", true)
		toggleControl(player, "next_weapon", true)
		toggleControl(player, "previous_weapon", true)
		toggleControl(player, "accelerate", true)
		toggleControl(player, "brake_reverse", true)
		toggleControl(player, "aim_weapon", true)
	end
end

-- RESTRAINING
function restrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	local dbid = getElementData( player, "dbid" )
	
	setTimer(toggleCuffs, 200, 1, true, player)
	
	exports["infobox"]:addBox(player, "warning", username:gsub("_", " ") .. " adlı kişi sizi kelepçeledi.")
	exports["infobox"]:addBox(source, "success", targetPlayerName:gsub("_", " ") .. " adlı kişiyi kelepçelediniz.")
	
	exports["global"]:sendLocalMeAction(source, targetPlayerName:gsub("_", " ") .. " isimli şahısın ellerini birleştirerek elindeki kelepçeyi takar.", false, true)
	
	exports["anticheat"]:changeProtectedElementDataEx(player, "restrain", 1, true)
	exports["anticheat"]:changeProtectedElementDataEx(player, "restrainedObj", restrainedObj, true)
	exports["anticheat"]:changeProtectedElementDataEx(player, "restrainedBy", getElementData(source, "dbid"), true)
	dbExec(mysql:getConnection(), "UPDATE characters SET cuffed = 1, restrainedby = " .. (getElementData(source, "dbid")) .. ", restrainedobj = " .. (restrainedObj) .. " WHERE id = " .. (dbid) )
	
	exports["global"]:takeItem(source, restrainedObj)

	if (restrainedObj==45) then -- If handcuffs.. give the key
		exports['items']:deleteAll(47, dbid)
		exports["global"]:giveItem(source, 47, dbid)
		cuff = createObject(9651, 0, 0, 0, 0, 0, 0, true)
		setElementDimension(cuff, getElementDimension(player))
		setElementInterior(cuff, getElementInterior(player))
		attachcuff = exports.bone_attach:attachElementToBone(cuff, player, 12 , -0.05, 0.1, 0.03, 90, -45, 15)
		exports["global"]:applyAnimation(player, "SWORD", "sword_block", 0, false, true, false, true)
		exports["global"]:applyAnimation(source, "BD_FIRE", "wash_up", -1, false, true, false)
		setTimer(function() exports["global"]:removeAnimation(source) end, 3000, 1)
		--animTimer = setTimer(function() exports["global"]:applyAnimation(player, "SWORD", "sword_block", 0, false, true, false, true) end, 100, 0)
	end
	--exports["global"]:removeAnimation(player)
end
addEvent("restrainPlayer", true)
addEventHandler("restrainPlayer", getRootElement(), restrainPlayer)

function unrestrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	exports["infobox"]:addBox(player, "success", username:gsub("_", " ") .. " adlı kişi kelepçenizi çıkarttı.")
	exports["infobox"]:addBox(source, "success", targetPlayerName:gsub("_", " ") .. " adlı kişinin kelepçesini çıkarttınız.")

	exports["global"]:sendLocalMeAction(source, targetPlayerName:gsub("_", " ") .. " isimli şahısın kelepçesini elindeki anahtarla çıkartır.", false, true)

	
	setTimer(toggleCuffs, 200, 1, false, player)
	
	exports["anticheat"]:changeProtectedElementDataEx(player, "restrain", 0)
	exports["anticheat"]:changeProtectedElementDataEx(player, "restrainedBy")
	exports["anticheat"]:changeProtectedElementDataEx(player, "restrainedObj")
	
	local dbid = getElementData(player, "dbid")
	if (restrainedObj==45) then -- If handcuffs.. take the key
		exports['items']:deleteAll(47, dbid)
		destroyElement(cuff)
		if isTimer(animTimer) then
			killTimer(animTimer)
		end
		exports["global"]:applyAnimation(source, "BD_FIRE", "wash_up", -1, false, true, false)
	end
	exports["global"]:giveItem(source, restrainedObj, 1)
	dbExec(mysql:getConnection(), "UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. (dbid) )
	
	exports["global"]:removeAnimation(player)
end
addEvent("unrestrainPlayer", true)
addEventHandler("unrestrainPlayer", getRootElement(), unrestrainPlayer)

addEventHandler("onPlayerDamage", root, 
	function()
		if getElementData(source, "restrain") == 1 then
			exports["global"]:applyAnimation(source, "SWORD", "sword_block", 0, false, true, false, true)
		end
	end
)

-- BLINDFOLDS
function blindfoldPlayer(player)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have been blindfolded by " .. username .. ".", player)
	outputChatBox("You blindfolded " .. targetPlayerName .. ".", source)
	
	exports["global"]:takeItem(source, 66) -- take their blindfold
	exports["anticheat"]:changeProtectedElementDataEx(player, "blindfold", 1)
	dbExec(mysql:getConnection(), "UPDATE characters SET blindfold = 1 WHERE id = " .. (getElementData( player, "dbid" )) )
	fadeCamera(player, false)
end
addEvent("blindfoldPlayer", true)
addEventHandler("blindfoldPlayer", getRootElement(), blindfoldPlayer)

function removeblindfoldPlayer(player)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have had your blindfold removed by " .. username .. ".", player)
	outputChatBox("You removed " .. targetPlayerName .. "'s blindfold.", source)
	
	exports["global"]:giveItem(source, 66, 1) -- give the remove the blindfold
	exports["anticheat"]:changeProtectedElementDataEx(player, "blindfold")
	dbExec(mysql:getConnection(), "UPDATE characters SET blindfold = 0 WHERE id = " .. (getElementData( player, "dbid" )) )
	fadeCamera(player, true)
end
addEvent("removeBlindfold", true)
addEventHandler("removeBlindfold", getRootElement(), removeblindfoldPlayer)


-- STABILIZE
function stabilizePlayer(player)
	local found, slot, itemValue = exports["global"]:hasItem(source, 70)
	if found then
		if itemValue > 1 then
			exports['items']:updateItemValue(source, slot, itemValue - 1)
		else
			exports["global"]:takeItem(source, 70, itemValue)
		end
		
		local username = getPlayerName(source)
		local targetPlayerName = getPlayerName(player)
	
	
		outputChatBox("You have been stabilized by " .. username .. ".", player)
		outputChatBox("You stabilized " .. targetPlayerName .. ".", source)
		triggerEvent("onPlayerStabilize", player)
	end
end
addEvent("stabilizePlayer", true)
addEventHandler("stabilizePlayer", getRootElement(), stabilizePlayer)