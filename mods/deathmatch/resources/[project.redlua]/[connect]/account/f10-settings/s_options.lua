function KarakterDegistirme(source)
	local KarakterDegistirmeDurumu = getElementData(source, "degisdurum", true)
	local isim = getPlayerName(source)

	if KarakterDegistirmeDurumu then 
		exports["global"]:sendLocalText(source, isim.." adlı oyuncu karakter değiştirme ekranına gitti! (kendi isteğiyle)", 255, 255, 255, 10)
	end	

end	