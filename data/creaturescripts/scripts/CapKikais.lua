function onAdvance(cid, skill, oldLevel, newLevel)
	if getPlayerVocation(cid) == 3 then
		if skill == 8 and getPlayerLevel(cid) > 10 then
			if getPlayerStorageValue(cid, sto_kikkais[2]) > getPlayerLevel(cid) then
				return true
			end
	local qtdLvl = newLevel-oldLevel
			setPlayerStorageValue(cid, sto_kikkais[1], getPlayerStorageValue(cid, sto_kikkais[1])+(qtdLvl*10))
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "Now your body stores more "..(qtdLvl*10).." kikais!")
			setPlayerStorageValue(cid, sto_kikkais[2], getPlayerStorageValue(cid, sto_kikkais[2])+(qtdLvl*1))
			doPlayerSave(cid)
		end
	return true
	end
end
