
local tasicon =
{
	{ tasicon = { -88.12890625, 1985.4677734375, -12.766128540039  }, sText = "Taş Kazma Bölgesi (/tas kaz)", iColor = tocolor( 255, 255, 255, 255 ), fDistance = 45, fScale = 1.02, sFont = "default-bold" };
	
};

function tas()
	for _, Data in pairs( tasicon ) do
		local fPosX, fPosY, fPosZ		= getElementPosition( localPlayer );
		local fDataX, fDataY, fDataZ 	= unpack( Data.tasicon );
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
addEventHandler( "onClientRender", root, tas );



local komuricon =
{
	{ komuricon = { -96.728515625, 1990.3515625, -12.667381286621  }, sText = "Kömür Kazma Bölgesi (/komur kaz)", iColor = tocolor( 255, 255, 255, 255 ), fDistance = 45, fScale = 1.02, sFont = "default-bold" };
	
};

function komur()
	for _, Data in pairs( komuricon ) do
		local fPosX, fPosY, fPosZ		= getElementPosition( localPlayer );
		local fDataX, fDataY, fDataZ 	= unpack( Data.komuricon );
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
addEventHandler( "onClientRender", root, komur );



local demiricon =
{
	{ demiricon = { -85.5048828125, 1964.8671875, -12.768867492676  }, sText = "Demir Kazma Bölgesi (/demir kaz)", iColor = tocolor( 255, 255, 255, 255 ), fDistance = 45, fScale = 1.02, sFont = "default-bold" };
	
};

function demir()
	for _, Data in pairs( demiricon ) do
		local fPosX, fPosY, fPosZ		= getElementPosition( localPlayer );
		local fDataX, fDataY, fDataZ 	= unpack( Data.demiricon );
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
addEventHandler( "onClientRender", root, demir );



local bakiricon =
{
	{ bakiricon = { -88.15625, 1972.40234375, -12.74259185791  }, sText = "Bakır Kazma Bölgesi (/bakir kaz)", iColor = tocolor( 255, 255, 255, 255 ), fDistance = 45, fScale = 1.02, sFont = "default-bold" };
	
};

function bakir()
	for _, Data in pairs( bakiricon ) do
		local fPosX, fPosY, fPosZ		= getElementPosition( localPlayer );
		local fDataX, fDataY, fDataZ 	= unpack( Data.bakiricon );
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
addEventHandler( "onClientRender", root, bakir );



local altinicon =
{
	{ altinicon = { -93.30859375, 1958.8125, -12.623115539551  }, sText = "Altın Kazma Bölgesi (/altin kaz)", iColor = tocolor( 255, 255, 255, 255 ), fDistance = 45, fScale = 1.02, sFont = "default-bold" };
	
};

function altin()
	for _, Data in pairs( altinicon ) do
		local fPosX, fPosY, fPosZ		= getElementPosition( localPlayer );
		local fDataX, fDataY, fDataZ 	= unpack( Data.altinicon );
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
addEventHandler( "onClientRender", root, altin );