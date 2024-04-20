-- Dizzy / 23.04.2022

function canPlayerAccessStaffManager(player)
	return exports["integration"]:isPlayerTrialAdmin(player) or exports["integration"]:isPlayerSupporter(player) or exports["integration"]:isPlayerVCTMember(player) or exports["integration"]:isPlayerLeadScripter(player) or exports["integration"]:isPlayerMappingTeamLeader(player)
end
	