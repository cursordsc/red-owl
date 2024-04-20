
function changeNametag(thePlayer, command, theState, theValue)
    if not theState then
        outputChatBox("SYNTAX: /"..command.." [font - bar]", thePlayer, 255, 194, 14)
    else
        if theState == "font" then
            if theValue then
                theValue = tonumber(theValue)
                if avaibleFonts[theValue] then
                    setElementData(thePlayer, 'interface.nametagFont', theValue)
                    outputChatBox(">>#F9F9F9 İsim etiketi yazı fontun '"..avaibleFonts[theValue][1].."' olarak değiştirildi.", thePlayer, 0, 255, 0, true)
                else
                    outputChatBox("SYNTAX: /"..command.." font [1-"..#avaibleFonts.."]", thePlayer, 255, 194, 14)
                end
            else
                outputChatBox("SYNTAX: /"..command.." font [1-"..#avaibleFonts.."]", thePlayer, 255, 194, 14)
            end
        elseif theState == "bar" then
            theValue = tostring(theValue)
            if theValue then
                if theValue == "rectangle" then
                    outputChatBox(">>#F9F9F9 İsim etiketi barların rectangle olarak değiştirildi.", thePlayer, 255, 255, 0, true)
                    setElementData(thePlayer, 'interface.nametagBar', "rectangle")
                elseif theValue == "text" then
                    outputChatBox(">>#F9F9F9 İsim etiketi barların text olarak değiştirildi.", thePlayer, 255, 255, 0, true)
                    setElementData(thePlayer, 'interface.nametagBar', "text")
                else
                    outputChatBox("SYNTAX: /"..command.." [rectangle - text]", thePlayer, 255, 194, 14)
                end
            else
                outputChatBox("SYNTAX: /"..command.." [rectangle - text]", thePlayer, 255, 194, 14)
            end
        else
            outputChatBox("SYNTAX: /"..command.." [font - bar]", thePlayer, 255, 194, 14)
        end
    end
end
addCommandHandler("nametag", changeNametag )
