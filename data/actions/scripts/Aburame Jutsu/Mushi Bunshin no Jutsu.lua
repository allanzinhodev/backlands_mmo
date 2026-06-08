local temp = {
exhausted = 3,
}

local confg = {
level = 15,
chakra = 20,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
		return true
	end
----[Restriçoes]-----    
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
---[Restriçoes]------
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	elseif getPlayerLevel(cid) < confg.level then
		doPlayerSendCancel(cid, "You need to be atleast level ".. confg.level ..".") 
	return true
	end

    if #getCreatureSummons(cid) <= 1 and itemEx.uid == cid then
	  local pos = getPlayerPosition(cid)
      local Bunshin = doCreateMonsterNick("Mushi Bunshin", getPlayerName(cid), toPosition)
	  if isPlayer(cid) then
			removeChakraLife(cid, - confg.chakra)
		end
		doConvinceCreature(cid, Bunshin)	 
		setCreatureMaxHealth(Bunshin, 100)
		doCreatureAddHealth(Bunshin, 100)
		doChangeSpeed(Bunshin, getCreatureBaseSpeed(cid))
		doSetCreatureOutfit(Bunshin, getCreatureOutfit(cid), -1)
		actionMove(cid, 372, 300)
		addEvent(doRemoveCondition, 300, cid, CONDITION_OUTFIT)
		noMove(cid, 800)
		doSendMagicEffect(getThingPos(Bunshin), 33)
		doCreatureSay(cid,"Mushi Bunshin no Jutsu!", TALKTYPE_MONSTER)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	return true	
	end
	if isCreature(itemEx.uid) and getCreatureNickRealName(itemEx.uid) == "Mushi Bunshin" and itemEx.uid ~= cid then
		doSendMagicEffect(getCreaturePosition(itemEx.uid), 33)
		doRemoveCreature(itemEx.uid)
    else
      return doPlayerSendCancel(cid, "You can't use.") 
   end	
end