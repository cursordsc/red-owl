addEvent('taxi > goto',true)
addEventHandler('taxi > goto',root, 
    function(player,text)
        if text == "Idlegash" then
            exports.global:takeMoney(player,137)
            setTimer(function()
                setElementPosition(player,1950.4892578125, -1743.46484375, 13.546875)
            end,1000,1)
        elseif text == "Ehliyet Alanı" then
            exports.global:takeMoney(player,89)
            setTimer(function()
                setElementPosition(player,1089.322265625, -1796.6318359375, 13.61766242981)
            end,1000,1)
        elseif text == "Santa Maria Beach" then
            exports.global:takeMoney(player,234)
            setTimer(function()
                setElementPosition(player,376.783203125, -2020.6162109375, 7.8300905227661)
            end,1000,1)
        end
        setTimer(function()
            triggerClientEvent(player,'taxi > fadecamera',player)
        end, 2000, 1)
    end
)