local screen = Vector2(guiGetScreenSize())
local w, h = 340, 240
local rx, ry = (screen.x-w)/2, (screen.y-h)/2

local font = exports.assets:getFont("in-bold", 15)
local font2 = exports.assets:getFont("in-regular", 10)
local font3 = exports.assets:getFont("in-regular", 11)
local awesome = exports.assets:getFont("FontAwesome", 22)
local awesome2 = exports.assets:getFont("FontAwesome", 15)

local links = {
    -- icon, link adı, link bağlantısı --
    {"","Discord Sunucumuz","! cursor’#1881"},
    {"","Youtube Kanalımız","! cursor’#1881"},
    {"","Bakiye Yükleme","! cursor’#1881"},
}

bindKey("f4", "down", function()
    if not isTimer(render) then
        setElementData(localPlayer, "nametagengel", true)
        click = 0
        render = setTimer(function()
            y = 0
            rectangle(rx,ry,w,h,tocolor(10,10,10,245),{0.1,0.1,0.1,0.1})
            dxDrawText("",rx+20,ry+23,w,h,tocolor(35,169,138,255),1,awesome)
            dxDrawText("Sosyal Medya",rx+65,ry+20,w,h,tocolor(255,255,255,255),1,font)
            dxDrawText("Bize ulaşmak için üstüne tıklaman yeter.",rx+65,ry+45,w,h,tocolor(150,150,150,255),1,font2)

            for k, v in pairs(links) do
                rectangle(rx+20,ry+80+y,w-40,h-195,mousePos(rx+20,ry+80+y,w-40,h-195) and tocolor(0,0,150,255) or tocolor(25,25,25,225),{0.4,0.4,0.4,0.4})
                dxDrawText(v[1],rx+25,ry+90+y,w,h,tocolor(255,255,255,255),1,awesome2)
                dxDrawText(v[2],rx+70,ry+93+y,w,h,tocolor(255,255,255,255),1,font3)

                if mousePos(rx+20,ry+80+y,w-40,h-195) and getKeyState("mouse1") and click+600 <= getTickCount() then
                    click = getTickCount()
                    outputChatBox(">>#ffffff "..v[2].." linki panoya kopyalandı.",0,255,0,true)
                    setClipboard(v[3])
                end
                y = y + 48
            end
        end,0,0)
    else
        killTimer(render)
        setElementData(localPlayer, "nametagengel", false)
    end
end)

function mousePos ( x, y, width, height )
    if ( not isCursorShowing( ) ) then
        return false
    end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    
    return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end