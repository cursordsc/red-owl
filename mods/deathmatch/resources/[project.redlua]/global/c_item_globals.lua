function hasSpaceForItem( ... )
	return call( getResourceFromName( "items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "items" ), "hasItem", element, itemID, itemValue )
end

function getItemName( itemID )
	return call( getResourceFromName( "items" ), "getItemName", itemID )
end
