local infoisaret = createPickup( -88.15625, 1972.40234375, -12.74259185791, 3, 1239, 1, 1 );
local bakirBolge = createColSphere (-88.15625, 1972.40234375, -12.74259185791, 40, 3, 81)
addCommandHandler("bakir", function(plr, cmd,komut)

local Kazma = 578
local BakirFiyati = 150
local IslenmisBakir = 575

if not isElementWithinColShape(plr, bakirBolge) then
outputChatBox("[RED:LUA Scripting]#ffffff Burada bakır kazıması yapamazsın.",plr,255,0,0,true)
return end

--if not exports["global"]:hasItem(plr,Kazma) then outputChatBox("[RED:LUA Scripting]#ffffff Bakır kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
if exports["global"]:hasItem(plr,IslenmisBakir) then outputChatBox("[!]#ffffff Envanterinde işlenmiş bakır taşıyorken bakır kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "bakir:durum") then
	outputChatBox("[RED:LUA Scripting]#ffffff Bakır kazabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("[RED:LUA Scripting]#FFFFFF /"..cmd.." [kaz] yazarak toplayabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	outputChatBox("[RED:LUA Scripting]#ffffff Bakır toplamaya başladın..",plr,0,255,0,true)
	setElementData(plr, "bakir:durum", true)
	exports["global"]:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["items"]:giveItem(plr,IslenmisBakir,1)
end
		outputChatBox("[RED:LUA Scripting]#ffffff Tebrikler, işlenmiş madeninizi artık borsada satabilirsiniz.",plr,0,255,0,true)
		exports["global"]:removeAnimation(plr)		
		setTimer(function()
			setElementData(plr, "bakir:durum", nil)
		outputChatBox("[RED:LUA Scripting]#ffffff Süren doldu, yeniden bakır toplayabilirsin.",plr,0,255,0,true)			
		end, 300000, 1)
	end, 10000, 1)

end

end)