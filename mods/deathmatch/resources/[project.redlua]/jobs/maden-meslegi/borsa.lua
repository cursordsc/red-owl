-----------------------------------
local tasSatim = (75+100) -- 30
local komurSatim = (100+100) -- 50
local bakirSatim = (125+100) -- 100
local demirSatim = (150+100) -- 150
local altinSatim = (200+100) -- 200

local IslenmisTas = 573
local IslenmisKomur = 574
local IslenmisBakir = 575
local IslenmisDemir = 576
local IslenmisAltin = 577

local genelSatisBolgesi = createColSphere (-2160.0009765625, 640.3583984375, 1052.3817138672, 40, 3, 81)
setElementDimension(genelSatisBolgesi,88)
setElementInterior(genelSatisBolgesi,1)

addCommandHandler("sat", function(plr, cmd,komut)

	if not isElementWithinColShape(plr, genelSatisBolgesi) then
		outputChatBox("[!]#ffffff Burada borsa satışı işlemi gerçekleştiremezsin.",plr,255,0,0,true)
	return end
	
	if not komut then
		outputChatBox("[!]#FFFFFF /"..cmd.." [borsalistesi] yazarak satış listesini ve fiyatları gözlemleyebilirsin.",plr,255,194,14,true)
	return end
	if komut == "borsalistesi" then
    outputChatBox("[!]#ffffff Borsa Listesi | RED:LUA Scripting",plr,0,255,0,true)
    outputChatBox("-#ffffff Taş Satım : "..tasSatim.." TL",plr,0,255,0,true)
    outputChatBox("-#ffffff Kömür Satım : "..komurSatim.." TL",plr,0,255,0,true)
    outputChatBox("-#ffffff Bakır Satım : "..bakirSatim.." TL",plr,0,255,0,true)
    outputChatBox("-#ffffff Demir Satım : "..demirSatim.." TL",plr,0,255,0,true)
    outputChatBox("-#ffffff Altın Satım : "..altinSatim.." TL",plr,0,255,0,true)
end
if komut == "tas" then
	if not exports["global"]:hasItem(plr,IslenmisTas) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Taş' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Taş' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports["global"]:giveMoney(plr,tasSatim)
	
	if getElementData(plr, "vip") == 1 then
	exports["global"]:giveMoney(plr,tasSatim+50) -- 10
	end
	if getElementData(plr, "vip") == 2 then
	exports["global"]:giveMoney(plr,tasSatim+100) -- 20
	end
	if getElementData(plr, "vip") == 3 then
	exports["global"]:giveMoney(plr,tasSatim+150) -- 30
	end
	if getElementData(plr, "vip") == 4 then
	exports["global"]:giveMoney(plr,tasSatim+200) -- 30
	end
	
	exports["global"]:takeItem(plr,IslenmisTas, 1)
end

if komut == "komur" then
	if not exports["global"]:hasItem(plr,IslenmisKomur) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Kömür' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Kömür' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports["global"]:giveMoney(plr,komurSatim)
	
	if getElementData(plr, "vip") == 1 then	
	exports["global"]:giveMoney(plr,komurSatim+50)
	end
	if getElementData(plr, "vip") == 2 then	
	exports["global"]:giveMoney(plr,komurSatim+100)
	end
	if getElementData(plr, "vip") == 3 then	
	exports["global"]:giveMoney(plr,komurSatim+150)
	end
	if getElementData(plr, "vip") == 4 then	
	exports["global"]:giveMoney(plr,komurSatim+200)
	end

	
	exports["global"]:takeItem(plr,IslenmisKomur, 1)
	
end

if komut == "bakir" then
	if not exports["global"]:hasItem(plr,IslenmisBakir) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Bakır' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Bakır' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports["global"]:giveMoney(plr,bakirSatim)
	
	if getElementData(plr, "vip") == 1 then
	exports["global"]:giveMoney(plr,bakirSatim+50)
	end
	if getElementData(plr, "vip") == 2 then
	exports["global"]:giveMoney(plr,bakirSatim+100)
	end
	if getElementData(plr, "vip") == 3 then
	exports["global"]:giveMoney(plr,bakirSatim+150)
	end
	if getElementData(plr, "vip") == 4 then
	exports["global"]:giveMoney(plr,bakirSatim+200)
	end
	
	exports["global"]:takeItem(plr,IslenmisBakir, 1)	
end

if komut == "demir" then
	if not exports["global"]:hasItem(plr,IslenmisDemir) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Demir' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Demir' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports["global"]:giveMoney(plr,demirSatim)
	
	if getElementData(plr, "vip") == 1 then
	exports["global"]:giveMoney(plr,demirSatim+50)	
	end
	if getElementData(plr, "vip") == 2 then
	exports["global"]:giveMoney(plr,demirSatim+100)	
	end
	if getElementData(plr, "vip") == 3 then
	exports["global"]:giveMoney(plr,demirSatim+150)	
	end
	if getElementData(plr, "vip") == 4 then
	exports["global"]:giveMoney(plr,demirSatim+200)	
	end
	
	exports["global"]:takeItem(plr,IslenmisDemir, 1)	
end

if komut == "altin" then
	if not exports["global"]:hasItem(plr,IslenmisAltin) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Altın' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Altın' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports["global"]:giveMoney(plr,altinSatim)
	
	if getElementData(plr, "vip") == 1 then
	exports["global"]:giveMoney(plr,altinSatim+50)
	end
	if getElementData(plr, "vip") == 2 then
	exports["global"]:giveMoney(plr,altinSatim+100)
	end
	if getElementData(plr, "vip") == 3 then
	exports["global"]:giveMoney(plr,altinSatim+150)
	end
	if getElementData(plr, "vip") == 4 then
	exports["global"]:giveMoney(plr,altinSatim+200)
	end
	
	exports["global"]:takeItem(plr,IslenmisAltin, 1)
end
end)

-- Satış Sistemi 