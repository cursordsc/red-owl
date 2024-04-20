
addCommandHandler("sethunger", function(oyuncu, komut, target, aclik)
	if target and aclik then
		if exports["integration"]:isPlayerTrialAdmin(oyuncu) or exports["integration"]:isPlayerSupporter(oyuncu) then
			if not (tonumber(aclik) > 100) and tonumber(aclik) then
				if not target or not aclik then
					oyuncu:outputChat("BİLGİ: /"..komut.." [İsim/ID] [Açlık]", 255, 194, 14)
				else
					local targetPlayer, targetName = exports["global"]:findPlayerByPartialNick(oyuncu, target)
					if not targetPlayer then
					elseif targetPlayer:getData("loggedin") ~= 1 then
						targetPlayer:outputChat("Oyuncu henüz giriş yapmadı.", 255, 0, 0)
					else
						targetPlayer:setData("hunger", tonumber(aclik))
						exports["infobox"]:addBox(oyuncu, "success", "Başarıyla "..targetName.." isimli oyuncunun açlığını %"..aclik.." olarak değiştirdin!")
						exports["infobox"]:addBox(targetPlayer, "info", "Açlık seviyeniz "..oyuncu:getData("account:username").." isimli yetkili tarafından %"..aclik.." olarak değiştirildi!")
					end
				end
			else
				exports["infobox"]:addBox(oyuncu, "error", "Bir sayı değeri veya 100'den aşağı değer girmelisiniz.")
			end
		end
	else
		exports["infobox"]:addBox(oyuncu, "error", "(/sethunger [ID/Isim] [Açlık])")
	end
end)

addCommandHandler("setthirst", function(oyuncu, komut, target, susuzluk)
	if target and susuzluk then
		if exports["integration"]:isPlayerTrialAdmin(oyuncu) or exports["integration"]:isPlayerSupporter(oyuncu) then
			if tonumber(susuzluk) and not (tonumber(susuzluk) > 100) then
				if not target or not susuzluk then
					oyuncu:outputChat("BİLGİ: /"..komut.." [İsim/ID] [Susuzluk]", 255, 194, 14)
				else
					local targetPlayer, targetName = exports["global"]:findPlayerByPartialNick(oyuncu, target)
					if not targetPlayer then
					elseif targetPlayer:getData("loggedin") ~= 1 then
						targetPlayer:outputChat("Oyuncu henüz giriş yapmadı.", 255, 0, 0)
					else
						targetPlayer:setData("thirst", tonumber(susuzluk))
						exports["infobox"]:addBox(oyuncu, "success", "Başarıyla "..targetName.." isimli oyuncunun susuzluğunu %"..susuzluk.." olarak değiştirdin!")
						exports["infobox"]:addBox(targetPlayer, "info", "Susuzluk seviyeniz "..oyuncu:getData("account:username").." isimli yetkili tarafından %"..susuzluk.." olarak değiştirildi!")
					end
				end
			else
				exports["infobox"]:addBox(oyuncu, "error", "Bir sayı değeri veya 100'den aşağı değer girmelisiniz.")
			end
		end
	else
		exports["infobox"]:addBox(oyuncu, "error", "(/sethunger [ID/Isim] [Açlık])")
	end
end)

function aclikEmote()
	exports["global"]:sendLocalDoAction(source, "Midesinden gelen bir gurultama duyulabilir...")
end
addEvent("aclik:emote", true)
addEventHandler("aclik:emote", getRootElement(), aclikEmote)