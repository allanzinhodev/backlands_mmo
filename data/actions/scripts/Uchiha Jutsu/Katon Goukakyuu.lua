local temp = {
exhausted = 2,
}

local confg = {
chakra = 10,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
		return true
	end
-----[Restrições]-----
	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	

-----[Restrições]-----
 if getPlayerVocation(cid) ~= 5 then
 	return true
 end
	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		stopNow(cid, 1400)   
		doPlayerCastSpell(cid, "#YZuchiha1")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
	return true
end