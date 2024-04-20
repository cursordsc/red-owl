local customBlockName = "WEAPC"

local IFP = engineLoadIFP( "custom/weapc.ifp", customBlockName )

function weaponSwitchAnimation()
	setPedAnimation(getLocalPlayer(), "WEAPC", "switch", 1000, false, false, false)
	setTimer(function()
	setPedAnimation(getLocalPlayer())
	end, 1000, 1)
end
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, weaponSwitchAnimation)
