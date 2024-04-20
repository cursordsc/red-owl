Interaction.Interactions = {}

function addInteraction(type, model, name, image, executeFunction)
	if not Interaction.Interactions[type][model] then
		Interaction.Interactions[type][model] = {} 
	end
 
	table.insert(Interaction.Interactions[type][model], {name, image, executeFunction})
end

addEventHandler("onClientResourceStart", resourceRoot, function()

end)

addCommandHandler("iptal",
function()
	if getElementData(localPlayer, "degisdurum") then
		setElementData(localPlayer, "degisdurum", nil)
		outputChatBox("#575757"..exports["pool"]:getServerName()..":#f9f9f9 Başarıyla işlemin iptal edildi.", 0, 255, 0, true)
	else
		outputChatBox("#575757"..exports["pool"]:getServerName()..":#f9f9f9 Şu anda her hangi bir istekte bulunmamışsın.", 255, 0, 0, true)	
	end
end)

function getInteractions(element, durum)
	local interactions = {}
	local type = getElementType(element)
	local model = getElementModel(element)
		
	
	if durum == "home" then
		if getElementData(localPlayer, "loggedin") ~= 1 then return end					
		table.insert(interactions, {"Karakter Değiştir", "icons/tagok.png",
			function (player, target)
				if getElementData(localPlayer, "loggedin") ~= 1 then outputChatBox("#575757"..exports["pool"]:getServerName()..":#f9f9f9 Giriş yapmadan karakterini değiştiremezsin.", 255, 0, 0, true) return end
				if getElementData(localPlayer, "dead") == 1 or getElementData(localPlayer, "isleme:durum") or getElementData(localPlayer, "kazma:durum") or getElementData(localPlayer, "tutun:durum") then 
					outputChatBox("#575757"..exports["pool"]:getServerName()..":#f9f9f9 Bu durumdayken F10 Karakter Değiştir butonunu kullanamazsın.", 255, 14, 14 ,true) 
				return end
				if getElementData(localPlayer,"degisdurum") then 
					outputChatBox("[-]#f9f9f9 Şu anda zaten karakter değiştirme işlemini gerçekleştiriyorsun.", 255,0,0,true) 
				return end 
				
				
				triggerServerEvent("karakterDegistirmeStart", localPlayer)
				exports["infobox"]:addBox("info", "20 saniye sonra karakter değiştirme ekranına gideceksin. İptal etmek için: /iptal")
				setElementData(localPlayer, "degisdurum", true)

				setTimer(function()
					if getElementData(localPlayer, "degisdurum") then
						triggerServerEvent("karakterDegistirme", localPlayer)
						setElementData(localPlayer, "degisdurum", nil)
						exports["account"]:options_logOut(localPlayer)
					else
						outputChatBox("#575757"..exports["pool"]:getServerName()..":#f9f9f9 Karakter değiştirme işlemini iptal ettiğinden dolayı işlemin gerçekleştirilmedi.", 255, 0, 0, true)
					end
				end, 20000, 1)
			end })
			

		table.insert(interactions, {"OOC Market", "icons/tl.png",
			function (player, target)
				executeCommandHandler("market")
			end })	

		if exports.integration:isPlayerTrialAdmin(localPlayer) then 
		
		table.insert(interactions, {"Yetkili Arayüzü", "icons/tagok.png",
			function (player, target)
				executeCommandHandler("staffs")
			end })		

		table.insert(interactions, {"Araç Kütüphanesi", "icons/lock.png",
			function (player, target)
				triggerServerEvent("vehlib:sendLibraryToClient", localPlayer)
			end })	
						
				
		end
			
		table.insert(interactions, {"Grafik Ayarları", "icons/leader.png",
			function (player, target)
				triggerEvent(""..exports["pool"]:getServerName()..":graphics", localPlayer, localPlayer)
			end })
		
	return interactions end
		if type == "ped" then
		table.insert(interactions, {"Konuş", "icons/detector.png",
			function (player, target)
				triggerEvent("npc:konus",localPlayer,element)
			end
			
			
		})
	
		elseif type == "player" then
		
		table.insert(interactions, {"Karakter Bilgileri", "icons/eyemask.png",
			function (player, target)
				exports["social"]:showPlayerInfo(target)
			end
		})		

		if exports["social"]:isFriendOf(getElementData(element, "account:id")) then
			table.insert(interactions, {"Arkadaşlıktan Çıkar", "icons/delete.png",
				function (player, target)
					exports["social"]:cremoveFriend(target)
				end
			})
		else
			table.insert(interactions, {"Arkadaş Ekle", "icons/add.png",
				function (player, target)
					exports["social"]:caddFriend(target)
				end
			})
		end
		
		table.insert(interactions, {"Üst Ara", "icons/glass.png",
			function (player, target)
				exports["social"]:cfriskPlayer(target)
			end
		})




		if getElementData(element, "restrain") == 0 then
			table.insert(interactions, {"Kelepçele", "icons/cuff.png",
				function (player, target)
					exports["social"]:crestrainPlayer(target)
				end
			})
		else
			table.insert(interactions, {"Kelepçeyi Çıkar", "icons/uncuff.png",
				function (player, target)
					exports["social"]:cunrestrainPlayer(target)
				end
			})
		end	
	
		table.insert(interactions, {"Araç Envanteri", "icons/trunk.png",
			function (player, target)
				--triggerServerEvent( "openFreakinInventory", player, element, 500, 500 )
				exports["vehicle"]:requestInventory(target)
			end
		})

       elseif type == "vehicle" then
		if getElementData(element, "carshop") then
			table.insert(interactions, {"Satın Al ($"..exports["global"]:formatMoney(getElementData(element,"carshop:cost"))..")","icons/trunk.png",
			function (player, target)
				triggerServerEvent("carshop:buyCar", element, "cash")
			end
		})
		else
		local faction = getElementData(localPlayer, "faction")
		if faction == 1 then
		table.insert(interactions, {"Ceza Kes", "icons/ceza.png",
			function (player, target)
				exports["ceza"]:panel(element)
				
			end
		})
		end

		table.insert(interactions, {"Kapı Kontrolü", "icons/trunk.png",
			function (player, target)
				exports["vehicle"]:fDoorControl(target)	
			end
		})
		
		table.insert(interactions, {"Araç Envanteri", "icons/wheelclamp.png",
			function (player, target)
				triggerServerEvent( "openFreakinInventory", player, element, 500, 500 )
			end
		})

		--[[if isVehicleLocked(element) then
			table.insert(interactions, {"Kapıları Aç", "icons/unlock.png",
				function (player, target)
					setVehicleLocked(element, false)
				end
			})
		else
			table.insert(interactions, {"Kapıları Kilitle", "icons/lock.png",
				function (player, target)
					setVehicleLocked(element, true)
				end
			})
		end]]

		if getElementData(localPlayer, "job") == 5 then
		table.insert(interactions, {"Modifiye et", "icons/icon.png",
				function (player, target)
						triggerEvent("openMechanicFixWindow", localPlayer, element)
				end})
			end
		end

		if exports["integration"]:isPlayerLeadAdmin(localPlayer)  then
		table.insert(interactions, {"ADM: Kaplama", "icons/icon.png",
				function (player, target)
						triggerEvent("item-texture:vehtex", player, element)
				end
			})
		end

		if getElementData(localPlayer, "duty_admin") == 1 then
		table.insert(interactions, {"ADM: Yenile", "icons/icon.png",
				function (player, target)
						triggerServerEvent("vehicle-manager:respawn", player, element)
				end
			})
		end
	elseif type == "object" then
		if getElementData(element, "tohum:obje") then
			if (getElementData(element, "tohum:gram") or 0) <= 0 then
			table.insert(interactions, {"Şuanda Hasat Edilemez", "icons/weed_red.png",
				function (player, target)
						Interaction.Close()
				end
			})
			else
			table.insert(interactions, {"Hasat Et", "icons/weed.png",
				function (player, target)
						triggerServerEvent("tohum:hasat", player, element)
				end
			})
			end
		end
		if getElementData(element, "uyusturucu:obje") then
			local tempActions4 = exports["uyusturucu"]:getCurrentInteractionList(model)

			for k,v in pairs(tempActions4) do
				table.insert(interactions, v)
			end

			tempActions4 = nil
		end
	end
		
			
	-- // Araç Bitiş // --
	table.insert(interactions, {"Kapat", "icons/cross_x.png",
		function ()
			Interaction.Close()
		end
	})
	return interactions
end


function isFriendOf( accountID )
	for _, data in ipairs( {online, offline} ) do
		for k, v in ipairs( data ) do
			if v.accountID == accountID then
				return true
			end
		end
	end
	return false
end