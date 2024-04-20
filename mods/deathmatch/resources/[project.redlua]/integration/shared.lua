--Dizzy
mysql = exports["mysql"]
TESTER = 25
SCRIPTER = 32
LEADSCRIPTER = 79
COMMUNITYLEADER = 14
TRIALADMIN = 18
ADMIN = 17
SENIORADMIN = 64
LEADADMIN = 15
SUPPORTER = 30
VEHICLE_CONSULTATION_TEAM_LEADER = 39
VEHICLE_CONSULTATION_TEAM_MEMBER = 43
MAPPING_TEAM_LEADER = 44
MAPPING_TEAM_MEMBER = 28
STAFF_MEMBER = {32, 14, 18, 17, 64, 15, 30, 39, 43, 44, 28}
AUXILIARY_GROUPS = {32, 39, 43, 44, 28}
ADMIN_GROUPS = {14, 18, 17, 64, 15}

staffTitles = {
	[1] = {
		[0] = "Oyuncu",
		[1] = "Stajyer Yetkili",
		[2] = "Oyun İçi Yetkili I",
		[3] = "Oyun İçi Yetkili II",
		[4] = "Oyun İçi Yetkili III",
		[5] = "Genel Yetkili",  --Yetkili Kısmı
		[6] = "3rd Party Developer",
		[7] = "Developer",
		[8] = "Co Founder",
		[9] = "Founder",
	}, 
	[2] = {
		[0] = "Oyuncu",
		[1] = "Rehber",             --Rehber Kısmı
		[2] = "Rehber Yöneticisi",
	}, 
	[3] = {
		[0] = "Oyuncu",
		[1] = "AYE Üyesi",          --Araç Ekibi Kısmı
		[2] = "AYE Lideri",
	}, 
	[4] = {
		[0] = "Oyuncu",
		[1] = "Test Geliştiricisi",
		[2] = "Deneme Geliştirici", --Geliştirici Ekibi Kısmı
		[3] = "Geliştirici",
	}, 
	[5] = {
		[0] = "Oyuncu",
		[1] = "Mapper",             --Mapper Ekibi Kısmı
		[2] = "Mapper Yönetisici",
	}, 
}


function getStaffTitle(teamID, rankID)
	local staffTitles = getStaffTitles()
	return staffTitles[tonumber(teamID)][tonumber(rankID)]
end

function getStaffTitles()
	return staffTitles
end


function isPlayerEGO(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 9)
end

function isPlayerTPK(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 8)
end

function isPlayerARGE(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 7)
end

-- Dizzy
function isPlayerHeadAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 6)
end

-- Dizzy
function isPlayerSeniorAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 4)
end

--MAXIME
function isPlayerLeadAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 5)
end

function isPlayerAdminIII(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 4)
end

function isPlayerAdminII(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 3)
end

function isPlayerAdminI(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 2)
end

function isPlayerAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 2)
end

function isPlayerTrialAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 1)
end

function isPlayerSupporter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 1)
end

function isPlayerSupportManager(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 2)
end

function isPlayerTester(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 1)
end

function isPlayerScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 2)
end

function isPlayerLeadScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 3)
end

--LEADER
function isPlayerVehicleConsultant(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 2)
end

--MEMBERS
function isPlayerVCTMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 1)
end

--LEADER
function isPlayerMappingTeamLeader(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 2)
end

--MEMBERS
function isPlayerMappingTeamMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 1)
end

function isPlayerStaff(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return 	isPlayerTrialAdmin(player)
	or		isPlayerSupporter(player)
	or 		isPlayerScripter(player)
	or 		isPlayerVCTMember(player)
	or 		isPlayerMappingTeamMember(player)
end

function getAdminGroups() -- this is used in c_adminstats to correspond levels to forum usergroups
	return { SUPPORTER, TRIALADMIN, ADMIN, SENIORADMIN, LEADADMIN }
end

-- internal affairs
function isPlayerIA( player )
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return false
	--return tonumber( getElementData( player, "account:id" ) ) == 211
end

adminTitles = {
    [1] = "Stajyer Yetkili",
    [2] = "Oyun İçi Yetkili I",
    [3] = "Oyun İçi Yetkili II",
    [4] = "Oyun İçi Yetkili III",
    [5] = "Genel Yetkili",
    [6] = "3rd Party Developer",
    [7] = "Developer",
    [8] = "Co Founder",
    [9] = "Founder",
}

function getAdminTitles()
	return adminTitles
end

function getSupporterNumber()
	return SUPPORTER
end

function getAuxiliaryStaffNumbers()
	return table.concat(AUXILIARY_GROUPS, ",")
end

function getAdminStaffNumbers()
	return table.concat(ADMIN_GROUPS, ",")
end
