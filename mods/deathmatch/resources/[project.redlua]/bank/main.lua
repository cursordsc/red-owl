--mysql = exports.mysql:getConnection()

screen = Vector2(guiGetScreenSize())
w, h = 450, 180
nx, ny = (screen.x-w)/2, (screen.y-h)/2

fonts = {
    [1] = exports.fonts:getFont('RobotoB',12),
    [2] = exports.fonts:getFont('Roboto',10),
    [3] = exports.fonts:getFont('FontAwesome',12)
}

tabs = {
    {char='Yatırma'},
    {char='Çekme'},
    {char='Bilgiler'}
}


addEventHandler('onClientClick', root, function(button, state, _,_,_,_,_, clickedElement)
    if button == 'right' and state == 'down' then 
        if clickedElement then
            if getElementType(clickedElement) == 'object' and getElementModel(clickedElement) == 2942 then
                if not isTimer(render) then
                    showCursor(true)
                    page = 1
                    selected = nil
                    addEventHandler('onClientCharacter', root, function(...) write(...) end)
                    wait = 0
                    edits = {
                        [1] = 'Miktar',
                        [2] = 'Miktar'
                    }
                    isim = getPlayerName(localPlayer):gsub("_", " ")
                    ssn = math.random(10,99)..'******'
                    miktar = getElementData(localPlayer,'bankmoney')..'$'
                    no = getElementData(localPlayer, 'dbid')
                    render = setTimer(function()
                        dxDrawShadowText('ATM Arayüzü',nx+5,ny-30,w,h,tocolor(255,255,255),1,fonts[1])
                        roundedRectangle(nx,ny,w,h,tocolor(10,10,10))
                        roundedRectangle(nx+415,ny+5,w-420,h-150,mousePos(nx+415,ny+5,w-420,h-150) and tocolor(240,0,0) or tocolor(240,0,0,120))
                        dxDrawText('X', nx+424,ny+7.5,w,h,tocolor(255,255,255),1,fonts[3])
                        -- kapatma
                        if mousePos(nx+415,ny+5,w-420,h-150) and getKeyState('mouse1') then
                            killTimer(render)
                            showCursor(false)
                        end
                        --
                        for k, v in pairs(tabs) do
                            roundedRectangle(nx+10 - 80 + (k * 80),ny+12.5,w-380,h-152.5,page == k and tocolor(60,60,60) or mousePos(nx+10 - 80 + (k * 80),ny+12.5,w-380,h-152.5) and tocolor(60,60,60) or tocolor(40,40,40))
                            dxDrawText(v.char,nx+15  - 80 + (k * 80),ny+17.5,w,h,tocolor(255,255,255),1,fonts[2])
                            if mousePos(nx+10 - 80 + (k * 80),ny+12.5,w-380,h-152.5) and getKeyState('mouse1') then
                                page = k
                            end
                        end
                        dxDrawLine(nx,ny+40,nx+450,ny+40,tocolor(40,40,40),5)
                        if page == 1 then
                            dxDrawText('Selam, '..getPlayerName(localPlayer):gsub("_", " ")..'.\n\nBu alanda banka hesabına para yatırabilirsin, aşşağıda bulunan kısma istedi-\nğin miktarı girerek banka hesabına para aktarabilirsin!',nx+10,ny+50,w,h,tocolor(255,255,255),1,fonts[2])
                            roundedRectangle(nx+10,ny+130,w-100,h-150,tocolor(30,30,30))
                            dxDrawText(edits[1], nx+15,ny+135,w,h,tocolor(255,255,255),1,fonts[2])
                            roundedRectangle(nx+370,ny+130,w-420,h-150,mousePos(nx+370,ny+130,w-420,h-150) and tocolor(51,102,0) or tocolor(51,102,0,180))
                            roundedRectangle(nx+410,ny+130,w-420,h-150,mousePos(nx+410,ny+130,w-420,h-150) and tocolor(102,0,0) or tocolor(102,0,0,180))
                            dxDrawText('+',nx+380,ny+135,w,h,tocolor(255,255,255),1,fonts[3])
                            dxDrawText('-',nx+421,ny+134,w,h,tocolor(255,255,255),1,fonts[3])
                            if mousePos(nx+10,ny+130,w-100,h-150) and getKeyState('mouse1') then
                                edits[page] = ''
                                selected = page
                            elseif mousePos(nx+370,ny+130,w-420,h-150) and getKeyState('mouse1') and wait+600 <= getTickCount() then
                                wait = getTickCount()
                                if tonumber(edits[page]) then
                                    triggerServerEvent('bank.deposit', localPlayer, edits[page])
                                end
                            elseif mousePos(nx+410,ny+130,w-420,h-150) and getKeyState('mouse1') then
                                edits[page] = ''
                            end
                        elseif page == 2 then
                            dxDrawText('Selam, '..getPlayerName(localPlayer):gsub("_", " ")..'.\n\nBu alanda hesabından para çekebilirsin, aşşağıda bulunan kısma istediğin \nmiktarı girerek banka hesabından para çekebilirsin!',nx+10,ny+50,w,h,tocolor(255,255,255),1,fonts[2])
                            roundedRectangle(nx+10,ny+130,w-100,h-150,tocolor(30,30,30))
                            dxDrawText(edits[page], nx+15,ny+135,w,h,tocolor(255,255,255),1,fonts[2])
                            roundedRectangle(nx+370,ny+130,w-420,h-150,mousePos(nx+370,ny+130,w-420,h-150) and tocolor(51,102,0) or tocolor(51,102,0,180))
                            roundedRectangle(nx+410,ny+130,w-420,h-150,mousePos(nx+410,ny+130,w-420,h-150) and tocolor(102,0,0) or tocolor(102,0,0,180))
                            dxDrawText('+',nx+380,ny+135,w,h,tocolor(255,255,255),1,fonts[3])
                            dxDrawText('-',nx+421,ny+134,w,h,tocolor(255,255,255),1,fonts[3])
                            if mousePos(nx+10,ny+130,w-100,h-150) and getKeyState('mouse1') then
                                edits[page] = ''
                                selected = page
                            elseif mousePos(nx+370,ny+130,w-420,h-150) and getKeyState('mouse1') and wait+600 <= getTickCount() then
                                wait = getTickCount()
                                if tonumber(edits[page]) then
                                    triggerServerEvent('bank.withdraw', localPlayer, edits[page])
                                end
                            elseif mousePos(nx+410,ny+130,w-420,h-150) and getKeyState('mouse1') then
                                edits[page] = ''
                            end
                        
                        elseif page == 3 then
                            dxDrawText('Selam, '..getPlayerName(localPlayer):gsub("_", " ")..'.\n\nHesap bilgilerin aşşağıda sıralandı.\n\nHesap Sahibi: '..isim..'\nHesap NO: '..no..'\nMiktar: '..miktar..'\nKimlik: '..ssn..'',nx+10,ny+50,w,h,tocolor(255,255,255),1,fonts[2])
                            dxDrawText('Kart NO: 4609 **** **** 5023',nx+220,ny+115,w,h,tocolor(255,255,255),1,fonts[2])
                        end
                    end,0,0)
                else
                    killTimer(render)
                    showCursor(false)
                end
            end
        end
    end
end)

function write(character)
    if selected == 1 then
        if wait+50 <= getTickCount() then
        wait = getTickCount()
        if string.len(edits[1]) <= 12 then
            if tonumber(character) then
                edits[1] = ''..edits[1]..''..character
                char = string.len(edits[1])+1
            end
        end                
        end
    elseif selected == 2 then
        if wait+50 <= getTickCount() then
            wait = getTickCount()
            if string.len(edits[2]) <= 12 then
                if tonumber(character) then
                    edits[2] = ''..edits[2]..''..character
                    char = string.len(edits[2])+1
                end
            end                
            end
        end
end