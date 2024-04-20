local carshop = new('carshop')

function carshop.prototype.____constructor(self)
	--/////////////////////////////////////////////////////////
	self._function = {}
	self._function.render = function(...) self:_render(self) end
	self._function.scrollUp = function(...) self:_scrollUp(self) end
	self._function.scrollDown = function(...) self:_scrollDown(self) end
	self._function.display = function(...) self:_display(self) end
	--/////////////////////////////////////////////////////////
	self.screen = Vector2(guiGetScreenSize())
	self.fontB = exports.fonts:getFont('RobotoB', 12)
	self.fontB2 = exports.fonts:getFont('RobotoB', 16)
	self.fontB3 = exports.fonts:getFont('RobotoB', 18)
	self.font = exports.fonts:getFont('Roboto', 10)
	self.iconfont = exports.fonts:getFont('AwesomeFont2', 25)
    self.icon = exports.fonts:getIcon('fa-car')
	--/////////////////////////////////////////////////////////
	self:_get(self)
end

function carshop.prototype._render(self)
	dxDrawRectangle(0,0,self.screen.x,self.screen.y,tocolor(255,255,255,25))
	self:roundedRectangle(5,self.screen.y/2-250,400,500,9,tocolor(7,7,7,235))
	self:roundedRectangle(5,self.screen.y/2-250,400,100,9,tocolor(25,25,25,235))
	dxDrawText(self.icon, 115,self.screen.y/2-250+15, nil, nil, tocolor(225,225,225), 1, self.iconfont)
	dxDrawText('Grotti', 175+5,self.screen.y/2-250+23, nil, nil, tocolor(225,225,225), 1, self.fontB2)

	dxDrawText('Araç', 25+5,self.screen.y/2-250+75, nil, nil, tocolor(225,225,225), 0.7, self.fontB)
	dxDrawText('Fiyat', 175+5,self.screen.y/2-250+75, nil, nil, tocolor(225,225,225), 0.7, self.fontB)
	dxDrawText('Vergi', 300+5,self.screen.y/2-250+75, nil, nil, tocolor(225,225,225), 0.7, self.fontB)

	self.table = vehicles
	self.current = 0
	self.countY = 0
	for index, value in ipairs(self.table) do
		if index > self.currentRow and self.current < self.maxRow then
			if self.selected == index then
				self:roundedRectangle(15,self.screen.y/2-250+105+self.countY,380,30,9,tocolor(20,20,20,235))
				self.veh.model = value[3]
			else
				if self:isInBox(15,self.screen.y/2-250+105+self.countY,380,30) then
					self:roundedRectangle(15,self.screen.y/2-250+105+self.countY,380,30,9,tocolor(25,25,25,235))
					if getKeyState('mouse1') and self.click+400 <= getTickCount() then
						self.click = getTickCount()
						self.selected = index
						self.veh.model = value[3]
					end
				else
					self:roundedRectangle(15,self.screen.y/2-250+105+self.countY,380,30,9,tocolor(35,35,35,235))
				end
			end
			dxDrawText(''..value[1]..' '..value[2], 25+5,self.screen.y/2-250+105+5+self.countY, nil, nil, tocolor(225,225,225), 1, self.font)
			dxDrawText(''..exports.global:formatMoney(value[5])..'$', 175+5,self.screen.y/2-250+105+5+self.countY, nil, nil, tocolor(225,225,225), 1, self.font)
			dxDrawText(''..exports.global:formatMoney(value[6])..'$', 300+5,self.screen.y/2-250+105+5+self.countY, nil, nil, tocolor(225,225,225), 1, self.font)
			self.current = self.current + 1
			self.countY = self.countY + 33
		end
	end
	dxDrawRectangle(400, self.screen.y/2-250+105+(self.currentRow*15), 3, 25, tocolor(188,163,81,135))

	if self:isInBox(400-50,self.screen.y/2-250+440,35,35) then
		self:roundedRectangle(400-50,self.screen.y/2-250+440,35,35,9,tocolor(168,163,81,200))
		if getKeyState('mouse1') and self.click+400 <= getTickCount() then
			self.click = getTickCount()
			triggerServerEvent('carshop.buy', localPlayer, self.selected)
			self:_display(self)
		end
	else
		self:roundedRectangle(400-50,self.screen.y/2-250+440,35,35,9,tocolor(168,163,81))
	end
	dxDrawText('$', 400-50+10,self.screen.y/2-250+440+3, nil, nil, tocolor(15,15,15), 1, self.fontB2)

	if self:isInBox(25-3, self.screen.y/2-250+440+6, 15, 25) then
		dxDrawText('<', 25,self.screen.y/2-250+440+3, nil, nil, tocolor(245,245,245,125), 1, self.fontB3)
		if getKeyState('mouse1') and self.click+400 <= getTickCount() then
			self.click = getTickCount()
			self:_display(self)
		end
	else
		dxDrawText('<', 25,self.screen.y/2-250+440+3, nil, nil, tocolor(245,245,245), 1, self.fontB3)
	end
end

function carshop.prototype._scrollUp(self)
	if self.active then
		if self.currentRow > 0 then
			self.currentRow = self.currentRow - 1
		end
	end
end

function carshop.prototype._scrollDown(self)
	if self.active then
		if self.currentRow < #self.table - self.maxRow then
            self.currentRow = self.currentRow + 1
        end
	end
end

function carshop.prototype._display(self)
	if self.active then
		self.active = false
		self.veh:destroy()
		showChat(true)
		showCursor(false)
		triggerServerEvent('carshop.close', localPlayer)
		removeEventHandler('onClientRender',root,self._function.render)
		self.npc:setData('is.active', false)
	else
		if getElementData(self.npc, 'is.active') then
			outputChatBox('Chris Frosthorne diyor ki: Şu anda başka bir müşteriyle ilgileniyorum, lütfen biraz bekleyin.',255,255,255,true)
		else
			self.npc:setData('is.active', true)
			self.veh = Vehicle(411, 1803.4215087891, -1430.5374755859, 18.958000183105, 0, 0, 228.40100097656)
			self.veh:setColor(255,255,255)
			self.currentRow, self.maxRow = 0, 10
			self.selected = 1
			self.click = 0
			self.active = true
			showCursor(true)
			showChat(false)
			Camera.setMatrix(1807.7663574219, -1437.2847900391, 19.959600448608, 1807.2059326172, -1436.4754638672, 19.783954620361)
			addEventHandler('onClientRender',root,self._function.render,true,'low-99')
		end
	end
end

function carshop.prototype._get(self)
	addEvent('carshop.display', true)
	addEventHandler('carshop.display',root,self._function.display)
	self.npc = createPed(36, 1828.3668212891, -1436.8128662109, 13.958000183105, 77)
    self.npc.interior = 0
    self.npc.dimension = 0
    self.npc:setData('name', 'Chris Frosthorne')
    setPedAnimation(self.npc, 'BAR', 'BARman_idle', -1, true, false, false)
    self.npc.frozen = true
	bindKey('mouse_wheel_up', 'down', self._function.scrollUp)
    bindKey('mouse_wheel_down', 'down', self._function.scrollDown)
end

function carshop.prototype:roundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
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

function carshop.prototype:isInBox(xS,yS,wS,hS)
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

function carshop.prototype:outerBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)
	dxDrawRectangle(x - borderSize, y - borderSize, w + (borderSize * 2), borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x - borderSize, y, borderSize, h + borderSize, borderColor, postGUI)
	dxDrawRectangle(x + w, y, borderSize, h + borderSize, borderColor, postGUI)
end

carshop = load(carshop)