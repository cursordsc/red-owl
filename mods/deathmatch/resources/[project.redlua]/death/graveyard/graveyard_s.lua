--MAXIME
local mysql = exports["mysql"]
local buriedCharacters = {}
local refreshRate = 5 --hours

function fetchBuriedCharacters()
	local buriedCharacters1 = {}
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					buriedCharacters1[#buriedCharacters1 + 1] = {
						["charactername"] = row.charactername,
						["born"] = getMonthShortName(row.month)..". "..row.day..". "..exports["global"]:getBirthYearFromAge(row.age),
						["dead"] = row.dead,
					}
				end
			end
		end,
	mysql:getConnection(), "SELECT `charactername`, DATE_FORMAT(`death_date`,'%b. %d. %Y') AS `dead`, `age`, `day` FROM `characters` WHERE `cked`='2' AND `death_date` IS NOT NULL ORDER BY `death_date` DESC LIMIT "..(#tombs).."; ")
	
	buriedCharacters = buriedCharacters1
end

function sendburiedCharactersToClient()
	if source then
		client = source
	end
	triggerClientEvent(client, "receiveBuriedCharactersFromServer", client, buriedCharacters)
end
addEvent("sendburiedCharactersToClient", true)
addEventHandler("sendburiedCharactersToClient", root, sendburiedCharactersToClient)

function initiation()
	fetchBuriedCharacters()
	setTimer(function()
		fetchBuriedCharacters()
	end, refreshRate*1000*60*60, 0)
end
addEventHandler("onResourceStart", resourceRoot, initiation)

function getMonthShortName(month)
	if not month or not tonumber(month) then
		return "Jan"
	end

	month = tonumber(month)

	if month == 1 then
		return "Jan"
	elseif motnh == 2 then
		return "Feb"
	elseif motnh == 3 then
		return "Mar"
	elseif motnh == 4 then
		return "Apr"
	elseif motnh == 5 then
		return "May"
	elseif motnh == 6 then
		return "June"
	elseif motnh == 7 then
		return "July"
	elseif motnh == 8 then
		return "Aug"
	elseif motnh == 9 then
		return "Sept"
	elseif motnh == 10 then
		return "Oct"
	elseif motnh == 11 then
		return "Nov"
	elseif motnh == 12 then
		return "Dec"
	else
		return "Jan"
	end
end