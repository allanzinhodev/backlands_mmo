local temp = {
exhausted = 5,
}

local buff = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(buff, CONDITION_PARAM_TICKS, -1)
setConditionParam(buff, CONDITION_PARAM_SKILL_FIST, 9)
setConditionParam(buff, CONDITION_PARAM_SKILL_CLUB, 9)
setConditionParam(buff, CONDITION_PARAM_SKILL_SWORD, 9)
setConditionParam(buff, CONDITION_PARAM_SKILL_AXE, 9)
setConditionParam(buff, CONDITION_PARAM_SKILL_DISTANCE, 9)


function onUse(cid, item, fromPosition, itemEx, toPosition)
	
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
	
	if not isCreature(cid) then
		return true
	end
	if getCreatureStorage(cid, sto_sharingan[1]) == 0 then
		doPlayerSendCancel(cid, "You can't use Sharingan Level 3 while you are using Sharingan Level 1.")
		return true
	end
	
	if getCreatureStorage(cid, sto_sharingan[2]) == 0 then
		doPlayerSendCancel(cid, "You can't use Sharingan Level 3 while you are using Sharingan Level 2.")
		return true
	end
	
	if getCreatureStorage(cid, sto_sharingan[4]) == 0 then
		doPlayerSendCancel(cid, "You can't use Sharingan Level 3 while you are using Mangekyou Sharingan.")
		return true
	end	
	
	if(getPlayerStorageValue(cid, sto_sharingan_exhausted[1]) > os.time() and getPlayerStorageValue(cid, sto_sharingan_exhausted[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "você esta exausto, espere " .. getPlayerStorageValue(cid, STORAGE_SHARINGAN3) - os.time() .. ' segundo' .. ((getPlayerStorageValue(cid, STORAGE_SHARINGAN3) - os.time()) == 1 and "" or "s"))
	return true
	elseif getPlayerStorageValue(cid, sto_sharingan[3]) > 0 then
		addEvent(stopNows, 0, cid, -1)
		addEvent(stopNows, 500, cid, 0)
	    addEvent(actionMove, 0, cid, 385, 400)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Sharingan: Activated!")
		doCreatureSay(cid, "Sharingan!", TALKTYPE_MONSTER)
		setPlayerStorageValue(cid, 9998, getPlayerStorageValue(cid, 9998)+1)
		setPlayerStorageValue(cid, sto_sharingan[3], 0)
		doAddCondition(cid, buff)
		removeChakra(cid, 1, 3, sto_sharingan[3], "sharingan")
	else
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Sharingan: Deactivated!")
		setPlayerStorageValue(cid, sto_sharingan[3], 1)
		doRemoveCondition(cid, CONDITION_ATTRIBUTES)
		setPlayerStorageValue(cid, sto_sharingan_exhausted[1], os.time() + temp.exhausted)
  end
end