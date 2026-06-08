function onGatsuuga(cid)
	if not isCreature(cid) then
		return true
	end
local pet = getPlayerPet(cid)
	local maxDmg = (getPlayerLevel(cid) * 0.3 + getPlayerSkill(cid,0) * 3.0)
	local minDmg = (getPlayerLevel(cid) * 0.6 + getPlayerSkill(cid,0) * 3.5)
	local poslook = getCreatureLookPosition(cid)
	poslook.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
     if isWalkable(poslook, false, false, true) then
     if not isCreature(getThingfromPos(poslook).uid) then
          doMoveCreature(cid, getPlayerLookDirection(cid))
		  doMoveCreature(pet, getPlayerLookDirection(pet))
     return true
      else
          doMoveCreature(cid, getPlayerLookDirection(cid))
		  doMoveCreature(pet, getPlayerLookDirection(pet))
          doAreaCombatHealth(cid, COMBAT_PHYSICALDAMAGE, getCreaturePosition(cid), area, -minDmg, -maxDmg, efeito)
		  doAreaCombatHealth(pet, COMBAT_PHYSICALDAMAGE, getCreaturePosition(pet), area, -minDmg, -maxDmg, efeito)
     return true
      end
       end
       end

function iniciarGatsuuga(cid)
	if not isCreature(cid) then
		return true
	end
         mayNotMove(cid, true)
		 local pet = getPlayerPet(cid)
         addEvent(actionMove, 200, cid, 191, 600)
		 addEvent(actionMove, 200, pet, 191, 600)
         addEvent(mayNotMove, 310, cid, false)
end

function finalizarGatsuuga(cid)
	if not isCreature(cid) then
		return true
	end
local pet = getPlayerPet(cid)
end

function dashGatsuuga(cid)
	if not isCreature(cid) then
		return true
	end
local pet = getPlayerPet(cid)
local pos = getCreaturePosition(cid)
local ppos = getCreaturePosition(pet)
if getCreatureLookDir(cid) == 0 then
doSendMagicEffect({x=pos.x, y=pos.y-1, z=pos.z}, 62)
elseif getCreatureLookDir(cid) == 1 then
doSendMagicEffect({x=pos.x+3, y=pos.y+0, z=pos.z}, 64)
elseif getCreatureLookDir(cid) == 2 then
doSendMagicEffect({x=pos.x, y=pos.y+4, z=pos.z}, 63)
elseif getCreatureLookDir(cid) == 3 then
doSendMagicEffect({x=pos.x-1, y=pos.y, z=pos.z}, 65)
end

if getCreatureLookDir(pet) == 0 then
doSendMagicEffect({x=ppos.x, y=ppos.y-1, z=ppos.z}, 62)
elseif getCreatureLookDir(pet) == 1 then
doSendMagicEffect({x=ppos.x+3, y=ppos.y+0, z=ppos.z}, 64)
elseif getCreatureLookDir(pet) == 2 then
doSendMagicEffect({x=ppos.x, y=ppos.y+4, z=ppos.z}, 63)
elseif getCreatureLookDir(pet) == 3 then
doSendMagicEffect({x=ppos.x-1, y=ppos.y, z=ppos.z}, 65)
end

 local distance = 3

      for i = 0, distance do
      addEvent(onGatsuuga,160*i,cid)
end
end
