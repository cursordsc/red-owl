Labels = {
    debug = false,
	adm = "",
	sup = "",
	reports = "",
    screen = Vector2(guiGetScreenSize()),

    date = function()
        x = getRealTime();
        x.year = x.year + 1900;
        x.month = x.month + 1;
        
            if (x.monthday < 10) then 
                monthday = '0'..x.monthday;
            else 
                monthday = x.monthday;
            end

            if (x.month < 10) then 
                month = '0'..x.month;
            else 
                month = x.month;
            end 

	return tostring(monthday..'/'..month..'/'..x.year)
    end,

    index = function(self)

        framesPerSecond = 0
        framesDeltaTime = 0
        lastRenderTick = false 

        label = GuiLabel(0,0,self.screen.x,15,'',false) 
        label:setAlpha(0.6)
        
        servers_label = GuiLabel(0,0,self.screen.x,15,'',false) 
        servers_label:setAlpha(0.6)
		
    end,
}

instance = new(Labels)
instance:index()


local time = getRealTime()
local hours = time.hour
local minutes = time.minute
local seconds = time.second
local monthday = time.monthday
local month = time.month
local year = time.year
local formattedTime = string.format("%04d/%02d/%02d", year + 1900, month + 1, monthday)

local screenW, screenH = guiGetScreenSize()
local iFPS 				= 0
local iFrames 			= 0
local iStartTick 		= getTickCount()
local id, nome = getElementData(localPlayer,"playerid") or "0"
local fontum =  exports.fonts:getFont("RobotoL", 10)
--local hoursplayed = getElementData(thePlayer, "hoursplayed")

addEventHandler("onClientRender", root, 
    function () 
        local currentTick = getTickCount() 
            lastRenderTick = lastRenderTick or currentTick 
            framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick) 
            lastRenderTick = currentTick 
            framesPerSecond = framesPerSecond + 1
         
            if framesDeltaTime >= 1000 then 

                if getElementData(localPlayer,'loggedin') == 1 then

                servers_label:setSize(instance.screen.x - guiLabelGetTextExtent(label) + 5,14,false)
                servers_label:setPosition(5, instance.screen.y - 15, false)
				servers_label:setAlpha(0.5)
				
				label:setText('CHID: '..getElementData(localPlayer, 'dbid')..' | RED:LUA Scripting - V2 OWL | '..tostring(framesPerSecond)..' FPS | '..getPlayerPing(localPlayer)..'MS |')
                
                label:setSize(instance.screen.x - guiLabelGetTextExtent(label) + 5,14,false)
                label:setPosition(instance.screen.x - guiLabelGetTextExtent(label) - 85, instance.screen.y - 15, false)
                
                framesDeltaTime = framesDeltaTime - 1000 
                framesPerSecond = 0 

                end

            end 
    end 
,true) 
