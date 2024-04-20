wPedrightclick = nil
bTalkToPed, bClosePedMenu = nil
ax, ay = nil
closing = nil
sent=false

function pedDamage()
	cancelEvent()
end
addEventHandler("onClientPedDamage", getRootElement(), pedDamage)

function konus (element)
	local ped = getElementData(element, "name")
			local isFuelped = getElementData(element,"ped:fuelped")
			local isTollped = getElementData(element,"ped:tollped")
			local isShopKeeper = getElementData(element,"shopkeeper") or false

			if (ped=="Steven Pullman") then
				triggerServerEvent( "startStevieConvo", getLocalPlayer())
				if (getElementData(element, "activeConvo")~=1) then
					triggerEvent ( "stevieIntroEvent", getLocalPlayer())
				end
			elseif (ped=="Hunter") then
				triggerServerEvent( "startHunterConvo", getLocalPlayer())
			elseif (ped=="Rook") then
				triggerServerEvent( "startRookConvo", getLocalPlayer())
			elseif (ped=="Chris Frosthorne") then
		        triggerEvent('carshop.display', getLocalPlayer())
			elseif (ped=="Julie Dupont") then
				triggerServerEvent( "clothing:list", getLocalPlayer())
			elseif (ped=="Victoria Greene") then
				triggerEvent("cPhotoOption", getLocalPlayer(), ax, ay)
			elseif (ped=="Jessie Smith") then
				--triggerEvent("onEmployment", getLocalPlayer())
				triggerEvent("cityhall:jesped", getLocalPlayer())
			elseif (ped=="Zehra Yildiz") then
				triggerEvent("onLicense", getLocalPlayer())
			elseif (ped=="Peter France") then
				triggerEvent("taxi > gui", getLocalPlayer())
			elseif (ped=="Ayça Korkmaz") then
				triggerEvent("skinshop.render", getLocalPlayer())
			elseif (ped=="Zeki Durmus") then
				triggerEvent("showRecoverLicenseWindow", getLocalPlayer())
			elseif (ped=="Diyar Birden") then
				triggerEvent("truck1:displayJob", getLocalPlayer())							
			elseif (ped=="Berkcan Soylu") then
				triggerServerEvent("electionWantVote", getLocalPlayer())
			elseif (ped=="Melih Alemdar") then
				triggerEvent("reklam:ver", getLocalPlayer())
			elseif (ped=="Greer Reid") then
				triggerServerEvent("onTowMisterTalk", getLocalPlayer())
			elseif (ped=="Melih Alemdar") then
				triggerEvent("reklam:ver", getLocalPlayer())
			elseif (ped=="Aaron Thompson") then
				triggerServerEvent("openMarriageMenu", getLocalPlayer())
			elseif (ped=="Nihat Durak") then
				triggerServerEvent("gosterotopark", getLocalPlayer())
			elseif (ped=="Umit Katar") then
				triggerEvent("kasap:panel", getLocalPlayer())
			elseif (ped == "Erdal Celebi") then
				triggerEvent("Cilingir:PanelAc", getLocalPlayer())
			elseif (ped=="Cemal Toprak") then
				triggerEvent("kazikazan:panel", getLocalPlayer())							
			elseif (ped=="Guard Jenkins") then
				triggerServerEvent("gateCityHall", getLocalPlayer())
			elseif (ped=="Airman Connor") then
				triggerServerEvent("gateAngBase", getLocalPlayer())
			elseif (ped=="Rosie Jenkins") then
				triggerEvent("lses:popupPedMenu", getLocalPlayer())
			elseif (ped=="Atilla Ciftci") then
				triggerEvent("stone:displayJob", getLocalPlayer(), getLocalPlayer())							
			elseif (ped=="Gabrielle McCoy") then
				triggerEvent("cBeginPlate", getLocalPlayer())
			elseif (isFuelped == true) then
				triggerServerEvent("fuel:startConvo", element)
			elseif (isTollped == true) then
				triggerServerEvent("toll:startConvo", element)
			elseif (ped=="Novella Iadanza") then
				triggerServerEvent("onSpeedyTowMisterTalk", getLocalPlayer())
			elseif (ped=="Ahmet Basboguk") then
				triggerEvent("ceza:npc", getLocalPlayer())
			elseif isShopKeeper then -- MAXIME
				triggerServerEvent("shop:keeper", element)
			elseif (ped=="Mehmet Yuksel") then --Banker ATM Service, MAXIME
				triggerEvent("bank-system:bankerInteraction", getLocalPlayer())
			elseif (ped=="Ahmet Demirtas") then --Banker General Service, MAXIME
				triggerServerEvent( "bank:showGeneralServiceGUI", getLocalPlayer(), getLocalPlayer())
			elseif getElementData(element,"carshop") then
				triggerServerEvent( "vehlib:sendLibraryToClient", localPlayer, element)
			elseif (ped=="Asya Kasikci") then
				triggerServerEvent('clothing:list', getResourceRootElement (getResourceFromName("mabako")))
			elseif (ped=="Evelyn Branson") then
				triggerEvent("airport:ped:receptionistFAA", localPlayer, element)
			elseif (ped=="Albert Henry") then
				triggerEvent("AracSatma:PanelAc", getLocalPlayer())							
			elseif (ped=="John G. Fox") then
				triggerServerEvent("startPrisonGUI", root, localPlayer)
			elseif (ped=="Georgio Dupont") then
				   triggerEvent("locksmithGUI", localPlayer, localPlayer)
			   elseif (ped=="Corey Byrd") then
				triggerEvent('ha:treatment', getLocalPlayer())
			elseif (ped=="Justin Borunda") then --PD impounder / Maxime 
				triggerServerEvent("tow:openImpGui", localPlayer, ped)
			elseif (ped=="Sergeant K. Johnson") then --PD release / Maxime
				triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
			elseif (ped=="Bobby Jones") then --HP impounder / Maxime 
				triggerServerEvent("tow:openImpGui", localPlayer, ped)
			elseif (ped=="Robert Dunston") then --HP release / Maxime
				triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
			elseif (ped=="Yasin Cinar") then
				triggerEvent("alkol:displayJob", getLocalPlayer(), getLocalPlayer())
			elseif (ped=="Buğra Can") then
				triggerEvent("cekici:meslek", getLocalPlayer(), getLocalPlayer())						
			elseif (ped=="Mike Johnson") then
				triggerEvent("kiralamaGoster", getLocalPlayer())
			elseif (ped=="Onur Demir") then
				triggerEvent("cigar:displayJob", getLocalPlayer(), getLocalPlayer())
			elseif (ped=="Joffrey Yount") then
				triggerEvent("ickiGUI", getLocalPlayer(), getLocalPlayer())
			elseif (ped=="Derya Yılmaz") then
				triggerEvent("reklamGUI", getLocalPlayer())
			elseif (ped=="Emrah Kara") then
				triggerEvent("reklamlarTablo", getLocalPlayer())
			elseif (ped=="Pete Robinson") then
				triggerServerEvent("vergi:sVergiGUI", getLocalPlayer())
			elseif (ped=="Johan_Layer") then  
				triggerEvent("market:panel", getLocalPlayer())							
			elseif (ped=="Antonio Worley") then
				triggerServerEvent("modifiye:pedStartConvo", getLocalPlayer())
			elseif (ped=="Bugra Atasoy") then
				triggerEvent("cop:meslek", getLocalPlayer(), getLocalPlayer())
			elseif (ped=="Samet Kalender") then
				triggerEvent("pizza:meslek", getLocalPlayer(), getLocalPlayer())
			elseif (ped=="Hakan Ertürk") then
				triggerEvent("yemek:meslek", getLocalPlayer(), getLocalPlayer())
			elseif (ped=="Memati Öz") then
				triggerEvent("kanalizasyon:meslek", getLocalPlayer(), getLocalPlayer())	
			elseif (ped=="Hasan Korkmaz") then
				triggerEvent("kargo:meslek", getLocalPlayer(), getLocalPlayer())	
			elseif (ped=="Yavuz Cantürk") then
				triggerEvent("oduncu:meslek", getLocalPlayer(), getLocalPlayer())	
			elseif (ped=="Cem Kayahan") then
				triggerEvent("sigaraGUI", getLocalPlayer())							
			elseif (ped=="Serdar Kara") then
				triggerEvent("bus:displayJob", getLocalPlayer())	
			elseif (ped=="Ahmet_Akkuzu") then 
				triggerEvent("dovizz:panel", getLocalPlayer())							
			elseif (ped=="Kerem Kasikci") then
				triggerEvent("taxi:displayJob", getLocalPlayer())
			elseif (ped=="Abdullah Kara") then
				triggerEvent("dolmus:displayJob", getLocalPlayer())
			elseif (ped=="Idris Arslan") then
				triggerEvent("multeci:drawJobGUI", getLocalPlayer())
			elseif (ped=="Hakan Bolunmez") then
				triggerEvent("meslek:otokurtarmaGUI", getLocalPlayer())
			elseif (ped=="Cantug Kaya") then
				triggerEvent("meslek:otobusGUI", getLocalPlayer())
			elseif (ped=="Ismail Gulen") then
				triggerEvent("meslek:kargoGUI", getLocalPlayer())
			elseif (ped=="Emir Aslankurt") then
				triggerEvent("meslek:copGUI", getLocalPlayer())						
			elseif (ped=="Aaron Thompson") then
				triggerServerEvent("papazAmca", getLocalPlayer())
			elseif (ped=="Ahmet Bascavus") then
				triggerEvent("otopark:panel", getLocalPlayer())
			elseif (ped=="Orospu Selen") then
				triggerServerEvent( "odrin:escort", getLocalPlayer())
			end

end
addEvent("npc:konus",true)
addEventHandler("npc:konus",root,konus)

function hidePedMenu()
	if (isElement(bTalkToPed)) then
		destroyElement(bTalkToPed)
	end
	bTalkToPed = nil

	if (isElement(bClosePedMenu)) then
		destroyElement(bClosePedMenu)
	end
	bClosePedMenu = nil

	if (isElement(wPedrightclick)) then
		destroyElement(wPedrightclick)
	end
	wPedrightclick = nil

	ax = nil
	ay = nil
	sent=false
	showCursor(false)

end
