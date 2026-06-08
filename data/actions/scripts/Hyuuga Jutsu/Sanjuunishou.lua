local temp = {
exhausted = 9,
}


local confg = {
level = 25,
chakra = 60,	
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
-----[Restrições]----
	if isPlayer(cid) then
		setPlayerStorageValue(cid, sto_jutsu[1], (os.time() + temp.exhausted))
		removeChakraLife(cid, - confg.chakra)
		doPlayerCastSpell(cid, "#YZhyuuga4")
	end
end