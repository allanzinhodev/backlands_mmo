local combat1 = createCombatObject()
local combat2 = createCombatObject()
local combat3 = createCombatObject()
local combat4 = createCombatObject()
local combat5 = createCombatObject()
local area1 = createCombatArea(Shiten)
local area2 = createCombatArea(Shiten)                                   
local area3 = createCombatArea(Shiten)                         
local area4 = createCombatArea(Shiten)
setCombatArea(combat1, area1)
setCombatArea(combat2, area2)
setCombatArea(combat3, area3)
setCombatArea(combat4, area4)
function onTargetTile1(cid, pos)
local level = getPlayerLevel(cid) 
local jutsuDmg = 26
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
quakePush(cid, pos, COMBAT_JUUKEN, dmg, dmg, effectdir(cid, 99, 97), true)
end
function onTargetTile2(cid, pos)
local level = getPlayerLevel(cid) 
local jutsuDmg = 26
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
quakePush(cid, pos, COMBAT_JUUKEN, dmg, dmg, effectdir(cid, 99, 97), true)
end
function onTargetTile3(cid, pos)
local level = getPlayerLevel(cid) 
local jutsuDmg = 26
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg =  math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
quakePush(cid, pos, COMBAT_JUUKEN, dmg, dmg, effectdir(cid, 99, 97), true)
end
function onTargetTile4(cid, pos)
local level = getPlayerLevel(cid) 
local jutsuDmg = 26
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg =  math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
quakePush(cid, pos, COMBAT_JUUKEN, dmg, dmg, effectdir(cid, 99, 97), true)
end


setCombatCallback(combat1, CALLBACK_PARAM_TARGETTILE, "onTargetTile1")
setCombatCallback(combat2, CALLBACK_PARAM_TARGETTILE, "onTargetTile2")
setCombatCallback(combat3, CALLBACK_PARAM_TARGETTILE, "onTargetTile3")
setCombatCallback(combat4, CALLBACK_PARAM_TARGETTILE, "onTargetTile4")

function onCastSpell(cid, var)
if not isCreature(cid) then
	return true
end
addEvent(doCreatureSay, 100, cid, "Shiten KUUSHOU!!!", TALKTYPE_MONSTER)
local combat = {[1] = combat1, [2] = combat2, [3] = combat3, [4] = combat4,}
stopNow(cid, 2400)
for i = 0,3 do
addEvent(actionMove, (600*i), cid, 382, 200)
addEvent(doCombat, (600*i), cid, combat[i+1], var)
end
end