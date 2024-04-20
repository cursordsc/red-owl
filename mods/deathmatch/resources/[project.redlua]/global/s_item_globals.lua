function hasSpaceForItem( ... )
	return call( getResourceFromName( "items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "items" ), "hasItem", element, itemID, itemValue )
end

function giveItem( element, itemID, itemValue )
	return call( getResourceFromName( "items" ), "giveItem", element, itemID, itemValue, false, true )
end

function takeItem( element, itemID, itemValue )
	return call( getResourceFromName( "items" ), "takeItem", element, itemID, itemValue )
end
