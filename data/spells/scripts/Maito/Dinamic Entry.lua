local function onDash(cid)
	if not isCreature(cid) then
		return true
	end
local level = getPlayerLevel(cid) 
local jutsuDmg = 15
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.25))
 local poslook = getCreatureLookPosition(cid)
 poslook.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
     if isWalkable(poslook, false, false, true) then
     if not isCreature(getThingfromPos(poslook).uid) then
          doMoveCreature(cid, getPlayerLookDirection(cid))
     return TRUE
      else
          doMoveCreature(cid, getPlayerLookDirection(cid))
          doAreaCombatHealth(cid, COMBAT_PHYSICALDAMAGE, getCreaturePosition(cid), area, dmg, dmg, efeito)
     return TRUE
      end
       end
       end

function iniciarEntry(cid)
	if not isCreature(cid) then
		return true
	end
         addEvent(actionMove, 0, cid, 469, 200)
         addEvent(actionMove, 100, cid, 470, 200)
         addEvent(actionMove, 200, cid, 471, 200)
         addEvent(actionMove, 300, cid, 472, 1000)
end

function finalizarEntry(cid)
	if not isCreature(cid) then
		return true
	end
         addEvent(actionMove, 400, cid, 473, 500)
         addEvent(actionMove, 500, cid, 474, 500)
         addEvent(doRemoveCondition, 600, cid, CONDITION_OUTFIT)
end

local function dash(cid)
	if not isCreature(cid) then
		return true
	end
 local distance = 3

      for i = 0, distance do
      addEvent(onDash,160*i,cid)
       end
end

function onCastSpell(cid, var)
	if not isCreature(cid) then
		return true
	end
		 noMove(cid, 1500)	
         iniciarEntry(cid)
		 setPlayerStorageValue(cid, STORAGE_DIRECTION, 1)
         addEvent(dash, 320, cid)
		 addEvent(function()
		 if not isCreature(cid) then return true end
		 setPlayerStorageValue(cid, STORAGE_DIRECTION, 0)
		 end, 1000)
         addEvent(finalizarEntry, 1000, cid)
         addEvent(doCreatureSay, 100, cid, "DYNAMIC..", TALKTYPE_MONSTER)
		 addEvent(doCreatureSay, 600, cid, "ENTRY!!", TALKTYPE_MONSTER)
		
return false
end 