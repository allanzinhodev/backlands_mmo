function iniBubun(cid)
             addEvent(actionMove, 0, cid, 431, 300)
             addEvent(actionMove, 100, cid, 432, 300)
             addEvent(actionMove, 200, cid, 433, 300)
			 addEvent(actionMove, 300, cid, 434, 300)
             addEvent(actionMove, 400, cid, 435, 300)
             addEvent(actionMove, 500, cid, 436, 300)
end

function onCastSpell(cid, var)
if not isCreature(cid) then
return true
end
noMove(cid, 800)
iniBubun(cid)
addEvent(doCreatureSay, 0, cid, "Bubun..", TALKTYPE_MONSTER)
addEvent(doCreatureSay, 300, cid, "BAIKA!!!", TALKTYPE_MONSTER)
  local level = getPlayerLevel(cid) 
  local jutsuDmg = 33
  local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
  local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.25))
local find_area = getFirstCreaturePosOnDirection(cid, 2)
local pos = getCreaturePosition(cid)
if getCreatureLookDir(cid) == 0 then
addEvent(doAreaCombatHealth, 200, cid, 1, find_area, AREA_HARITE, dmg, dmg, 255)
elseif getCreatureLookDir(cid) == 1 then
addEvent(doAreaCombatHealth, 200, cid, 1, find_area, AREA_HARITE, dmg, dmg, 255)
addEvent(doSendMagicEffect, 200, {x = pos.x+2, y = pos.y, z = pos.z}, 90)
elseif getCreatureLookDir(cid) == 2 then
addEvent(doAreaCombatHealth, 200, cid, 1, find_area, AREA_HARITE, dmg, dmg, 255)
addEvent(doSendMagicEffect, 200, {x = pos.x, y = pos.y+2, z = pos.z}, 89)
elseif getCreatureLookDir(cid) == 3 then
addEvent(doAreaCombatHealth, 200, cid, 1, find_area, AREA_HARITE, dmg, dmg, 255)
end
for i = 0,1 do
addEvent(doMoveCreature2, 250+(200*i), getThingfromPos(find_area).uid, getPlayerLookDir(cid), effectdir(cid, 255, 255))
end
end