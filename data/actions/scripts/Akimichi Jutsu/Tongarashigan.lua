local temp = {
exhausted = 2,
}
	

function onUse(cid)
local info = {
		mana = 1,
		speed = 300,
	}
local buff = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(buff, CONDITION_PARAM_TICKS, -1)
setConditionParam(buff, CONDITION_PARAM_SKILL_FIST, 12)
setConditionParam(buff, CONDITION_PARAM_SKILL_FISHING, 12)

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
	if checkJutsu(cid, "Horengan") then
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
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
	
------------------------------------------------------------------------
	if not isCreature(cid) then
		return true
	end

		local outfit = getCreatureOutfit(cid)
		outfit.lookType = 525
		
		local Aoutfit = getCreatureOutfit(cid)
		Aoutfit.lookType = 418
		
	if getPlayerStorageValue(cid, sto_sensha[4]) > 0 then
        doCreatureChangeOutfit(cid, outfit)
		doSendMagicEffect(getCreaturePosition(cid),106)
		doCreatureSay(cid, "Tongarashigan", TALKTYPE_MONSTER)
		setPlayerStorageValue(cid, sto_sensha[4], 0)
		removeChakra(cid, 3, 2, sto_sensha[4], "sharingan")
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doAddCondition(cid, buff)
		doChangeSpeed(cid, getCreatureBaseSpeed(cid) + info.speed)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	else
		doCreatureChangeOutfit(cid, Aoutfit)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid))
		doRemoveCondition(cid, CONDITION_ATTRIBUTES)
		setPlayerStorageValue(cid, sto_sensha[4], 1)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		
	end
end