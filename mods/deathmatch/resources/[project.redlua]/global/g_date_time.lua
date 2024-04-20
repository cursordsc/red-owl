--MAXIME / THIS FILE IS WORKAROUND FUNCTIONS FOR ANY KIND OF DATE TIME FORMAT

function getPlayerDoB(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		local age = getElementData(thePlayer, "age")
		local month = getElementData(thePlayer, "month")
		local day = getElementData(thePlayer, "day")
		return formatDate(day).." "..numberToMonth(month).." "..getBirthYearFromAge(age)
	else
		return false
	end
end

function isThisYearLeap(year)
	if not year or not tonumber(year) then
		return false
	else
		year = tonumber(year)
	end

	if (year%4) == 0 then
		return true
	else
		return false
	end
end

function monthToNumber(monthName)
	if not monthName then
		return 1
	else
		if monthName == "Ocak" then
			return 1
		elseif monthName == "Şubat" then
			return 2
		elseif monthName == "Mart" then
			return 3
		elseif monthName == "Nisan" then
			return 4
		elseif monthName == "Mayıs" then
			return 5
		elseif monthName == "Haziran" then
			return 6
		elseif monthName == "Temmuz" then
			return 7
		elseif monthName == "Ağustos" then
			return 8
		elseif monthName == "Eylül" then
			return 9
		elseif monthName == "Ekim" then
			return 10
		elseif monthName == "Kasım" then
			return 11
		elseif monthName == "Aralık" then
			return 12
		else
			return 1
		end
	end
end

function numberToMonth(monthNumber)
	if not monthNumber or not tonumber(monthNumber) then
		return "Ocak"
	else
		monthNumber = tonumber(monthNumber)
		if monthNumber == 1 then
			return "Ocak"
		elseif monthNumber == 2 then
			return "Şubat"
		elseif monthNumber == 3 then
			return "Mart"
		elseif monthNumber == 4 then
			return "Nisan"
		elseif monthNumber == 5 then
			return "Mayıs"
		elseif monthNumber == 6 then
			return "Haziran"
		elseif monthNumber == 7 then
			return "Temmuz"
		elseif monthNumber == 8 then
			return "Ağustos"
		elseif monthNumber == 9 then
			return "Eylül"
		elseif monthNumber == 10 then
			return "Ekim"
		elseif monthNumber == 11 then
			return "Kasım"
		elseif monthNumber == 12 then
			return "Aralık"
		else
			return "Ocak"
		end
	end
end

function daysInMonth(month, year)
	if not month or not year or not tonumber(month) or not tonumber(year) then
		return 31
	else
		month = tonumber(month)
		year = tonumber(year)
	end

	if month == 1 then
		return 31
	elseif month == 2 then
		if isThisYearLeap(year) then
			return 29
		else
			return 28
		end
	elseif month == 3 then
		return 31
	elseif month == 4 then
		 return 30
	elseif month == 5 then
		return 31
	elseif month == 6 then
		return 30
	elseif month == 7 then
		return 31
	elseif month == 8 then
		return 31
	elseif month == 9 then
		return 30
	elseif month == 10 then
		return 31
	elseif month == 11 then
		return 30
	elseif month == 12 then
		return 31
	else
		return 31
	end
end

function getBirthYearFromAge(age)
	if not age or not tonumber(age) then
		return 2015
	else
		age = tonumber(age)
	end

	local time = getRealTime()
	time.year = time.year + 1900
	return (time.year - age)
end

function formatDate(day)
	if not day or not tonumber(day) then
		return "1"
	else
		day = tonumber(day)
		if day == 1 or day == 21 or day == 31 then
			return day..""
		elseif day == 2 or day == 22 then
			return day..""
		elseif day == 3 or day == 23 then
			return day..""
		else
			return day..""
		end
	end
end
