local localPlayer = getLocalPlayer()
local show = false
local width, height = 340, 360
local sx, sy = guiGetScreenSize()

local content = {}
local timerClose = nil
local cooldownTime = 20 --seconds
local BizNoteFont20 = exports.assets:getFont("in-medium", 16)
local Roboto = exports.assets:getFont("in-regular", 10)
local toBeDrawnWidth = width
local justClicked = false

function drawOverlayTopRight(info, widthNew, posXOffsetNew, posYOffsetNew, cooldown)
	local pinned = getElementData(localPlayer, "hud:pin")
	if not pinned and timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
	if info then
		content = info
		content[1][1] = string.sub(content[1][1], 1, 1)..string.sub(content[1][1], 2)
	else
		return false
	end
	
	if posXOffsetNew then
		posXOffset = posXOffsetNew
	end
	if posYOffsetNew then
		posYOffset = posYOffsetNew
	end
	if cooldown then
		cooldownTime = cooldown
	end
	if content then
		show = true
	end
	
	toBeDrawnWidth = width
	
	playSoundFrontEnd ( 101 )
	if cooldownTime ~= 0 and not pinned then
		timerClose = setTimer(function()
			show = false
			setElementData(localPlayer, "hud:overlayTopRight", 0, false)
		end, cooldownTime*1000, 1)
	end
	
	for i=1, #info do
		outputConsole(info[i][1] or "")
	end
end
addEvent("hudOverlay:drawOverlayTopRight", true)
addEventHandler("hudOverlay:drawOverlayTopRight", localPlayer, drawOverlayTopRight)

setTimer(function ()
	if show and not getElementData(localPlayer, "integration:previewPMShowing") and getElementData(localPlayer, 'loggedin') == 1 then 
		if ( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( localPlayer, "aim_weapon" ) ) then
			local posXOffset, posYOffset = 0, 270
			local hudDxHeight = getElementData(localPlayer, "hud:whereToDisplayY") or 0
			if hudDxHeight then
				posYOffset = posYOffset + hudDxHeight + 20
			end
			
			local reportDxHeight = getElementData(localPlayer, "report-system:dxBoxHeight") or 0
			if reportDxHeight then
				posYOffset = posYOffset + reportDxHeight
			end
		   -- dxDrawRoundedRectangle(sx,sy,width,height,tocolor(10,10,10,235),{0.05,0.05,0.05,0.05})
			dxDrawRoundedRectangle(sx-toBeDrawnWidth-15+posXOffset, posYOffset+7, toBeDrawnWidth+5, 16*(#content)+30, #content, tocolor(10,10,10,235)) -- main
			--dxDrawImage ( sx-5+posXOffset-90, (5+posYOffset)-60, 100, 100, (pinned and "pinned.png" or "pin.png" ),0, 0, 0, tocolor(255,255,255,200), false )
			for i=1, #content do
				if content[i] then
					local currentWidth = dxGetTextWidth ( (content[i][1] or "" ) , 1 , Roboto) + 30
					if currentWidth > toBeDrawnWidth then
						toBeDrawnWidth = currentWidth
					end
					
					if i == 1 or content[i][7] == "title" then --Title
						
						dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+5+posXOffset, (16*i)+posYOffset, toBeDrawnWidth-5, 15, tocolor ( 255,255,255,255), 1, BizNoteFont20 )
					else
						dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+2+posXOffset, (16*i)+posYOffset, toBeDrawnWidth-5, 15, tocolor ( 255,255,255,255), 1, Roboto )
					end
				end
			end
		end
	end
end, 5, 0)

function pinIt()
	setElementData(localPlayer, "hud:pin", true, false)
	if timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
end

function unpinIt()
	pinIt()
	setElementData(localPlayer, "hud:pin", false, false)
	timerClose = setTimer(function()
		show = false
		setElementData(localPlayer, "hud:overlayTopRight", 0, false)
	end, 3000, 1)
end

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
