local temp = {
exhausted = 3,
}

local confg = {
level = 40,
chakra = 100,
}


function onUse(cid, item, frompos, itemEx, topos)
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	elseif getPlayerLevel(cid) < confg.level then
		doPlayerSendCancel(cid, "You need to be atleast level ".. confg.level ..".") 
	return true
	end
	
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
	

	local info = {
		speed = 500,
	}
	

	if not isCreature(cid) then
		return true
	end

		local pet = getPlayerPet(cid)
	if isPlayer(cid) and getPlayerStorageValue(cid, sto_inuzuka[3]) > 0 then
	 if pet then
		doCreatureSetStorage(cid, petStorages.health, getCreatureHealth(pet))
		doCreatureSetStorage(cid, petStorages.mana, getCreatureMana(pet))
		doRemoveCreature(pet)
       	removeChakraLife(cid, - confg.chakra)
		addEvent(doCreatureSay, 200, cid, "Juujin Konbi Henge..", TALKTYPE_MONSTER)
		addEvent(doCreatureSay, 600, cid, "SOUTOUROU!!!", TALKTYPE_MONSTER)
		actionMove(cid, 464, 500)
		addEvent(changeMove, 500, cid, 407, -1)
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)+20)
		doPlayerAddSkill(cid, 6, getPlayerSkill(cid, 6)+20)
		addEvent(doSendMagicEffect, 500, getCreaturePosition(cid),111)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid) + info.speed)
		setPlayerStorageValue(cid, sto_inuzuka[3], 0)
		removeChakra(cid, 4, 2, sto_inuzuka[3], "sharingan")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		else
		doPlayerSendCancel(cid, "Call your dog.")
		end
	elseif isPlayer(cid) and getPlayerStorageValue(cid, sto_inuzuka[3]) == 0 then
		changeMove(cid, 359, -1)
		callPet(cid)
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)-20)
		doPlayerAddSkill(cid, 6, getPlayerSkill(cid, 6)-20)
	    doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid))
		setPlayerStorageValue(cid, sto_inuzuka[3], 1)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end
