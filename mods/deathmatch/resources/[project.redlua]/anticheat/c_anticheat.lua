local localPlayer = getLocalPlayer()
local timer = false
local kills = 0
function checkDM(killer)
	if (killer==localPlayer) then
		kills = kills + 1
		
		if (kills>=3) then
			triggerServerEvent("alertAdminsOfDM", localPlayer, kills)
		end
		
		if not (timer) then
			timer = true
			setTimer(resetDMCD, 120000, 1)
		end
	end
end
addEventHandler("onClientPlayerWasted", getRootElement(), checkDM)

function resetDMCD()
	kills = 0
	timer = false
end

function setEld(oyuncu, data, deger, sync)
	local sync2 = false
	local nosyncatall = true
	if sync == "one" then
		sync2 = false
		nosyncatall = false
		setElementdata(oyuncu, data, deger)
	elseif sync == "all" then
		sync2 = true
		nosyncatall = false
	else
		return setElementdata(oyuncu, data, deger)
	end
	return triggerServerEvent("anticheat:changeEld", oyuncu, data, deger, sync2, nosyncatall)
end