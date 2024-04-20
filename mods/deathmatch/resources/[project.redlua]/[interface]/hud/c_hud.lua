function bindSomeHotKey()
    bindKey("F5", "down", function()
        if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
            return false
        end
        triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
    end) 

    bindKey("x", "down", function() 
        if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
            return false
        end
        triggerServerEvent('vehicle:togWindow', localPlayer)
    end)
end
addEventHandler("onClientResourceStart", resourceRoot, bindSomeHotKey)

--[[x,y             = guiGetScreenSize()
cursorScreenX    = x/2
hudx            = 240
hudy            = 24
inbarY          = hudy/2 + 4
inbarX          = hudx - (hudy/2) + 4

local cursor = exports.fonts:getFont("FontAwesome", 12)
local iconsFont = dxCreateFont("fonts/FontAwesomeRegular.ttf", 9)
local iconsFont2 = dxCreateFont("fonts/FontAwesomeRegular.ttf", 10)
local player = tonumber(#getElementsByType('player'))

function dxDrawBorderedText( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
    dxDrawText ( text:gsub('#%x%x%x%x%x%x', ''), x - 1, y - 1, w - 1, h - 1, tocolor ( 0, 0, 0, 100 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text:gsub('#%x%x%x%x%x%x', ''), x + 1, y - 1, w + 1, h - 1, tocolor ( 0, 0, 0, 100 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text:gsub('#%x%x%x%x%x%x', ''), x - 1, y + 1, w - 1, h + 1, tocolor ( 0, 0, 0, 100 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text:gsub('#%x%x%x%x%x%x', ''), x + 1, y + 1, w + 1, h + 1, tocolor ( 0, 0, 0, 100 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text:gsub('#%x%x%x%x%x%x', ''), x - 1, y, w - 1, h, tocolor ( 0, 0, 0, 100 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text:gsub('#%x%x%x%x%x%x', ''), x + 1, y, w + 1, h, tocolor ( 0, 0, 0, 100 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text:gsub('#%x%x%x%x%x%x', ''), x, y - 1, w, h - 1, tocolor ( 0, 0, 0, 100 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text:gsub('#%x%x%x%x%x%x', ''), x, y + 1, w, h + 1, tocolor ( 0, 0, 0, 100 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, true )
end

function cursorDate()
    local time = getRealTime()
    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second
    
    local monthday = time.monthday
    local month = time.month
    local year = time.year
    
    local tarih = string.format("%02d.%02d.%04d", monthday, month + 1, year + 1900)
    local saat = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    return {tarih, saat}
end 


minimapPosX = (x-hudx) - 115
minimapPosY = - 30

renderHUD = function()
    --if  tonumber(getElementData(localPlayer, "loggedin")) == 1 then 
	if getElementData(localPlayer, "hud") == 1 and tonumber(getElementData(localPlayer, "loggedin")) == 1 then 

    end
end
addEventHandler('onClientRender',root,renderHUD)

addEventHandler("onClientRender", root,
    function()
        if  tonumber(getElementData(localPlayer, "loggedin")) == 1 then 

    local tarih, saat = cursorDate()[1], cursorDate()[2]
 
    cursorRoundedRectangle((x-hudx+4)-140,31, hudx+130 ,inbarY+15,tocolor(15, 15, 15, 235), { 0.7, 0.7, 0.7, 0.7 }, false)

    dxDrawText(saat..' / '..tarih,(x-hudx)+60,35,hudx,hudy,tocolor(255, 255, 255, 175), 1, cursor )
    dxDrawText('',(x-hudx)+40,39,hudx,hudy,tocolor(255, 255, 255, 175), 1, iconsFont )

    dxDrawText(""..getPlayerName(localPlayer):gsub("_"," "),(x-hudx)-100,35,hudx,hudy,tocolor(255, 255, 255, 175), 1, cursor )
    dxDrawText('',(x-hudx)-120,39,hudx,hudy,tocolor(255, 255, 255, 175), 1, iconsFont )

end
end]]
--)