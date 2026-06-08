local temp = {
exhausted = 4,

}

local confg = {
level = 55,
chakra = 55,
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
		stopNow(cid, 1700)   
		doPlayerCastSpell(cid, "#YZuchiha4")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		doPlayerSendCancel(cid, "you do not have chakra.")
	end
end