local temp = {
exhausted = 2,
}

local info = {
speed = 200,	
	}
	
function onUse(cid)
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
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
	
	if checkJutsu(cid, "Juujin") then
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

	if getPlayerStorageValue(cid, sto_inuzuka[1]) > 0 then
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)+3)
		doPlayerAddSkill(cid, 6, getPlayerSkill(cid, 6)+3)
        addEvent(changeMove, 0, cid, 362, -1)
		doCreatureSay(cid, "Shikyaku no Jutsu!!!", TALKTYPE_MONSTER)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid) + info.speed)
		setPlayerStorageValue(cid, sto_inuzuka[1], 0)
		removeChakra(cid, 1, 2, sto_inuzuka[1], "sharingan")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	elseif getPlayerStorageValue(cid, sto_inuzuka[1]) < 1 then
		addEvent(changeMove, 0, cid, 359, -1)
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)-3)
		doPlayerAddSkill(cid, 6, getPlayerSkill(cid, 6)-3)
	    doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid))
		setPlayerStorageValue(cid, sto_inuzuka[1], 1)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		
	end
end