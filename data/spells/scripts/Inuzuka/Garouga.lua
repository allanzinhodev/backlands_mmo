local function onDash(cid)
	if not isCreature(cid) then
		return true
	end
local level = getPlayerLevel(cid) 
local jutsuDmg = 26
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
	local poslook = getCreatureLookPosition(cid)
	poslook.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
     if isWalkable(poslook, false, false, true) then
     	if not isCreature(getThingfromPos(poslook).uid) then
          	doMoveCreature(cid, getPlayerLookDirection(cid))
     	return true
      	else
         	doMoveCreature(cid, getPlayerLookDirection(cid))
         	doAreaCombatHealth(cid, COMBAT_PHYSICALDAMAGE, getCreaturePosition(cid), area, -dmg, -dmg, efeito)
     	return true
      end
    end
end

local function iniciarGarouga(cid)
	if not isCreature(cid) then
		return true
	end
         mayNotMove(cid, true)
         addEvent(actionMove, 200, cid, 191, 600)
         addEvent(mayNotMove, 310, cid, false)
end

local function finalizarGarouga(cid)
	if not isCreature(cid) then
		return true
	end
         addEvent(doRemoveCondition, 600, cid, CONDITION_OUTFIT)
end

local function dashGarouga(cid)
	if not isCreature(cid) then
		return true
	end

local pos = getCreaturePosition(cid)
if getCreatureLookDir(cid) == 0 then
doSendMagicEffect({x=pos.x, y=pos.y-1, z=pos.z}, 68)
elseif getCreatureLookDir(cid) == 1 then
doSendMagicEffect({x=pos.x+4, y=pos.y+0, z=pos.z}, 69)
elseif getCreatureLookDir(cid) == 2 then
doSendMagicEffect({x=pos.x, y=pos.y+4, z=pos.z}, 67)
elseif getCreatureLookDir(cid) == 3 then
doSendMagicEffect({x=pos.x-1, y=pos.y, z=pos.z}, 70)
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
         iniciarGarouga(cid)
		 setPlayerStorageValue(cid, STORAGE_DIRECTION, 1)
         addEvent(dashGarouga, 320, cid)
		 addEvent(function()
		 if not isCreature(cid) then return true end
		 setPlayerStorageValue(cid, STORAGE_DIRECTION, 0)
		 end, 1000)
         addEvent(finalizarGarouga, 1000, cid)
         addEvent(doCreatureSay, 0, cid, "GAAAA", TALKTYPE_MONSTER)
		 addEvent(doCreatureSay, 500, cid, "ROUUGA!!!", TALKTYPE_MONSTER)
end 