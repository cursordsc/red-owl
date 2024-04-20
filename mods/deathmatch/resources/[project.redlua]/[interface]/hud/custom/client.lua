local screenX, screenY = guiGetScreenSize()
local w, h = 450, 170
local x, y = (screenX-w)/2, (screenY-h)/2
local toggleMenu = false
local lastClick = 0

local menuName = ""
local choseTable = {

	--[["radar"] = {
		["name"] = "Minimap Seçimi:",
		["data"] = "interface.radar",
		["articles"] = {
			{"     Modern Radar", 1},
			{"      GTA Minimap", 2},
			{"       Radarı Gizle", 3},
		}
	},
 ]]
	["nametag"] = {
		["name"] = "İsim Etiketi Görünüş Seçimi:",
		["data"] = "interface.nametagBar",
		["articles"] = {
			{"      Yazı Tarzında", "text"},
			{"     Barlı Gösterim", "rectangle"},
		}
	},

	["font"] = {
		["name"] = "İsim Etiketi Yazı Tipi Seçimi:",
		["data"] = "interface.nametagFont",
		["articles"] = {
    		{"Roboto", 1},
   			{"RobotoB", 2},
		    {"Bebas", 3},
		    {"BoldFont", 4},
		    {"OpenSans", 5},
		    {"roboto", 6},
		    {"FontAwesome", 7},
		   	{"default-bold", 8},
		    {"default", 9},
		}
	},

	--["speedo"] = {
		--["name"] = "Araç Hız Göstergesi:",
		--["data"] = "interface.speedo",
		--["articles"] = {
			--{"    Samp Gösterge", 1},
			--{"   Analog Gösterge", 2},
			--{"   Göstergeyi Gizle", 3},
		--}
	--},

}

avaibleFonts = {
    ["Roboto"] = 10,
    ["RobotoB"] = 9,
    --["Bebas"] = 11,
    ["BoldFont"] = 10,
    ["OpenSans"] = 10,
    --["roboto"] = 10,
    ["FontAwesome"] = 9,
    ["default-bold"] = 1,
    ["default"] = 1,
}

function toggleHudSelection(command, status)
	if not status then
		outputChatBox("SYNTAX: /"..command.." [font - nametag]", 255, 194, 14)
	else
		if choseTable[status] then

			if status == "speedo" then
		        local vehicle = getPedOccupiedVehicle(localPlayer)
		        if not vehicle then
		        	outputChatBox(">>#F9F9F9 Bu arayüz seçimini sadece araçta gerçekleştirebilirsiniz.", 255, 0, 0, true)
					return false
				end 
			end

			if toggleMenu then
				toggleMenu = false
				removeEventHandler('onClientRender', root, renderMenu)
				showCursor(false)
				showChat(true)
			else

				if status == "font" then
					w, h = 450, 270
					x, y = (screenX-w)/2, (screenY-h)/2
				else
					w, h = 450, 170
					x, y = (screenX-w)/2, (screenY-h)/2
				end

				menuName = status
				toggleMenu = true
				showCursor(true)
				showChat(false)
				addEventHandler('onClientRender', root, renderMenu)
			end
		else
			outputChatBox("SYNTAX: /"..command.." [font - nametag]", 255, 194, 14)
		end
	end
end
addCommandHandler('arayuz', toggleHudSelection)
addCommandHandler('arayüz', toggleHudSelection)

local robotoB = exports.fonts:getFont('RobotoB', 15)
local awesome = exports.fonts:getFont('FontAwesome', 15)
--local roboto = exports.fonts:getFont('Roboto', 10)
local roboto = exports.fonts:getFont('Roboto', 10)

function renderMenu()

	dxDrawRectangle(0,0,screenX,screenY,tocolor(15,15,15,235))
	roundedRectangle(x,y,w,h, tocolor(10,10,10,235))
	dxDrawText("Arayüzünü Belirle", x+15,y+10,0,0, tocolor(225,225,225), 1, robotoB)
	dxDrawText("İstediğin arayüzü seçip kullanabilirsin.", x+15,y+40,0,0, tocolor(225,225,225), 1, roboto)
	dxDrawRectangle(x+13,y+70,w-26,1, tocolor(100,100,100))

	if isInBox(x+w-40,y+10,30,30) then
		roundedRectangle(x+w-40,y+10,30,30, tocolor(168, 50, 50, 240))
		dxDrawText("", x+w-38,y+11,0,0, tocolor(200,200,200), 1, awesome)
		if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
			lastClick = getTickCount() 
			toggleHudSelection("arayuz", menuName)
		end
	else
		roundedRectangle(x+w-40,y+10,30,30, tocolor(20,20,20,235))
		dxDrawText("", x+w-38,y+11,0,0, tocolor(150,150,150), 1, awesome)
	end

	dxDrawText(choseTable[menuName]["name"], x+20,y+85,0,0, tocolor(225,225,225), 1, roboto)

	local count = 0
	local y = (screenY-h)/2+115
	for index, value in ipairs(choseTable[menuName]["articles"]) do 
		count = count + 1

        if count > 3 then
            count = 1
            y = y + 50
        end

		if isInBox(x-115+(count*135),y,125,30,15) then
			roundedCircleRectangle(x-115+(count*135),y,125,30,15, tocolor(35,35,35,150))

			if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
				lastClick = getTickCount() 
				setElementData(localPlayer, choseTable[menuName]["data"], value[2])
				triggerServerEvent("update.custom_hud", localPlayer, localPlayer)
			end

	    else
	    	roundedCircleRectangle(x-115+(count*135),y,125,30,15, tocolor(20,20,20,235))
	    end

	    if avaibleFonts[value[1]] then
	    	if avaibleFonts[value[1]] == 1 then 
	    		dxDrawText(value[1], x-90+(count*135),y+6,125,30, tocolor(150,150,150), 1, value[1])
	    	else
	    		dxDrawText(value[1], x-90+(count*135),y+5,125,30, tocolor(150,150,150), 1, exports.fonts:getFont(value[1], 10))
	    	end
	    else
	    	dxDrawText(value[1], x-110+(count*135),y+5,125,30, tocolor(150,150,150), 1, roboto)
	    end
	end

end

function isInBox(xS,yS,wS,hS)
    if(isCursorShowing()) then
        local cursorX, cursorY = getCursorPosition()
        sX,sY = guiGetScreenSize()
        cursorX, cursorY = cursorX*sX, cursorY*sY
        if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
            return true
        else
            return false
        end
    end 
end

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
