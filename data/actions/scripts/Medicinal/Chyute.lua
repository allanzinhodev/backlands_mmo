local temp = {
exhausted = 5,
}

function onUse (cid, item, frompos, itemEx, topos)
	local info = {
		health = 10,
	}

	local confg = {
		chakra = 15
	}

    local healthPercent = getCreatureMaxHealth(cid) * (info.health / 100)
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
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
--------------------
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu") 
	return true
	end
	if isPlayer(cid) then
	if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		doSetCreatureOutfit(cid, outfitA, 300)
	elseif getPlayerStorageValue(cid, initStorages.graduation) == "Gennin" then
		doSetCreatureOutfit(cid, outfit, 300)
	end
		doCreatureAddHealth(itemEx.uid, healthPercent)
		noMove(cid, 800)
		removeChakraLife(cid, - confg.chakra)
        doSendMagicEffect(pos ,7)
        doCreatureSay(cid, "Chiyute no Jutsu..", TALKTYPE_MONSTER)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end