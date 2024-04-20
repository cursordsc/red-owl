local show = true;
local element = false;
local tick = 0;
local scroll = 0;
local max = 6
local maxx = 18

local sx,sy = guiGetScreenSize()
local x,y = 640,400
local ox,oy = (sx-x)/2, (sy-y)/2

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    sColor = {200, 200, 200};
    sColor2 = "#000000"
    white = "#FFFFFF";
	fontaw = exports.fonts:getFont("AwesomeFont",16)
	fontaw1 = exports.fonts:getFont("AwesomeFont",12)
	fontaw2 = exports.fonts:getFont("FontAwesome",14)
	font = exports.fonts:getFont("AwesomeFont",9)
	click = 0
	bindKey("mouse_wheel_up","down",up)
	bindKey("mouse_wheel_down","down",down)
end)

render = function()
	if show then
		if shopItems[show] then
			rounded(ox,oy,x,y,12,tocolor(10,10,10,230))
			dxDrawText(name,ox+50,oy+20,ox+x,oy+y,tocolor(255,255,255,255),1,fontaw)
			dxDrawText("istediğiniz ürünü tıklayarak satın alın.",ox+50,oy+45,ox,oy,tocolor(200,200,200,255),1,fontaw1)
			
			rounded(ox+x-40-20,oy+20,40,40,8,tocolor(20,20,20,255))
			if mouse(ox+x-40-20,oy+20,40,40) then
				rounded(ox+x-40-20,oy+20,40,40,8,tocolor(120,0,0,150))
				if getKeyState("mouse1") and click+500 <= getTickCount() then click = getTickCount()
					closeShop()
				end
			end
			dxDrawText("",ox+x-40-20,oy+20,ox+x-40-20+40,oy+20+40,tocolor(255,255,255,255),1,fontaw2,"center","center")
					
			count = 0
			countt = 0
			xx = 0
			yy = 0
			for i,v in pairs(shopItems[show]) do
				if i > scroll and countt < maxx then
					rounded(ox+50+xx,oy+yy+90,80,80,8,tocolor(20,20,20,255))
					if mouse(ox+50+xx,oy+yy+90,80,80) then
						rounded(ox+50+xx,oy+yy+90,80,80,8,tocolor(30,30,30,255))
						if getKeyState("mouse1") and click+500 <= getTickCount() then click = getTickCount()
							triggerServerEvent("shop.buy",localPlayer,localPlayer,v)
						end
					end
					
					if v[1] == 115 then
						dxDrawImage(ox+65+xx,oy+yy+105,50,50,":items/images/-"..v[3]..".png")
					else
						dxDrawImage(ox+65+xx,oy+yy+105,50,50,":items/images/"..v[1]..".png")
					end		
					dxDrawText(exports.global:formatMoney(v[2]).."₺",ox+50+xx,oy+yy+120,ox+50+xx+80,oy+yy+120+80,tocolor(180,180,180,255),1,font,"center","center")
					
					count = count + 1
					countt = countt + 1
					xx = xx+90
					
					if count == max then
						count = 0
						xx = 0
						yy = yy + 90
					end
				end
			end
			
			local px,py,pz = getElementPosition(localPlayer)
			local wx,wy,wz = getElementPosition(element)
			if getDistanceBetweenPoints3D(px,py,pz,wx,wy,wz) > 4 then 
				closeShop()
			end	
		end
	end
end

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickElement)
    if state == "down" and clickElement then 
		if isTimer(timer) then return end
        if getElementData(clickElement,"shop.type") or false then 
            local px,py,pz = getElementPosition(localPlayer);
            if getDistanceBetweenPoints3D(px,py,pz,wx,wy,wz) < 4 and tick+1000 < getTickCount() then 
                element = clickElement;
                show = getElementData(clickElement,"shop.type");
				name = getElementData(clickElement,"shop.name");
				scroll = 0
				timer = setTimer(render,5,0)
				click = 0
                setElementData(localPlayer,"pednames.show",false);
            end
        end
    end
end)

up = function()
    if isTimer(timer) then 
        if mouse(ox,oy,x,y) then 
            if scroll > 0 then 
                scroll = scroll - max;
            end
        end
	end
end

down = function()
	if isTimer(timer) then 
		if mouse(ox,oy,x,y) then 
			if scroll < #shopItems[show] - maxx then 
				scroll = scroll + max
			end
		end
	end
end


function closeShop()
    
    element = false;
    killTimer(timer)
	show = false;
    tick = getTickCount();
    setElementData(localPlayer,"pednames.show",true);
	scroll = 0;
end

--UTILS--



rounded = function(x, y, width, height, radius, color, postGUI, subPixelPositioning)
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

mouse = function( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end