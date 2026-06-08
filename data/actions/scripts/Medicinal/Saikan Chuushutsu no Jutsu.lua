local temp = {
exhausted = 3,
}

function onUse (cid, item, frompos, itemEx, topos)
	local confg = {
		chakra = 30
	}

    local pos = getCreaturePosition(cid)
	local outfit = getCreatureOutfit(cid)
	
	if not isCreature(cid) then
		return true
	end
		local outfit = getCreatureOutfit(cid)
		outfit.lookType = infoClan[getPlayerVocation(cid)].moldOutfit
		
		local outfitA = getCreatureOutfit(cid)
		outfitA.lookType = infoClanS[getPlayerVocation(cid)].moldOutfit
		
        if itemEx.uid <= 1 then
        	return doPlayerSendCancel(cid,"You can't do that.")
        end
-----[Restrições]-----
    if itemEx.uid <= 1 then
        return doPlayerSendCancel(cid,"You can't do that.")
    end

    if impossibleUse(cid) then 
    	return true
    end
--------------------
	if checkDoing(cid) then
		return true
	end

	if isPlayer(cid) then
	if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		doSetCreatureOutfit(cid, outfitA, 300)
	elseif getPlayerStorageValue(cid, initStorages.graduation) ~= "Academy Student" then
		doSetCreatureOutfit(cid, outfit, 300)
	end
		doCreatureAddHealth(itemEx.uid, healthPercent)
		noMove(cid, 800)
		removeChakraLife(cid, - confg.chakra)
        doSendMagicEffect(pos ,7)
        doRemoveCondition(cid, CONDITION_FIRE)
        doRemoveCondition(cid, CONDITION_POISON)
        doRemoveCondition(cid, CONDITION_ENERGY)
        doCreatureSay(cid, "Saikan Chuushutsu no Jutsu..", TALKTYPE_MONSTER)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end