local bubbles = {} -- {text, player, lastTick, alpha, yPos}
local fontHeight = 22
local characteraddition = 50
local maxbubbles = 5
local selfVisible = true -- Want to see your own message?
local timeVisible = 5000
local distanceVisible = 20

function addText(source, text, color, font, sticky, type)
	if getElementData(localPlayer, "graphic_chatbub") == "0" then
		return
	end

	if not bubbles[source] then
		bubbles[source] = {}
	end

	local tick = getTickCount()
	local info = {
		text = text,
		player = source,
		color = color or {255, 255, 255},
		tick = tick,
		expires = tick + (timeVisible + #text * characteraddition),
		alpha = 0,
		sticky = sticky,
		type = type
	}

	if sticky then
		table.insert(bubbles[source], 1, info)
	else
		table.insert(bubbles[source], info)
	end

	if #bubbles[source] > maxbubbles then
		for k, v in ipairs(bubbles[source]) do
			if not v.sticky then
				table.remove(bubbles[source], k)
				break
			end
		end
	end
end

addEvent("addChatBubble", true)
addEventHandler("addChatBubble", root,
	function(message, command)
		if source ~= localPlayer or selfVisible then
			if command == "ado" or command == "ame" then
				addText(source, message, { 255, 51, 102 }, "default-bold", false, command)
			else
				addText(source, message)
			end
		end
	end
)


addEvent("addChatBubblee", true)
addEventHandler("addChatBubblee", root,
	function(message, command)
		if source ~= localPlayer or selfVisible then
			if command == "do" then
				addText(source, message, { 17, 96, 98 })
			elseif command == "me" then
				addText(source, message, { 102, 51, 153 })
			end
		end
	end
)

addEvent("addChatBubbleee", true)
addEventHandler("addChatBubbleee", root,
	function(message, command)
		if source ~= localPlayer or selfVisible then
			if command == "ado" or command == "ame" then
				addText(source, message, { 255, 51, 102 }, "default-bold", false, command)
			else
				addText(source, message, { 136, 87, 201 })
			end
		end
	end
)

function removeTexts(player, type)
	local t = bubbles[player] or {}
	for i = #t, 1, -1 do
		if t[i].type == type then
			table.remove(t, i)
		end
	end

	if #t == 0 then
		bubbles[player] = nil
	end
end

-- Status
addEventHandler("onClientElementDataChange", root, function(n)
	if n == "chat:status" and getElementType(source) == "player" then
		updateStatus(source, "status")
	end
end)
addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "chat:status") then
			updateStatus(player, "status")
		end
	end
end)

function updateStatus(source, n)
	removeTexts(source, n)
	if getElementData(source, "chat:status") then
		addText(source, getElementData(source, "chat:status"), {136, 87, 201}, "default-bold", true, n)
	end
end

--
-- outElastic | Got from https://github.com/EmmanuelOga/easing/blob/master/lib/easing.lua
-- For all easing functions:
-- t = elapsed time
-- b = begin
-- c = change == ending - beginning
-- d = duration (total time)
-- a: amplitud
-- p: period
local pi = math.pi
function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < math.abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * math.asin(c/a)
  end

  return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * pi) / p) + c + b
end

local awesome = exports.fonts:getFont("FontAwesome", 9)
local function renderChatBubbles()
	if getElementData(localPlayer, "graphic_chatbub") ~= "0" then
		local square = getElementData(localPlayer, "graphic_chatbub_square") ~= "0"
		local tick = getTickCount()
		local x, y, z = getElementPosition(localPlayer)
		for player, texts in pairs(bubbles) do
			if isElement(player) then
				for i, v in ipairs(texts) do
					if tick < v.expires or v.sticky then
						local px, py, pz = getElementPosition(player)
						local dim, pdim = getElementDimension(player), getElementDimension(localPlayer)
						local int, pint = getElementInterior(player), getElementInterior(localPlayer)

						if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < distanceVisible and isLineOfSightClear ( x, y, z, px, py, pz, true, not isPedInVehicle(player), false, true) and pdim == dim and pint == int then
							v.alpha = v.alpha < 200 and v.alpha + 5 or v.alpha
							local bx, by, bz = getPedBonePosition(player, 6)
							local sx, sy = getScreenFromWorldPosition(bx, by, bz)

							local elapsedTime = tick - v.tick
							local duration = v.expires - v.tick

							if sx and sy then
								if not v.yPos then v.yPos = sy end
								local width = dxGetTextWidth(v.text:gsub("#%x%x%x%x%x%x", ""), 1, "default-bold")
								local yPos = outElastic(elapsedTime, v.yPos - 20, (sy - fontHeight*i ) - v.yPos - 10, 1000, 5, 500)

								if square then
									dxDrawRoundedRectangle(5, sx - (52 + (0.5 * width)), yPos + 142, width + 120, 20, tocolor(15, 15, 15, 235))
									--dxDrawRoundedRectangle(10, sx - (32 + (0.5 * width)), yPos + 152, width + 110, 1, tocolor(0, 0, 0, 255))
										--All but /say
										--((v.type == "ado" or v.type == "ame" or v.type == "status") and tocolor(v.color[1], v.color[2], v.color[3], 255) or tocolor(0, 0, 0, 255))
								else
									dxDrawRoundedRectangle(sx - (3 + (0.5 * width)),yPos - 2,width + 5,19,tocolor(0,0,0,bg_color))
									dxDrawRoundedRectangle(sx - (6 + (0.5 * width)),yPos - 2,width + 11,19,tocolor(0,0,0,40))
									dxDrawRoundedRectangle(sx - (8 + (0.5 * width)),yPos - 1,width + 15,17,tocolor(0,0,0,bg_color))
									dxDrawRoundedRectangle(sx - (10 + (0.5 * width)),yPos - 1,width + 19,17,tocolor(0,0,0,40))
									dxDrawRoundedRectangle(sx - (10 + (0.5 * width)),yPos + 1,width + 19,13,tocolor(0,0,0,bg_color))
									dxDrawRoundedRectangle(sx - (12 + (0.5 * width)),yPos + 1,width + 23,13,tocolor(0,0,0,40))
									dxDrawRoundedRectangle(sx - (12 + (0.5 * width)),yPos + 4,width + 23,7,tocolor(0,0,0,bg_color))
								end
								dxDrawText("*"..localPlayer:getName():gsub("_", " ").." "..v.text, sx - (30 + 0.5 * width), yPos + 143, sx - (0.5 * width), yPos - (i * fontHeight), tocolor(unpack(v.color)), 1, awesome, "left", "top", false, false, true)
								--dxDrawRectangle(sx - (0.5 * width), yPos, sx - (0.5 * width), )
							end
						end
					else
						table.remove(bubbles[player], i)
					end
				end

				if #texts == 0 then
					bubbles[player] = nil
				end
			else
				bubbles[player] = nil
			end
		end
	end
end

addEventHandler("onClientPlayerQuit", root, function() bubbles[source] = nil end)
addEventHandler("onClientRender", root, renderChatBubbles)
--

function dxDrawRoundedRectangle(radius,x,y,w,h,color,postGUI,subPixel,noTL,noTR,noBL,noBR)
	local noTL = not noTL and dxDrawCircle(x+radius,y+radius,radius,180,270,color,color,9,1,postGUI) -- top left corner
	local noTR = not noTR and dxDrawCircle(x+w-radius,y+radius,radius,270,360,color,color,9,1,postGUI) -- top right corner
	local noBL = not noBL and dxDrawCircle(x+radius,y+h-radius,radius,90,180,color,color,9,1,postGUI) -- bottom left corner
	local noBR = not noBR and dxDrawCircle(x+w-radius,y+h-radius,radius,0,90,color,color,9,1,postGUI) -- bottom right corner
	dxDrawRectangle(x+radius-(not noTL and radius or 0),y,w-2*radius+(not noTL and radius or 0)+(not noTR and radius or 0),radius,color,postGUI,subPixel) -- top rectangle
	dxDrawRectangle(x,y+radius,w,h-2*radius,color,postGUI,subPixel) -- center rectangle
	dxDrawRectangle(x+radius-(not noBL and radius or 0),y+h-radius,w-2*radius+(not noBL and radius or 0)+(not noBR and radius or 0),radius,color,postGUI,subPixel)-- bottom rectangle
end