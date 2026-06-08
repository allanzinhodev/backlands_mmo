function iniHarite(cid)
             addEvent(actionMove, 0, cid, 438, 300)
             addEvent(actionMove, 100, cid, 439, 300)
             addEvent(actionMove, 200, cid, 440, 300)
			 addEvent(actionMove, 300, cid, 441, 300)
             addEvent(actionMove, 400, cid, 442, 300)
             addEvent(actionMove, 500, cid, 443, 300)
end

function onCastSpell(cid, var)
if not isCreature(cid) then
return true
end
noMove(cid, 700)
iniHarite(cid)
addEvent(doCreatureSay, 0, cid, "Harite..", TALKTYPE_MONSTER)
addEvent(doCreatureSay, 300, cid, "Chou!!!", TALKTYPE_MONSTER)
  local level = getPlayerLevel(cid) 
  local jutsuDmg = 26
  local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
  local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.25))
local find_area = getFirstCreaturePosOnDirection(cid, 2)
local pos = getCreaturePosition(cid)
if getCreatureLookDir(cid) == 0 then
addEvent(doAreaCombatHealth, 400, cid, 1, find_area, AREA_HARITE, dmg, dmg, 255)
elseif getCreatureLookDir(cid) == 1 then
addEvent(doAreaCombatHealth, 400, cid, 1, find_area, AREA_HARITE, dmg, dmg, 255)
addEvent(doSendMagicEffect, 300, {x = pos.x+3, y = pos.y, z = pos.z}, 92)
elseif getCreatureLookDir(cid) == 2 then
addEvent(doAreaCombatHealth, 400, cid, 1, find_area, AREA_HARITE, dmg, dmg, 255)
addEvent(doSendMagicEffect, 300, {x = pos.x, y = pos.y+3, z = pos.z}, 91)
elseif getCreatureLookDir(cid) == 3 then
addEvent(doAreaCombatHealth, 400, cid, 1, find_area, AREA_HARITE, dmg, dmg, 255)
end
end