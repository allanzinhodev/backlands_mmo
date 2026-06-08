function onUse(cid, item, itemEx)
	local outfit = getCreatureOutfit(cid)
		outfit.lookType = infoClan[getPlayerVocation(cid)].moldOutfit
		
	local outfitA = getCreatureOutfit(cid)
		outfitA.lookType = infoClanS[getPlayerVocation(cid)].moldOutfit
		
		
	if getPlayerStorageValue(cid, sto_jutsu[3]) == 1 then
		addEvent(doCreatureSay, 100, cid, "Mizu Kinobori!", TALKTYPE_MONSTER)
	if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		doSetCreatureOutfit(cid, outfitA, 300)
	elseif getPlayerStorageValue(cid, initStorages.graduation) == "Gennin" then
		doSetCreatureOutfit(cid, outfit, 300)
	end
		doSendMagicEffect(getThingPos(cid), 1)
		doPlayerSendCancel(cid, "You can now walk through the water.")
		setPlayerStorageValue(cid, sto_jutsu[3], 0)
		removeChakra(cid, 1, 2, sto_jutsu[3], "sharingan")
	else
		setPlayerStorageValue(cid, sto_jutsu[3], 1)
	end
end
	
	