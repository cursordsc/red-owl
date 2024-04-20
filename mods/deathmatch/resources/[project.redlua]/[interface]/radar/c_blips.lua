
radarBlips = --- name : name,blip element,type,image,r,g,b
{
	["gift"]={"Hediye Ağacı",createBlip(1305.677734375, -2348.90625,0,0,2,255,0,0,255,0,0),0,"51",32,32,255, 255, 255},
	--["lojist"]={"VIP Lojistik",createBlip(2211.3623046875, -2239.4140625,0,0,2,255,0,0,255,0,0),0,"26",32,32,255, 255, 255},
	--["uzum1"]={"Üzüm Tarlası",createBlip(-23.7275390625, -70.7451171875,0,0,2,255,0,0,255,0,0),0,"64",32,32,255, 255, 255},
	--["uzum2"]={"Üzüm İşleme",createBlip(647.380859375, -509.3212890625,0,0,2,255,0,0,255,0,0),0,"64",32,32,255, 255, 255},
	--["uzum3"]={"Üzüm Hamı Satma",createBlip(-77.6923828125, -1136.521484375,0,0,2,255,0,0,255,0,0),0,"64",32,32,255, 255, 255},
	--["knvr1"]={"Kenevir Tarlası",createBlip(1940.896484375, 206.96484375,0,0,2,255,0,0,255,0,0),0,"33",32,32,255, 255, 255},
	--["knvr2"]={"Kenevir İşleme",createBlip(1298.3876953125, 396.3701171875,0,0,2,255,0,0,255,0,0),0,"33",32,32,255, 255, 255},
	--["knvr3"]={"Kenevir Satma",createBlip(1467.4921875, 366.615234375,0,0,2,255,0,0,255,0,0),0,"33",32,32,255, 255, 255},
	["bnzn"]={"Benzinlik & Market",createBlip(1944.5966796875, -1771.76953125,0,0,2,255,0,0,255,0,0),0,"42",32,32,255, 255, 255},
	["banka"]={"Banka",createBlip(1311.09765625, -1373.6669921875,0,0,2,255,0,0,255,0,0),0,"52",32,32,255, 255, 255},
	["hstn"]={"İstanbul Devlet Hastanesi",createBlip(1182.1982421875, -1323.3330078125,0,0,2,255,0,0,255,0,0),0,"22",32,32,255, 255, 255},
	["emniyet"]={"İstanbul Emniyet Müdürlüğü",createBlip(1554.0205078125, -1676.9921875,0,0,2,255,0,0,255,0,0),0,"30",32,32,255, 255, 255},
	["sjnn"]={"Giyim Mağazası",createBlip(2243.77734375, -1665.0625,0,0,2,255,0,0,255,0,0),0,"45",32,32,255, 255, 255},
	["crshpo"]={"Araç Mağazası",createBlip(1834.1552734375, -1447.044921875,0,0,2,255,0,0,255,0,0),0,"56",32,32,255, 255, 255},
	["taksi"]={"Taksi Durağı",createBlip(1770.2470703125, -1859.974609375,0,0,2,255,0,0,255,0,0),0,"71",32,32,255, 255, 255},
	["aracprcltm"]={"Araç Hurdalığı",createBlip(1600.7431640625, -1799.4736328125,0,0,2,255,0,0,255,0,0),0,"72",32,32,255, 255, 255},
	["mknk"]={"Mekanik & Sanayi",createBlip(2894.044921875, -1913.1259765625,0,0,2,255,0,0,255,0,0),0,"69",32,32,255, 255, 255},
	["trrt"]={"TRT Haber",createBlip(700.7421875, -1359.1611328125,0,0,2,255,0,0,255,0,0),0,"77",32,32,255, 255, 255},
	["hvlnm"]={"İstanbul Havalimanı",createBlip(1721.1533203125, -2551.7021484375,0,0,2,255,0,0,255,0,0),0,"5",32,32,255, 255, 255},
	--["methlbr"]={"Meth Laboratuarı",createBlip(-418.7119140625, -1406.705078125,0,0,2,255,0,0,255,0,0),0,"23",32,32,255, 255, 255},
	--["escort"]={"Pig The Peen",createBlip(2417.0869140625, -1222.6953125,0,0,2,255,0,0,255,0,0),0,"38",32,32,255, 255, 255},
	--["lahanasatıs"]={"Lahana Tarlası",createBlip(1527.9423828125, -37.6474609375,0,0,2,255,0,0,255,0,0),0,"job",32,32,255, 255, 255},
	--["lahanatoplama"]={"Lahana Satış",createBlip( 1509.0732421875, -131.6103515625,0,0,2,255,0,0,255,0,0),0,"job",32,32,255, 255, 255},
	["denzfner"]={"Deniz Feneri",createBlip (  154.1484375, -1938.78515625,0,0,2,255,0,0,255,0,0),0,"9",24,24,255, 255, 255},
	--["balkclk"]={"Balıkçılık",createBlip (  367.01171875, -2037.87890625,0,0,2,255,0,0,255,0,0),0,"9",24,24,255, 255, 255},
	--["metalic"]={"Meth Alıcısı",createBlip(1424.2001953125, -1314.6494140625,0,0,2,255,0,0,255,0,0),0,"23",32,32,255, 255, 255},
	--["rrrs"]={"Jandarma Komutanlığı",createBlip(-518.03125, -535.3017578125,0,0,2,255,0,0,255,0,0),0,"30",32,32,255, 255, 255},
}


radarOwnBlips = {}

limitlessDistanceBlips = {}
setTimer(
	function()
		local blipIndex = 1
		for index, value in ipairs(getElementsByType("blip")) do
			if getBlipIcon(value) ~= 0 then
				local distanceStatus = limitlessDistanceBlips[getBlipIcon(value)] and 1 or 0
				radarBlips["blip_"..blipIndex] = {getElementData(value, "name") or "",value,distanceStatus,getBlipIcon(value),30,30,255,255,255}
				blipIndex = blipIndex + 1
			end
		end
	end,
1500, 0)



local free_ids = {}
local free_id = 1
function createOwnBlip(type,word_x,word_y)
	local name = ""
	if type == "mark_1" or type == "mark_2" or type == "mark_3" or type == "mark_4" then name = "Jelölés"
	elseif type == "garage" then name = "Garázs"
	elseif type == "house" then name = "Ház"
	elseif type == "vehicle" then name = "Jármű" end
    if not free_ids[type] then
        free_ids[type] = 0
    end
    local free_id = free_ids[type] + 1
	if not radarOwnBlips[name.." "..tostring(free_id)] then
		local element = createBlip (word_x,word_y,0,0,2,255,0,0,255,0,0)
		radarOwnBlips[name.." "..tostring(free_id)] = {name.." "..tostring(free_id),word_x,word_y,0,type,12,12,255,255,255}
		createStayBlip(name.." "..tostring(free_id),element,0,type,12,12,255,255,255)
		free_ids[type] = 1 
	else
		free_ids[type] = free_id+1
		createOwnBlip(type,word_x,word_y)
	end
end

function deleteOwnBlip(name)
	if radarOwnBlips[name] then
		destroyStayBlip(name)
		radarOwnBlips[name] = nil
	end
end

function jsonLoad()
	local json = fileOpen(":radar/blips.json")
	local json_string = ""
	while not fileIsEOF(json) do
		json_string = json_string..""..fileRead(json,500)
	end
	fileClose(json)
	return fromJSON(json_string)
end

function jsonSave()
	if fileExists(":radar/blips.json") then fileDelete(":radar/blips.json") end
	local json = fileCreate(":radar/blips.json")
		local json_string = toJSON(radarOwnBlips)
		fileWrite(json,json_string)
		fileClose(json)
end

addEventHandler( "onClientResourceStart",resourceRoot,function()
	if fileExists(":radar/blips.json") then

		local blip_table = nil
		local json = fileOpen(":radar/blips.json")
		local json_string = ""
		while not fileIsEOF(json) do
			json_string = json_string..""..fileRead(json,500)
		end
		fileClose(json)
		blip_table = fromJSON( json_string )
		for k, values in pairs(blip_table) do
			radarOwnBlips[values[1]] = {values[1],values[2],values[3],values[4],values[5],values[6],values[7],values[8],values[9],values[10]}
			createStayBlip(values[1],createBlip (values[2],values[3],0,0,2,255,0,0,255,0,0),values[4],values[5],values[6],values[7],values[8],values[9],values[10])
		end
	end
end)

addEventHandler( "onClientResourceStop",resourceRoot,function()
	 jsonSave()
end)



function createStayBlip(name,element,visible,image,imgw,imgh,imgr,imgg,imgb,no3d)
    radarBlips[name] = {name,element,visible,image,imgw,imgh,imgr,imgg,imgb,no3d}
end


function destroyStayBlip(name)
	radarBlips[name] = nil
end
