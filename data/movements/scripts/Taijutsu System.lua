local buff = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(buff, CONDITION_PARAM_TICKS, -1)
setConditionParam(buff, CONDITION_PARAM_SKILL_CLUB, 3)

function onEquip(cid, item, slot)
local ITEM = getPlayerItemById(cid, true, 2376)
doItemSetAttribute(ITEM.uid, "description", "Ninjutsu: + 3")
doAddCondition(cid, buff)
return true
end

function onDeEquip(cid, item, slot)
		doRemoveCondition(cid, CONDITION_ATTRIBUTES)
return true
end