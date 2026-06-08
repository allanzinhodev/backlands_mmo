function onCastSpell(cid, var)
if not isCreature(cid) then
	return true
end
if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
local level = getPlayerLevel(cid) 
local jutsuDmg = 6
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.20))
actionMove(cid, 372, 500)
addEvent(actionMove, 600, cid, 373, 1200)
	noMove(cid, 1800)
	addEvent(doCreatureSay, 100, cid, "Kikkaichu", TALKTYPE_MONSTER)
	addEvent(doCreatureSay, 400, cid, "Bashira!", TALKTYPE_MONSTER)
for n = 0,3 do
local pos = getFirstCreaturePosOnDirection(cid,(n+1))
local newpos = {x = pos.x - 7, y = pos.y - 6, z = pos.z}
	addEvent(doSendDistanceShoot, 600+400*n, newpos, pos, 41)
	addEvent(doAreaCombatHealth, 600+400*n, cid, COMBAT_KIKAICHUU, getFirstCreaturePosOnDirection(cid,(n+1)), 0, dmg, dmg, 31)
	end
end