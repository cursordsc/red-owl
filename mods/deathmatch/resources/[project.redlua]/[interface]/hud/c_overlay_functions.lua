function sendBottomNotification(thePlayer, title, content, cooldown, widthNew, woffsetNew, hoffsetNew )--Client-side	
	local info = {
		{title or "", 70,200,14,255,1},
		{""},
	}
	if type(content) == "table" then 
		for i = 1, 20 do 
			if not content[i] then break end
			table.insert(info, {" "..content[i][1] or ""} )
		end
	else
		table.insert(info, {" "..content or ""} )
	end
	triggerEvent("hudOverlay:drawOverlayBottomCenter", thePlayer, info , widthNew, woffsetNew, hoffsetNew, cooldown)
end

function sendTopRightNotification(contentArray, thePlayer, widthNew, posXOffset, posYOffset, cooldown) --Client-side
	triggerEvent("hudOverlay:drawOverlayTopRight", thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown)
end

local thePlayer = getLocalPlayer()
local moneyFloat = {}
local maxIconsPerLine = 6
function moneyUpdateFX(state, amount)
	if amount and tonumber(amount) and tonumber(amount) > 0  then
		if state then
			triggerEvent("shop:playCollectMoneySound", thePlayer)
			moneyFloat["mR"] = 20
			moneyFloat["mG"] = 255
			moneyFloat["mB"] = 20
			moneyFloat["mAlpha"] = 255
			moneyFloat["direction"] = 1
			moneyFloat["moneyYOffset"] = 60
			moneyFloat["text"] = "+$"..exports.global:formatMoney(amount)
		else
			triggerEvent("shop:playPayWageSound", thePlayer)
			moneyFloat["mR"] = 255
			moneyFloat["mG"] = 20
			moneyFloat["mB"] = 20
			moneyFloat["mAlpha"] = 255
			moneyFloat["direction"] = -1
			moneyFloat["moneyYOffset"] = 180
			moneyFloat["text"] = "-$"..exports.global:formatMoney(amount)
		end
		local money = getElementData(thePlayer, "money") or 0
		local bankmoney = getElementData(thePlayer, "bankmoney") or 0
		local info = {{"Finansal Durum Değişimi"},{""}}
		table.insert(info, {"   - Taşınan: $"..exports.global:formatMoney(money).." ("..moneyFloat["text"]..")"})
		table.insert(info, {"   - Banka Hesabı: $"..exports.global:formatMoney(bankmoney)})
		triggerEvent("hudOverlay:drawOverlayTopRight", thePlayer, info ) 
		if getElementData(thePlayer, "hide_hud") == "2" then
			setPlayerMoney(money)
		end
	end
end
addEvent("moneyUpdateFX", true)
addEventHandler("moneyUpdateFX", root, moneyUpdateFX)

