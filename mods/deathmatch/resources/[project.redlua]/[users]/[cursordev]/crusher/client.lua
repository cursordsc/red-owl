local material = dxCreateTexture("files/image.png")
local sx, sy = guiGetScreenSize()
local white = "#ffffff"

function hitJunkCP(hitPlayer, matchingDimension)
    if hitPlayer == localPlayer and matchingDimension and getDistanceBetweenPoints3D(localPlayer.position, source.position) <= 3 then
        if getElementData(source, "junkyard") then
            local veh = getPedOccupiedVehicle(localPlayer)
            if getPedOccupiedVehicle(localPlayer) then
                if localPlayer.vehicleSeat == 0 then
                    local vehId = veh:getData("owner") or -1
                    local vehId2 = veh:getData("dbid") or -1
                    local accId = localPlayer:getData("dbid") or -1
                    if vehId == accId and vehId2 >= 1 then
                        gVeh = veh
                        gMarker = source
                        --outputChatBox("asd")
                        --setElementFrozen(gVeh, true)
                        start = true
                        startTick = getTickCount()
                        addEventHandler("onClientRender", root, renderPanel, true, "low-5")
                        addEventHandler("onClientClick", root, panelClick)
                        --oState = isCursorShowing()
                        --showCursor(true)
                        vehid = getElementModel(gVeh)
                        vehiclePrice = (getElementData(gVeh, "carshop:cost")) or 0
                        local carHealthMp = getElementHealth(gVeh) / 1000 -- azért 1000 mert a mostani hp-t elosszuk a maxhpval
                        ----outputChatBox(vehiclePrice)
                        ----outputChatBox(vehiclePr)
                        vehiclePrice = math.floor(vehiclePrice*multipler*carHealthMp)
                    else
                        outputChatBox("[!]#ffffff Bu araç senin değil.",255,0,0,true)
                    end
                end
            end
        end
    end
end
addEventHandler("onClientMarkerHit", root, hitJunkCP)

function leaveJunkCP(hitPlayer, matchingDimension)
    if hitPlayer == localPlayer and matchingDimension then
        if getElementData(source, "junkyard") then
            local veh = getPedOccupiedVehicle(localPlayer)
            if getPedOccupiedVehicle(localPlayer) then
                if start then
                    start = false
                    startTick = getTickCount()
                end
            end
        end
    end
end
addEventHandler("onClientMarkerLeave", root, leaveJunkCP)

startAnimationTime = 500
startAnimation = "InOutQuad"
white = "#7d7d7d"

function renderPanel()
    local alpha
    local nowTick = getTickCount()
    if start then
        local elapsedTime = nowTick - startTick
        local duration = (startTick + startAnimationTime) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            0, 0, 0,
            255, 0, 0,
            progress, startAnimation
        )
        
        alpha = alph
    else
        
        local elapsedTime = nowTick - startTick
        local duration = (startTick + startAnimationTime) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            255, 0, 0,
            0, 0, 0,
            progress, startAnimation
        )
        
        alpha = alph
        
        if progress >= 1 then
            alpha = 0
            removeEventHandler("onClientRender", root, renderPanel, true, "low-5")
            removeEventHandler("onClientClick", root, panelClick)
            return
        end
    end
    
    if not localPlayer.vehicle or gMarker:getData("using") then
        if start then
            start = false
            startTick = getTickCount()
        end
        return 
    end
    
    font = exports['fonts']:getFont("RobotoB", 14)
    baslik = exports.assets:getFont("in-bold", 17)
	baslik2 = exports.assets:getFont("in-regular", 9)
    font2 = exports['fonts']:getFont("RobotoB", 8)
    blue = "#4287f5"
    br, bg, bb = 66,135,245
    green = "#4bc44b"
    gr, gb, gg = 75, 196, 75
    red = "#b34545"
    rr, rg, rb = 179, 69, 69
    selected = nil
    
    local w, h = 430, 417
    local x, y = sx/2-w/2, sy/2-h/2
    dxDrawRectangle(x, y, w, h, tocolor(10,10,10,235))
    dxDrawRectangle(x + 2, y + 2, w - 4, 200, tocolor(5,5,5,255 * 0.3))
    dxDrawRectangle(x + 2, y + h - 2 - 112, w - 4, 112, tocolor(5,5,5,255 * 0.3))
    dxDrawImage(x, y, w, h, "files/icon.png", 0,0,0, tocolor(255,255,255,alpha))
    dxDrawText(red .. "ARAÇ MEZARLIĞI", sx/2, y + 180, sx/2, y + 180, tocolor(255,255,255,255), 1, baslik, "center", "center", false, false, false, true)
    dxDrawText("Merhaba! Araç parçalama arayüzüne hoş geldin.\nParçalama işlemi gerçekleştiğinde belirli bir ücret alırsınız.\nKabul ediyorsanız "..green.."‘Kabul Et’"..white.."  butonuna tıklayın.\n Vaz geçtiyseniz "..red.."‘Reddet’"..white.." butonuna tıklayın!\n\nSize Verilecek Ücret: "..blue..vehiclePrice.." $", sx/2, y + 200, sx/2, y + h - 2 - 112, tocolor(125, 125, 125, 255), 1, baslik2, "center", "center", false, false, false, true)

    if isInSlot(sx/2 - 276/2, y + h - 27 - 30 - 2 - 30, 276, 30) or pressing1 then
        dxDrawRectangle(sx/2 - 276/2, y + h - 27 - 30 - 2 - 30, 276, 30, tocolor(25,25,25,255)) -- átkelés
        if pressing then
            local elapsedTime = nowTick - pressTick
            local duration = (pressTick + 1000) - pressTick
            local progress = elapsedTime / duration
            local alph = interpolateBetween(
                0, 0, 0,
                100, 0, 0,
                progress, startAnimation
            )

            local multiplier = alph / 100

            dxDrawRectangle(sx/2 - 276/2, y + h - 27 - 30 - 2 - 2, 276 * multiplier, 2, tocolor(br,bg,bb,alpha)) -- átkelés

            if progress >= 1 then
                pressing = false
                if gMarker:getData("using") then return end
                if not localPlayer.vehicle then return end
                --givePlayerMoney(vehiclePrice)
                outputChatBox("[!]#ffffff Araç parçalama işlemi başlatıldı. Alacağınız ücret: $"..vehiclePrice,0,255,0,true)
				outputChatBox("[!]#ffffff Unutmayın, bu işlem geri alınamaz. Oluşacak zarardan yönetim sorumlu değildir!", 255,0,0,true)
                triggerServerEvent("parcalama:paraver",localPlayer,vehiclePrice)
                --outputChatBox("Kilépés")
                removeEventHandler("onClientRender", root, renderPanel)
                removeEventHandler("onClientClick", root, panelClick)
                --showCursor(false)
                local _, _, z1, _, _, z2 = getElementBoundingBox(localPlayer.vehicle)
                local z = math.abs(z1) + math.abs(z2)
                triggerServerEvent("acceptOffer", localPlayer, localPlayer, z)
            end
        end

        if not pressing1 then
            dxDrawText("Kabul Et", sx/2, y + h - 27 - 30 - 2 - 30, sx/2, y + h - 27 - 30 - 2, tocolor(gr, gb, gg, alpha), 1, font2, "center", "center", false, false, false, true)
            selected = 1
        else
            dxDrawText("Kabul Et", sx/2, y + h - 27 - 30 - 2 - 30, sx/2, y + h - 27 - 30 - 2, tocolor(125, 125, 125, alpha), 1, font2, "center", "center", false, false, false, true)
        end
    else
        dxDrawRectangle(sx/2 - 276/2, y + h - 27 - 30 - 2 - 30, 276, 30, tocolor(44,44,44,alpha)) -- átkelés
        dxDrawText("Kabul Et", sx/2, y + h - 27 - 30 - 2 - 30, sx/2, y + h - 27 - 30 - 2, tocolor(125, 125, 125, alpha), 1, font2, "center", "center", false, false, false, true)
    end

    if isInSlot(sx/2 - 276/2, y + h - 27 - 30, 276, 30) or pressing2 then
        dxDrawRectangle(sx/2 - 276/2, y + h - 27 - 30, 276, 30, tocolor(25,25,25,255)) -- Reddet
        if pressing then
            local elapsedTime = nowTick - pressTick
            local duration = (pressTick + 1000) - pressTick
            local progress = elapsedTime / duration
            local alph = interpolateBetween(
                0, 0, 0,
                100, 0, 0,
                progress, startAnimation
            )

            local multiplier = alph / 100

            dxDrawRectangle(sx/2 - 276/2, y + h - 27 - 2, 276 * multiplier, 2, tocolor(br,bg,bb,alpha)) -- átkelés

            if progress >= 1 then
                pressing = false
                start = false
                startTick = getTickCount()
            end
        end

        if not pressing2 then
            dxDrawText("Reddet", sx/2, y + h - 27 - 30, sx/2, y + h - 27, tocolor(rr, rg, rb, alpha), 1, font2, "center", "center", false, false, false, true)
            selected = 2
        else
            dxDrawText("Reddet", sx/2, y + h - 27 - 30, sx/2, y + h - 27, tocolor(125, 125, 125, alpha), 1, font2, "center", "center", false, false, false, true)
        end
    else
        dxDrawRectangle(sx/2 - 276/2, y + h - 27 - 30, 276, 30, tocolor(44,44,44,alpha)) -- Reddet
        dxDrawText("Reddet", sx/2, y + h - 27 - 30, sx/2, y + h - 27, tocolor(125, 125, 125, alpha), 1, font2, "center", "center", false, false, false, true)
    end
end

addEvent("changeMultipler", true)
addEventHandler("changeMultipler", root, 
    function(mp)
        ----outputChatBox("kliens: " .. mp)
        multipler = mp
    end
)    

addEvent("getData", true)
addEventHandler("getData", root, 
        function(datas)
        ----outputChatBox("kliens: " .. mp)
        gMarker = datas[1]
        craneObj = datas[2]
        crObj = datas[3]


        addEventHandler("onClientElementDataChange", craneObj,
            function(dName)
                if source == craneObj then
                    if dName == "startPos" then
                        if isElementStreamedIn(craneObj) then
                            local val = source:getData(dName)
                            if val then
                                if not lineState then
                                    start = val
                                    lineState = true
                                    addEventHandler("onClientRender", root, drawnLines, true, "low-5")
                                end
                            else
                                if lineState then
                                    lineState = false
                                    removeEventHandler("onClientRender", root, drawnLines)
                                end
                            end
                        end
                    end
                end
            end
        )
    end
)    


function onStart()
    triggerServerEvent("requestMultipler", localPlayer, localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, onStart)

lastClickTick = 0

function panelClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "left" and state == "down" then
        if selected == 2 then
            pressing = true
            pressTick = getTickCount()
        elseif selected == 1 then
            pressing = true
            pressTick = getTickCount()
        end
        selected = nil
    elseif button == "left" and state == "up" then
        if pressing then
            pressing = false
        end
    end
end

addEventHandler("onClientKey",root,
	function(bill,press)
        --outputChatBox(tostring(press))
		if bill == "enter" and start and not isChatBoxInputActive() then
            cancelEvent()
            if press then
                pressing1 = true
                pressing2 = false
                pressing = true
                pressTick = getTickCount()
            else
                pressing = false
                pressing1 = false
                pressTick = getTickCount()
            end
		elseif bill == "backspace" and start and not isChatBoxInputActive() then
			if press then
                pressing2 = true
                pressing1 = false
                pressing = true
                pressTick = getTickCount()
            else
                pressing2 = false
                pressing = false
                pressTick = getTickCount()
            end
		end
	end
)

--Render

screenSize = {guiGetScreenSize()}
getCursorPos = getCursorPosition
function getCursorPosition()

    --outputChatBox(tostring(isCursorShowing()))
    if isCursorShowing() then
        --outputChatBox("asd")
        local x,y = getCursorPos()
        --outputChatBox("x"..tostring(x))
        --outputChatBox("y"..tostring(y))
        x, y = x * screenSize[1], y * screenSize[2] 
        return x,y
    else
        return -5000, -5000
    end
end

cursorState = isCursorShowing()
cursorX, cursorY = getCursorPosition()

function isInBox(dX, dY, dSZ, dM, eX, eY)
    if eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM then
        return true
    else
        return false
    end
end

function isInSlot(xS,yS,wS,hS)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        if isInBox(xS,yS,wS,hS, cursorX, cursorY) then
            return true
        else
            return false
        end
    end 
end

--3dLine
function drawnLines()
    if isElementStreamedIn(craneObj) then
        dxDrawLine3D(start[1], start[2], start[3], craneObj.position, tocolor(0,0,0,255), 10)
    end
    ----outputChatBox("asd")
end