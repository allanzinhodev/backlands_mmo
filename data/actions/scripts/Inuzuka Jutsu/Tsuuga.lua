local temp = {
exhausted = 3,
}

local confg = {
level = 5,
chakra = 10,
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
-----[Restrições]-----
	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	

	if checkJutsu(cid, "Soutorou") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
-----[Restrições]-----
-----------------------
	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		doPlayerCastSpell(cid, "#YZinuzuka1")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end