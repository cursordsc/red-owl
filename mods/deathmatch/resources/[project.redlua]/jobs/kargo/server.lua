local eventsPrefix = "Postman_"
local theVehicle = {}
local count = 0

addEvent(eventsPrefix .. "tryToCreateVehicle",true)
addEventHandler(eventsPrefix .. "tryToCreateVehicle",getRootElement(),
	function(hitElement)
		local letter1 = string.char(math.random(65,90))
		local letter2 = string.char(math.random(65,90)) -- TÜRK PLAKA
		local plate = "34 " .. letter1 .. letter2 .. " " .. tostring(math.random(100, 9999))
		local count = count + 1

		theVehicle[hitElement] = createVehicle (455, 2323.7109375, -2079.1123046875, 13.546875, 0, 0, 61, plate)
		setElementData(theVehicle[hitElement], "fuel", 20)
		setElementData(theVehicle[hitElement], "dbid", -count)
		setElementData(theVehicle[hitElement], "enginebroke", 0)
		setElementData(theVehicle[hitElement], "meslek:arac", getElementData(hitElement, "job"))
		setElementData(theVehicle[hitElement], "owner", getElementData(hitElement, "dbid"))
		setElementData(theVehicle[hitElement], "meslek", true)
		setElementData(theVehicle[hitElement], "plate", plate)
		setElementData(hitElement, "meslek:aracim", theVehicle[hitElement])
		fixVehicle(theVehicle[hitElement])
		setVehicleDamageProof(theVehicle[hitElement], false)
		warpPedIntoVehicle (hitElement, theVehicle[hitElement])
		triggerClientEvent(source,eventsPrefix.."initializeJob",source)
		setElementData(source,"meslek:aracta",true)
	end
)

addEvent("processUnusedVehicles",true)
addEventHandler("processUnusedVehicles",getRootElement(),
	function()
		if getElementData(source, "job") == 1 then
			if isElement(theVehicle[source]) then
			    destroyElement(theVehicle[source])
		    end
		end
	end
)

addEvent("kargo:paraver",true)
addEventHandler("kargo:paraver",getRootElement(),
	function(oyuncu)
		if getElementData(oyuncu, "job") == 1 then
			local miktar = 100

			if getElementData(oyuncu, "vip") == 1 then
				ekpara = 125
			elseif getElementData(oyuncu, "vip") == 2 then
				ekpara = 250
			elseif getElementData(oyuncu, "vip") == 3 then
				ekpara = 375
			elseif getElementData(oyuncu, "vip") == 4 then
				ekpara = 500
			else
				ekpara = 0
			end
			
			exports["global"]:giveMoney(oyuncu, miktar+ekpara)
		end
	end
)