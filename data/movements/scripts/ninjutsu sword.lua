local buff = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(buff, CONDITION_PARAM_TICKS, -1)
setConditionParam(buff, CONDITION_PARAM_SKILL_CLUB, 3)

function onEquip(cid, item, slot)
doAddCondition(cid, buff)
return true
end

function onDeEquip(cid, item, slot)
		doRemoveCondition(cid, CONDITION_ATTRIBUTES)
return true
end