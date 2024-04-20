local count = 0
local theVehicle = {}

function aracOlustur(oyuncu)
	outputChatBox("[BİLGİ]: #ffffffMotorunu alıp mesleğe başladıktan sonra #800000'radarda'#ffffff işaretlenmiş yere git.",oyuncu, 208, 101, 29, true)
	outputChatBox("[BİLGİ]: #ffffffHedefe varınca motorundan in ve motora  #d0651d'sol'#ffffff tıklayarak pizzayı al..",oyuncu, 208, 101, 29, true)
	outputChatBox("[BİLGİ]: #ffffffPizzayı aldıktan sonra müşteriye sol tıklayarak pizzayı teslim et!",oyuncu, 208, 101, 29, true)
	local letter1 = string.char(math.random(65,90))
	local letter2 = string.char(math.random(65,90)) -- TÜRK PLAKA
	local plate = "34 " .. letter1 .. letter2 .. " " .. tostring(math.random(100, 9999))
	local count = count + 1

	theVehicle[oyuncu] = createVehicle (448, 800.337890625, -1629.2744140625, 13.3828125, 0, 0, 90, plate)
	
	if theVehicle[oyuncu] then
		setVehicleColor(theVehicle[oyuncu], 255, 0, 0, 255, 0, 0)
		setElementData(theVehicle[oyuncu], "fuel", 20)
		setElementData(theVehicle[oyuncu], "dbid", -count)
		setElementData(theVehicle[oyuncu], "enginebroke", 0)
		setElementData(theVehicle[oyuncu], "meslek:arac", getElementData(oyuncu, "job"))
		setElementData(theVehicle[oyuncu], "owner", getElementData(oyuncu, "dbid"))
		setElementData(theVehicle[oyuncu], "meslek:arac_sahip", getElementData(oyuncu, "dbid"))
		setElementData(theVehicle[oyuncu], "meslek", true)
		setElementData(theVehicle[oyuncu], "plate", plate)
		setElementData(theVehicle[oyuncu], "veh:Box", 0)
		setElementData(oyuncu, "meslek:aracim", theVehicle[oyuncu])

		fixVehicle(theVehicle[oyuncu])
		setTimer ( function()
				warpPedIntoVehicle (oyuncu, theVehicle[oyuncu], 1)
			end, 500, 1 )
		setVehicleDamageProof(theVehicle[oyuncu], false)
		warpPedIntoVehicle (oyuncu, theVehicle[oyuncu], 0)
		setElementData(oyuncu,"meslek:aracta",true)
	end
end
addEvent("pizzaOlustur",true)
addEventHandler("pizzaOlustur",getRootElement(), aracOlustur)