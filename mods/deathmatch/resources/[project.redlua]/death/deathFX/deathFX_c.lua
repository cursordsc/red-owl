
--MAXIME
local deathSound = nil
local ckSound = nil
function playerWasted (thePlayer)
	deathSound = playSound("deathFX/wasted.mp3",false)
	setSoundVolume(deathSound, 0.2)
	setGameSpeed (0.1)
end
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), playerWasted )

function playerSpawn()
	if deathSound and isElement(deathSound) then
		destroyElement(deathSound)
	end
	setGameSpeed (1)
end
addEventHandler ( "onClientPlayerSpawn", getLocalPlayer(), playerSpawn )


local pedInfo = {
    --back left
    {
        model=104,
        x=870.099,
        y=-1102.699,
        z=24.5,
        rotZ=270,
        initX=893.4,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    },
    --middle left
    {
        model=143,
        x=871,
        y=-1102.699,
        z=24.5,
        rotZ=270,
        initX=894.200,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    },
    --front left
    {
        model=185,
        x=872.099,
        y=-1102.700,
        z=24.5,
        rotZ=270,
        initX=895.099,
        initY=-1089.9,
        initZ=24.299,
        initRotZ=180
    },
    --back right
    {
        model=47,
        x=870.099,
        y=-1101.299,
        z=24.5,
        rotZ=270,
        initX=896,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    },  
    --middle right
    {
        model=30,
        x=871,
        y=-1101.300,
        z=24.5,
        rotZ=270,
        initX=896.799,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    },
    --front right
    {
        model=166,
        x=872.099,
        y=-1101.300,
        z=24.5,
        rotZ=270,
        initX=897.599,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    }
}

local danceMoves = {
    "dance_loop",
    "dan_down_a",
    "dan_left_a"
}

local coffinCameraPos = {
    {
        876.04760742188, -1102.0268554688, 24.955196380615, 776.07507324219, -1100.548828125, 23.136426925659
    },
    {
        871.17047119141, -1098.109375, 25.18699836731, 869.30242919922, -1197.7568359375, 17.008024215698
    },
    {
        875.92095947266, -1103.0090332031, 24.648569107056, 777.544921875, -1085.0686035156, 24.103551864624
    }
}


local thePeds = {}
local theCoffin
local targetPlayerName

local initialCameraTarget

local changeCameraTimer

function randomDanceMove()
    return danceMoves[math.random(#danceMoves)]
end

function randomCameraPos()
    return unpack(coffinCameraPos[math.random(#coffinCameraPos)])
end

function createPedsAndCoffin()
    theCoffin = createObject(2896, 871, -1102, 25.25)
    setElementCollisionsEnabled(theCoffin, false)
    for i, pedData in pairs(pedInfo) do
        pedInfo[i].thePed = createPed(pedData.model,pedData.initX, pedData.initY, pedData.initZ, pedData.initRotZ)    
    end
end

function movePedsAndCoffin()
    randomMove = randomDanceMove()
    for i, pedData in pairs(pedInfo) do
        setElementPosition(pedInfo[i].thePed, pedData.x, pedData.y, pedData.z)
        setElementRotation(pedInfo[i].thePed, 0,0, pedData.rotZ)
        setPedAnimation(pedInfo[i].thePed, "dancing", randomMove, -1, true)
    end

    setCameraMatrix(874.66851806641, -1103.0676269531, 26.115673065186, 783.24334716797, -1071.3548583984, 0.90169233083725)
    changeCameraTimer = setTimer(changeMovesAndCamera, 3000, 0)
end

function changeMovesAndCamera()
    randomMove = randomDanceMove()
    for i, pedData in pairs(pedInfo) do
        setPedAnimation(pedInfo[i].thePed, "dancing", randomMove, -1, true)
    end
    local x, y, z, lx, ly, lz = randomCameraPos()
    setCameraMatrix(x, y, z, lx, ly, lz)
end


local playerVehicle
local velX, velY, velZ

function startCoffinDance(targetPlayer)
    initialCameraTarget = getCameraTarget();
    if(not initialCameraTarget) then
        initialCameraTarget = localPlayer
    elseif(getElementType(initialCameraTarget) == "vehicle") then
        initialCameraTarget = getVehicleOccupant(initialCameraTarget)
    end
    playerVehicle = getPedOccupiedVehicle(localPlayer)
    if(playerVehicle) then
        velX, velY, velZ = getElementVelocity(playerVehicle)
        setElementFrozen(playerVehicle, true)
    elseif(not isPedDead(localPlayer)) then
        setElementFrozen(localPlayer, true)
    end
    targetPlayerName = getPlayerName(targetPlayer)
    createPedsAndCoffin()
    local sound = playSound("sounds/music.mp3")

    setTimer(endCoffinDance, 20000, 1)
    smoothMoveCamera(895.61645507813, -1090.732421875, 25.03558921814, 800.69714355469, -1059.275390625, 25.923006057739, 895.61645507813, -1090.732421875, 25.03558921814, 989.95971679688, -1057.6175537109, 23.375392913818, 5000)

    setTimer(movePedsAndCoffin, 5000, 1)
    addEventHandler("onClientRender", root, drawNameTag)
    addEventHandler("onClientRender", root, adjustCoffinPosition)
end
addEvent("showCkWindow",true)
addEventHandler("showCkWindow", resourceRoot, startCoffinDance)


-- Restore everything
function endCoffinDance()
    if(isTimer(changeCameraTimer)) then 
        killTimer(changeCameraTimer)
    end
    removeEventHandler("onClientRender", root, drawNameTag)
    removeEventHandler("onClientRender", root, adjustCoffinPosition)
    setCameraTarget(initialCameraTarget)

    
    setTimer(
        function()
            if (playerVehicle) then
                setElementFrozen(playerVehicle, false)
                setElementVelocity(playerVehicle, velX, velY, velZ)
            elseif(not isPedDead(localPlayer)) then
                setElementFrozen(localPlayer, false)
            end
        end,
        500,
        1
    )
        
   
    for i, pedData in pairs(pedInfo) do
        if(isElement(pedInfo[i].thePed)) then
            destroyElement(pedInfo[i].thePed)
        end
    end
    if(isElement(theCoffin)) then
        destroyElement(theCoffin)
    end
end


function adjustCoffinPosition()
    local sx, sy, sz = getPedBonePosition( pedInfo[1].thePed, 32 )
    local x,y,z = getElementPosition(theCoffin)
    setElementPosition(theCoffin, x,y,sz+0.38)
end



function drawNameTag ()
	rx, ry, rz = getElementPosition (theCoffin)
	px01, py01, pz01 = getCameraMatrix()
	distance01 = getDistanceBetweenPoints3D (rx, ry, rz, px01, py01, pz01)
	if distance01 <= 150 then
		local sx01 ,sy01 = getScreenFromWorldPosition (rx, ry, rz+0.2, 0.06)
		if not sx01 then return end
		dxDrawText (targetPlayerName, sx01, sy01 - 30, sx01, sy01 - 30, tocolor(0, 0, 255, 200), math.min (0.4*(150/distance01)*1.4,4), "default", "center", "bottom", false, false, false, true)
	end
end

-- ///////////// smoothmove camera script from mta Wiki

local sm = {}
sm.moov = 0

local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end

local start
local animTime
local tempPos = {{},{}}
local tempPos2 = {{},{}}

local function camRender()
	local now = getTickCount()
	if (sm.moov == 1) then
		local x1, y1, z1 = interpolateBetween(tempPos[1][1], tempPos[1][2], tempPos[1][3], tempPos2[1][1], tempPos2[1][2], tempPos2[1][3], (now-start)/animTime, "InOutQuad")
		local x2,y2,z2 = interpolateBetween(tempPos[2][1], tempPos[2][2], tempPos[2][3], tempPos2[2][1], tempPos2[2][2], tempPos2[2][3], (now-start)/animTime, "InOutQuad")
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientRender",root,camRender)
		fadeCamera(true)
	end
end

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1) then
		killTimer(timer1)
		killTimer(timer2)
		removeEventHandler("onClientRender",root,camRender)
		fadeCamera(true)
	end
	fadeCamera(true)
	sm.moov = 1
	timer1 = setTimer(removeCamHandler,time,1)
	timer2 = setTimer(fadeCamera, time-1000, 1, false) -- 
	start = getTickCount()
	animTime = time
	tempPos[1] = {x1,y1,z1}
	tempPos[2] = {x1t,y1t,z1t}
	tempPos2[1] = {x2,y2,z2}
	tempPos2[2] = {x2t,y2t,z2t}
	addEventHandler("onClientRender",root,camRender)
	return true
end

--[[local gui = {}
function showCkWindow()
	triggerServerEvent("updateCharacters", localPlayer)
	setTimer(function()
		triggerEvent("accounts:logout", localPlayer)
		setGameSpeed (1)
		closeCkWindow()

		ckSound = playSound("deathFX/cked.mp3",false)
		setSoundVolume(ckSound, 0.4)

		triggerEvent("es-system:closeRespawnButton", localPlayer)

		gui.window = guiCreateStaticImage(0, 0, 350, 300, ":resources/window_body.png", false)
		exports["global"]:centerWindow(gui.window)

		gui.label = guiCreateLabel(0.05, 0.05, 0.9, 0.7, string.gsub(getPlayerName(localPlayer), "_", " ").." has just been CK-ed!\n\nCK (Character killing) is the most uncommon way a character is killed in game and is used only in situations where it's needed. \n\nWhen you are killed from a CK, it's permanent and the only way to get the assests that are owned by this character back is from a stat transfer perk in Premium Features (F10).\n\nYou are now redirected to character selection screen as it was the only option you had.", true, gui.window)
		guiLabelSetHorizontalAlign(gui.label, "left", true)
		guiLabelSetVerticalAlign(gui.label, "center", true)

		gui.bClose = guiCreateButton(0.05, 0.8, 0.9, 0.15, "OK", true, gui.window)
		addEventHandler("onClientGUIClick", gui.bClose,
		function ()
			if source == gui.bClose then
				closeCkWindow()
			end
		end, false)
	end, 2000, 1)
end
addEvent("showCkWindow", true)
addEventHandler ( "showCkWindow", localPlayer, showCkWindow )

function closeCkWindow()
	if gui.window and isElement(gui.window) then
		destroyElement(gui.window)
		--setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	end
end]]
