author = 'github.com/bekiroj'
dxDrawImage = dxDrawImage
sX, sY = guiGetScreenSize()

function renderCursor()
 if isCursorShowing() then
  local cX, cY = getCursorPosition()
  cX, cY = cX * sX, cY * sY
    if isChatBoxInputActive(  ) and not isCursorShowing( ) then
        dxDrawImage(cX, cY, 20, 20, 'components/cursor.png', 0, 0, 0, tocolor(255, 255, 255, 255), true)
        setCursorAlpha(0)
    elseif isConsoleActive(  ) and not isCursorShowing( ) then
        dxDrawImage(cX, cY, 20, 20, 'components/cursor.png', 0, 0, 0, tocolor(255, 255, 255, 255), true)
        setCursorAlpha(0)
    elseif isCursorShowing( ) then
        dxDrawImage(cX, cY, 20, 20, 'components/cursor.png', 0, 0, 0, tocolor(255, 255, 255, 255), true)
        setCursorAlpha(0)
    end
 end
end
addEventHandler("onClientRender", root, renderCursor, true, "low-9999999")