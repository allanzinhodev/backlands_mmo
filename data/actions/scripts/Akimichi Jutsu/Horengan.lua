function onUse(cid)
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	end
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if checkJutsu(cid, "Nikudan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Karegan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Hari") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Chou Baika") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end	
	if checkJutsu(cid, "Mizudan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Tongarashigan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end	
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
------------------------------------

	if not isCreature(cid) then
		return true
	end
	if getPlayerStorageValue(cid, sto_sensha[2]) == 1 then
        doCreatureSay(cid, "Horengan!", TALKTYPE_MONSTER)
		setPlayerStorageValue(cid, sto_sensha[2], 0)
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)+5)
		removeChakra(cid, 1, 2, sto_sensha[2], "sharingan")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	else
		doPlayerAddSkill(cid, 0, -5)
		setPlayerStorageValue(cid, sto_sensha[2], 1)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		
	end
end