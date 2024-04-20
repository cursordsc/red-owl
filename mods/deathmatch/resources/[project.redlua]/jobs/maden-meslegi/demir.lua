local infoisaret = createPickup( -85.5048828125, 1964.8671875, -12.768867492676, 3, 1239, 1, 1 );
local demirBolge = createColSphere (-85.5048828125, 1964.8671875, -12.768867492676, 40, 3, 81)
addCommandHandler("demir", function(plr, cmd,komut)

local Kazma = 578	
local DemirFiyati = 175
local IslenmisDemir = 576

if not isElementWithinColShape(plr, demirBolge) then
outputChatBox("[RED:LUA Scripting]#ffffff Burada demir kazıması yapamazsın.",plr,255,0,0,true)
return end

--if not exports["global"]:hasItem(plr,Kazma) then outputChatBox("[RED:LUA Scripting]#ffffff Demir kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
if exports["global"]:hasItem(plr,IslenmisDemir) then outputChatBox("[!]#ffffff Envanterinde işlenmiş demir taşıyorken demir kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "demir:durum") then
	outputChatBox("[RED:LUA Scripting]#ffffff Demir kazabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("[RED:LUA Scripting]#FFFFFF /"..cmd.." [kaz] yazarak toplayabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	outputChatBox("[RED:LUA Scripting]#ffffff Demir toplamaya başladın..",plr,0,255,0,true)
	setElementData(plr, "demir:durum", true)
	exports["global"]:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["items"]:giveItem(plr,IslenmisDemir,1)
end
		outputChatBox("[RED:LUA Scripting]#ffffff Tebrikler, işlenmiş madeninizi artık borsada satabilirsiniz.",plr,0,255,0,true)
		exports["global"]:removeAnimation(plr)	
		setTimer(function()
		outputChatBox("[RED:LUA Scripting]#ffffff Süren doldu, yeniden demir toplayabilirsin.",plr,0,255,0,true)
			setElementData(plr, "demir:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)