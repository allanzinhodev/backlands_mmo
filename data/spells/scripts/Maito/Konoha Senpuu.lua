function iniSenpuu(cid)
  mayNotMove(cid, true)
  addEvent(actionMove, 0, cid, 475, 300)
  addEvent(actionMove, 100, cid, 476, 300)
  addEvent(actionMove, 200, cid, 477, 300)
  addEvent(actionMove, 300, cid, 478, 300)
  addEvent(actionMove, 400, cid, 479, 300)
  addEvent(actionMove, 500, cid, 480, 200)
    addEvent(actionMove, 700, cid, 474, 300)
  addEvent(doRemoveCondition, 900, cid, CONDITION_OUTFIT)
end


function onCastSpell(cid, var)
		if not isCreature(cid) then
				return true
		end
iniSenpuu(cid)
		local area = {
				{1, 1, 1},
				{1, 2, 1},
				{1, 1, 1},
		}
	
		stopNow(cid, 900)
		addEvent(doCreatureSay, 100, cid, "KONOHA!", TALKTYPE_MONSTER)
		addEvent(doCreatureSay, 400, cid, "SENPUU!", TALKTYPE_MONSTER)
	local level = getPlayerLevel(cid) 
	local jutsuDmg = 12
	local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
	local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.25))
		local pos = getCreaturePosition(cid)
		pos = getPosfromArea(cid,area)
		n = 0
		while n < #pos do
				n = n+1
				addEvent(quake, 500, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z}, COMBAT_PHYSICALDAMAGE, -dmg, -dmg, 255, true)
		end
end