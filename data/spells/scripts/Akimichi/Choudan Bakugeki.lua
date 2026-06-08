function iniChoudan(cid)
             addEvent(actionMove, 0, cid, 527, 300)
             addEvent(actionMove, 100, cid, 528, 300)
             addEvent(actionMove, 200, cid, 529, 300)
			 addEvent(actionMove, 300, cid, 530, 300)
             addEvent(actionMove, 400, cid, 531, 300)
             addEvent(actionMove, 500, cid, 532, 300)
end

function onCastSpell(cid, var)
if not isCreature(cid) then
return true
end

		local area = {
				{1, 1, 1},
				{1, 2, 1},
				{1, 1, 1},
		}

noMove(cid, 1000)
iniChoudan(cid)
addEvent(doCreatureSay, 0, cid, "Choudan..", TALKTYPE_MONSTER)
addEvent(doCreatureSay, 300, cid, "BAKUGEKII!!!", TALKTYPE_MONSTER)
  local level = getPlayerLevel(cid) 
  local jutsuDmg = 30
  local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
  local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.25))
local find_area = getFirstCreaturePosOnDirection(cid, 1)
local pos = getCreaturePosition(cid)
if getCreatureLookDir(cid) == 0 then
addEvent(doAreaCombatHealth, 400, cid, 1, find_area, AREA_HARITE, dmg, dmg, 88)
doSendMagicEffect(getThingPos(cid), 106)
elseif getCreatureLookDir(cid) == 1 then
addEvent(doAreaCombatHealth, 400, cid, 1, find_area, AREA_HARITE, dmg, dmg, 88)
doSendMagicEffect(getThingPos(cid), 106)
elseif getCreatureLookDir(cid) == 2 then
addEvent(doAreaCombatHealth, 400, cid, 1, find_area, AREA_HARITE, dmg, dmg, 88)
doSendMagicEffect(getThingPos(cid), 106)
elseif getCreatureLookDir(cid) == 3 then
addEvent(doAreaCombatHealth, 400, cid, 1, find_area, AREA_HARITE, dmg, dmg, 88)
doSendMagicEffect(getThingPos(cid), 106)
end
for i = 0,1 do
addEvent(doMoveCreature2, 450+(100*i), getThingfromPos(find_area).uid, getPlayerLookDir(cid), effectdir(cid, 255, 255))
end
end