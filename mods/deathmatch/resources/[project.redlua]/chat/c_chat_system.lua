bindKey("b", "down", "chatbox", "LocalOOC")
bindKey ("u" , "down" , "chatbox", "quickreply")

data = { }
function datachange(value)
	if (data[value] == nil) then
		data[value] = 1
	else
		data[value] = data[value] + 1
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), datachange)

function playRadioSound()
	playSoundFrontEnd(47)
	setTimer(playSoundFrontEnd, 700, 1, 48)
	setTimer(playSoundFrontEnd, 800, 1, 48)
end
addEvent( "playRadioSound", true )
addEventHandler( "playRadioSound", getRootElement(), playRadioSound )

--Exciter
function playCustomChatSound(sound)
	playSound("sound/"..tostring(sound), false)
end
addEvent( "playCustomChatSound", true )
addEventHandler( "playCustomChatSound", getRootElement(), playCustomChatSound )

local tick = getTickCount()
function showdata()
	local tick2 = getTickCount()
	local time = (tick2 - tick) / 1000
	outputChatBox("Sync for " .. time .. " seconds.")
	
	local largest = 0
	local largestname = "none"
	for key, value in pairs(data) do
		if (value>=5) then
			if (value>largest) and (value~="scoreboard:reload") then
				largest = value
				largestname = key
			end
			outputChatBox(tostring(key) .. ": ".. value)
		end
	end
	
	outputChatBox("En büyüğü: ".. largestname .. ": " .. largest)
end
addCommandHandler("showdata", showdata)


--HQ CHAT FOR PD / MAXIME
function playHQSound()
	playSoundFrontEnd(1)
	setTimer(playSoundFrontEnd, 300, 1, 1)
end
addEvent("playHQSound", true)
addEventHandler("playHQSound", getRootElement(), playHQSound)

--PM SOUND FX / MAXIME
function playPmSound()
local pmsound = playSound("sound/pmSoundFX.mp3",false)
setSoundVolume(pmsound, 0.9)
end
addEvent("pmSoundFX",true)
addEventHandler("pmSoundFX",getRootElement(),playPmSound)

addCommandHandler("oocdurum", function()
	if localPlayer:getData("loggedin") == 1 then
		if exports["integration"]:isPlayerTrialAdmin() and localPlayer:getData("duty_admin") == 1 then
			local konum = oyuncu:getPosition()
			local x, y, z = konum:getX(), konum:getY(), konum:getZ()

			local alan = createColSphere(x,y,z, 20)
		end
	end
end)

addCommandHandler("d", function()
	outputChatBox("[!] başarılı bir biçimde işlemi gerçekleştirmek için /dep")
end, false, false)
