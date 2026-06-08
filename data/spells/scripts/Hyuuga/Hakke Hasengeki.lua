function onCastSpell(cid, var)
if not isCreature(cid) then
	return true
end
local level = getPlayerLevel(cid) 
local jutsuDmg = 26
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
local find_area = getFirstCreaturePosOnDirection(cid,1)
local pos = getCreaturePosition(cid)
actionMove(cid, 377, 600)
stopNow(cid, 600)
if isPlayer(getThingfromPos(find_area).uid) then
doPlayerAddMana(getThingfromPos(find_area).uid, -(dmg/2))
end
addEvent(doCreatureSay, 100, cid, "Hasengeki!", TALKTYPE_MONSTER)
if getCreatureLookDir(cid) == 0 then
doAreaCombatHealth(cid, COMBAT_JUUKEN, find_area, KAGE1, dmg, dmg, 255)
doSendMagicEffect({x = pos.x, y = pos.y-1, z = pos.z}, 58)
elseif getCreatureLookDir(cid) == 1 then
doAreaCombatHealth(cid, COMBAT_JUUKEN, find_area, KAGE1, dmg, dmg, 255)
doSendMagicEffect({x = pos.x+4, y = pos.y, z = pos.z}, 59)
elseif getCreatureLookDir(cid) == 2 then
doAreaCombatHealth(cid, COMBAT_JUUKEN, find_area, KAGE1, dmg, dmg, 255)
doSendMagicEffect({x = pos.x, y = pos.y+4, z = pos.z}, 57)
elseif getCreatureLookDir(cid) == 3 then
doAreaCombatHealth(cid, COMBAT_JUUKEN, find_area, KAGE1, dmg, dmg, 255)
doSendMagicEffect({x = pos.x-1, y = pos.y, z = pos.z}, 60)
end
for i = 1,3 do
addEvent(doMoveCreature2, 100*i, getThingfromPos(find_area).uid, getPlayerLookDir(cid), effectdir(cid, 54, 55))
	end
end