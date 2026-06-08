local temp = {
exhausted = 3,

}

local confg = {
chakra = 35,
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
 if getPlayerVocation(cid) ~= 5 then
 	return true
 end
-----[Restrições]-----

	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)  
		doPlayerCastSpell(cid, "#YZuchiha3")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end