local temp = {
exhausted = 3,
}

local confg = {
level = 45,
chakra = 180,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
-----[Restrições]-----
	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	

	if getPlayerStorageValue(cid, sto_inuzuka[3]) == 1 then
		return doPlayerSendCancel(cid, "Use o Soutorou primeiro.") 
	end 
-----[Restrições]-----
	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		doPlayerCastSpell(cid, "#YZinuzuka3")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end