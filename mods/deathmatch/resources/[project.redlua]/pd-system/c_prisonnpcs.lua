local ped = createPed(71, -1040.828125, -624.6923828125, 32.0078125)
setElementInterior(ped, 0)
setElementDimension(ped, 0)
setPedRotation(ped, 90)
--setPedAnimation( ped, "FOOD", "FF_Sit_Look", -1, true, false, false )
setElementData( ped, "talk", 1, false )
setElementData( ped, "name", "Guard", false )
addEventHandler("onClientPedDamage", ped, cancelEvent)
setElementFrozen(ped, true)