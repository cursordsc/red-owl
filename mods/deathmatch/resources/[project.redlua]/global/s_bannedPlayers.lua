local IPs = { }
local serials = { }

function fillBans(res)
	if res == getThisResource() then
		local ipCounter = 0
		local serialCounter = 0
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						if not row then break end
						table.insert(IPs, row["ip"])
						ipCounter = ipCounter + 1
						--outputDebugString(ipCounter .. " IP bans have been loaded")
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM bannedIPs")

		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						if not row then break end
						table.insert(serials, row["serial"])
						serialCounter = serialCounter + 1
						--outputDebugString(serialCounter .. " serial bans have been loaded")
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM bannedSerials")
    end
end
--addEventHandler("onResourceStart", getRootElement(), fillBans)

function fetchIPs()
	return IPs
end

function fetchSerials()
	return serials
end

function updateBans()
	IPs = { }
	serials = { }
	fillBans(getThisReasource())
end