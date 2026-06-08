local temp = {
exhausted = 2,
}

local condition = createConditionObject(CONDITION_POISON)
setConditionParam(condition, CONDITION_PARAM_DELAYED, 1)
addDamageCondition(condition, 30, 1000, -5)

function onUse(cid, item, fromPosition, itemEx, toPosition)
-----[Restrições]-----
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You in this area pz.") 
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
-----[Restrições]-----
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
						doPlayerSendTextMessage(cid, 24, "You are exhausted.")
		return true
	end

	if isPlayer(cid) then
		local min = 5
		local max = 7
		for i = 1,6 do
		local random = randomPos(cid, toPosition)
		addEvent(doAreaCombatHealth, (180*i), cid, COMBAT_KIKAICHUU, random, 0, -min, -max, 109)
		addEvent(doAreaCombatHealth, 180, cid, COMBAT_KIKAICHUU, toPosition, 0, -min, -max, 109)
		addEvent(doAreaCombatCondition, (180*i), cid, random, 0, condition, 109)
		addEvent(doAreaCombatCondition, 180, cid, toPosition, 0, condition, 109)
	end
		doRemoveItem(item.uid, 1)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	return true
	end
end