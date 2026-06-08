function onUse(cid, item, fromPosition, itemEx, toPosition)
local temp = {
exhausted = 12,
}

local confg = {
chakra = 70,
}

		local outfit = getCreatureOutfit(cid)
		outfit.lookType = infoClan[getPlayerVocation(cid)].moldOutfit
		
		local outfitA = getCreatureOutfit(cid)
		outfitA.lookType = infoClanS[getPlayerVocation(cid)].moldOutfit

	if not isCreature(cid) then
		return true
	end
	
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You in this area pz.") 
    end 

    if impossibleUse(cid) then
    	return true
    end

		if(getPlayerStorageValue(cid, sto_gen[4]) > os.time() and getPlayerStorageValue(cid, sto_gen[4]) < 100+os.time()) then
			return doPlayerSendTextMessage(cid, 24, "You are already doing a jutsu") 
		end
	
		if isPlayer(cid) then
		if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
			doSetCreatureOutfit(cid, outfitA, 300)
		elseif getPlayerStorageValue(cid, initStorages.graduation) ~= "Academy Student" then
			doSetCreatureOutfit(cid, outfit, 300)
		end
			removeChakraLife(cid, - confg.chakra)
			stopNow(cid, 400)  
			doCreatureSay(cid, "Nehan Shoja!", TALKTYPE_MONSTER)
			doSendMagicEffect(getThingPos(cid), 3)
			doPlayerCastSpell(cid, "#YZgenjutsu1")
			setPlayerStorageValue(cid, sto_gen[4], os.time() + temp.exhausted)
			return true
		end
end
