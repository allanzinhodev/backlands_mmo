local temp = {
exhausted = 2,
}

local confg = {
chakra = 15,
}

local condition = createConditionObject(CONDITION_FIRE)
setConditionParam(condition, CONDITION_PARAM_DELAYED, 1)
addDamageCondition(condition, 7, 1000, -2)

function onUse(cid, item, fromPosition, itemEx, toPosition)
	
-----[Restrições]-----
	if  impossibleUse(cid) then return true end
	if 	checkDoing(cid) then return true end
-----[Restrições]-----

	if itemEx.uid == cid then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")	
	end
 	if getPlayerVocation(cid) ~= 5 then
 		return true
	 end

local level = getPlayerLevel(cid) 
local jutsuDmg = 15
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.25))

	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		stopNow(cid, 1000)
		actionMove(cid, 385, 500)
		addEvent(actionMove, 600, cid, 386, 100) 
		addEvent(doCreatureSay, 200, cid, "Katon:", TALKTYPE_MONSTER)
		addEvent(doCreatureSay, 600, cid, "Housenka no Jutsu!", TALKTYPE_MONSTER)
		addEvent(actionMove, 900, cid, 386, 100)
		addEvent(doAreaCombatHealth, 600, cid, COMBAT_FIREDAMAGE, toPosition, 0, dmg, dmg, 4)
		for i = 1,5 do
		local random = randomPos(cid, toPosition)
		addEvent(doSendDistanceShoot, 600+(1*i), getCreaturePosition(cid), random, 8)
		addEvent(doAreaCombatHealth, 600+(1*i), cid, COMBAT_FIREDAMAGE, random, 0, dmg, dmg, 4)
		addEvent(doAreaCombatCondition, 600+(1*i), cid, random, 0, condition, 4)
	end

	for k = 1,5 do
		local random2 = randomPos(cid, toPosition)
		addEvent(doSendDistanceShoot, 900+(100*k), getCreaturePosition(cid), random2, 8)
		local combat = addEvent(doAreaCombatHealth, 900+(100*k), cid, COMBAT_FIREDAMAGE, random2, 0, dmg, dmg, 4)
		addEvent(doAreaCombatCondition, 900+(1*k), cid, random2, 0, condition, 4)
	end

		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		return true
	end
end