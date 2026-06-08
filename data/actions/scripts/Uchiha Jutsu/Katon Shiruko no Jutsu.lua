local temp = {
exhausted = 2,
}

local confg = {
chakra = 25,
}


function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
		return true
	end
-----[Restrições]-----
	if impossibleUse(cid) then
		return true
	end	
-----[Restrições]-----
	if checkDoing(cid) then
		return true
	end	
 if getPlayerVocation(cid) ~= 5 then
 	return true
 end

	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		doPlayerCastSpell(cid, "#YZuchiha2")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)

		end
	return true
end