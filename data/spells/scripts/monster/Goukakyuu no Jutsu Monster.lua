function onCastSpell(cid, var)
if not isCreature(cid) then
return true
end
stopNow(cid, 500)
actionMove(cid, 551, 500)
addEvent(actionMove, 600, cid, 552, 600) 
addEvent(doCreatureSay, 200, cid, "Katon:", TALKTYPE_MONSTER)
addEvent(doCreatureSay, 600, cid, "Goukakyuu no Jutsu!", TALKTYPE_MONSTER)
local min = 60
local max = 80
local find_area = getFirstCreaturePosOnDirection(cid, 1)
local pos = getCreaturePosition(cid)
if getCreatureLookDir(cid) == 0 then
addEvent(doAreaCombatHealth, 600, cid, COMBAT_FIREDAMAGE, find_area, KATON, -min, -max, 255)
addEvent(doAreaCombatHealth, 1200, cid, COMBAT_FIREDAMAGE, find_area, KATON, -min, -max, 255)
addEvent(doSendMagicEffect, 600, {x = pos.x+1, y = pos.y-1, z = pos.z}, 17)
elseif getCreatureLookDir(cid) == 1 then
addEvent(doAreaCombatHealth, 600, cid, COMBAT_FIREDAMAGE, find_area, KATON, -min, -max, 255)
addEvent(doAreaCombatHealth, 1200, cid, COMBAT_FIREDAMAGE, find_area, KATON, -min, -max, 255)
addEvent(doSendMagicEffect, 600, {x = pos.x+5, y = pos.y+1, z = pos.z}, 18)
elseif getCreatureLookDir(cid) == 2 then
addEvent(doAreaCombatHealth, 600, cid, COMBAT_FIREDAMAGE, find_area, KATON, -min, -max, 255)
addEvent(doAreaCombatHealth, 1200, cid, COMBAT_FIREDAMAGE, find_area, KATON, -min, -max, 255)
addEvent(doSendMagicEffect, 600, {x = pos.x+1, y = pos.y+5, z = pos.z}, 19)
elseif getCreatureLookDir(cid) == 3 then
addEvent(doAreaCombatHealth, 600, cid, COMBAT_FIREDAMAGE, find_area, KATON, -min, -max, 255)
addEvent(doAreaCombatHealth, 1200, cid, COMBAT_FIREDAMAGE, find_area, KATON, -min, -max, 255)
addEvent(doSendMagicEffect, 600, {x = pos.x-1, y = pos.y+1, z = pos.z}, 16)
end
end