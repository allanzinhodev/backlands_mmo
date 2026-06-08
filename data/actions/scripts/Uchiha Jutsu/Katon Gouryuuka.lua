local temp = {
exhausted = 3,
}

local confg = {
level = 50,
chakra = 45,
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
		return true
	end
local level = getPlayerLevel(cid) 
local jutsuDmg = 27
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
-----[Restrições]-----

	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	

	if getPlayerVocation(cid) ~= 5 then
 		return true
 	end
------------------------
	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		addEvent(doCreatureSay, 100, cid, "Katon:", TALKTYPE_MONSTER)
		addEvent(doCreatureSay, 300, cid, "Gouryuuka no Jutsu!!!", TALKTYPE_MONSTER)
		noMove(cid, 2100)
		addEvent(actionMove, 0, cid, 385, 200)
		addEvent(actionMove, 300, cid, 386, 300)

		for i = 1,8 do
		local random = randomPos(cid, toPosition)
			addEvent(doSendDistanceShoot, 300+(200*i), getCreaturePosition(cid), random, 11)
				addEvent(doAreaCombatHealth, 300+(200*i), cid, COMBAT_FIREDAMAGE, random, 0, dmg, dmg, 5)
			end
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end