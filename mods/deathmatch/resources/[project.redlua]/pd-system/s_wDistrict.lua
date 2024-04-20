addEvent("weaponDistrict:doDistrict", true)

function weaponDistrict_doDistrict(name)
	exports["chat"]:districtIC(client, _, "Çeverede yüksek bir sesle" .. name .. " model silahın mermi sesi duyuldu.")
end

addEventHandler("weaponDistrict:doDistrict", root, weaponDistrict_doDistrict)