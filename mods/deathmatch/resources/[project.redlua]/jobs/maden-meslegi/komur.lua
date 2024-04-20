local infoisaret = createPickup(-96.728515625, 1990.3515625, -12.667381286621, 3, 1239, 1, 1 );
local komurBolge = createColSphere (-96.728515625, 1990.3515625, -12.667381286621, 40, 3, 81)
addCommandHandler("komur", function(plr, cmd,komut)

local Kazma = 578
local KomurFiyati = 75
local IslenmisKomur = 574

if not isElementWithinColShape(plr, komurBolge) then
outputChatBox("[RED:LUA Scripting]#ffffff Burada kömür kazıması yapamazsın.",plr,255,0,0,true)
return end

--if not exports["global"]:hasItem(plr,Kazma) then outputChatBox("[RED:LUA Scripting]#ffffff Kömür kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
if exports["global"]:hasItem(plr,IslenmisKomur) then outputChatBox("[!]#ffffff Envanterinde işlenmiş kömür taşıyorken kömür kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "komur:durum") then
	outputChatBox("[RED:LUA Scripting]#ffffff Kömür kazabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("[RED:LUA Scripting]#FFFFFF /"..cmd.." [kaz] yazarak toplayabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	outputChatBox("[RED:LUA Scripting]#ffffff Kömür toplamaya başladın..",plr,0,255,0,true)
	setElementData(plr, "komur:durum", true)
	exports["global"]:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["items"]:giveItem(plr,IslenmisKomur,1)
end
		outputChatBox("[RED:LUA Scripting]#ffffff Tebrikler, işlenmiş madeninizi artık borsada satabilirsiniz.",plr,0,255,0,true)
		exports["global"]:removeAnimation(plr)		
		setTimer(function()
		outputChatBox("[RED:LUA Scripting]#ffffff Süren doldu, yeniden kömür toplayabilirsin.",plr,0,255,0,true)
			setElementData(plr, "komur:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)