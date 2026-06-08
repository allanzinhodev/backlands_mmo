local temp = {
exhausted = 2,
}

local confg = {
chakra = 5,
}


function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
		return true
	end

local level = getPlayerLevel(cid) 
local jutsuDmg = 12
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))

-----[Restrições]-----
 if getPlayerVocation(cid) ~= 5 then
 	return true
 end

	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	

-----[Restrições]-----
   if isPlayer(cid) then
        removeChakraLife(cid, - confg.chakra)
		addEvent(doCreatureSay, 100, cid, "Katon:", TALKTYPE_MONSTER)
		addEvent(doCreatureSay, 300, cid, "Endan no Jutsu!", TALKTYPE_MONSTER)
		stopNow(cid, 800)
		addEvent(actionMove, 0, cid, 385, 200)
		addEvent(actionMove, 300, cid, 386, 300)


		addEvent(doSendDistanceShoot, 300, getCreaturePosition(cid), toPosition, 27)
		addEvent(doAreaCombatHealth, 400, cid, COMBAT_FIREDAMAGE, toPosition, 0, dmg, dmg, 5)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
	return true
end