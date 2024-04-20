
local dosyatag = ""
local onceliklidosyalar = {
	[dosyatag .. "license"] = true,
    [dosyatag .. "mysql"] = true,
    [dosyatag .. "global"] = true,
	[dosyatag .. "integration"] = true,
	[dosyatag .. "data"] = true,
	[dosyatag .. "pool"] = true,
	[dosyatag .. "bone_attach"] = true,
	[dosyatag .. "logs"] = true,
	[dosyatag .. "vehicle_manager"] = true,
	[dosyatag .. "vehicle_interiors"] = true,
}
local zamanlayaci
local parcalar = {}
local yukleme_hizi = 1000
local yukleme_siniri = 6
local baglanabilir = false

addEventHandler("onResourceStart", resourceRoot,
    function()
        
        for k, v in pairs(onceliklidosyalar) do
            local dosya = getResourceFromName(k)
            if dosya then
                startResource(dosya)
                --outputDebugString(k.. " başlatıldı.", 3)
            end
        end
        
        for k,v in pairs(getResources()) do
            local subText = utfSub(getResourceName(v), 1, #dosyatag)
            if subText == dosyatag and not onceliklidosyalar[getResourceName(v)] and v ~= getThisResource() then 
                parcalar[v] = true
            end
        end
        
        zamanlayaci = setTimer(
            function()
                local durum = 0
                
                for k,v in pairs(parcalar) do
                    durum = durum + 1
                    
                    if durum > yukleme_siniri then
                        break
                    end
                    
                    startResource(k)
                    
                    parcalar[k] = nil
                    
                    --outputDebugString(getResourceName(k).. " başlatıldı.", 0)
                end
                
                local uzunluk = 0
                for k,v in pairs(parcalar) do uzunluk = uzunluk + 1 end
                if uzunluk == 0 then
                    killTimer(zamanlayaci)
                    zamanlayaci = nil
                    baglanabilir = true
                end
            end, yukleme_hizi, 0
        )
    end
)

addEventHandler("onPlayerConnect", root,
    function()
        if not baglanabilir then
            cancelEvent(true,"R-LUA!\n Sunucu kurulum aşamasında, lisans kontrol ediliyor lütfen bekle.")
        end
    end
)


