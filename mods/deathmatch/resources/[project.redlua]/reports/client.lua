local sx, sy = guiGetScreenSize()
local ww, wh = 630, 400
local x, y = (sx-ww)/2, (sy-wh)/2

local baslik = exports.assets:getFont("in-bold", 17)
local baslik2 = exports.assets:getFont("in-regular", 10)

local robotoB = exports.fonts:getFont("RobotoB", 14)
local roboto = exports.fonts:getFont("Roboto", 11)
local fontAwesome = exports.fonts:getFont("FontAwesome", 12)
local fontIcon = exports.fonts:getFont("FontAwesome", 27)
local fontIcon2 = exports.assets:getFont("FontAwesomeRegular", 60)

local userIcon = exports.fonts:getIcon("fa-user")
local comment = exports.fonts:getIcon("fa-comment")
local circle = exports.fonts:getIcon("fa-circle-o")
local circle = exports.fonts:getIcon("fa-circle-o")
local text = "Buraya sorununu detaylı şekilde açıkla, yetkililer seninle ilgilenecektir!"
local char = string.len(text)+1


function drawReports ()
    rectangleHud(x,y,ww,wh,tocolor(10,10,10,235), {0.1,0.1,0.1,0.1}) --arkadaki siyah
    rectangleHud(x+15,y+80,600,250,tocolor(5,5,5,255), {0.1,0.1,0.1,0.1})--gri şey
    rectangleHud(x+17,y+345,597,35,tocolor(5,5,5,255), {0.1,0.1,0.1,0.1})
    dxDrawText("Rapor Paneli", x+80, y+20, 100, 100, tocolor(255,255,255,255), 0.8, baslik)
    dxDrawText(userIcon, x+25, y+15, 200, 200, tocolor(255,255,255,255),1, fontIcon)
    dxDrawText(circle, x+105, y+15, 200, 200, tocolor(255,255,255,255),1, fontIcon)
    dxDrawText('', x+265, y+155, 200, 200, tocolor(255,255,255,105),1, fontIcon2)
	dxDrawText("bu alanda sorununu bildirerek yardım alabilirsin!", x+80, y+45, 100, 100, tocolor(255,255,255,255), 1, baslik2)
    dxDrawText(text,x+30,y+90,550,150,tocolor(255,255,255,255), 1, baslik2)
    if isInBox(x+50,y+120,625,150) then
        if getKeyState("mouse1") and click+600 <= getTickCount() then
        click = getTickCount()
        text = ""
        end
    else
        text = text
    end
    if isInBox(x+50,y+345,600,35) then
        local suan = getTickCount()
        local alpha = interpolateBetween(0,-1,-1,255,-1,-1,(suan-baslangic)/1000,"Linear")
        rectangleHud(x+17,y+345,597,35,tocolor(0,0,255,alpha), {0.1,0.1,0.1,0.1})--dasads
        dxDrawText("Raporu Gönder", x+265, y+350, 100, 100, tocolor(255,255,255,255), 1, fontAwesome)
        if getKeyState("mouse1") and click+600 <= getTickCount() then
            click = getTickCount()
            if text == "Sorununu bize anlat!" then
                outputChatBox("[!]#FFFFFF Lütfen geçerli bir sebep yazın!",255,0,0,true)
            elseif text == "" then
                outputChatBox("[!]#FFFFFF Lütfen geçerli bir sebep yazın!",255,0,0,true)
            elseif getElementData(localPlayer, "reportNum") then
                outputChatBox("[!] #ffffffZaten sırada beklemede olan bir rapor kaydın var. Raporunu sonlandırmak için ( /er )", 245, 66, 66, true)
            else
            outputChatBox("[!]#FFFFFF Başarılı bir şekilde raporun iletildi.",0,255,0,true)
            outputChatBox("[!] #FFFFFFRaporun : "..text.."",0,20,150,true)
            triggerServerEvent("clientSendReport", localPlayer, localPlayer, text, 4)
            end
        end
    else
        baslangic = getTickCount()
      --  rectangleHud(x+17,y+345,597,35,tocolor(5,5,5,alpha), {0.1,0.1,0.1,0.1})--adsads
        dxDrawText("Raporu Gönder", x+265, y+350, 100, 100, tocolor(255,255,255,255), 1, fontAwesome)
    end 
end

function onOpenCheck(playerID)
	executeCommandHandler ( "check", tostring(playerID) )
end
addEvent("report:onOpenCheck", true)
addEventHandler("report:onOpenCheck", getRootElement(), onOpenCheck)

function open()
    if getElementData(localPlayer, "loggedin") == 1 then
            if active then
                active = false
                showCursor(false)
                toggleAllControls(true)
                setElementData(localPlayer, "rapor:acik", false)
                removeEventHandler("onClientRender", getRootElement(), drawReports)
            else
                active = true
                click = 0
                text = text
                toggleAllControls(false)
                showCursor(true)
                setElementData(localPlayer, "rapor:acik", true)
                addEventHandler("onClientRender", root, drawReports, true, "low-10")
            end
        end
    end
bindKey("F2","down",open)

function write(character)
    if getElementData(localPlayer, "rapor:acik") then
	text = ''..text..''..character
    char = string.len(text)+1
    end
end
addEventHandler('onClientCharacter', root, function(...) write(...) end)


function delete()
	if string.len(text) > 0 then
		local fistPart = text:sub(0, char-1)
		local lastPart = text:sub(char+1, #text)
		text = fistPart..lastPart
		char = string.len(text)
	end
end
bindKey('backspace', 'down', delete)

function isInBox(xS,yS,wS,hS)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX*sx, cursorY*sy
        if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
            return true
        else
            return false
        end
    end
end
