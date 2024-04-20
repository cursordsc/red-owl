local infoisaret = createPickup( -93.30859375, 1958.8125, -12.623115539551, 3, 1239, 1, 1 );
local altinBolge = createColSphere (-93.30859375, 1958.8125, -12.623115539551, 10, 3, 81)
addCommandHandler("altin", function(plr, cmd,komut)

local Kazma = 578
local AltinFiyati = 200
local IslenmisAltin = 577

if not isElementWithinColShape(plr, altinBolge) then
outputChatBox("[RED:LUA Scripting]#ffffff Burada altın kazıması yapamazsın.",plr,255,0,0,true)
return end

--if not exports["global"]:hasItem(plr,Kazma) then outputChatBox("[RED:LUA Scripting]#ffffff Altın kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
if exports["global"]:hasItem(plr,IslenmisAltin) then outputChatBox("[!]#ffffff Envanterinde işlenmiş altın taşıyorken altın kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "altin:durum") then
	outputChatBox("[RED:LUA Scripting]#ffffff Altın kazabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("[RED:LUA Scripting]#FFFFFF /"..cmd.." [kaz] yazarak toplayabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	outputChatBox("[RED:LUA Scripting]#ffffff Altın toplamaya başladın..",plr,0,255,0,true)
	setElementData(plr, "altin:durum", true)
	exports["global"]:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["items"]:giveItem(plr,IslenmisAltin,1)
end
		outputChatBox("[RED:LUA Scripting]#ffffff Tebrikler, işlenmiş madeninizi artık borsada satabilirsiniz.",plr,0,255,0,true)
		exports["global"]:removeAnimation(plr)		
		setTimer(function()
		outputChatBox("[RED:LUA Scripting]#ffffff Süren doldu, yeniden altın toplayabilirsin.",plr,0,255,0,true)
			setElementData(plr, "altin:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)