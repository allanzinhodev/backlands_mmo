function onCastSpell(cid, var)
if not isCreature(cid) then
return true
end
local level = getPlayerLevel(cid) 
local jutsuDmg = 12
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
local find_area = getFirstCreaturePosOnDirection(cid,1)
local pos = getCreaturePosition(cid)
actionMove(cid, 382, 500)
addEvent(actionMove, 600, cid, 378, 500)
noMove(cid, 600)
if isPlayer(getThingfromPos(find_area).uid) then
doPlayerAddMana(getThingfromPos(find_area).uid, (dmg/2))
end
addEvent(doCreatureSay, 300, cid, "Hiasangi!", TALKTYPE_MONSTER)
addEvent(doAreaCombatHealth, 600, cid, COMBAT_JUUKEN, find_area, 0, dmg, dmg, 56)
addEvent(doSendMagicEffect, 600, find_area, 1)
end