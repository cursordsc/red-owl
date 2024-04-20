local mysql = exports["mysql"]

local serverRegFee = 2000

function getPlateList()
	local allVehicles = getElementsByType("vehicle")
	local vehicleTable = { }
	local playerDBID = getElementData(client,"dbid")
	if not playerDBID then
		return
	end
	for _,vehicleElement in ipairs( exports["pool"]:getPoolElementsByType("vehicle") ) do
		if (getElementData(vehicleElement, "owner")) and (tonumber(getElementData(vehicleElement, "owner")) == tonumber(playerDBID)) and exports["vehicle"]:hasVehiclePlates(vehicleElement) then
			local vehicleID = getElementData(vehicleElement, "dbid")
			table.insert(vehicleTable, { vehicleID, vehicleElement } )
		end
	end
	triggerClientEvent(client, "vehicle-plate-system:clist", client, vehicleTable)
end
addEvent("vehicle-plate-system:list", true)
addEventHandler("vehicle-plate-system:list", getRootElement(), getPlateList)

function getRegisterList()
	local allVehicles = getElementsByType("vehicle")
	local vehicleTable = { }
	local playerDBID = getElementData(client,"dbid")
	if not playerDBID then
		return
	end
	for _,vehicleElement in ipairs( exports["pool"]:getPoolElementsByType("vehicle") ) do
		if (getElementData(vehicleElement, "owner")) and (tonumber(getElementData(vehicleElement, "owner")) == tonumber(playerDBID)) and exports["vehicle"]:hasVehiclePlates(vehicleElement) then
			local vehicleID = getElementData(vehicleElement, "dbid")
			table.insert(vehicleTable, { vehicleID, vehicleElement } )
		end
	end
	triggerClientEvent(client, "vehicle-plate-system:rlist", client, vehicleTable)
end
addEvent("vehicle-plate-system:registerlist", true)
addEventHandler("vehicle-plate-system:registerlist", getRootElement(), getRegisterList)

function pedTalk(state)
	if (state == 1) then
		--exports["global"]:sendLocalText(source, "Hasan Bozkir diyor ki: Welcome! Would you be unregistering, registering or changing your vehice plates today?", 255, 255, 255, 10)
		--outputChatBox("The fee is $".. exports["global"]:formatMoney(serverRegFee) .. " per vehicle.", source, 200, 200, 200)
	elseif (state == 2) then
		--exports["global"]:sendLocalText(source, "[Türkçe] Hasan Bozkir diyor ki: Sorry but the fee to register new plates is $" .. exports["global"]:formatMoney(serverRegFee) .. ". Please come back once you have the money.", 255, 255, 255, 10)
		--outputChatBox(source, "You lack of GCs to activate this feature.", 255,0,0)
		exports["infobox"]:addBox(source, "error", "Yeterli miktarda bakiyeniz bulunmamakta! (5 TL)")
	elseif (state == 3) then
		--exports["global"]:sendLocalText(source, "[Türkçe] Hasan Bozkir diyor ki: That is great! Lets get everything set up for you in our system.", 255, 255, 255, 10)
	elseif (state == 4) then
		exports["global"]:sendLocalText(source, "[Türkçe] Hasan Bozkir diyor ki: Hayır mı? Umarım daha sonra fikrini değiştirirsin. İyi günler!", 255, 255, 255, 10)
	elseif (state == 5) then
		exports["global"]:sendLocalText(source, " *Hasan Bozkir, bilgileri bilgisayarına girmeye başlar.", 255, 51, 102)
		exports["global"]:sendLocalText(source, "[Türkçe] Hasan Bozkir diyor ki: Pekala gidebilirsiniz, iyi günler dilerim.", 255, 255, 255, 10)
	elseif (state == 6) then
		exports["global"]:sendLocalText(source, "[Türkçe] Hasan Bozkir diyor ki: Hmmm. Kayıtlarımıza göre, bu zaten kayıtlı bir plaka.", 255, 255, 255, 10)
	elseif (state == 7) then
		exports["global"]:sendLocalText(source, "[Türkçe] Hasan Bozkir diyor ki: Üzgünüm ancak aracınızın kayıtlı bir plakaya sahip olması gerekli..", 255, 255, 255, 10)
	elseif (state == 8) then
		exports["global"]:sendLocalText(source, "[Türkçe] Hasan Bozkir diyor ki: Üzgünüm ancak evraklara göre aracın sahibi siz değilsiniz.", 255, 255, 255, 10)
	end
end
addEvent("platePedTalk", true)
addEventHandler("platePedTalk", getRootElement(), pedTalk)

function setNewInfo(data, car)
	if not (data) or not (car) then
		outputChatBox("Sistemsel Hata!", source, 255,0,0)
		return false
	end

	local tvehicle = exports["pool"]:getElement("vehicle", car)
	if not exports["vehicle"]:hasVehiclePlates(tvehicle) then
		triggerEvent("platePedTalk", source, 7)
		return false
	end

	if getElementData(source, "dbid") ~= getElementData(tvehicle, "owner") then
		triggerEvent("platePedTalk", source, 8)
		return false
	end

	--[[dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					if (tonumber(row["no"]) > 0) then
						triggerEvent("platePedTalk", source, 6)
					end
				end
			end
		end, mysql:getConnection(), "SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. data.."'")]]

	--[[dbQuery(
	function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, value in ipairs(res) do
				triggerEvent("platePedTalk", source, 6)
				return false
			end
		end
	end, mysql:getConnection(), "SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. data .."'")]]

	dbQuery(
			function(qh, source)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					triggerEvent("platePedTalk", source, 6)
					return false
				end
			end, mysql:getConnection(), "SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. data .."'")

	local accountID = getElementData(source, "account:id")
	credits = tonumber(getElementData(source, "bakiyeMiktar"))
	if credits < 5 then
		triggerEvent("platePedTalk", source, 2)
		return false
	end

	dbExec(mysql:getConnection(), "UPDATE `accounts` SET `bakiyeMiktari`=`bakiyeMiktari`-5 WHERE `id`='"..accountID.."' ")
	dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `plate`='" .. data .. "' WHERE `id` = '" .. car .. "'")

	exports["anticheat"]:changeProtectedElementDataEx(tvehicle, "plate", data, true)
	--exports["anticheat"]:changeProtectedElementDataEx(tvehicle, "show_plate", 1, true)
	setVehiclePlateText(tvehicle, data )

	triggerEvent("platePedTalk", source, 5)
end
addEvent("sNewPlates", true)
addEventHandler("sNewPlates", getRootElement(), setNewInfo)

function setNewReg(car)
	if not (car) then
		return false
	end

	local tvehicle = exports["pool"]:getElement("vehicle", car)
	if getElementData(source, "dbid") ~= getElementData(tvehicle, "owner") then
		triggerEvent("platePedTalk", source, 8)
		return false
	end
	
	if not exports["vehicle"]:hasVehiclePlates(tvehicle) then
		triggerEvent("platePedTalk", source, 7)
		return false
	end

	if getElementData(tvehicle, "registered") == 0 then
		data = 1
	else
		data = 0
	end

	if not exports["global"]:takeMoney(source, data == 1 and 175 or 50) then
		exports["global"]:sendLocalText(source, "[Türkçe] Hasan Bozkir diyor ki: Lütfen "..(data == 1 and 175 or 50).." TL alabilir miyim?", 255, 255, 255, 10)
	end

	exports["anticheat"]:changeProtectedElementDataEx(tvehicle, "registered", data, true)
	dbExec(mysql:getConnection(), "UPDATE vehicles SET registered='"..(data).."' WHERE id = '" .. (car) .. "'")
	triggerEvent("platePedTalk", source, 5)
end
addEvent("sNewReg", true)
addEventHandler("sNewReg", getRootElement(), setNewReg)

function givePaperToSellVehicle(thePlayer)
	source = thePlayer
	exports["global"]:takeMoney(thePlayer, 100)
	exports["global"]:giveItem(thePlayer, 173, 1)
end
addEvent("givePaperToSellVehicle", true)
addEventHandler("givePaperToSellVehicle", getResourceRootElement(), givePaperToSellVehicle)