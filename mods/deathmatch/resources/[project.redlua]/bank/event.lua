connection = exports.mysql

addEvent('bank.deposit', true)
addEventHandler('bank.deposit', root, function(amount)
	if tonumber(amount) then
		if tonumber(amount) > 0 then
			if exports.global:takeMoney(source, amount) then
				source:setData('bankmoney', tonumber(source:getData('bankmoney') + amount))
				source:outputChat(':#FFFFFF Banka hesabınıza '..amount..'₺ para yatırdınız.',127,127,127,true)
				dbExec(connection:getConnection(), "UPDATE `characters` SET bankmoney='"..source:getData('bankmoney').."' WHERE id='"..source:getData('account:id').."'")
			else
				source:outputChat(':#FFFFFF Üzerinizde yarıtmak istediğiniz miktarda para yok.',127,127,127,true)
			end
		else
			source:outputChat(':#FFFFFF Bir şeyler ters gitti!',127,127,127,true)
		end
	else
		source:outputChat(':#FFFFFF Lütfen geçerli bir miktar girin.',127,127,127,true)
	end
end)

addEvent('bank.withdraw', true)
addEventHandler('bank.withdraw', root, function(amount)
	if tonumber(amount) then
		if tonumber(amount) > 0 then
			if source:getData('bankmoney') >= tonumber(amount) then
				source:setData('bankmoney', tonumber(source:getData('bankmoney') - amount))
				exports.global:giveMoney(source, amount)
				source:outputChat(':#FFFFFF Banka hesabınızdan '..amount..'₺ para çektiniz.',127,127,127,true)
				dbExec(connection:getConnection(), "UPDATE `characters` SET bankmoney='"..source:getData('bankmoney').."' WHERE id='"..source:getData('account:id').."'")
			else
				source:outputChat(':#FFFFFF Hesabınızda çekmek istediğiniz miktarda para yok.',127,127,127,true)
			end
		else
			source:outputChat(':#FFFFFF Bir şeyler ters gitti!',127,127,127,true)
		end
	else
		source:outputChat(':#FFFFFF Lütfen geçerli bir miktar girin.',127,127,127,true)
	end
end)