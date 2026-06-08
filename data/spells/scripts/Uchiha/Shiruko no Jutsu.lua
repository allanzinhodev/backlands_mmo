local combat1 = createCombatObject()

local combat2 = createCombatObject()

local combat3 = createCombatObject()

local combat4 = createCombatObject()

local combat5 = createCombatObject()

local arr1 = {
{0, 3, 0,},
}

local arr2 = {
{0, 1, 0,},
{0, 2, 0,},
}

local arr3 = {
{0, 1, 0,},
{0, 0, 0,},
{0, 2, 0,},
}

local arr4 = {
{0, 1, 0,},
{0, 0, 0,},
{0, 0, 0,},
{0, 2, 0,},
}

local arr5 = {
{0, 1, 0,},
{0, 0, 0,},
{0, 0, 0,},
{0, 0, 0,},
{0, 2, 0,},
}

local area1 = createCombatArea(arr1)
local area2 = createCombatArea(arr2)
local area3 = createCombatArea(arr3)
local area4 = createCombatArea(arr4)
local area5 = createCombatArea(arr5)
setCombatArea(combat1, area1)
setCombatArea(combat2, area2)
setCombatArea(combat3, area3)
setCombatArea(combat4, area4)
setCombatArea(combat5, area5)

function onTargetTile1(cid, pos)
doSendDistanceShoot(getCreaturePosition(cid), pos, 8)
end
function onTargetTile2(cid, pos)
doSendDistanceShoot(getCreaturePosition(cid), pos, 8)
end
function onTargetTile3(cid, pos)
doSendDistanceShoot(getCreaturePosition(cid), pos, 8)
end
function onTargetTile4(cid, pos)
doSendDistanceShoot(getCreaturePosition(cid), pos, 8)
end
function onTargetTile5(cid, pos)
doSendDistanceShoot(getCreaturePosition(cid), pos, 8)
end
setCombatCallback(combat1, CALLBACK_PARAM_TARGETTILE, "onTargetTile1")
setCombatCallback(combat2, CALLBACK_PARAM_TARGETTILE, "onTargetTile2")
setCombatCallback(combat3, CALLBACK_PARAM_TARGETTILE, "onTargetTile3")
setCombatCallback(combat4, CALLBACK_PARAM_TARGETTILE, "onTargetTile4")
setCombatCallback(combat5, CALLBACK_PARAM_TARGETTILE, "onTargetTile5")

function onCastSpell(cid, var) 
	if not isCreature(cid) then
		return true
	end

local level = getPlayerLevel(cid) 
local jutsuDmg = 22
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))


	addEvent(doCreatureSay, 500, cid, "Katon:", TALKTYPE_MONSTER)
	addEvent(doCreatureSay, 1000, cid, "Shiruko no Jutsu!", TALKTYPE_MONSTER)
	noMove(cid, 1800)
	actionMove(cid, 385, 1000)
	addEvent(actionMove, 1000, cid, 386, 800)
local combat = {[1] = combat1, [2] = combat2, [3] = combat3, [4] = combat4,}
local area = {[1] = area1, [2] = area2, [3] = area3, [4] = area4,}
	for i = 0,3 do
		addEvent(doCombat, (1000 +(100*i)), cid, combat[i+1], var)
		addEvent(doAreaCombatHealth, (1000 +(100*i)), cid, COMBAT_FIREDAMAGE, getFirstCreaturePosOnDirection(cid,1), area[i+1], dmg, dmg, 4)
	end
	addEvent(doCombat, 1600, cid, combat5, var)
	addEvent(doAreaCombatHealth, 1600, cid, COMBAT_FIREDAMAGE, getFirstCreaturePosOnDirection(cid,1), area5, dmg, dmg, 4)
end