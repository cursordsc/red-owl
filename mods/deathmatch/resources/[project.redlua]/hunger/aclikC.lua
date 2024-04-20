azalmaSure = 180 -- Buraya girdiğiniz değer kadar saniyede bir açlık seviyesi düşer.
miliSaniye = (azalmaSure*1000) -- Bu kısım üstte girdiğiniz saniyeyi milisaniye'ye çevirir ve sistemin işlemesini sağlar.

addEventHandler ("onClientResourceStart", getResourceRootElement(),
function ()
	setTimer (aclikAzalma,miliSaniye,0,localPlayer)
	setTimer (susuzlukAzalma,miliSaniye,0,localPlayer)
end)

function aclikAzalma(oyuncu)
	if oyuncu:getData("loggedin") == 1 then
		if (oyuncu == localPlayer) then
			if not (oyuncuAclik(oyuncu) <= 0) then
				return oyuncu:setData("hunger", oyuncuAclik(oyuncu) - 1)
			end
		end
	end
end

function susuzlukAzalma(oyuncu)
	if oyuncu:getData("loggedin") == 1 then
		if (oyuncu == localPlayer) then
			if not (oyuncuSusuzluk(oyuncu) <= 0) then
				return oyuncu:setData("thirst", oyuncuSusuzluk(oyuncu) - 1)
			end
		end
	end
end

setTimer(function() 
	if localPlayer:getData("loggedin") == 0 then
		if localPlayer:getData("hunger") <= 10 then 
			triggerServerEvent("aclik:emote", localPlayer) 
		end
	end
end, 600000, 0) -- 5 Dakikada bir

setTimer(
function()
	if localPlayer:getData("loggedin") == 1 then
		if tonumber(localPlayer:getData("hunger")) <= 10 then
			localPlayer:setHealth( localPlayer:getHealth(localPlayer) - 0.2)
		elseif localPlayer:getData("hunger") <= 0 then
			localPlayer:setHealth( localPlayer:getHealth(localPlayer) - 0.5)
		else
			localPlayer:setHealth( localPlayer:getHealth(localPlayer) + 2)
		end

		if localPlayer:getData("thirst") <= 10 then
			localPlayer:setHealth( localPlayer:getHealth(localPlayer) - 0.2)
		elseif localPlayer:getData("thirst") <= 0 then
			localPlayer:setHealth( localPlayer:getHealth(localPlayer) - 0.5)
		else
			localPlayer:setHealth( localPlayer:getHealth(localPlayer) + 2)
		end
	end
end, 60000, 0)

function oyuncuAclik(oyuncu)
	if (oyuncu == getLocalPlayer()) then
		local aclik = oyuncu:getData("hunger") or 100
		return tonumber(aclik)
	end
end

function oyuncuSusuzluk(oyuncu)
	if (oyuncu == getLocalPlayer()) then
		local susuzluk = oyuncu:getData("thirst") or 100
		return tonumber(susuzluk)
	end
end
