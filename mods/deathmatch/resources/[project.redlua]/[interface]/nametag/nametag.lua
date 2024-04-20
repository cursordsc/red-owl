local icons = {}
local showNametag = true
local r,g,b = 255,255,255
local name = ""
local font = "FontAwesome"
local barType = "rectangle"
local allowedDistance = 5
local recon = false

function whereAim(thePlayer)
    return getPedTarget(localPlayer) == thePlayer and getPedControlState(localPlayer, "aim_weapon")
end

function scoreChangeTracker(theKey, oldValue, newValue)
    if (getElementType(source) == "player") and (theKey == "toggleHuds") and (oldValue == false and newValue == true) then
        showNametag = false
    elseif (getElementType(source) == "player") and (theKey == "toggleHuds") and (oldValue == true and newValue == false) then
        showNametag = true
    elseif (getElementType(source) == "player") and (theKey == "interface.nametagFont") and (newValue) then
        if avaibleFonts[newValue] then
            if avaibleFonts[newValue][2] then
                font = exports.assets:getFont(avaibleFonts[newValue][1], avaibleFonts[newValue][2])
            else
                font = avaibleFonts[newValue][1]
            end
        end
    elseif (getElementType(source) == "player") and (theKey == "interface.nametagBar") and (newValue) then
        barType = newValue
    elseif (getElementType(source) == "player") and (theKey == "lastPositionRecon") then
        recon = newValue
    end
end
addEventHandler("onClientElementDataChange", getLocalPlayer(), scoreChangeTracker)

addEventHandler("onClientResourceStart", resourceRoot, function()  
    local newValue = getElementData(localPlayer, 'interface.nametagFont') or 9
    if avaibleFonts[newValue] then
        if avaibleFonts[newValue][2] then
            font = exports.assets:getFont(avaibleFonts[newValue][1], avaibleFonts[newValue][2])
        else
            font = avaibleFonts[newValue][1]
        end
    end
    local newValue = getElementData(localPlayer, 'interface.nametagBar') or "rectangle"
    barType = newValue
    recon = getElementData(localPlayer, 'lastPositionRecon') or false
end)

function getPlayerIcons(player)

    icons = { }
    r,g,b = getPlayerNametagColor(player)
    playerid = getElementData(player,'playerid')
    name = getPlayerName(player):gsub("_"," ").." ("..playerid..")"

    if getElementData(player, 'hiddenadmin') ~= 1 then		
	if getElementData(player,"duty_admin") == 1 then
        table.insert(icons, "a"..getElementData(player, "admin_level").."")
        name = getElementData(player,'account:username').." ("..playerid..")"
    end
	end

    if (getElementData(player, "written")) then
        table.insert(icons, "writing")
    end
	
	--if (getElementData(player, "written")) then
		--	table.insert(icons, "written")
		--end

    local veryImportantPlayer = getElementData(player, "veryImportantPlayer") or 0
    if veryImportantPlayer > 0 then
        table.insert(icons, "v"..veryImportantPlayer)
    end

    local selected_sticker = getElementData(player, "selected_sticker") or 0
    if selected_sticker > 0 then
        table.insert(icons, "stickers/s"..selected_sticker)
    end

    if getElementHealth(player) < 20 then
        table.insert(icons, "injury")
    end
	
    local veh = getPedOccupiedVehicle(player)
    
    if (veh) then 
        if getElementData(player, "seatbelt") then
            table.insert(icons, "seatbelt")
        end

        if getElementData(veh, "vehicle:windowstat") == 1 then
            table.insert(icons, "window")
        end
		
		if (getElementData(player, "vip") or 0) > 0 then
		    table.insert(icons, "v"..getElementData(player, "vip"))
	    end

        if getElementData(veh, "tinted") then
            name = "Bilinmeyen Kişi (Gizli)"
        end
    end

    return icons, name, r, g, b
end

setTimer(function()
    if showNametag then
        for k, v in ipairs(getElementsByType("player")) do
            if getElementData(v, 'loggedin') == 1 then
                local x1, y1, z1 = getElementPosition(localPlayer)
                local x2, y2, z2 = getElementPosition(v)
                if getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= allowedDistance or whereAim(v) or recon then
                    local x, y, z = getPedBonePosition( v, 5 )
                    local sx, sy = getScreenFromWorldPosition( x, y, z + 0.5 )

                    if ( sx and sy ) then
                        local icons, name, r, g, b = getPlayerIcons(v)
                        local sx, sy = sx+5, sy

                        local hpx, hpy, hpw, hph, height = sx-57/2-7 + 8, sy + 5, 52, 8, 13
                        if barType == "rectangle" then
                            dxDrawRectangle(hpx-1, hpy-1, hpw+2, hph+2, tocolor(0,0,0,255))
                            dxDrawRectangle(hpx-1, hpy-1, hpw+2, hph+2, tocolor(0,0,0,255))
                            dxDrawRectangle(hpx-0, hpy-0, hpw+0, hph+0, tocolor(50,0,0,255))
                            dxDrawRectangle(hpx+1, hpy+0.7, (50)*(getElementHealth(v)/100), 6, tocolor(200, 15, 15,255))
                            if getPedArmor(v) > 0 then
                                hpx, hpy, hpw, hph = sx-57/2-7 + 8, sy + 17, 52, 8
                                dxDrawRectangle(hpx-1, hpy-1, hpw+2, hph+2, tocolor(0,0,0,255))
                                dxDrawRectangle(hpx-1, hpy-1, hpw+2, hph+2, tocolor(0,0,0,255))
                                dxDrawRectangle(hpx-0, hpy-0, hpw+0, hph+0, tocolor(0, 0, 0,255))
                                dxDrawRectangle(hpx+1, hpy+1, (hpw-2)*(getPedArmor(v)/100), hph-2, tocolor(200, 200, 200,255))
                            end
                        elseif barType == "text" then
                            local sx, sy = sx+2, sy+17
                            dxDrawText("HP: "..math.floor(getElementHealth(v)).."%", sx+1, sy+1, sx+1, sy+1, tocolor(0,0,0), 1, font, "center", "bottom", false, false, false, true)
                            dxDrawText("#FFFFFFHP: "..getVariableColor(math.floor(getElementHealth(v)))..math.floor(getElementHealth(v)).."%", sx, sy, sx, sy, tocolor(255,255,255), 1, font, "center", "bottom", false, false, false, true)
                            if getPedArmor(v) > 0 then
                                local sx, sy = sx+2, sy+17
                                height = height + 13
                                dxDrawText("Zırh: "..math.floor(getPedArmor(v)).."%", sx+1, sy+1, sx+1, sy+1, tocolor(0,0,0), 1, font, "center", "bottom", false, false, false, true)
                                dxDrawText("#FFFFFFZırh: #777777"..math.floor(getPedArmor(v)).."%", sx, sy, sx, sy, tocolor(255,255,255), 1, font, "center", "bottom", false, false, false, true)
                            end
                        end

                        local sx, sy = sx+3, sy
                        dxDrawText(name, sx+1, sy+1, sx+1, sy+1, tocolor(0,0,0), 1, font, "center", "bottom", false, false, false)
                        dxDrawText(name, sx, sy, sx, sy, tocolor(r, g, b), 1, font, "center", "bottom", false, false, false)

                        local left = #icons * 13
                        local xpos = 0
                        for k, v in ipairs(icons) do
                            dxDrawImage(hpx+(k*27)-left, hpy+height, 25, 25, "icons/" .. v .. ".png", 0, 0, 0, tocolor(255, 255, 255, 235))
                            xpos = xpos + 25
                        end

                    end

                end 
            end
        end
    end
end, 0, 0)

function getVariableColor(variable)
    if (variable) > 50 then
        return "#009432"
    elseif (variable) >= 30 and (variable) <= 50 then
        return "#f1c40f"
    elseif (variable) <= 29 then
        return "#ff0000"
    end
end

function getNameagFont()
    return font
end

function setNametagFont(newFont)
    if newFont then
        if avaibleFonts[newFont][2] then
            font = exports.assets:getFont(avaibleFonts[newFont][1], avaibleFonts[newFont][2])
        else
            font = avaibleFonts[newValue][1]
        end
    end
end

function getNametagBar()
    return barType
end

function setNametagBar(newBar)
    if newBar then
        barType = newBar
    end
end

function toggleNametag()
    showNametag = not showNametag
end
addCommandHandler('name', toggleNametag)
addCommandHandler('togname', toggleNametag)
addCommandHandler('isimkapat', toggleNametag)
addCommandHandler('isimgoster', toggleNametag)