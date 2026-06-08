local temp = {
exhausted = 2,
}
	
local buff = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(buff, CONDITION_PARAM_TICKS, -1)
setConditionParam(buff, CONDITION_PARAM_SKILL_FIST, 3)
setConditionParam(buff, CONDITION_PARAM_SKILL_CLUB, 3)
setConditionParam(buff, CONDITION_PARAM_SKILL_DISTANCE, 3)

function onUse(cid)
    if not isCreature(cid) then
		return true
	end
-----[Restrições]-----
	if(getPlayerStorageValue(cid, sto_byakugan[2]) > os.time() and getPlayerStorageValue(cid, sto_byakugan[2]) < 100+os.time()) then
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
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
-----[Restrições]-----
	if getPlayerStorageValue(cid, sto_byakugan[1]) > 0 then
		doAddCondition(cid, buff)
		doCreatureSay(cid, "Byakugan!", TALKTYPE_MONSTER)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Byakugan: Activated!")
		if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		actionMove(cid, 594, 300)
		elseif getPlayerStorageValue(cid, initStorages.graduation) == "Gennin" then
		actionMove(cid, 376, 300)
		end
		noMove(cid, 500)
		setPlayerStorageValue(cid, 9997, 1)
		setPlayerStorageValue(cid, sto_byakugan[1], 0)
		setPlayerStorageValue(cid, sto_byakugan[6], 0)
		removeChakra(cid, 1, 2, sto_byakugan[1], "sharingan")
	elseif getPlayerStorageValue(cid, sto_byakugan[1]) == 0 then
		doRemoveCondition(cid, CONDITION_ATTRIBUTES)
		setPlayerStorageValue(cid, 9997, 0)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Byakugan: Deactivated!")
		setPlayerStorageValue(cid, sto_byakugan[1], 1)
		setPlayerStorageValue(cid, sto_byakugan[4], 1)
------------------------------------------------------------------------------
		setPlayerStorageValue(cid, sto_byakugan[5], 1)
		setPlayerStorageValue(cid, sto_byakugan[6], 1)
		setPlayerStorageValue(cid, sto_byakugan[4], 1)
		setPlayerStorageValue(cid, sto_byakugan[3], 1)
		doSendPlayerExtendedOpcode(cid, 124, "Default")
		setPlayerStorageValue(cid, sto_byakugan[2], os.time() + temp.exhausted)
	end
end