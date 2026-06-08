local temp = {
exhausted = 1,
}


local confg = {
level = 0,
chakra = 10
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	
	if not isCreature(cid) then
		return true
	end
		local outfit = getCreatureOutfit(cid)
		outfit.lookType = infoClan[getPlayerVocation(cid)].moldOutfit
		
		local outfitA = getCreatureOutfit(cid)
		outfitA.lookType = infoClanS[getPlayerVocation(cid)].moldOutfit
		
		local bunshinOutfit = getCreatureOutfit(cid)
-----[Restrições]-----
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
    elseif getPlayerLevel(cid) < confg.level then
        doPlayerSendCancel(cid, "You need to be atleast level ".. confg.level ..".") 
    return true
    end
	if isPlayer(cid) then
	if getPlayerStorageValue(cid, 4001) <= 0 then
		setPlayerStorageValue(cid, 4001, 1)
	end
    if #getCreatureSummons(cid) <= 1 then
      local Bunshin = doCreateMonsterNick("Bunshin", getPlayerName(cid), getThingPos(cid))
	    doConvinceCreature(cid, Bunshin)
		removeChakraLife(cid, - confg.chakra)
		doSetCreatureOutfit(Bunshin, bunshinOutfit, -1)		
		doChangeSpeed(Bunshin, getCreatureBaseSpeed(cid))
		noMove(cid, 800)
		doSendMagicEffect(getThingPos(Bunshin), 110)
		doCreatureSay(cid,"Bunshin no Jutsu!!", TALKTYPE_FIRST)		
	if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		doSetCreatureOutfit(cid, outfitA, 300)
	elseif getPlayerStorageValue(cid, initStorages.graduation) == "Gennin" then
		doSetCreatureOutfit(cid, outfit, 300)
	end
	    setPlayerStorageValue(cid, sto_jutsu[1]	, os.time() + temp.exhausted)
	end
	else
	   doPlayerSendCancel(cid, "You do not have chakra.")	
	return true
	end
end