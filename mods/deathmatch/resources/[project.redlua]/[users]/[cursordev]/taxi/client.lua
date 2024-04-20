list = { 
    [1] = {price = 234, shape = "Santa Maria Beach"},
    [2] = {price = 89, shape = "Ehliyet Alanı"},
    [3] = {price = 137, shape = "Idlegas"},
}

addEvent('taxi > gui', true)
addEventHandler('taxi > gui', root,
	function ()
	    if isElement(window) then destroyElement(window) return end
	    window = guiCreateWindow ( 0, 0, 0.2, 0.2, "Hızlı Erişim Arayüzü - RED:LUA", true ) 
	    exports.global:centerWindow(window)
	    guiWindowSetMovable(window,false)
	    guiWindowSetSizable(window,false)
	    showCursor(true)

	    gridlist = guiCreateGridList(0.01, 0.09, 0.93, 0.68, true, window)
	    guiGridListAddColumn(gridlist, "Yer İsmi", 0.6)
	    guiGridListAddColumn(gridlist, "Taksi Ücreti", 0.3)

	    for k, v in ipairs(list) do 
	    local row = guiGridListAddRow(gridlist)
	        guiGridListSetItemText(gridlist,row,1,v.shape,false,false)
	        guiGridListSetItemText(gridlist,row,2,"$"..v.price,false,false)
	    end

	    go = guiCreateButton( 0.52, 0.8, 0.6, 0.18, "Taksiye Bin", true,window )
	    cancel = guiCreateButton( 0.02, 0.8, 0.45, 0.18, "Kapat", true,window )
	end
)


addEventHandler('onClientGUIClick', root, 
    function(btn)
        if source == cancel then
            destroyElement(window)
            showCursor(false)
        elseif source == go then
            local get = guiGridListGetSelectedItem(gridlist)
            if get == -1 then
                    outputChatBox(""..exports.pool:getServerName()..":#F9F9F9 Lütfen yukarıdan bir bölge seçiniz.",255,0,0,true)
                return false 
            end
            local name = guiGridListGetItemText(gridlist, get, 1)
            triggerServerEvent('taxi > goto', localPlayer, localPlayer, name)
            fadeCamera(false)
            destroyElement(window)
            showCursor(false)
        end
    end
)

addEvent('taxi > fadecamera',true)
addEventHandler('taxi > fadecamera',root, 
    function()
        fadeCamera(true)
    end
)

local ped = createPed(23, 1690.03515625, -2247.0361328125, 13.539621353149, 92)
setElementFrozen(ped, true)
setElementData( ped, "talk", 1, false )
setElementData( ped, "name", "Peter France", false )