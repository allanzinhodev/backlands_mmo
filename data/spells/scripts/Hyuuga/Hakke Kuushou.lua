local combat1 = createCombatObject()
local combat2 = createCombatObject()
local combat3 = createCombatObject()
local combat4 = createCombatObject()
local area1 = createCombatArea(WAVE1)
local area2 = createCombatArea(WAVE2)                                   
local area3 = createCombatArea(WAVE3)                         
local area4 = createCombatArea(WAVE4)
setCombatArea(combat1, area1)
setCombatArea(combat2, area2)
setCombatArea(combat3, area3)
setCombatArea(combat4, area4)
function onTargetTile1(cid, pos)
local level = getPlayerLevel(cid) 
local jutsuDmg = 14
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
quake(cid, pos, COMBAT_JUUKEN, -dmg, -dmg, effectdir(cid, 99, 97), true)
end
function onTargetTile2(cid, pos)
local level = getPlayerLevel(cid) 
local jutsuDmg = 14
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
quake(cid, pos, COMBAT_JUUKEN, -dmg, -dmg, effectdir(cid, 99, 97), true)
end
function onTargetTile3(cid, pos)
local level = getPlayerLevel(cid) 
local jutsuDmg = 14
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
quake(cid, pos, COMBAT_JUUKEN, -dmg, -dmg, effectdir(cid, 99, 97), true)
end
function onTargetTile4(cid, pos)
local level = getPlayerLevel(cid) 
local jutsuDmg = 14
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
quake(cid, pos, COMBAT_JUUKEN, -dmg, -dmg, effectdir(cid, 99, 97), true)
end

setCombatCallback(combat1, CALLBACK_PARAM_TARGETTILE, "onTargetTile1")
setCombatCallback(combat2, CALLBACK_PARAM_TARGETTILE, "onTargetTile2")
setCombatCallback(combat3, CALLBACK_PARAM_TARGETTILE, "onTargetTile3")
setCombatCallback(combat4, CALLBACK_PARAM_TARGETTILE, "onTargetTile4")

function onCastSpell(cid, var)
if not isCreature(cid) then
return true
end
actionMove(cid, 382, 600)
noMove(cid, 600)
addEvent(doCreatureSay, 100, cid, "Kuushou!", TALKTYPE_MONSTER)
local combat = {[1] = combat1, [2] = combat2, [3] = combat3, [4] = combat4,}
for i = 0,3 do
addEvent(doCombat, (200*i), cid, combat[i+1], var)
end
end