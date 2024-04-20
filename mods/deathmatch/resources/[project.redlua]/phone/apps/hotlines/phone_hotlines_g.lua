-- Dizzy

hotlines = {
	[155] = "Polis Departmanı",
	[7331] = "SanTV",
	[112] = "Medical Departmanı",
}

function isNumberAHotline(theNumber)
	local challengeNumber = tonumber(theNumber)
	return hotlines[challengeNumber]
end