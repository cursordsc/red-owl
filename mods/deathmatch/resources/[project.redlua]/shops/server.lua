local sql = exports.mysql:getConnection()
local white = "#FFFFFF";
local shops = {};


function loadShop(id)
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        if #result > 0 then 
            for k,v in pairs(result) do 
                local ped = createPed(v.skin,v.x,v.y,v.z,v.rotationz);
                setElementDimension(ped,v.dimension);
                setElementInterior(ped,v.interior);
                setElementFrozen(ped,true);
                setElementData(ped,"shop.id",v.id);
                setElementData(ped,"shop.type",v.shoptype);
				setElementData(ped,"shop.name",v.shopname);
                setElementData(ped,"ped >> name","");
                setElementData(ped,"ped >> type","Boltos");
                setElementData(ped,"ped.noDamage",true);
                shops[v.id] = ped;
            end
        end
    end,sql,"SELECT * FROM shops WHERE id=?",id);
end

function loadAllShop()
    dbQuery(function(qh)
        local counter = 0;
        local result = dbPoll(qh,0);
        if #result > 0 then 
            for k,v in pairs(result) do 
                loadShop(v.id);
                counter = counter + 1;
            end
            outputDebugString("Dukkan: "..counter.." dukkan yuklendi!");
        end
    end,sql,"SELECT id FROM shops");
end
addEventHandler("onResourceStart",resourceRoot,loadAllShop);


addEvent("shop.buy",true);
addEventHandler("shop.buy",root,function(player,item)
	if exports.global:hasMoney(player,item[2]) then
		if item[1] == 2 then
			local attempts = 0
				attempts = attempts + 1
				itemValue = math.random(311111, attempts < 20 and 899999 or 8999999)
				local suc = exports["global"]:giveItem(player,item[1],itemValue)
				exports.global:takeMoney(player, item[2])
				outputChatBox("[Dükkan] #ffffffBaşarılı bir şekilde satın aldınız! Alınan Ürün: #85EFB5"..exports.items:getItemName(item[1]).." #FFFFFF| Ücret: #85EFB5"..item[2].."#FFFFFF₺",player,133,239,181,true);
		return end
		
		if item[1] == 115 then 
			local id = item[3]
			local serial1 = tonumber(getElementData(player, "account:character:id"))
			local serial2 = tonumber(getElementData(player, "account:character:id"))
			local mySerial = exports.global:createWeaponSerial( 1, serial1, serial2)
			exports.global:giveItem(player, 115, id..":"..mySerial..":"..getWeaponNameFromID(id).."::")
			outputChatBox("[Dükkan] #ffffffBaşarılı bir şekilde satın aldınız! Alınan Ürün: #85EFB5"..exports.items:getItemName(-item[3]).." #FFFFFF| Ücret: #85EFB5"..item[2].."#FFFFFF₺",player,133,239,181,true);
		else 
			local suc = exports["global"]:giveItem(player,item[1],1);
			if suc then 
				exports.global:takeMoney(player, item[2])
				outputChatBox("[Dükkan] #ffffffBaşarılı bir şekilde satın aldınız! Alınan Ürün: #85EFB5"..exports.items:getItemName(item[1]).." #FFFFFF| Ücret: #85EFB5"..item[2].."#FFFFFF₺",player,133,239,181,true);
			else 
				outputChatBox("[Dükkan] #ffffffBaşarısız satın alma! Envanterde yer yok!",player,133,239,181,true);
			end
		end
	else
		exports.infobox:addBox(player,"error","Yeterli paran yok bro!")
	end
end);

function makeShop(player,command,type,name)
    if getElementData(player,"admin_level") > 6 then 
        if not type or not tonumber(type) or not name or tonumber(type) > #types or tonumber(type) < 0 then
            outputChatBox("/"..command.." [Tip] [NPC Adı]",player,255,255,255,true);
            for k,v in ipairs(types) do 
                outputChatBox(k.." - "..v,player,255,255,255,true);
            end
            return
        end;
        local type = math.floor(tonumber(type));
        local x,y,z = getElementPosition(player);
        local _,_,rot = getElementRotation(player);
        local interior,dimension = getElementInterior(player),getElementDimension(player);
        local allSkin = getValidPedModels();
        local skin = allSkin[math.random(1,#allSkin)];
		local nameodrin = types[type]
        dbQuery(function(qh)
            local result,_,id = dbPoll(qh,0);
            if id then 
                loadShop(id);
                local sColor = "#85EFB5"
				--outputChatBox(""..nameodrin.."",player,255,255,255,true)
                outputChatBox("[Dükkan] #ffffffBir mağazayı başarıyla oluşturdunuz! ID: "..sColor..id..white..".",player,133,239,181,true);
            else 
                outputChatBox("Mağaza oluşturulamadı. MySQL hatası!",player,255,255,255,true);
            end
		end,sql,"INSERT INTO shops SET skin=?, x=?,y=?,z=?,rotationz=?,dimension=?,interior=?, shoptype=?, pedName=?,shopname=?",skin,x,y,z,rot,dimension,interior,type,tostring(name),nameodrin);
    end
end
addCommandHandler("makeshop",makeShop,false,false);
addCommandHandler("addshop",makeShop,false,false);
addCommandHandler("createshop",makeShop,false,false);

function nearbyShops(player,command)
    if getElementData(player,"admin_level") > 6 then 
        local px,py,pz = getElementPosition(player);
        local counter = 0;
        local sColor = "#85EFB5"
        outputChatBox("Yakındaki mağazalar: ",player,255,255,255,true);
        for k,v in pairs(getElementsByType("ped",resourceRoot,true)) do 
            if getElementData(v,"shop.type") or false then 
                local x,y,z = getElementPosition(v);
                local distance = getDistanceBetweenPoints3D(px,py,pz,x,y,z);
                if distance < 15 then 
                    outputChatBox("ID: "..sColor..(getElementData(v,"shop.id"))..white.." | Tip: "..sColor..(types[getElementData(v,"shop.type")])..white.." | Mesafe: "..sColor..math.ceil(distance)..white.." m.",player,255,255,255,true);
                    counter = counter + 1;
                end
            end
        end
        if counter == 0 then 
            outputChatBox("[Dükkan] #ffffffYakınınızda mağaza yok!",player,133,239,181,true);
        end
    end
end
addCommandHandler("nearbyshops",nearbyShops,false,false);
addCommandHandler("nearbyshop",nearbyShops,false,false);

function deleteShop(player,command,id)
    if getElementData(player,"admin_level") > 6 then 
        if not id or not tonumber(id) then outputChatBox("/"..command.." [ID]",player,255,255,255,true) return end;
        local id = math.floor(tonumber(id));
        if shops[id] then 
            local ped = shops[id];
            if isElement(ped) then 
                destroyElement(ped);
            end
            dbExec(sql,"DELETE FROM shops WHERE id=?",id);
            local sColor = "#85EFB5"
            outputChatBox("[Dükkan] #ffffffBir mağazayı başarıyla sildiniz. ID: "..sColor..id..white..".",player,133,239,181,true);
        else
            outputChatBox("[Dükkan] #ffffffBöyle bir dükkan yok!",player,133,239,181,true);
        end
    end
end
addCommandHandler("delshop",deleteShop,false,false);
addCommandHandler("deleteshop",deleteShop,false,false);

function gotoShop(thePlayer, commandName, shopID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not tonumber(shopID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Shop ID]", thePlayer, 255, 194, 14)
		else
			local possibleShops = getElementsByType("ped", resourceRoot)
			local foundShop = false
			for _, shop in ipairs(possibleShops) do
				if getElementData(shop,"shopkeeper") and (tonumber(getElementData(shop, "dbid")) == tonumber(shopID)) then
					foundShop = shop
					break
				end
			end
			
			if not foundShop then
				outputChatBox("No shop founded with ID #"..shopID, thePlayer, 255, 0, 0)
				return false
			end
				
			local x, y, z = getElementPosition(foundShop)
			local dim = getElementDimension(foundShop)
			local int = getElementInterior(foundShop)
			local _, _, rot = getElementRotation(foundShop)
			startGoingToShop(thePlayer, x,y,z,rot,int,dim,shopID)
		end
	end
end
addCommandHandler("gotoshop", gotoShop, false, false)

function startGoingToShop(thePlayer, x,y,z,r,interior,dimension,shopID)
	-- Maths calculations to stop the player being stuck in the target
	x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
	y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
	
	setCameraInterior(thePlayer, interior)
	
	if (isPedInVehicle(thePlayer)) then
		local veh = getPedOccupiedVehicle(thePlayer)
		setElementAngularVelocity(veh, 0, 0, 0)
		setElementInterior(thePlayer, interior)
		setElementDimension(thePlayer, dimension)
		setElementInterior(veh, interior)
		setElementDimension(veh, dimension)
		setElementPosition(veh, x, y, z + 1)
		warpPedIntoVehicle ( thePlayer, veh ) 
		setTimer(setElementAngularVelocity, 50, 20, veh, 0, 0, 0)
	else
		setElementPosition(thePlayer, x, y, z)
		setElementInterior(thePlayer, interior)
		setElementDimension(thePlayer, dimension)
	end
	outputChatBox(" You have teleported to shop ID#"..shopID, thePlayer)
end