local sx, sy = guiGetScreenSize()
local w2,h2 = 75,75
local wx2,wy2 = (sx-w2)/1-10,(sy-h2)/1
local asufontV = dxCreateFont("files/font.ttf",10)

setTimer(function()
	if getPedOccupiedVehicle(localPlayer) then
    local theVehicle = getPedOccupiedVehicle(localPlayer)
    local vehs = math.floor(getElementSpeed(theVehicle, "kmh"))
    local speedText = getFormatSpeed(vehs)
    local fuel = getElementData(theVehicle, "fuel") or 100
	dxDrawText(speedText,wx2,wy2+60,wx2+w2-90,wy2,tocolor(255,255,255),3,"default-bold","right","center",false,false,false,true)
    dxDrawText("km/h",wx2,wy2+67,wx2+w2-30,wy2,tocolor(255,255,255),2,"default-bold","right","center",false,false,false,true)
    dxDrawText("",wx2,wy2+67,wx2+w2,wy2,tocolor(255,255,255),1,asufontV,"right","center",false,false,false,true)
    asu_r(wx2+59,wy2-20,10,40,tocolor(70,130,84),5)
    asu_r(wx2+59,wy2-20,10,fuel/2.50,tocolor(121,220,145),5)
    dxDrawImage(wx2-100,wy2-16,150,60,"files/bar.png",0,0,0,tocolor(170,170,170))
    dxDrawImageSection(wx2-100,wy2-16,vehs/2,60, 0, 0,vehs/2,60,'files/bar.png')
	end
end,0,0)

function asu_r(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

function getFormatSpeed(unit)
    if unit < 10 then
        unit = "#aaaaaa00#ffffff" .. unit
    elseif unit < 100 then
        unit = "#aaaaaa0#ffffff" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end


function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100 * 1.609344)
        end
    else
        return false
    end
end