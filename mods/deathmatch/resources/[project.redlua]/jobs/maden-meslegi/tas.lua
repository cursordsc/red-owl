local infoisaret = createPickup( -88.12890625, 1985.4677734375, -12.766128540039, 3, 1239, 1, 1 );
local tasBolge = createColSphere (-88.12890625, 1985.4677734375, -12.766128540039, 40, 3, 81)
addCommandHandler("tas", function(plr, cmd,komut)

local Kazma = 578
local TasFiyati = 50
local IslenmisTas = 573

if not isElementWithinColShape(plr, tasBolge) then
outputChatBox("[RED:LUA Scripting]#ffffff Burada taş kazıması yapamazsın.",plr,255,0,0,true)
return end

--if not exports["global"]:hasItem(plr,Kazma) then outputChatBox("[RED:LUA Scripting]#ffffff Taş kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
if exports["global"]:hasItem(plr,IslenmisTas) then outputChatBox("[!]#ffffff Envanterinde işlenmiş taş taşıyorken taş kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "tas:durum") then
	outputChatBox("[RED:LUA Scripting]#ffffff Taş toplayabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("[RED:LUA Scripting]#FFFFFF /"..cmd.." [kaz] yazarak kazabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	outputChatBox("[RED:LUA Scripting]#ffffff Taş kazmaya başladın..",plr,0,255,0,true)
	setElementData(plr, "tas:durum", true)
	exports["global"]:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["items"]:giveItem(plr,IslenmisTas,1)
end
		outputChatBox("[RED:LUA Scripting]#ffffff Tebrikler, işlenmiş madeninizi artık borsada satabilirsiniz.",plr,0,255,0,true)
		exports["global"]:removeAnimation(plr)			
		setTimer(function()
		outputChatBox("[RED:LUA Scripting]#ffffff Süren doldu, yeniden taş toplayabilirsin.",plr,0,255,0,true)
			setElementData(plr, "tas:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)