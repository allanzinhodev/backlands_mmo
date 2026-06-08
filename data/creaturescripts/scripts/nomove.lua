function onCombat(cid, target)
	if isPlayer(target) or isMonster(target) then
		if getCreatureStorage(cid, 2137) == 0 then -- Mold
			doPlayerSendCancel(cid, "you cannot attack while you are molding.")
		return false
		elseif getCreatureStorage(cid, 2136) == 0 then -- Rest
			doPlayerSendCancel(cid, "you cannot attack while you are resting.")
		return false
		elseif getCreatureStorage(cid, sto_gen[1]) == 0 then -- Kanashibari
			doPlayerSendCancel(cid, "you cannot attack while you are in genjutsu.")
			return false
		end
	end
	return true
end