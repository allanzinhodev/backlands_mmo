local temp = {
exhausted = 4
}


local confg = {
level = 35,
chakra = 30,
}

local function moviment(cid)
actionMove(cid, 385, 1100)
noMove(cid, 3300)
doCreatureSay(cid, "Katon:", TALKTYPE_MONSTER)
addEvent(doCreatureSay, 400, cid, "Karyuudan no Jutsu!", TALKTYPE_MONSTER)
addEvent(actionMove, 300, cid, 386, 1200)
setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
local level = getPlayerLevel(cid) 
local jutsuDmg = 24
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))

local function katonKaryuudan(cid, pos, toPosition)
local random = randomPos(cid, toPosition)
doSendDistanceShoot({x = pos.x+2, y = pos.y+1, z = pos.z}, random, 20)
addEvent(doAreaCombatHealth, 100, cid, COMBAT_FIREDAMAGE, random, 0, dmg, dmg, 5)
end
 if getPlayerVocation(cid) ~= 5 then
 	return true
 end

	if not isCreature(cid) then
		return true
	end
-----[Restrições]-----

	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	
-----[Restrições]-----

	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
	local pos = getCreaturePosition(cid)
	if (toPosition.y == pos.y 
	or (toPosition.y <= pos.y+1 and toPosition.x >= pos.x+2) 
	or (toPosition.y <= pos.y-1 and toPosition.x >= pos.x+2) 
	or (toPosition.y <= pos.y+2 and toPosition.x >= pos.x+4) 
	or (toPosition.y <= pos.y-2 and toPosition.x >= pos.x+4))
	and toPosition.x > pos.x then
		moviment(cid)
	local disteffect = {x = pos.x, y = pos.y, z = pos.z}
	local random = randomPos(cid, toPosition)
      for i = 1,8 do
      addEvent(katonKaryuudan, 300*i, cid, disteffect, toPosition)
      end
	elseif (toPosition.y == pos.y 
	or (toPosition.y <= pos.y+1 and toPosition.x <= pos.x-2) 
	or (toPosition.y <= pos.y-1 and toPosition.x <= pos.x-2) 
	or (toPosition.y <= pos.y+2 and toPosition.x <= pos.x-4) 
	or (toPosition.y <= pos.y-2 and toPosition.x <=  pos.x-4))
	and toPosition.x < pos.x then
		moviment(cid)
	local disteffect = {x = pos.x-2, y = pos.y, z = pos.z}
	local random = randomPos(cid, toPosition)
      for i = 1,8 do
      addEvent(katonKaryuudan, 300*i, cid, disteffect, toPosition)
      end
	elseif (toPosition.x == pos.x
	or (toPosition.y <= pos.y-2 and toPosition.x <= pos.x-1) 
	or (toPosition.y <= pos.y-2 and toPosition.x <= pos.x+1) 
	or (toPosition.y <= pos.y-5 and toPosition.x <= pos.x-2) 
	or (toPosition.y <= pos.y-5 and toPosition.x <= pos.x+2))
	and toPosition.y < pos.y then
	moviment(cid)
	local disteffect = {x = pos.x-1, y = pos.y-1, z = pos.z}
	local random = randomPos(cid, toPosition)
      for i = 1,8 do
      addEvent(katonKaryuudan, 300*i, cid, disteffect, toPosition)
      end
	elseif (toPosition.x == pos.x
	or (toPosition.y <= pos.y+2 and toPosition.x <= pos.x-1) 
	or (toPosition.y <= pos.y+2 and toPosition.x <= pos.x+1) 
	or (toPosition.y <= pos.y+5 and toPosition.x <= pos.x-2) 
	or (toPosition.y <= pos.y+5 and toPosition.x <= pos.x+2))
	and toPosition.y > pos.y then
		moviment(cid)
	local disteffect = {x = pos.x-1, y = pos.y+2, z = pos.z}
	local random = randomPos(cid, toPosition)
      for i = 1,8 do
      addEvent(katonKaryuudan, 300*i, cid, disteffect, toPosition)
      end
      end
	end
	return true
end