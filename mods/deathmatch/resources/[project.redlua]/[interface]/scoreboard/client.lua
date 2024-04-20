local screenX, screenY = guiGetScreenSize()
local w, h = 600, 450
local x, y = (screenX - w)/2, (screenY - h)/2
local alpha = 15
local logoAlpha = 1
local toggle = nil
local scoreboard = nil
local currentRow = 1
local maxShowing = 20
local playerData = {}

local roboto = "default-bold"
local roboto10 = exports.assets:getFont('Roboto', 9)
local robotob = exports.assets:getFont('RobotoB', 9)
local awesome = exports.assets:getFont('FontAwesome', 9)

local mainText = {
    "Lonca Roleplay V2.0 - Bir roleplay sunucusu ve daha fazlası karşınızda.",
    "Bize yakında www.loncaroleplay.com sitesinden ulaşabiliceksiniz.",
    "Market hakkında bilgi almak için /market yazabilirsiniz.",
    "Sunucuyla alakalı bir probleminiz olursa discord üzerinden ticket açabilirsiniz.",
    "Bir bug veya hata ile karşılaşırsanız bize bildirmeyi unutmayınız.",
    "Ziraat, ininal ve papara ile bakiye yükleme işlemi yapabilirsiniz.",
}

local lastText = 0
local lastMainText = 1

function renderScoreboard()

    if not playerData then return end

    if toggle then
        alpha = alpha + 5
        logoAlpha = logoAlpha + 1
        if alpha > 200 then alpha = 200 end
        if logoAlpha > 35 then logoAlpha = 35 end

        lastText = lastText + 1
        if lastText > 500 then
            if lastMainText < #mainText then 
                lastMainText = lastMainText +1
            else
                lastMainText = 1
            end
            lastText = 0
        end

    else
        alpha = alpha - 5
        if logoAlpha > 0 then logoAlpha = logoAlpha -1 end
        if alpha == 0 then removeEventHandler('onClientRender', root, renderScoreboard) scoreboard = nil executeCommandHandler("name") end
    end
    
    roundedRectangle(x,y,w,h, tocolor(15,15,15,225))
    roundedRectangle(x,y,w,32, tocolor(15,15,15,225))

    dxDrawText(mainText[lastMainText], x+10,y+7, 25,25, tocolor(255,255,255,alpha), 1, roboto10)
    dxDrawText("   "..(#playerData), x+w-45-dxGetTextWidth(#playerData, 0.8, awesome),y+8, 25,25, tocolor(255,255,255,alpha), 1, awesome)

    dxDrawText("   id          isim soyisim                                                                                  geçirdiği saat                        gecikmesi", x+15,y+40, 25, 25, tocolor(200,200,200,alpha), 1, roboto10)
    dxDrawRectangle(x+15,y+65, w-35, 1, tocolor(150,150,150,alpha))

    playerData = {}         
    for k,v in ipairs(getElementsByType("player")) do
        playerData[k] = v
    end

    local latestLine = currentRow + maxShowing
    local count = 0
    for index, value in ipairs(playerData) do
        if value and index >= currentRow and index <= latestLine then
            count = count + 1
            local r,g,b = getPlayerNametagColor(value)
            local name = getPlayerName(value):gsub("_"," ") or "Belirsiz"
            local hoursplayed = getElementData(value, 'hoursplayed') or "Yeni"

            dxDrawText(getElementData(value, 'playerid') or 0, x+25,y+55+(count*20), 25, 25, tocolor(r,g,b,alpha), 1, roboto10)
            if getElementData(localPlayer, 'admin_duty') then
                dxDrawText(name.." ("..(getElementData(value, "account:username") or "")..")", x+65,y+55+(count*20), 25, 25, tocolor(r,g,b,alpha), 1, roboto10)
            else
                dxDrawText(name, x+65,y+55+(count*20), 25, 25, tocolor(r,g,b,alpha), 1, roboto10)
            end

            dxDrawText(hoursplayed, x+405-dxGetTextWidth(hoursplayed, 0.5, roboto10),y+55+(count*20), 25, 25, tocolor(r,g,b,alpha), 1, roboto10)

            local ping = getPlayerPing(value)

            if isInBox(x+w-65, y+55+(count*20), 15, 15) then
                dxDrawText(ping, x+w-62-dxGetTextWidth(ping, 0.5, roboto10),y+55+(count*20), 25, 25, tocolor(r,g,b,alpha), 1, roboto10)
            else

            if ping < 100 then
                ping = "files/normal.png"
            elseif ping > 150 then
                ping = "files/normal.png"
            else
                ping = "files/low.png" 
            end
                dxDrawImage(x+w-65, y+55+(count*20), 15, 15, ping, 0,0,0, tocolor(200,200,200, alpha))
            end
        end
    end

end

addEventHandler("onClientKey",root,
    function(button,state)
        if getElementData(localPlayer,"loggedin") == 1 then
            if (button == "tab") then
                cancelEvent()
                if (state) then
                    alpha = 15
                    logoAlpha = 1
                    toggle = true
                    
                    playerData = {}
                    for k,v in ipairs(getElementsByType("player")) do
                        playerData[k] = v
                    end

                    table.sort(playerData, function(a, b)
                        if a~= localPlayer and b ~= localPlayer and getElementData(a, "playerid") and getElementData(b, "playerid" ) then
                            return getElementData(a, "playerid") < getElementData(b, "playerid")
                        end
                    end)
                    
                    if not scoreboard then
                        scoreboard = true
                        addEventHandler('onClientRender', root, renderScoreboard)
                        executeCommandHandler("name")
                    end
                else
                    toggle = nil
                end
            elseif button == "mouse_whedown" and state then
                if scoreboard then
                    if currentRow + maxShowing < #playerData then
                        currentRow = currentRow +1
                    end
                end
            elseif button == "mouse_wheup" and state then
                if scoreboard then
                    if currentRow > 1 then
                        currentRow = currentRow -1
                    end
                end
            end
        end
    end
)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
    if (x and y and w and h) then
        if (not borderColor) then
            borderColor = tocolor(0, 0, 0, 180)
        end
        if (not bgColor) then
            bgColor = borderColor
        end
        dxDrawRectangle(x, y, w, h, bgColor, postGUI);
        dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
        dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
        dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
        dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);

        dxDrawRectangle(x + 0.5, y + 0.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + 0.5, y + h - 1.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + w - 0.5, y + 0.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + w - 0.5, y + h - 1.5, 1, 2, borderColor, postGUI);
    end
end

function roundedCircleRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function isInBox(xS,yS,wS,hS)
    if(isCursorShowing()) then
        local sX, sY = guiGetScreenSize()
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX*sX, cursorY*sY
        if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
            return true
        else
            return false
        end
    end 
end
