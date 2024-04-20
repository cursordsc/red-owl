function tryLuck(oyuncu, komut , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 == nil and pa2 == nil and pa3 == nil then
		exports["global"]:sendLocalText(oyuncu, "((OOC Şans)) "..oyuncu:getName():gsub("_", " ").." isimli kişi 1 ile 100 arasında şansını dener ve "..math.random(100).." rakamı gelir.", 255, 51, 102, 30, {}, true)
	elseif pa1 ~= nil and p1 ~= nil and pa2 == nil then
		exports["global"]:sendLocalText(oyuncu, "((OOC Şans)) "..oyuncu:getName():gsub("_", " ").." isimli kişi 1 ile "..p1.." arasında şansını dener ve "..math.random(p1).." rakamı gelir.", 255, 51, 102, 30, {}, true)
	else
		oyuncu:outputChat("SYNTAX: /" .. komut.."                  - 1 ile 100 arasında sayı çek", 255, 194, 14)
		oyuncu:outputChat("SYNTAX: /" .. komut.." [maksimum]         - 1 ile [maksimum] arasında sayı çek", 255, 194, 14)
	end
end
addCommandHandler("sans", tryLuck)

addCommandHandler("chance", function(oyuncu, komut, sans)
	sans = tonumber(sans)
	if oyuncu:getData("loggedin") == 1 then
    	if sans then 
    	    if sans <= 100 and sans >=0 then
    	        if math.random(100) >= sans then
					exports["global"]:sendLocalText(oyuncu, "((OOC Şans - %"..sans..")) "..oyuncu:getName():gsub("_", " ").." isimli kişinin denemesi başarısız oldu.", 255, 51, 102, 30, {}, true)
    			else
					exports["global"]:sendLocalText(oyuncu, "((OOC Şans - %"..sans..")) "..oyuncu:getName():gsub("_", " ").." isimli kişinin denemesi başarılı oldu.", 255, 51, 102, 30, {}, true)
    	        end
    		else
    			oyuncu:outputChat("İhtimaller 0 ile 100 arasında olmalıdır!", 255, 0, 0, true)
    		end
    	else
    		oyuncu:outputChat("KULLANIM: /"..komut.." [0-100%]", 255, 194, 14)
    	end
	end
end)


function yaziTura(oyuncu)
	if oyuncu:getData("loggedin") == 1 then
		if  math.random( 1, 2 ) == 2 then
			exports["global"]:sendLocalText(oyuncu, "((OOC Yazı Tura)) " .. oyuncu:getName():gsub("_", " ") .. " bir madeni para fırlatır, para yazıdır.", 255, 51, 102)
		else
			exports["global"]:sendLocalText(oyuncu, "((OOC Yazı Tura)) " .. oyuncu:getName():gsub("_", " ") .. " bir madeni para fırlatır, para turadır.", 255, 51, 102)
		end
	end
end
addCommandHandler("flipcoin", yaziTura)
addCommandHandler("yazitura", yaziTura)