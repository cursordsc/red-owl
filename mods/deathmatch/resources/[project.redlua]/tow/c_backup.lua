local backupBlip = nil
addEvent("createBackupBlip3", true)
addEvent("destroyBackupBlip3", true)
addEventHandler("createBackupBlip3", getRootElement(), function ()
	if (backupBlip) then
		destroyElement(backupBlip)
		backupBlip = nil
	end
end)
addEventHandler("destroyBackupBlip3", getRootElement(), function ()
	if (backupBlip) then
		destroyElement(backupBlip)
		backupBlip = nil
	end
end)