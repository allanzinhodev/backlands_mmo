function onUse(cid, item, fromPosition, itemEx, toPosition)
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
	if #getCreatureSummons(cid) >= 1 then
		actionMove(cid, 373, 1000)
		noMove(cid, 1000)
	for n = 1,#getCreatureSummons(cid) do
	if getCreatureName(getCreatureSummons(cid)[n]) == "Small Kikkais" or getCreatureName(getCreatureSummons(cid)[1]) == "Medium Kikkais" then
		setPlayerStorageValue(cid, sto_kikkais[1], getPlayerStorageValue(cid, sto_kikkais[1])+getCreatureHealth(getCreatureSummons(cid)[n]))
		doSendMagicEffect(getCreaturePosition(getCreatureSummons(cid)[n]), 37)
		doRemoveCreature(getCreatureSummons(cid)[n])
	else
		doPlayerSendCancel(cid, "You not have kikais released.")  
	end
	end
	else
	doPlayerSendCancel(cid, "You not have kikais released.")  
	end
end