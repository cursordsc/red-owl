local widget = new("Widget")

local localPlayer = getLocalPlayer()
local dxDrawText = dxDrawText
local dxDrawImage = dxDrawImage
local dxGetTextWidth = dxGetTextWidth
local ipairs = ipairs
local tocolor = tocolor
local exports = exports

function widget.prototype.____constructor(self)
	--/////////////////////////////////////////////////////////
	self._function = {}
	self._function.render = function(...) self:render(self, ...) end
	--/////////////////////////////////////////////////////////
	self.screen = Vector2(guiGetScreenSize())
	self.FPSLimit, self.lastTick, self.framesRendered, self.FPS = 100, getTickCount(), 0, 0
	self.px, self.py = 1600, 900
	self.x, self.y =  (self.screen.x/self.px), (self.screen.y/self.py)
	if self.screen.x == 1680 then 
	    self.size = 1
	elseif self.screen.x == 1940 then 
	    self.size = 0.8 
	end
	self.robotoB9 = exports.fonts:getFont('RobotoB', 9)
	self.robotoB10 = exports.fonts:getFont('RobotoB', 10)
	self.robotoB11 = exports.fonts:getFont('RobotoB', 11)
	self.robotoB13 = exports.assets:getFont('in-medium', 12)
	self.robotoB20 = exports.fonts:getFont('RobotoB', 20)
	self.robotoB30 = exports.fonts:getFont('RobotoB', 30)
	self.awesome9 = exports.assets:getFont('in-regular', 13)
	--/////////////////////////////////////////////////////////
	addEventHandler('onClientRender', root, self._function.render)
end

function widget.prototype.render(self)
	if localPlayer:getData('loggedin') == 1 then
        if localPlayer:getData('auth.f10') then else
            if localPlayer:getData('bigmapIsVisible') then else
            
			if localPlayer.dimension > 0 then
                self.x3 = 260
            else
                self.x3 = 275
            end
		
			self.screen.y = 1100
			
            self.hunger = localPlayer:getData('hunger') or 100
            self.thirst = localPlayer:getData('thirst') or 100
            self.money = localPlayer:getData('money') or 0
            dxDrawRectangle(self.x3+50-2, self.screen.y-215-2, 5+4, 100+4, tocolor(15,15,15))
            dxDrawRectangle(self.x3+50, self.screen.y-215, 5, 100, tocolor(211,157,59,75))
            dxDrawRectangle(self.x3+50, self.screen.y-215, 5, self.hunger, tocolor(211,157,59))

            dxDrawRectangle(self.x3+65-2, self.screen.y-215-2, 5+4, 100+4, tocolor(15,15,15))
            dxDrawRectangle(self.x3+65, self.screen.y-215, 5, 100, tocolor(239,57,107,75))
            dxDrawRectangle(self.x3+65, self.screen.y-215, 5, self.thirst, tocolor(239,57,107))

            dxDrawImage(self.x3+45, self.screen.y-65, 32, 32, 'assets/thirst.png', 0, 0, 0, tocolor(255, 255, 255, 255))
            dxDrawImage(self.x3+45, self.screen.y-105, 32, 32, 'assets/hunger.png', 0, 0, 0, tocolor(255, 255, 255, 255))

            dxDrawText('$'..exports.global:formatMoney(self.money)..'', self.x3+45*2-1, self.screen.y-48, nil, nil, tocolor(255, 255, 255 ,235), 0.9, self.robotoB13)
            self.weapon = localPlayer:getWeapon()
            self.clip = localPlayer:getAmmoInClip()
            self.ammo = localPlayer:getTotalAmmo()

            dxDrawImage(self.x3+42*2, self.screen.y-115, 65, 65, ':widget/components/weapon/'..self.weapon..'.png', 0, 0, 0, tocolor(255, 255, 255, 255))

                if (self.weapon >= 15 and self.weapon ~= 40 and self.weapon <= 44 or self.weapon >= 46) then
                    dxDrawText(''..self.ammo-self.clip..'/'..self.clip, self.x3+47*2-1, self.screen.y-80, nil, nil, tocolor(0, 0, 0 ,255), 0.75, self.robotoB11)
                    dxDrawText(''..self.ammo-self.clip..'/'..self.clip, self.x3+47*2, self.screen.y-80-1, nil, nil, tocolor(0, 0, 0 ,255), 0.75, self.robotoB11)
                    dxDrawText(''..self.ammo-self.clip..'/'..self.clip, self.x3+47*2+1, self.screen.y-80, nil, nil, tocolor(0, 0, 0 ,255), 0.75, self.robotoB11)
                    dxDrawText(''..self.ammo-self.clip..'/'..self.clip, self.x3+47*2, self.screen.y-80+1, nil, nil, tocolor(0, 0, 0 ,255), 0.75, self.robotoB11)
                    dxDrawText(''..self.ammo-self.clip..'/'..self.clip, self.x3+47*2, self.screen.y-80, nil, nil, tocolor(225, 225, 225 ,225), 0.75, self.robotoB11)
                end
            end
        end
	end
end

function widget.prototype:_dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
    dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    dxDrawText(text, x1 - 2, y1, x2 - 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    dxDrawText(text, x1 + 2, y1, x2 + 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    dxDrawText(text, x1, y1 - 2, x2, y2 - 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    dxDrawText(text, x1, y1 + 2, x2, y2 + 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
end

function widget.prototype:formatSpeed(unit)
    if unit < 10 then
        unit = "#Cfd2d200#ffffff" .. unit
    elseif unit < 100 then
        unit = "#Cfd2d20#ffffff" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end

function widget.prototype:roundedRectangle(x, y, sizeX, sizeY, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, sizeX-(radius*2), sizeY-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+sizeY)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+sizeX)-radius, (y+sizeY)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+sizeX)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, sizeY-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+sizeY-radius, sizeX-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+sizeX-radius, y+radius, radius, sizeY-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, sizeX-(radius*2), radius, color, postGUI, subPixelPositioning)
end

widget = load(widget)