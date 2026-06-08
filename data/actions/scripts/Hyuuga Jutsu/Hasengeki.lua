local temp = {
exhausted = 2,
}

local confg = {
level = 35,
chakra = 50,
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
        removeChakraLife(cid, - confg.chakra)
		doPlayerCastSpell(cid, "#YZhyuuga5")
        setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
    end
end