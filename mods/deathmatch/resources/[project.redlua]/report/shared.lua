--[[ //Chaos
~=~=~=~=~=~= ORGANIZED REPORTS FOR OWL INFO =~=~=~=~=~=~
Name: The name to show once the report is submitted and in the F2 menu
Staff to send to: The Usergroup ID on the forums that you are sending the report to
Abbreviation: Used in the report identifier for the staff
r, g, b: The color for the report

I used the strings as the values instead of the keys, this way its easier for us to organize. 
{NAME, { Staff to send to }, Abbreviation, r, g, b} ]]

reportTypes = {
 	{"Başka bir oyuncuyla sorun yaşama", {18, 17, 64, 15, 14}, "OYUNCU", 214, 6, 6, "Eğer bir oyuncu ile sorun yaşarsanız bunu kullanın." },
	{"Interior Sorunları", {18, 17, 64, 15, 14}, "", 255, 126, 0, "Interior ile sorununuz varsa bunu kullanın." },
	--{"Interior Sorunları", {18, 17, 64, 15, 14}, "INTERIOR", 255, 126, 0, "Interior ile sorununuz varsa bunu kullanın." },
	{"Item Sorunları", {18, 17, 64, 15, 14}, "ITEM", 255, 126, 0, "Itemler ile ilgili sorununuz varsa bunu kullanın." },
	{"Genel Soru", {30, 18, 17, 64, 15, 14}, "YETKİLİ", 70, 200, 30, "Her türlü sorunuzu buradan sorabilirsiniz." },
	{"RolePlay Hakkında Soru", {30, 18, 17, 64, 15, 14}, "REHBER", 70, 200, 30, "Roleplay ile ilgili her türlü sorunuzu buradan sorabilirsiniz." },
	{"Araç Hakkında Sorunlar", {30, 18, 17, 64, 15, 14}, "ARAÇ", 255, 126, 0, "Aracınızla ilgili sorununuz varsa burayı kullanın." },
	{"Donate/Premium Özellikler", {39, 43}, "DONATE", 176, 7, 237, "VCT'ye ulaşmak için bunu kullanın." },
	{"Script Sorunları", {32}, "SİSTEM", 148, 126, 12, "Scripting takımına ulaşmak için burayı kullanın." },
}
adminTeams = exports["integration"]:getAdminStaffNumbers()
auxiliaryTeams = exports["integration"]:getAuxiliaryStaffNumbers()
SUPPORTER = exports["integration"]:getSupporterNumber()

function getReportInfo(row, element)
	if not isElement(element) then
		element = nil
	end

	local staff = reportTypes[row][2]
	local players = getElementsByType("player")
	local vcount = 0
	local scount = 0


	for k,v in ipairs(staff) do
		if v == 39 or v == 43 then

			for key, player in ipairs(players) do
				if exports["integration"]:isPlayerVCTMember(player) or exports["integration"]:isPlayerVehicleConsultant(player) then
					vcount = vcount + 1
					save = player
				end
			end

			if vcount==0 then
				return false, "There is currently no VCT Members online. Contact them here: http://forums.owlgaming.net/forms.php?do=form&fid=42"
			elseif vcount==1 and save == element then -- Callback for checking if a aux staff logs out
				return false, "There is currently no VCT Members online. Contact them here: http://forums.owlgaming.net/forms.php?do=form&fid=42"
			end
		elseif v == 32 then

			for key, player in ipairs(players) do
				if exports["integration"]:isPlayerScripter(player) then
					scount = scount + 1
					save = player
				end
			end

			if scount==0 then
				return false, "There is currently no members of the Scripting team online. Use Support Center at www.owlgaming.net/support.php"
			elseif scount==1 and save == element then -- Callback for checking if a aux staff logs out
				return false, "There is currently no members of the Scripting team online. Use Support Center at www.owlgaming.net/support.php"
			end
		end
	end

	local name = reportTypes[row][1]
	local abrv = reportTypes[row][3]
	local red = reportTypes[row][4]
	local green = reportTypes[row][5]
	local blue = reportTypes[row][6]

	return staff, false, name, abrv, red, green, blue
end

function isSupporterReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if v == SUPPORTER then
			return true
		end
	end
	return false
end

function isAdminReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(adminTeams, v) then
			return true
		end
	end
	return false
end

function isAuxiliaryReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(auxiliaryTeams, v) then
			return true
		end
	end
	return false
end

function showExternalReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3")
end

function showTopRightReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports["integration"]:isPlayerTrialAdmin(thePlayer) or exports["integration"]:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "1" or getElementData(thePlayer, "report_panel_mod") == "3")
end