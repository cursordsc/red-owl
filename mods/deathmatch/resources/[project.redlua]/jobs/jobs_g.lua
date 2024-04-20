function getJobTitleFromID(jobID)
	if (tonumber(jobID)==1) then
		return "Kargo Şöförü"
	elseif (tonumber(jobID)==2) then
		return "Taksi Şöförü"
	elseif  (tonumber(jobID)==3) then
		return "Dolmuş Şoförü"
	elseif (tonumber(jobID)==4) then
		return "Çöp Şöförü"
	elseif (tonumber(jobID)==5) then
		return "Tamirci"
	elseif (tonumber(jobID)==6) then
		return "Pizza Şöförü"
	elseif (tonumber(jobID)==7) then
		return "Kanalizasyon Görevlisi"
	elseif (tonumber(jobID)==8) then
		return "Yemek Dağıtımcısı"
	elseif (tonumber(jobID)==9) then
		return "Çekici"
	elseif (tonumber(jobID)==10) then
		return "Sigara Kaçakcısı"
	elseif (tonumber(jobID)==11) then
		return "Oto Kurtarma"
	elseif (tonumber(jobID)==12) then
		return "Otobüs Şöförü"
	elseif (tonumber(jobID)==13) then
		return "Oduncu"
	else
		return "İşsiz"
	end
end