
local sudakItem = 581
local denizItem = 582
local dereItem = 583
local dagItem = 584





-- BURADAN AŞAĞIDAKİLERİ EDITLEMEYIN.
local yemx, yemy, yemz = 355.09765625, -2027.5849609375, 7.8359375
local yemCol = createColSphere(yemx, yemy, yemz, 2)
local balikCol = createColPolygon(360.2646484375, -2047.708984375, 349.84375, -2047.708984375, 349.8466796875, -2088.7978515625, 409.24609375, -2088.7978515625, 409.25390625, -2047.7099609375, 399.392578125, -2047.7099609375, 399.513671875, -2048.248046875, 408.4306640625, -2048.2607421875, 408.322265625, -2087.6474609375, 350.8984375, -2087.5585937, 350.7744140625, -2048.453125, 360.427734375, -2048.681640625, 360.2431640625, -2047.709960937)
local yeampickup = createPickup(355.09765625, -2027.5849609375, 7.8359375, 3, 1239, 1, 1 );

function balikYardim(thePlayer)
	if isElementWithinColShape(thePlayer, yemCol) then
		outputChatBox("----------------------------------------------------------------------------------", thePlayer, 255, 0, 0)
		outputChatBox("==> Yem Almak İçin /yemal --",thePlayer,255,240,240)
		outputChatBox("==> Balık Satmak İçin /baliksat --",thePlayer,255,240,240)
		outputChatBox("==> Yem ve Balık Bilgileriniz İçin /balikdurum --",thePlayer,255,240,240)
		outputChatBox("----------------------------------------------------------------------------------", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("balikyardim", balikYardim)
addCommandHandler("balikbilgi", balikYardim)

addCommandHandler("baliktut", 
	function(thePlayer, cmd)
		if isElementWithinColShape(thePlayer, balikCol) then
			if (not getElementData(thePlayer, "balikTutuyor")) then
				local toplamyem = getElementData(thePlayer, "toplamyem") or 0
				if toplamyem > 0 then
					triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
					setElementData(thePlayer, "balikTutuyor", true)
					exports["global"]:sendLocalMeAction(thePlayer, "oltasını denize doğru sallar.", false, true)
					outputChatBox("[!] #ffffffBalık tutuyorsunuz, lütfen bekleyin!", thePlayer, 10, 10, 255, true)
					setElementData(thePlayer, "toplamyem", toplamyem - 1)
					setElementFrozen(thePlayer, true)
					exports["global"]:applyAnimation(thePlayer, "SWORD", "sword_IDLE", -1, false, true, true, false)
					setTimer(function(thePlayer) 
						local rastgeleSayi = math.random(1, 2)
						if rastgeleSayi == 1 then
							local balikTipi1 = yuzdelikOran(50)
							local balikTipi2 = yuzdelikOran(30)
							local balikTipi3 = yuzdelikOran(10)
							
							-- ORANI EN DÜŞÜKTEN BAŞLAYARAK SIRALANMALIDIR.
							if balikTipi3 then
								exports["items"]:giveItem(thePlayer, sudakItem, 1) -- SUDAK BALIĞI
								outputChatBox("[!] #ffffffTebrikler, bir adet 'Sudak Balığı' tuttunuz!", thePlayer, 0, 255, 0, true)					
							elseif balikTipi2 then
								exports["items"]:giveItem(thePlayer, dagItem, 1) -- DAĞ ALABALIĞI
								outputChatBox("[!] #ffffffTebrikler, bir adet 'Dağ Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)
							elseif balikTipi1 then
								exports["items"]:giveItem(thePlayer, denizItem, 1) -- DENİZ ALABALIĞI
								outputChatBox("[!] #ffffffTebrikler, bir adet 'Deniz Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)		
							else -- Hiçbiri Vurmazsa, (Değeri en düşük balık.)
								exports["items"]:giveItem(thePlayer, dereItem, 1) -- DERE ALABALIĞI
								outputChatBox("[!] #ffffffTebrikler, bir adet 'Dere Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)		
							end
						elseif rastgeleSayi >= 2 then
							outputChatBox("[!] #ffffffMalesef, balık tutamadınız.", thePlayer, 255, 0, 0, true)
						end
						exports["global"]:removeAnimation(thePlayer)
						triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
						setElementFrozen(thePlayer, false)
						setElementData(thePlayer, "balikTutuyor", false)
					end, 20000, 1, thePlayer)
				else
					outputChatBox("[!] #ffffffMalesef, üzerinizde yem kalmadı.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
)


addCommandHandler("balikdurum", 
	function(thePlayer, cmd)
		local yem = getElementData(thePlayer, "toplamyem") or 0
		local toplamBalik = exports["items"]:countItems(thePlayer, sudakItem, 1) + exports["items"]:countItems(thePlayer, dagItem, 1) + exports["items"]:countItems(thePlayer, denizItem, 1) + exports["items"]:countItems(thePlayer, dereItem, 1)
		outputChatBox("-----------------------------------------", thePlayer, 255, 0, 0)
		outputChatBox("==> Toplam Balık: " .. tostring(toplamBalik), thePlayer, 255, 240, 240)
		outputChatBox("==> Toplam Yem: " .. tostring(yem), thePlayer, 255, 240, 240)
		outputChatBox("-----------------------------------------", thePlayer, 255, 0, 0)
	end
)

function yemAl(thePlayer, cmd)
	local para = exports["global"]:getMoney(thePlayer)
	if para >= 1 then
		if isElementWithinColShape(thePlayer, yemCol) then
			local toplamyem = getElementData(thePlayer, "toplamyem") or 0
			if toplamyem >= 20 then
				outputChatBox("[!] #ffffffMalesef, daha fazla yem alamazsınız.", thePlayer, 255, 0, 0, true)
				return
			elseif toplamyem <= 20 then
				exports["global"]:takeMoney(thePlayer, 1)
				if (toplamyem + 10) <= 20 then
					setElementData(thePlayer, "toplamyem", toplamyem + 10)
					outputChatBox("[!] #ffffff10 Adet yem aldınız.", thePlayer, 10, 10, 255, true)
				elseif (toplamyem + 10) >= 20 then
					alinamayanYem = toplamyem + 10 - 20
					alinanYem = 10 - alinamayanYem
					setElementData(thePlayer, "toplamyem", 20)
					outputChatBox("[!] #ffffff" .. tostring(alinanYem) .. " Adet yem aldınız.", thePlayer, 10, 10, 255, true)
				end
			end
		end
	else
		outputChatBox("[!] #ffffffYem almak için paranız yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("yemal", yemAl)

function balikSat(thePlayer, cmd)
	local denizMiktar = exports["items"]:countItems(thePlayer, denizItem, 1) or 0
	local dagMiktar = exports["items"]:countItems(thePlayer, dagItem, 1) or 0
	local dereMiktar = exports["items"]:countItems(thePlayer, dereItem, 1) or 0
	local sudakMiktar = exports["items"]:countItems(thePlayer, sudakItem, 1) or 0
	
local HediyePara = 0
local CarpimPara = 1
------------------------------------------------
local sudakPara = (66+HediyePara)*CarpimPara-- 10
if getElementData(thePlayer, "vip") == 1 then
sudakPara = (66+25+HediyePara)*CarpimPara -- 15
end
if getElementData(thePlayer, "vip") == 2 then
sudakPara = (66+50+HediyePara)*CarpimPara -- 20
end
if getElementData(thePlayer, "vip") == 3 then
sudakPara = (66+75+HediyePara)*CarpimPara -- 25
end
if getElementData(thePlayer, "vip") == 4 then
sudakPara = (66+100+HediyePara)*CarpimPara -- 25
end
-----------------------------------------------
------------------------------------------------
local denizPara = (66+HediyePara)*CarpimPara
if getElementData(thePlayer, "vip") == 1 then
denizPara = (66+25+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 2 then
denizPara = (66+50+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 3 then
denizPara = (66+75+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 4 then
denizPara = (66+100+HediyePara)*CarpimPara
end
-----------------------------------------------
------------------------------------------------
local derePara = (66+HediyePara)*CarpimPara
if getElementData(thePlayer, "vip") == 1 then
derePara = (66+25+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 2 then
derePara = (66+50+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 3 then
derePara = (66+75+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 4 then
derePara = (66+100+HediyePara)*CarpimPara
end
-----------------------------------------------
------------------------------------------------
local dagPara = (66+HediyePara)*CarpimPara
if getElementData(thePlayer, "vip") == 1 then
dagPara = (66+25+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 2 then
dagPara = (66+50+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 3 then
dagPara = (66+75+HediyePara)*CarpimPara
end
if getElementData(thePlayer, "vip") == 4 then
dagPara = (66+100+HediyePara)*CarpimPara
end
-----------------------------------------------
	
	if isElementWithinColShape(thePlayer, yemCol) then
		local toplambalik = denizMiktar + dagMiktar + dereMiktar + sudakMiktar
		if toplambalik <= 0 then
			outputChatBox("[!] #ffffffSatacak balığınız yok!", thePlayer, 255, 0, 0, true)
			return
		else
			verilecekPara = (denizMiktar * denizPara) + (dagMiktar * dagPara) + (dereMiktar * derePara) + (sudakMiktar * sudakPara)
			exports["global"]:giveMoney(thePlayer, verilecekPara)
			for i = 0, denizMiktar do
				exports["items"]:takeItem(thePlayer, denizItem, 1)
			end
			for i = 0, dagMiktar do
				exports["items"]:takeItem(thePlayer, dagItem, 1)
			end
			for i = 0, dereMiktar do
				exports["items"]:takeItem(thePlayer, dereItem, 1)
			end
			for i = 0, sudakMiktar do
				exports["items"]:takeItem(thePlayer, sudakItem, 1)
			end

			local birim = "$"
			outputChatBox("[!] #ffffff" .. tostring(toplambalik) .. " tane balıktan toplam "..birim.."" .. tostring(verilecekPara) .. " kazandınız!", thePlayer, 0, 255, 0, true)
			outputChatBox("[!] #ffffffTuttugunuz Baliklar;", thePlayer, 0, 0, 255, true)
			outputChatBox("✹ #ffffff '" .. tostring(sudakMiktar) .. "' Sudak Balığı '"..birim.."" .. tostring(sudakMiktar * sudakPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("✹ #ffffff '" .. tostring(dereMiktar) .. "' Dere Alabalığından '"..birim.."" .. tostring(dereMiktar * derePara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("✹ #ffffff '" .. tostring(denizMiktar) .. "' Deniz Alabalığından '"..birim.."" .. tostring(denizMiktar * denizPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("✹ #ffffff '" .. tostring(dagMiktar) .. "' Dağ Alabalığından '"..birim.."" .. tostring(dagMiktar * dagPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			
		end
	end
end
addCommandHandler("baliksat", balikSat)

function yuzdelikOran (percent)
	assert(percent >= 0 and percent <= 100) 
	return percent >= math.random(1, 100)
end