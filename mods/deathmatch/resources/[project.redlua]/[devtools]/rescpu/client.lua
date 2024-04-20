local sx,sy = guiGetScreenSize()
local resStat = false
local clientRows = {}, {}
local serverRows = {}, {}

local font = exports.fonts:getFont('Roboto',11)

local MED_CLIENT_CPU = 3 -- 3%
local MAX_CLIENT_CPU = 5 -- 5%

local MED_SERVER_CPU = 1 -- 1%
local MAX_SERVER_CPU = 2 -- 2%

function cpu()
            resStat = not resStat
            if resStat then

                _, clientRows = getPerformanceStats("Lua timing")
            
                setTimer(resStatRender,7,0)
                triggerServerEvent("getServerStat", localPlayer)
            else
           
                removeEventHandler("onClientRender", root, resStatRender)
                serverRows = {}, {}
                clientRows = {}, {}
                triggerServerEvent("destroyServerStat", localPlayer)
            end
        end

addCommandHandler('cpu',cpu)
addCommandHandler('stat',cpu)

function toFloor(num)
	return tonumber(string.sub(tostring(num), 0, -2)) or 0
end

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, 
    function(stat1,stat2)
        _, clientRows = getPerformanceStats("Lua timing")
        _, serverRows = stat1,stat2

        table.sort(clientRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)

        table.sort(serverRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)
    end
)

local disabledResources = {}
function resStatRender()
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end
	totalCPUC, totalCPUS = 0, 0
	if #clientRows ~= 0 then
		local height = (15*#clientRows)+15
		local y = sy/2-height/2
		_y = y
		--dxDrawRectangle(x-10,y,150,height,tocolor(57,57,57,150))
		y = y + 5
		for i, row in ipairs(clientRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
				local r,g,b,a = 255,255,255,255
				if usedCPU > MAX_CLIENT_CPU then
					r,g,b,a = 255,0,0,255
				elseif usedCPU > MED_CLIENT_CPU then
					r,g,b,a = 255,255,0,255
				end
				local text = row[1]:sub(0,15)..": "..usedCPU.."%"
				dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,255),1,font)
				dxDrawText(text,x,y,150,15,tocolor(r,g,b,a),1,font)
				y = y + 15
				totalCPUC = totalCPUC + usedCPU
				newY = y
			end
		end
		y = _y
		if #serverRows == 0 then
			dxDrawText("Kullanıcı - %"..totalCPUC,sx-74,y-19,sx-74,y-19,tocolor(0,0,0,255),1, font,"center")
			dxDrawText("Kullanıcı - %"..totalCPUC,sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1, font,"center")
		else
			dxDrawText("Kullanıcı - %"..totalCPUC,sx-234,y-19,sx-234,y-19,tocolor(0,0,0,255),1, font,"center")
			dxDrawText("Kullanıcı - %"..totalCPUC,sx-235,y-20,sx-235,y-20,tocolor(255,255,255,255),1, font,"center")
		end
		y = newY
	end
	
	if #serverRows ~= 0 then
		local x = sx-140
		local height = (15*#serverRows)
		local y = sy/2-height/2
		_y = y
		y = y + 5
		for i, row in ipairs(serverRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
				local r,g,b,a = 255,255,255,255
				if usedCPU > MAX_SERVER_CPU then
					r,g,b,a = 255,0,0,255
				elseif usedCPU > MED_SERVER_CPU then
					r,g,b,a = 255,255,0,255
				end
				local text = row[1]:sub(0,15)..": "..usedCPU.."%"
				dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,255),1,font)
				dxDrawText(text,x,y,150,15,tocolor(r,g,b,a),1,font)
				y = y + 15
				totalCPUS = totalCPUS + usedCPU
			end
		end
		y = _y

		dxDrawText("Sunucu - %"..totalCPUS,sx-74,y-19,sx-74,y-19,tocolor(0,0,0,255),1, font,"center")
		dxDrawText("Sunucu - %"..totalCPUS,sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1, font,"center")
	end
end