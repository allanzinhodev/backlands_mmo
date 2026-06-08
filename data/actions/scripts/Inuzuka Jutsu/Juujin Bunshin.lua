local temp = {
exhausted = 2,
}


local info = {
speed = 400,	
	}
	
function onUse(cid)
local pet = getPlayerPet(cid)
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
	
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	
	if checkJutsu(cid, "Shikyaku") then
		return doPlayerSendCancel(cid, "You cannot use jutsu")
	end
	if checkJutsu(cid, "Soutorou") then
		return doPlayerSendCancel(cid, "You cannot use jutsu")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end	
	
	if not isCreature(cid) then
		return true
	end

	if getPlayerStorageValue(cid, sto_inuzuka[2]) > 0 then
	 local pet = getPlayerPet(cid)
	 local outfit = getCreatureOutfit(cid)
		outfit.lookType = 362
        changeMove(cid, 362, -1)
		doCreatureSay(cid, "Juujin Bunshin!!!", TALKTYPE_MONSTER)
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)+4)
		doPlayerAddSkill(cid, 6, getPlayerSkill(cid, 6)+4)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid) + info.speed)
	if pet then
		doSetCreatureOutfit(pet, outfit, -1)
		doChangeSpeed(pet, -getCreatureSpeed(pet))
		doChangeSpeed(pet, getCreatureBaseSpeed(pet) + info.speed)
	end
		setPlayerStorageValue(cid, sto_inuzuka[2], 0)
		removeChakra(cid, 2, 2, sto_inuzuka[2], "sharingan")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	elseif getPlayerStorageValue(cid, sto_inuzuka[2]) < 1 then
		addEvent(changeMove, 0, cid, 359, -1)
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)-4)
		doPlayerAddSkill(cid, 6, getPlayerSkill(cid, 6)-4)
	    doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid))
	if pet then
		addEvent(changeMove, 0, pet, 403, -1)
		doChangeSpeed(pet, -getCreatureSpeed(pet))
		doChangeSpeed(pet, getCreatureBaseSpeed(pet))
	end
		setPlayerStorageValue(cid, sto_inuzuka[2], 1)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		
	end
end