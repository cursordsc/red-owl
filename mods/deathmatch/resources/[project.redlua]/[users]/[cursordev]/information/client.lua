
local sx, sy = guiGetScreenSize()
local browser = guiCreateBrowser(0, 0, sx, sy, true, true, false)
guiSetVisible(browser, false)
local theBrowser = guiGetBrowser(browser)

addEventHandler("onClientBrowserCreated", theBrowser, 
	function()
		loadBrowserURL(source, "http://mta/local/social.html")
	end
)

bindKey("F1","down",function()
	if not guiGetVisible(browser,true) then
		informationOpen()
	else
		informationClose()
	end
end)

function informationOpen()
	guiSetVisible(browser,true)
	guiSetInputEnabled(true)
	showCursor(true)
end

function informationClose()
	guiSetVisible(browser,false)
	guiSetInputEnabled(false)
	showCursor(false)
end