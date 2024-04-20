local sx, sy = guiGetScreenSize()
--BÜYÜK KUTUCUKLAR
local w, h = 85,23
local wx, wy = (sx-w)/125, (sy-h)/1.009
--UFAK KUTUCUKLAR
local we, he = 30,23
local wx, wy = (sx-we)/125, (sy-he)/1.009
--
local cords = {
    {0, "N"},
    {15, 15},
    {30, 30},
    {45, "NE"},
    {60, 60},
    {75, 75},
    {90, "E"},
    {105, 105},
    {120, 120},
    {135, "SE"},
    {150, 150},
    {165, 165},
    {170, "S"},
    {195, 195},
    {210, 210},
    {225, "SW"},
    {240, 240},
    {255, 255},
    {270, "W"},
    {285, 285},
    {300, 300},
    {315, "NW"},
    {330, 330},
    {345, 345}
}

function impasseUi()
local h5nzfont1 = exports.fonts:getFont("hanzbold",10)
local h5nzfont2 = exports.fonts:getFont("hanzbold",7)
local h5nzfont3 = exports.fonts:getFont("FontAwesome",11)
local h5nzfont4 = exports.fonts:getFont("hanzawesome",11)
if getElementData(localPlayer,"loggedin") == 1 then
--if getElementData(localPlayer, "hud") == 1 and getElementData(localPlayer, "loggedin") == 1 then
local oyuncu_sagligi = math.floor(getElementHealth(localPlayer))
local oyuncu_zirhi = math.floor(getPedArmor(localPlayer))
local oyuncu_acligi = getElementData(localPlayer,"hunger")
local oyuncu_susuzlugu = getElementData(localPlayer,"thirst")
--
dxDrawRoundedRectangle(wx-2,wy-2,w+4,h+4,4,tocolor(15,15,15,170))
if oyuncu_sagligi >= 3 then
dxDrawRoundedRectangle(wx+1,wy+0.5,w/98*oyuncu_sagligi-4,h+0.1,2,tocolor(145, 15, 15,120))
end
dxDrawText("",wx+35,wy+3,w,h,tocolor(225,225,225,245),1,h5nzfont4)
--
dxDrawRoundedRectangle(wx+90,wy-2,w+4,h+4,4,tocolor(15,15,15,170))
if oyuncu_zirhi >= 3 then
    dxDrawRoundedRectangle(wx+93,wy+0.5,w/98*oyuncu_zirhi-4,h+0.1,2,tocolor(191, 191, 191,150))
end
dxDrawText("",wx+128,wy+3,w,h,tocolor(225,225,225,245),1,h5nzfont4)
--  
dxDrawRoundedRectangle(wx+182,wy-2,we+6,he+4,4,tocolor(15,15,15,170))
if oyuncu_acligi >= 20 then
dxDrawRoundedRectangle(wx+185,wy+0.5,we/94*oyuncu_acligi-2,he+0.1,2,tocolor(255, 200, 0,150))
end
dxDrawText("",wx+192,wy+3,we,he,tocolor(225,225,225,245),1,h5nzfont4)
--
dxDrawRoundedRectangle(wx+222,wy-2,we+6,he+4,4,tocolor(15,15,15,170))
if oyuncu_susuzlugu >= 20 then
dxDrawRoundedRectangle(wx+225,wy+0.5,we/94*oyuncu_susuzlugu-2,he+0.1,2,tocolor(0, 187, 201,150))
end
dxDrawText("",wx+233,wy+3,we,he,tocolor(225,225,225,245),1,h5nzfont4)
--
dxDrawText("",wx+380,wy+4,we,he,tocolor(225,225,225,245),1,h5nzfont4)
dxDrawText(""..exports.global:formatMoney(getElementData(localPlayer,"money") or 0).." ₺",wx+405,wy+5,w,h,tocolor(255,255,255,200),1,h5nzfont1)

local show = 4
local center = math.ceil(show / 2) - 2
local _, _, r = getElementRotation(getCamera())
local pos = math.floor(r / 10)
local slotwidth = 25
local smooth = ((r - (pos * 10)) / 10) * slotwidth
local left = wx + 185 + ((show + 2) * slotwidth)/2

for i=1, show do
    local id = i + pos - center
if(id > #cords)then
        id = id - #cords
    end
    if(id <= 0)then
        id = #cords - math.abs(id)
    end

dxDrawRoundedRectangle(wx+265,wy+0.5,w+20,h+1,2,tocolor(2,2,2,50))
dxDrawRoundedRectangle(wx+305,wy+0.5,w-60,h+1,2,tocolor(222,222,222,20))
dxDrawRectangle(left - 5 + slotwidth * i - smooth + (slotwidth / 2 - 1) + 1, wy - 8 , 2, 6, tocolor(0, 0, 0, 200))
dxDrawRectangle(left - 5 + slotwidth * i - smooth + (slotwidth / 2 - 1), wy - 8 , 2, 6, tocolor(255, 255, 255, 200))
dxDrawText(cords[id][2],left + slotwidth * i - smooth + 1 , wy + 7, left + slotwidth * (i+1) - smooth + 2  , wy + 6,tocolor(255,255,255,200),1,h5nzfont2)
      end
   end
end
setTimer(impasseUi,5,0)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
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