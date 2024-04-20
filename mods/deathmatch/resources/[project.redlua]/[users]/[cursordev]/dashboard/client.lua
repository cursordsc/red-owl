screen = Vector2(guiGetScreenSize())
w, h = 620, 360
nx, ny = (screen.x-w)/2, (screen.y-h)/2

fonts = {
    regular = exports.assets:getFont('sf-regular',12),
    medium = exports.assets:getFont('sf-medium',12),
    mediumbig = exports.assets:getFont('sf-medium',14),
    awesome = exports.assets:getFont('FontAwesome',12)
}

datas = {"Karakter Yaşı", "Karakter Kilosu", "Karakter Boyu", "Karakter Parası", "Karakter Banka",  "Karakter Canı", "Karakter Zırhı", }

function dash(_,id)
    if localPlayer:getData("loggedin") == 1 then
        if not isTimer(render) then
            player = id and tonumber(localPlayer:getData("admin_level")) >= 1 and exports.global:findPlayerByPartialNick(localPlayer, id) or localPlayer
            dataNames = {"age", "weight", "height", "money", "bankmoney", math.floor(player.health), player.armor,}
            data = getDatas(player)
            render = setTimer(function()
                dxDrawRoundedRectangle(nx,ny,w,h,10,tocolor(15,15,15,235))
                dxDrawRoundedRectangle(nx+10,ny+60,w-390,h-165,10,tocolor(10,10,10,245))
                dxDrawRoundedRectangle(nx+250,ny+60,w-390,h-165,10,tocolor(10,10,10,245))
                dxDrawRoundedRectangle(nx+10,ny+260,w-390,h-265,10,tocolor(10,10,10,245))
                dxDrawText('',nx+10,ny+10,w-40,h-195,tocolor(255,83,83),1,fonts.awesome)
				dxDrawText('',nx+260,ny+70,w,h,tocolor(220,220,220),1,fonts.awesome)--car
				dxDrawText('Araç Bilgilerin',nx+288,ny+70,w,h,tocolor(220,220,220),1,fonts.medium)--car text
				dxDrawText('ID: ',nx+262,ny+100,w,h,tocolor(220,220,220),1,fonts.regular)--car text

                dxDrawText("RED:LUA",nx+40,ny+9,w,h,tocolor(255,83,83),1,fonts.medium)
               -- dxDrawText('',player.name:gsub("_"," ").." ("..player:getData("playerid")..")",nx+20,ny+40,w,h,tocolor(220,220,220),1,fonts.awesome)
				dxDrawText("Karakter Bilgilerin",nx+15,ny+35,w,h,tocolor(220,220,220),1,fonts.medium)
                dxDrawText('',nx+20,ny+70,w,h,tocolor(220,220,220),1,fonts.awesome) -- player
			    dxDrawText(player.name:gsub("_"," ").." ("..player:getData("playerid")..")",nx+45,ny+70,w,h,tocolor(220,220,220),1,fonts.medium)
                dxDrawText(data, nx+20,ny+100,nx+400,ny+h,tocolor(200,200,200),1,fonts.regular,"left","top",true)
            end,0,0)
        else
            killTimer(render)
        end
    end
end
addCommandHandler('bilgiler', dash)
bindKey('f1', 'down', dash)

function getDatas(player)
    if isElement(player) then
        list = {}
        for k=1, #dataNames do
            data = player:getData(dataNames[k]) or dataNames[k]
           table.insert(list, datas[k]..": "..data)
        end
        return table.concat(list, "\n")
    end
end