config = {
    min = 10,
    max = 20,
    effect = CONST_ME_EXPLOSIONAREA,
    damageType = COMBAT_FIREDAMAGE,
    itemId = 11474,
}

function explode(cid, min, max, damagetype, pos, effect, itemId)
        -- COMBAT FUNCTION --  
        local area = {
                {x = pos.x+1, y = pos.y, z = pos.z},
                {x = pos.x, y = pos.y+1, z = pos.z},
                {x = pos.x-1, y = pos.y, z = pos.z},
                {x = pos.x+1, y = pos.y+1, z = pos.z},
                {x = pos.x-1, y = pos.y-1, z = pos.z},
                {x = pos.x, y = pos.y-1, z = pos.z},
                {x = pos.x+1, y = pos.y-1, z = pos.z},
                {x = pos.x-1, y = pos.y+1, z = pos.z},
        }
        doAreaCombatHealth(0, damagetype, {x = pos.x, y = pos.y, z = pos.z}, 0, -min, -max, effect)
        doRemoveItem(getTileItemById({x = pos.x, y = pos.y, z = pos.z}, itemId).uid, 1)
        for i = 1,#area do
                doAreaCombatHealth(0, damagetype, area[i], 0, -min, -max, effect)
                findItemById(area[i], itemId)
        end
        doSendMagicEffect(pos,5)
        return true
end

function findItemById(pos, id)
	for i = 0, 255 do
		local findd = getThingFromPos({x=pos.x, y=pos.y, z=pos.z, stackpos=i})
		if findd.itemid == id then
			explode(cid, config.min, config.max, config.damageType, pos, config.effect, id)
		end
	end
	return false
end
 
function onStepIn(cid, item, pos)
    if(item.itemid == config.itemId) then
        if(isCreature(cid)) then
            explode(cid, config.min, config.max, config.damageType, pos, config.effect, config.itemId)
        end
    end
    return true
end