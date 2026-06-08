local temp = {
exhausted = 2,
}

local buff = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(buff, CONDITION_PARAM_TICKS, -1)
setConditionParam(buff, CONDITION_PARAM_SKILL_FIST, 12)
setConditionParam(buff, CONDITION_PARAM_SKILL_CLUB, 12)
setConditionParam(buff, CONDITION_PARAM_SKILL_SWORD, 12)
setConditionParam(buff, CONDITION_PARAM_SKILL_AXE, 12)
setConditionParam(buff, CONDITION_PARAM_SKILL_DISTANCE, 12)

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if getCreatureStorage(cid, 8701) == 0 then
		doPlayerSendCancel(cid, "You can't use Mangekyou Sharingan while you are using Sharingan Level 1.")
		return true
	end
		if getCreatureStorage(cid, 8703) == 0 then
		doPlayerSendCancel(cid, "You can't use Mangekyou Sharingan while you are using Sharingan Level 3.")
		return true
	end
		if getCreatureStorage(cid, 8702) == 0 then
		doPlayerSendCancel(cid, "You can't use Mangekyou Sharingan while you are using Sharingan Level 2.")
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
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
   if not isCreature(cid) then
		return true
	end
	if(getPlayerStorageValue(cid, STORAGE_SHARINGAN4) > os.time() and getPlayerStorageValue(cid, STORAGE_SHARINGAN4) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "você esta exausto, espere " .. getPlayerStorageValue(cid, STORAGE_SHARINGAN4) - os.time() .. ' segundo' .. ((getPlayerStorageValue(cid, STORAGE_SHARINGAN4) - os.time()) == 1 and "" or "s"))
	return true
	elseif getPlayerStorageValue(cid, STORAGE_SHARINGAN4_CHECK) > 0 then
        addEvent(stopNows, 0, cid, -1)
		addEvent(stopNows, 500, cid, 0)
	    addEvent(actionMove, 0, cid, 385, 400)
		doAddCondition(cid, buff)
		doCreatureSay(cid, "Mangekyou Sharingan!", TALKTYPE_MONSTER)
		setPlayerStorageValue(cid, STORAGE_SHARINGAN4_CHECK, 0)
		setPlayerStorageValue(cid, 9998, getPlayerStorageValue(cid, 9998)+1)
		setPlayerStorageValue(cid, STORAGE_SHARINGAN4_CHAKRA, 0)
		removeChakra(cid, 1, 3, STORAGE_SHARINGAN4_CHAKRA, "sharingan")
	else
		doRemoveCondition(cid, CONDITION_ATTRIBUTES)
		setPlayerStorageValue(cid, STORAGE_SHARINGAN4_CHAKRA, 1)
		setPlayerStorageValue(cid, STORAGE_SHARINGAN4_CHECK, 1)
	setPlayerStorageValue(cid, STORAGE_SHARINGAN4, os.time() + temp.exhausted)
  end
end