
local useFakePickups = true
local useFakeRot = false
local streamdistance = 10
local interiorsSpawned = {}
local elevatorsSpawned = { }
local colShapesSpawned = {}
local elevatorsColShapesSpawned = { }
local intsToBeLoaded = {}
local elevatorsToBeLoaded = {}
local fakePickups = {}
local fakePickupsEle = {}
local animFake = {}
local done = 0
local debugmode = false
local sx, sy = guiGetScreenSize()
local w, h = 300,75
local x, y = (sx-w), sy-h
local iconfont = exports.assets:getFont('FontAwesome', 25)
local icon = "$"
local icon2 = "$"
local font = exports.fonts:getFont('Roboto', 10)

function roundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
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

function applyPickupClientConfigSettings()
    local streamerDistance = tonumber( exports.account:loadSavedData("streamer-pickup", "25") )
    if (streamerDistance) then
        streamdistance = streamerDistance
    end
end
addEventHandler("accounts:settings:loadGraphicSettings", getRootElement(), applyPickupClientConfigSettings)

local lagcatcherenabled = false
local pickupRefreshRate = 20000
function checkNearbyInteriorPickups(first)
    if first then
        setTimer(checkNearbyInteriorPickups, pickupRefreshRate, 0)
        return 0
    end
    if getElementData(localPlayer, "loggedin") == 1 then
        for interior,_ in pairs(intsToBeLoaded) do
            local dbid = isElement(interior) and getElementData(interior, "dbid") or nil
            if dbid and not interiorsSpawned[dbid] then
                interiorShowPickups(interior)
                intsToBeLoaded[interior] = nil
            end
        end
        return 2
    end
end
setTimer(checkNearbyInteriorPickups, pickupRefreshRate, 1, true)

function checkNearbyElevatorPickups(first)
    if first then
        setTimer(checkNearbyElevatorPickups, pickupRefreshRate, 0)
        return 0
    end
    if getElementData(localPlayer, "loggedin") == 1 then
        for elevator,_ in pairs(elevatorsToBeLoaded) do
            if isElement(elevator) and getElementChildrenCount(elevator) ~= 2 then
                interiorShowPickups(elevator)
                elevatorsToBeLoaded[elevator] = nil
            end
        end
        return 2
    end
end
setTimer(checkNearbyElevatorPickups, math.ceil(pickupRefreshRate+(pickupRefreshRate/2)), 1, true)

function interiorCreateColshape(interiorElement)
    local dbid = getElementData(interiorElement, "dbid")
    if debugmode then
        outputDebugString("interiorCreateColshape running with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
    end
    local entrance = getElementData(interiorElement, "entrance")

    local outsideColShape = createColSphere ( entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z], 1 )

    if getElementType( interiorElement ) == "elevator" then
        setElementParent(outsideColShape, elevatorsSpawned[dbid][1])
    else
        setElementParent(outsideColShape, interiorsSpawned[dbid][1])
    end


    setElementInterior(outsideColShape, entrance[INTERIOR_INT])
    setElementDimension(outsideColShape, entrance[INTERIOR_DIM])
    setElementData(outsideColShape, "entrance", true, false)

    local exit = getElementData(interiorElement, "exit")

    local insideColShape = createColSphere ( exit[INTERIOR_X], exit[INTERIOR_Y], exit[INTERIOR_Z], 1 )
    if getElementType( interiorElement ) == "elevator" then
        setElementParent(insideColShape, elevatorsSpawned[dbid][2])
    else
        setElementParent(insideColShape, interiorsSpawned[dbid][2])
    end

    setElementInterior(insideColShape, exit[INTERIOR_INT])
    setElementDimension(insideColShape, exit[INTERIOR_DIM])
    setElementData(insideColShape, "entrance", false, false)

    if getElementType( interiorElement ) == "elevator" then
        elevatorsColShapesSpawned[dbid] = { outsideColShape, insideColShape }
    else
        colShapesSpawned[dbid] = { outsideColShape, insideColShape }
    end
    if debugmode then
        outputDebugString("interiorCreateColshape done with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
    end
end

function interiorRemoveColshape(interiorElement)
    local dbid = getElementData(interiorElement, "dbid")
    if debugmode then
        outputDebugString("interiorRemoveColshape running with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
    end
    if getElementType( interiorElement ) == "interior" then
        if not colShapesSpawned[dbid] then
            return
        end
        if isElement(colShapesSpawned[dbid][1]) then
            destroyElement( colShapesSpawned[dbid][1])
        end
        if isElement(colShapesSpawned[dbid][2]) then
            destroyElement( colShapesSpawned[dbid][2])
        end
            colShapesSpawned[dbid] = false
    elseif getElementType( interiorElement ) == "elevator" then
        if not elevatorsColShapesSpawned[dbid] then
            return
        end
        destroyElement( elevatorsColShapesSpawned[dbid][1])
        destroyElement( elevatorsColShapesSpawned[dbid][2])
        elevatorsColShapesSpawned[dbid] = false
    end
end

function interiorShowPickups(interiorElement)

    local dbid = getElementData(interiorElement, "dbid")
    if debugmode then
        outputDebugString("interiorShowPickups running with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
    end
    if getElementType( interiorElement ) == "elevator" then
        if getElementChildrenCount(interiorElement) == 2 then --if elevatorsSpawned[dbid] then
            if debugmode then
            outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 1" )
            end
            return false, 1
        end
    else
        if interiorsSpawned[dbid] then
            if debugmode then
            outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 2" )
            end
            return false, 2
        end
    end

    local entrance = getElementData(interiorElement, "entrance")
    local exit = getElementData(interiorElement, "exit")
    local int = getElementData(interiorElement, "status")

    if not entrance  then
        if debugmode then
            outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 3" )
        end
        return false, 3
    end

    if not exit  then
        if debugmode then
            outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 4" )
        end
        return false, 4
    end

    if not int  then
        if debugmode then
            outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 5" )
        end
        return false, 5
    end

    local tpObjectModel =  1272--1316 --1559 --

    local outsidePickup = createPickup( entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z], 3, int[INTERIOR_DISABLED] and 1314 or ( getElementType(interiorElement) == "elevator" and tpObjectModel or ( int[INTERIOR_TYPE] == 2 and tpObjectModel  or ( int[INTERIOR_OWNER] < 1 and int[INTERIOR_FACTION] < 1 and ( int[INTERIOR_TYPE] == 1 and 1272 or 1273 ) or tpObjectModel  ) ) ) )
    setElementDoubleSided( outsidePickup, true )

    setElementParent(outsidePickup, interiorElement)
    setElementInterior(outsidePickup, entrance[INTERIOR_INT])
    setElementDimension(outsidePickup, entrance[INTERIOR_DIM])
    setElementData(outsidePickup, "dim", entrance[INTERIOR_DIM], false)

    if useFakePickups then
        if not isPickupStreamable(outsidePickup) then
            local fakeHelper = createObject(int[INTERIOR_DISABLED] and 1314 or ( getElementType(interiorElement) == "elevator" and tpObjectModel or ( int[INTERIOR_TYPE] == 2 and tpObjectModel  or ( int[INTERIOR_OWNER] < 1 and ( int[INTERIOR_TYPE] == 1 and 1272 or 1273 ) or tpObjectModel  ) ) ), entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
            setElementParent(fakeHelper, interiorElement)
            fakePickups[tonumber(exit[INTERIOR_DIM])] = fakeHelper
            table.insert(animFake, fakeHelper)
            setElementInterior(fakeHelper, entrance[INTERIOR_INT])
            setElementDimension(fakeHelper, entrance[INTERIOR_DIM])
            setElementCollisionsEnabled(fakeHelper, false)
            local fakeModel = getElementModel(fakeHelper)
            local fakeScale = 0.5
            if(fakeModel == 1272 or fakeModel == 1273) then
                fakeScale = 1.0
            end
            setObjectScale(fakeHelper, fakeScale)
        end
    end

    local insidePickup = createPickup( exit[INTERIOR_X], exit[INTERIOR_Y], exit[INTERIOR_Z], 3,  tpObjectModel )
    setElementDoubleSided( insidePickup, true )
    setElementParent(insidePickup, interiorElement)
    setElementInterior(insidePickup, exit[INTERIOR_INT])
    setElementDimension(insidePickup, exit[INTERIOR_DIM])
    setElementData(insidePickup, "dim", exit[INTERIOR_DIM], false)

    setElementData(insidePickup, "other", outsidePickup, false)
    setElementData(outsidePickup, "other", insidePickup, false)

    if getElementType(interiorElement) == "elevator" then
        elevatorsSpawned[dbid] = { outsidePickup, insidePickup }
    else
        interiorsSpawned[dbid] = { outsidePickup, insidePickup }
    end
    interiorCreateColshape(interiorElement)
    done = done + 1
    if debugmode then
        outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": true, "..getElementType(interiorElement) == "interior" and 1 or 2 )
    end
    return true, getElementType(interiorElement) == "interior" and 1 or 2
end

function interiorRemovePickups(interiorElement)
    local dbid = getElementData(interiorElement, "dbid")

    if debugmode then
        outputDebugString("interiorRemovePickups running with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
    end

    if getElementType( interiorElement ) == "interior" then
        if not interiorsSpawned[dbid] then
            if debugmode then
                outputDebugString("interiorRemovePickups returning with  "..tostring(dbid) ..": false,  1" )
            end
            return false, 1
        end

        destroyElement( interiorsSpawned[dbid][1])
        destroyElement( interiorsSpawned[dbid][2])
        if useFakePickups then
            if(fakePickups[dbid]) then
                destroyElement(fakePickups[dbid])
                fakePickups[dbid] = nil
            end
        end
        interiorsSpawned[dbid] = false
        done = done - 1
        if debugmode then
            outputDebugString("interiorRemovePickups finished resulting on  "..tostring(dbid) .." true, 1" )
        end

        return true, 1
    elseif getElementType( interiorElement ) == "elevator" then
        if getElementChildrenCount(interiorElement) == 2 then
            if debugmode then
                outputDebugString("interiorRemovePickups returning with  "..tostring(dbid) ..": false,  2" )
            end
            return false, 2
        end

        destroyElement( elevatorsSpawned[dbid][1])
        destroyElement( elevatorsSpawned[dbid][2])
        if(fakePickupsEle[dbid]) then
            destroyElement(fakePickupsEle[dbid])
            fakePickupsEle[dbid] = nil
        end
        elevatorsSpawned[dbid] = false
        done = done - 1
        if debugmode then
            outputDebugString("interiorRemovePickups finished resulting on  "..tostring(dbid) .." true, 2" )
        end
        return true, 2
    else
        outputDebugString(" interiorRemovePickupsFail? ")
        outputDebugString("---")
        outputDebugString(tostring(interiorElement))
        outputDebugString(tostring(getElementType(interiorElement)))
        outputDebugString(tostring(dbid))
        outputDebugString("---")
    end

    if debugmode then
        outputDebugString("interiorRemovePickups finished without result on  "..tostring(dbid) )
    end
    return true
end


function deleteInteriorElement(databaseID)
    if debugmode then
        outputDebugString("interiorRemovePickups running with  "..tostring(databaseID) .." ".. getElementType( source ) == "elevator" and  "(elevator)" or "(interior)" )
    end
    if getElementType(source) == "interior" then
        interiorRemovePickups(source)
        interiorRemoveColshape(source)
        interiorsSpawned[databaseID] = nil
        colShapesSpawned[databaseID] = nil
    elseif getElementType(source) == "elevator" then
        interiorRemovePickups(source)
        interiorRemoveColshape(source)
        elevatorsSpawned[databaseID] = nil
        elevatorsColShapesSpawned[databaseID] = nil
    end
end
addEvent("deleteInteriorElement", true)
addEventHandler("deleteInteriorElement", getRootElement(), deleteInteriorElement)
----********END********----
----*INTERIOR STREAMER*----
----********END********----

----*******************----
----*  PICKUP HANDLER *----
----*******************----
local lastSource = nil
local lastCol = nil
local lastSourceIsEntrance = false
function enterInterior()
    local localElement = getLocalPlayer()
    local localDimension = getElementDimension( getLocalPlayer() )
    local vehicleElement = false
    local theVehicle = getPedOccupiedVehicle( getLocalPlayer() )
    if theVehicle and getVehicleOccupant ( theVehicle, 0 ) == getLocalPlayer() then
        vehicleElement = theVehicle
    end
    local found, foundInterior, foundColShape, foundIsEntrance = false
    for _, interior in ipairs( getElementsByType('interior') ) do
        local dbid = getElementData(interior, "dbid")
        local intEntrance = getElementData(interior, "entrance")
        local intExit = getElementData(interior, "exit")
        if colShapesSpawned[dbid] then
            if (isElementWithinColShape ( localElement, colShapesSpawned[dbid][1] ) or vehicleElement and isElementWithinColShape ( vehicleElement, colShapesSpawned[dbid][1] ) ) and localDimension == intEntrance[INTERIOR_DIM] then


                found = true
                foundInterior = interior
                foundColShape = colShapesSpawned[dbid][1]
                foundIsEntrance = true
                break

            elseif (isElementWithinColShape ( localElement, colShapesSpawned[dbid][2] ) or vehicleElement and isElementWithinColShape ( vehicleElement, colShapesSpawned[dbid][1] ) ) and localDimension == intExit[INTERIOR_DIM] then
                found = true
                foundInterior = interior
                foundColShape = colShapesSpawned[dbid][2]
                foundIsEntrance = false
                break
            end
        end
    end

    if not found then
        for _, elevator in ipairs( getElementsByType('elevator') ) do
            local dbid = getElementData(elevator, "dbid")
            local eleEntrance = getElementData(elevator, "entrance")
            local eleExit = getElementData(elevator, "exit")
            if elevatorsColShapesSpawned[dbid] then
                if (isElementWithinColShape ( localElement, elevatorsColShapesSpawned[dbid][1] ) or vehicleElement and isElementWithinColShape ( vehicleElement, elevatorsColShapesSpawned[dbid][1] ) ) and localDimension == eleEntrance[INTERIOR_DIM] then
                    found = true
                    foundInterior = elevator
                    foundColShape = elevatorsColShapesSpawned[dbid][1]
                    foundIsEntrance = true
                    break
                elseif (isElementWithinColShape ( localElement, elevatorsColShapesSpawned[dbid][2] ) or vehicleElement and isElementWithinColShape ( vehicleElement, elevatorsColShapesSpawned[dbid][2] ) ) and localDimension == eleExit[INTERIOR_DIM] then
                    found = true
                    foundInterior = elevator
                    foundColShape = elevatorsColShapesSpawned[dbid][2]
                    foundIsEntrance = false
                    break
                end
            end
        end
    end

    if not found then
        return
    end

    local interiorID = getElementData(foundInterior, "dbid")
    if interiorID then
        local interiorEntrance = getElementData(foundInterior, "entrance")
        local interiorExit = getElementData(foundInterior, "exit")

        local canEnter, errorCode, errorMsg = canEnterInterior(foundInterior)
        if canEnter or isInteriorForSale( foundInterior ) then
            if getElementType(foundInterior) == "interior" then
                if not vehicleElement then
                    triggerServerEvent("interior:enter", foundInterior)
                end
            else
                triggerServerEvent("elevator:enter", foundInterior, foundIsEntrance)
            end
        else
            outputChatBox(errorMsg, 255, 0, 0)
        end

    end
end

function bindKeys()
    bindKey("enter", "down", enterInterior)
    bindKey( "f", "down", enterInterior)
    toggleControl("enter_exit", false)
    --triggerServerEvent("int:updatemarker", getLocalPlayer(), true)
    --setElementData(localPlayer, "official-interiors:showIntPreviewer", true)
end

function unbindKeys()
    unbindKey("enter", "down", enterInterior)
    unbindKey("f", "down", enterInterior)
    toggleControl("enter_exit", true)
    --triggerServerEvent("int:updatemarker", getLocalPlayer(), false)
    --triggerEvent("displayInteriorName", getLocalPlayer() )
    --setElementData(localPlayer, "official-interiors:showIntPreviewer", false)
end

function checkLeavePickupStart(var1)
    if var1 then
        --bindKeys(  source )
        --lastSource = source
    end
end
--addEventHandler("displayInteriorName", getRootElement(), checkLeavePickupStart)

local isLastSourceInterior = nil
function hitInteriorPickup(theElement, matchingdimension)
    local colshape = getElementParent(getElementParent(source))
    if getElementType(colshape) == "interior" or getElementType(colshape) == "elevator" then
        local isVehicle = false
        local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
        if theVehicle and theVehicle == theElement and getVehicleOccupant ( theVehicle, 0 ) == getLocalPlayer() then
            isVehicle = true
        end

        if matchingdimension and (theElement == getLocalPlayer() or isVehicle)  then
            if getElementType(colshape) == "interior" or getElementType(colshape) == "elevator" then
                lastSource = false
                bindKeys()
                lastSourceIsEntrance = getElementData(source,"entrance") or false
                lastCol = source
                if getElementType(colshape) == "interior" then
                   isLastSourceInterior = true
                else
                    isLastSourceInterior = nil
                end
            end
        end
        cancelEvent()
    end
end
addEventHandler("onClientColShapeHit", getRootElement(), hitInteriorPickup)

function leaveInteriorPickup(thePlayer, matchingdimension)
    if lastSource and lastCol == source then
        lastSource = false
    end
end
addEventHandler("onClientColShapeLeave", getRootElement(), leaveInteriorPickup)
addEvent("manual-onClientColShapeLeave", true)
addEventHandler("manual-onClientColShapeLeave", getRootElement(), leaveInteriorPickup)

local intNameFont = dxCreateFont( "components/Bebas.ttf", 24 ) or "default-bold"
local robotoFont = exports.fonts:getFont("RobotoB", 9)
local BizNoteFont = dxCreateFont( ":resources/BizNote.ttf", 21 ) or "default-bold"
local scrWidth, scrHeight = guiGetScreenSize()
local yOffset = scrHeight-110
local margin = 3
local textShadowDistance = 3

function _dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
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

function renderInteriorName()
    local theInterior = lastCol
    if theInterior and isElement(theInterior) and isElementWithinColShape ( localPlayer, theInterior ) then
        local intInst = "Girmek için F tuşuna basın"
        local intID = getElementData(theInterior, "dbid")
        local intStatus = getElementData(theInterior, "status")
        local intName = "Kapi"
        local intFee = getElementData(theInterior, "intfee") or 0
        local intMoney = getElementData(theInterior, "money") or 0

        if isLastSourceInterior then
            intName = getElementData(theInterior, "name")
        end
        local intName_width = dxGetTextWidth ( intName, 1, intNameFont )
        local intName_left = (scrWidth-intName_width)/2
        local intName_height = dxGetFontHeight ( 1, intNameFont )
        local intName_top = (yOffset-intName_height)
        local intName_right = intName_left + intName_width
        local intName_bottom = intName_top + intName_height

        local textColor = tocolor(255,255,255,255)
        local protectedText, inactiveText = nil
        if true or canPlayerKnowInteriorOwner(theInterior) or canPlayerSeeInteriorID(theInterior) then
            local protected, details = isProtected(theInterior)
            if protected then
                textColor = tocolor(0, 255, 0,255)
                protectedText = "[Inactivity protection remaining: "..details.."]"
            else
                local active, details2 = isActive(theInterior)
                if not active then
                    textColor = tocolor(150,150,150,255)
                    inactiveText = "["..details2.."]"
                end
            end
        end

        intName_top = intName_top + intName_height

        if isLastSourceInterior then
            local intType = intStatus[INTERIOR_TYPE]
            local bizNote = getElementData(theInterior, "business:note")
            if intType == 1 and bizNote and type(bizNote) == "string" and string.len(bizNote) > 0 then
                local bizNote_width = dxGetTextWidth ( bizNote, 1, BizNoteFont )+20
                local bizNote_left = (scrWidth-bizNote_width)/2
                local bizNote_height = dxGetFontHeight ( 1, BizNoteFont )
                intName_top = intName_top - margin
                local bizNote_right = bizNote_left + bizNote_width
                local bizNote_bottom = intName_top + bizNote_height
                intName_top = intName_top + bizNote_height
            end

            if canPlayerKnowInteriorOwner(theInterior) then
                local intOwner = ""
                roundedRectangle(x/2,sy-h-25,w,h,9,tocolor(15,15,15,235))
                if intStatus[INTERIOR_OWNER] > 0 then
                    local ownerName = exports.cache:getCharacterNameFromID(intStatus[INTERIOR_OWNER])
                    if intType == 3 then
                        intOwner = "Kiracı: "..(ownerName or "..Loading..")
                        intInst = 'Girmek için "F" tuşuna basın'
                        if intName then else
                            intName = 'yükleniyor..'
                        end
                        dxDrawText("", x/2+10,sy-h-22+10, nil, nil, tocolor(86,103,215,245), 1, iconfont)
                        dxDrawRectangle(x/2+65,sy-h-25+15,2,45,tocolor(86,103,215,245))
                        dxDrawText('Kiralık Mülk ('..intName..') ('..intID..')', x/2+75,sy-h-25+15, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText('Giriş Ücreti '..(intFee or 0)..'$', x/2+75,sy-h-25+30, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText(intInst, x/2+75,sy-h-25+45, nil, nil, tocolor(225,225,225,245), 1, font)
                    elseif intType ~= 2 then
                        intOwner = "Mülk Sahibi: "..(ownerName or "..Loading..")
                        intInst = 'Girmek için "F" tuşuna basın'
                        dxDrawText("", x/2+10,sy-h-22+10, nil, nil, tocolor(86,103,215,245), 1, iconfont)
                        dxDrawRectangle(x/2+65,sy-h-25+15,2,45,tocolor(86,103,215,245))
                        dxDrawText('Mülk ('..intName..') ('..intID..')', x/2+75,sy-h-25+15, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText('Giriş Ücreti '..(intFee or 0)..'$', x/2+75,sy-h-25+30, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText(intInst, x/2+75,sy-h-25+45, nil, nil, tocolor(225,225,225,245), 1, font)
                    end
                elseif intStatus[INTERIOR_FACTION] > 0 then
                    local ownerName = exports.cache:getFactionNameFromId(intStatus[INTERIOR_FACTION])
                    if intType ~= 2 then
                        intOwner = "Mülk Sahibi: "..(ownerName or "..Loading..")
                        intInst = 'Girmek için "F" tuşuna basın'
                        dxDrawText("", x/2+10,sy-h-22+10, nil, nil, tocolor(86,103,215,245), 1, iconfont)
                        dxDrawRectangle(x/2+65,sy-h-25+15,2,45,tocolor(86,103,215,245))
                        dxDrawText('Mülk ('..intName..') ('..intID..')', x/2+75,sy-h-25+15, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText('Giriş Ücreti '..(intFee or 0)..'$', x/2+75,sy-h-25+30, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText(intInst, x/2+75,sy-h-25+45, nil, nil, tocolor(225,225,225,245), 1, font)
                    end
                else
                    if intType == 2 then
                        intOwner = "Kamu Binası"
                        intInst = 'Girmek için "F" tuşuna basın'
                        dxDrawText("", x/2+10,sy-h-22+10, nil, nil, tocolor(86,103,215,245), 1, iconfont)
                        dxDrawRectangle(x/2+65,sy-h-25+15,2,45,tocolor(86,103,215,245))
                        dxDrawText('Kamu Mülkü ('..intName..') ('..intID..')', x/2+75,sy-h-25+15, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText('Giriş Ücreti '..(intFee or 0)..'$', x/2+75,sy-h-25+30, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText(intInst, x/2+75,sy-h-25+45, nil, nil, tocolor(225,225,225,245), 1, font)
                    elseif intType == 3 then
                        local intPrice = exports.global:formatMoney(intStatus[INTERIOR_COST])
                        intOwner = "Kiralık: " ..intPrice
                        intInst = 'Kiralamak için "F" tuşuna basın'
                        dxDrawText("", x/2+20,sy-h-22+10, nil, nil, tocolor(86,103,215,245), 1, iconfont)
                        dxDrawRectangle(x/2+65,sy-h-25+15,2,45,tocolor(86,103,215,245))
                        dxDrawText('Kiralık Mülk ('..intName..') ('..intID..')', x/2+75,sy-h-25+15, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText('Fiyat '..(intPrice or 0)..'$', x/2+75,sy-h-25+30, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText(intInst, x/2+75,sy-h-25+45, nil, nil, tocolor(225,225,225,245), 1, font)
                    else
                        local intPrice = exports.global:formatMoney(intStatus[INTERIOR_COST])
                        intOwner = "Satılık: " ..intPrice
                        intInst = 'Satın almak için "F" tuşuna basın'
                        dxDrawText("", x/2+20,sy-h-22+10, nil, nil, tocolor(86,103,215,245), 1, iconfont)
                        dxDrawRectangle(x/2+65,sy-h-25+15,2,45,tocolor(86,103,215,245))
                        dxDrawText('Satılık Mülk ('..intName..') ('..intID..')', x/2+75,sy-h-25+15, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText('Fiyat '..(intPrice or 0)..'$', x/2+75,sy-h-25+30, nil, nil, tocolor(225,225,225,245), 1, font)
                        dxDrawText(intInst, x/2+75,sy-h-25+45, nil, nil, tocolor(225,225,225,245), 1, font)
                    end
                
                end
                
                local intOwner_width = dxGetTextWidth ( intOwner, 1, robotoFont )
                local intOwner_left = (scrWidth-intOwner_width)/2
                local intOwner_height = dxGetFontHeight ( 1, robotoFont )
                intName_top = intName_top + margin
                local intOwner_right = intOwner_left + intOwner_width
                local intOwner_bottom = intName_top + intOwner_height
                intName_top = intName_top + intOwner_height
            end
            if protectedText then
                local intProtected_width = dxGetTextWidth ( protectedText, 1, robotoFont )
                local intProtected_left = (scrWidth-intProtected_width)/2
                local intProtected_height = dxGetFontHeight ( 1, robotoFont )
                intName_top = intName_top + margin
                local intProtected_right = intProtected_left + intProtected_width
                local intProtected_bottom = intName_top + intProtected_height
                intName_top = intName_top + intProtected_height
            elseif inactiveText then
                local intProtected_width = dxGetTextWidth ( inactiveText, 1, robotoFont )
                local intProtected_left = (scrWidth-intProtected_width)/2
                local intProtected_height = dxGetFontHeight ( 1, robotoFont )
                intName_top = intName_top + margin
                local intProtected_right = intProtected_left + intProtected_width
                local intProtected_bottom = intName_top + intProtected_height
                intName_top = intName_top + intProtected_height
            end
        end
        if tonumber(intFee) > 0 then
            local intFee = "Giriş Ücreti: $"..intFee
            local intFee_width = dxGetTextWidth ( intFee, 2, "default" )
            local intFee_left = (scrWidth-intFee_width)/2
            local intFee_height = dxGetFontHeight ( 1, "default" )
            intName_top = intName_top + margin
            local intFee_right = intFee_left + intFee_width
            local intFee_bottom = intName_top + intFee_height
            intName_top = intName_top + intFee_height
        end     
        local intInst_width = dxGetTextWidth ( intInst, 1, robotoFont )
        local intInst_left = (scrWidth-intInst_width)/2
        local intInst_height = dxGetFontHeight ( 1, robotoFont )
        intName_top = intName_top + margin
        local intInst_right = intInst_left + intInst_width
        local intInst_bottom = intName_top + intInst_height
        intName_top = intName_top + intInst_height

        -- Interior ID for admins/factions with MDC access to interior information
        if isLastSourceInterior and canPlayerSeeInteriorID(theInterior) then
            local intId = "(( ID: " .. getElementData(theInterior, "dbid") .. " ))"
            local intId_width = dxGetTextWidth ( intId, 1, robotoFont )
            local intId_left = (scrWidth-intId_width)/2
            local intId_height = dxGetFontHeight ( 1, robotoFont )
            intName_top = intName_top + margin
            local intId_right = intId_left + intId_width
            local intId_bottom = intName_top + intId_height
            intName_top = intName_top + intId_height
        end
    else
        --removeEventHandler("onClientRender", root, renderInteriorName)
        unbindKeys()
    end
end
--addEventHandler("onClientPreRender", root, renderInteriorName)
setTimer(renderInteriorName, 0, 0, true)

function canPlayerKnowInteriorOwner(theInterior)
    return  (getElementData(theInterior, "status")[INTERIOR_OWNER] == 0) -- unown.
        or  (exports.integration:isPlayerTrialAdmin(localPlayer) and (getElementData(localPlayer, "duty_admin") == 1))
        or  (getElementData(localPlayer, "dbid") == getElementData(theInterior, "status")[INTERIOR_OWNER])
end

function canPlayerSeeInteriorID(theInterior)
    return  getElementData(localPlayer, "faction") == 1 -- LSPD
        or  getElementData(localPlayer, "faction") == 3 -- Gov
        or  getElementData(localPlayer, "faction") == 59 -- SAHP
        or  (exports.integration:isPlayerTrialAdmin(localPlayer) and (getElementData(localPlayer, "duty_admin") == 1))
        or  (exports.integration:isPlayerSupporter(localPlayer) and (getElementData(localPlayer, "duty_supporter") == 1))
end

--Disable enter/exit vehicle for driver while being inside int marker - maxime
--[[
function enteringExitingVehicle(button, press)
    if (button == "f" or button == "enter") and (press) then -- Only output when they press it down
        if intShowing then
            cancelEvent()
        end
    end
end
]]
--addEventHandler("onClientKey", root, enteringExitingVehicle)

--[[
function vehicleStartEnter(thePlayer)
    if thePlayer == getLocalPlayer() then
        if getElementData(thePlayer, "interiormarker") then
            cancelEvent()
        end
    end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), vehicleStartEnter)
]]
----********END********----
----*  PICKUP HANDLER *----
----********END********----

----*******************----
----*   Lag catcher   *----
----*******************----
local lagCatcherWindow, lagCatcherMessage = nil
function showLagCatcher()
    --[[if not firsttime then return end

    lagcatcherenabled = true
    setTimer(hideLagCatcher, 5000, 1, 1)

    if (isElement(lagCatcherWindow)) then
        destroyElement(lagCatcherWindow)
    end

    local x, y = guiGetScreenSize()
    lagCatcherWindow = guiCreateWindow( x*.5-150, y*.5-65, 280, 110, "ATTENTION", false )
    guiWindowSetSizable( lagCatcherWindow, false )
    lagCatcherMessage = guiCreateLabel( 20, 20, 260, 80, "The server is sending all the interiors\nto your game, please standby. Your game\nmay hang for a few seconds in the process.\n", false, lagCatcherWindow )
    guiBringToFront( lagCatcherWindow )

    updateLagCatcher()]]
end


function hideLagCatcher(step)
    if step < 3 then
        setTimer(hideLagCatcher, 1000, 1, step+1)
        return
    end
    lagcatcherenabled = false
    destroyElement(lagCatcherMessage)
    destroyElement(lagCatcherWindow)
end

----********END********----
----*   Lag catcher   *----
----********END********----


----*********************************----
----*   Exciter's pickup streamer   *----
----*********************************----
function isPickupStreamable(pickup)
    local x,y,z = getElementPosition(pickup)
    if(x > 4092 or x < -4092 or y > 4092 or y < -4092) then
        return false
    end
    return true
end

function stopFakeRotation()
    killTimer(rotateFakeTimer)
    rotateFakeTimer = nil
    outputChatBox("FakeRot timer stopped.")
end
addCommandHandler("stopfakerot", stopFakeRotation)

function debugGetNotLoadedInts()
    outputChatBox("intsToBeLoaded "..tostring(#intsToBeLoaded))
    outputChatBox("elevatorsToBeLoaded: "..tostring(#elevatorsToBeLoaded))
    outputChatBox("interiorsSpawned: "..tostring(#interiorsSpawned))
    outputChatBox("elevatorsSpawned: "..tostring(#elevatorsSpawned))
end
addCommandHandler("getloaded", debugGetNotLoadedInts)

addEventHandler("onClientResourceStart", getRootElement( ),
    function( )
        for _, interior in ipairs(getElementsByType("interior")) do
            intsToBeLoaded[interior] = true
        end

        for _, elevator in ipairs(getElementsByType("elevator")) do
            elevatorsToBeLoaded[elevator] = true
        end
    end
);

function initializePickupLoading()
    --outputChatBox("doing it")
    for _, interior in ipairs(getElementsByType("interior")) do
        intsToBeLoaded[interior] = true
    end

    for _, elevator in ipairs(getElementsByType("elevator")) do
        elevatorsToBeLoaded[elevator] = true
    end
end
--setTimer(initializePickupLoading, 5000, 1)

function schedulePickupLoading(element)
    outputDebugString("schedulePickupLoading("..tostring(element)..")")
    local pickupType = getElementType(element)
    if(pickupType == "interior") then
        --if interiorsSpawned[element] then
        --    interiorsSpawned[element] = nil
        --end
        if not intsToBeLoaded[element] then
            intsToBeLoaded[element] = true
        end
    elseif(pickupType == "elevator") then
        --if elevatorsSpawned[element] then
        --    elevatorsSpawned[element] = nil
        --end
        if not elevatorsToBeLoaded[element] then
            elevatorsToBeLoaded[element] = true
        end
    end
end
addEvent("interior:schedulePickupLoading",true)
addEventHandler("interior:schedulePickupLoading",getRootElement(),schedulePickupLoading)

function clearElevators()
    --[[
    local possibleElevators = getElementsByType("elevator")
    for key, element in ipairs(possibleElevators) do
        if elevatorsToBeLoaded[element] then
            elevatorsToBeLoaded[element] = nil
        end
        if elevatorsSpawned[element] then
            elevatorsSpawned[element] = nil
        end
    end
    --]]
    elevatorsToBeLoaded = {}
    elevatorsSpawned = {}
end
addEvent("interior:clearElevators",true)
addEventHandler("interior:clearElevators",getRootElement(),clearElevators)

addEventHandler("onClientResourceStop", getResourceRootElement(getResourceFromName("elevators")),
    function(stoppedRes)
        clearElevators()
    end
);

function forcePickupSpawn()
    if exports.integration:isPlayerScripter(getLocalPlayer()) then
        initializeSoFar()
    end
end
addCommandHandler("forcepickupspawn", forcePickupSpawn)
----***************END***************----
----*   Exciter's pickup streamer   *----
----***************END***************----


--START / Interior/Elevator Loading Notifier - MAXIME
local curInteriors, maxInteriors, showingInterior, lastUpdateInterior = 0, 1, false, 0
local curElevators, maxElevators, showingElevator, lastUpdateElevator = 0, 1, false, 0

function showInteriorLoadingNotifier()
    showingInterior = true
    if getElementData(localPlayer, "loggedin") == 1 then
        local x, y, w, h = 410, 374, 470, 85
        local xoffset = (scrWidth-x)/2-x
        local yoffset = -y+10
        --dxDrawRectangle(x+xoffset, y+yoffset, w, h, tocolor(0, 0, 0, 98), true)
       -- dxDrawText("Progress: "..curInteriors.."/"..maxInteriors.." ("..math.ceil(curInteriors/maxInteriors*100).."%)", 434+xoffset, 384+yoffset, 848+xoffset, 415+yoffset, tocolor(255, 255, 255, 255), 1.00, "bankgothic", "center", "top", false, false, true, false, false)
       -- dxDrawText("Interiors are being loaded at the moment, please be patient if your property hasn't appeared yet.", 434+xoffset, 415+yoffset, 848+xoffset, 448+yoffset, tocolor(255, 255, 255, 255), 1.00, robotoFont, "center", "top", false, true, true, false, false)
    end

    if curInteriors >= maxInteriors or getTickCount() - lastUpdateInterior > 20000 then
        hideInteriorLoadingNotifier()
    end
end

function hideInteriorLoadingNotifier()
    if showingInterior then
        removeEventHandler("onClientPreRender", root, showInteriorLoadingNotifier)
        curInteriors, maxInteriors, showingInterior = 0, 1, false
    end
end

function interior_initializeSoFar(cur, max)
    for _, interior in ipairs(getElementsByType("interior")) do
        local dbid = tonumber(getElementData(interior, "dbid")) or 0
        if not intsToBeLoaded[interior] and not interiorsSpawned[dbid] then
            intsToBeLoaded[interior] = true
        end
    end

    if not showingInterior then
        addEventHandler("onClientPreRender", root, showInteriorLoadingNotifier)
    end
    curInteriors, maxInteriors = cur, max
    lastUpdateInterior = getTickCount()
end
addEvent("interior:initializeSoFar",true)
addEventHandler("interior:initializeSoFar",getRootElement(),interior_initializeSoFar)

function showElevatorLoadingNotifier()
    showingElevator = true
    if getElementData(localPlayer, "loggedin") == 1 then
        local x, y, w, h = 410, 374, 470, 85
        local xoffset = (scrWidth-x)/2-x
        local yoffset = -y+10
        if showingInterior then
            yoffset = yoffset + 85+10
        end
      --  dxDrawRectangle(x+xoffset, y+yoffset, w, h, tocolor(0, 0, 0, 98), true)
       -- dxDrawText("Progress: "..curElevators.."/"..maxElevators.." ("..math.ceil(curElevators/maxElevators*100).."%)", 434+xoffset, 384+yoffset, 848+xoffset, 415+yoffset, tocolor(255, 255, 255, 255), 1.00, "bankgothic", "center", "top", false, false, true, false, false)
        -- dxDrawText("Elevators are being loaded at the moment, please be patient if your markers hasn't appeared yet.", 434+xoffset, 415+yoffset, 848+xoffset, 448+yoffset, tocolor(255, 255, 255, 255), 1.00, robotoFont, "center", "top", false, true, true, false, false)
    end

    if curElevators >= maxElevators or getTickCount() - lastUpdateElevator > 20000 then
        hideElevatorLoadingNotifier()
    end
end

function hideElevatorLoadingNotifier()
    if showingElevator then
        removeEventHandler("onClientPreRender", root, showElevatorLoadingNotifier)
        curElevators, maxElevators, showingElevator = 0, 1, false
    end
end

function elevator_initializeSoFar(cur, max)
    for _, elevator in ipairs(getElementsByType("elevator")) do
        local dbid = tonumber(getElementData(elevator, "dbid")) or 0
        if not elevatorsToBeLoaded[elevator] and not elevatorsSpawned[dbid] then
            elevatorsToBeLoaded[elevator] = true
        end
    end

    if not showingElevator then
        addEventHandler("onClientPreRender", root, showElevatorLoadingNotifier)
    end
    curElevators, maxElevators = cur, max
    lastUpdateElevator = getTickCount()
end
addEvent("elevator:initializeSoFar",true)
addEventHandler("elevator:initializeSoFar",getRootElement(),elevator_initializeSoFar)
--END / Interior/Elevator Loading Notifier - MAXIME