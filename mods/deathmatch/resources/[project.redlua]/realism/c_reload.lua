local noReloadGuns = { [25]=true, [33]=true, [34]=true, [35]=true, [36]=true, [37]=true }
function isGun(id) return getSlotFromWeapon(id) >= 2 and getSlotFromWeapon(id) <= 7 end
local screen = Vector2(guiGetScreenSize())
local w, h = 31, 35
local gx, gy = (screen.x-w)/1.05, (screen.y-h)/1.05
local font = exports.assets:getFont("in-regular", 13)
local awesome = exports.assets:getFont("FontAwesome", 13)

savedAmmo = { }
local handled = true

function weaponAmmo(prevSlot, currSlot)
    cleanupUI()
    triggerEvent("checkReload", source)
end
addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(), weaponAmmo)

function disableAutoReload(weapon, ammo, ammoInClip)
    if (ammoInClip==1)  and not getElementData(getLocalPlayer(), "deagle:reload") and not getElementData(getLocalPlayer(), "scoreboard:reload") then
        --triggerServerEvent("addFakeBullet", getLocalPlayer(), weapon, ammo)
        triggerEvent("i:s:w:r", getLocalPlayer())
        triggerEvent("checkReload", source)
    elseif (ammoInClip==0) then
        -- panic?
        --outputChatBox("We never ever should get this, comprende?")
    else
        cleanupUI()
        setTimer(function()
            --killTimer(dolduruldu)
        end,3000,1)
    end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), disableAutoReload)

function drawText()
    text = "Şarjöründe mermi kalmadı, R tuşuna bas ve doldur!"
    local uzunluk = dxGetTextWidth(text, 1, font)
    cursorRoundedRectangle(gx-uzunluk,gy,w+uzunluk+25,h,tocolor(10,10,10,225),{0.5,0.5,0.5,0.5})
    dxDrawText("", gx+10-uzunluk,gy+6,w,h,tocolor(200,0,0,255),1,awesome)
    dxDrawText(text, gx+45-uzunluk,gy+5,w,h,tocolor(255,255,255,255),1,font)
end

function checkReloadStatus ()
    local weaponID = getPedWeapon(getLocalPlayer())
    if  getPedAmmoInClip (getLocalPlayer()) == 1 and isGun(weaponID) then -- getElementData(source, "r:cf:"..tostring(weaponID)) or 
        if not handled then
            addEventHandler("onClientRender", getRootElement(), drawText)
            handled = true
        end
        --triggerServerEvent("addFakeBullet", getLocalPlayer(), weaponID, getPedTotalAmmo(getLocalPlayer()))
        --toggleControl ( "fire", false )
    else
        cleanupUI(false)
    end
end
addEvent("checkReload", true)
addEventHandler("checkReload", getRootElement(), checkReloadStatus)
setTimer(checkReloadStatus, 500, 0)

function cleanupUI(bplaySound)
    if (bplaySound) then
        playSound("reload.wav")
        setTimer(playSound, 400, 1, "reload.wav")
        dolduruldu = setTimer(function()
            texts = "Başarıyla şarjörü doldurdun."
            local uzunluks = dxGetTextWidth(texts, 1, font)
            cursorRoundedRectangle(gx-uzunluks,gy,w+uzunluks+25,h,tocolor(10,10,10,225),{0.5,0.5,0.5,0.5})
            dxDrawText("", gx+10-uzunluks,gy+6,w,h,tocolor(125,125,125,255),1,awesome)
            dxDrawText(texts, gx+45-uzunluks,gy+5,w,h,tocolor(255,255,255,255),1,font)
        end,0,0)
        setTimer(function()
            killTimer(dolduruldu)
        end,3000,1)
    end
    removeEventHandler("onClientRender", getRootElement(), drawText)
    handled = false
end
addEvent("cleanupUI", true)
addEventHandler("cleanupUI", getRootElement(), cleanupUI)