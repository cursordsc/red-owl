
local yemicon =
{
	{ meslekicon = { 354.9462890625, -2027.5322265625, 7.8359375  }, sText = "/balikyardim", iColor = tocolor( 255, 255, 255, 255 ), fDistance = 45, fScale = 1.02, sFont = "default" };
	
};

function Render()
	for _, Data in pairs( yemicon ) do
		local fPosX, fPosY, fPosZ		= getElementPosition( localPlayer );
		local fDataX, fDataY, fDataZ 	= unpack( Data.meslekicon );
		local fDistanceBetweenPoints	= getDistanceBetweenPoints3D ( fPosX, fPosY, fPosZ,fDataX, fDataY, fDataZ );
		local fInputDistance			= Data.fDistance or 45;
		if fDistanceBetweenPoints < fInputDistance then
			local fCameraX, fCameraY, fCameraZ 	= getCameraMatrix();
			local fWorldPosX, fWorldPosY 		= getScreenFromWorldPosition( fDataX, fDataY, fDataZ + 1, fInputDistance );
			local bHit  						= processLineOfSight( fCameraX, fCameraY, fCameraZ, fDataX, fDataY, fDataZ, true, false, false, true, false, false, false, false );
			if not bHit then
				if fWorldPosX and fWorldPosY then
					dxDrawText( 
						Data.sText,
						fWorldPosX,
						fWorldPosY,
						fWorldPosX,
						fWorldPosY,
						Data.iColor,
						Data.fScale,
						Data.sFont
					);
				end	
			end	
		end
	end
end
addEventHandler( "onClientRender", root, Render );