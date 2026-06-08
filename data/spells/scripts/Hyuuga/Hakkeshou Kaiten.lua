function onCastSpell(cid, var)
		if not isCreature(cid) then
				return true
		end
		local area = {
				{1, 1, 1},
				{1, 2, 1},
				{1, 1, 1},
		}
		actionMove(cid, 382, 1000)
		addEvent(actionMove, 1000, cid, 379, 2300)
		if getPlayerLookDir(cid) == 0 then
		addEvent(function()
		doCreatureSetLookDir(cid, 3)
		if not isCreature(cid) then return true end 
		end, 700)
		addEvent(function()
		doCreatureSetLookDir(cid, 0)
		if not isCreature(cid) then return true end 
		end, 2200)
		end
		if getPlayerLookDir(cid) == 1 then
		addEvent(function()
		doCreatureSetLookDir(cid, 0)
		if not isCreature(cid) then return true end 
		end, 700)
		addEvent(function()
		doCreatureSetLookDir(cid, 1)
		if not isCreature(cid) then return true end 
		end, 2200)
		end
		if getPlayerLookDir(cid) == 2 then
		addEvent(function()
		doCreatureSetLookDir(cid, 1)
		if not isCreature(cid) then return true end 
		end, 700)
		addEvent(function()
		doCreatureSetLookDir(cid, 2)
		if not isCreature(cid) then return true end 
		end, 2200)
		end
		if getPlayerLookDir(cid) == 3 then
		addEvent(function()
		doCreatureSetLookDir(cid, 2)
		if not isCreature(cid) then return true end 
		end, 700)
		addEvent(function()
		doCreatureSetLookDir(cid, 3)
		if not isCreature(cid) then return true end 
		end, 2850)
		end
		noMove(cid, 3500)
		addEvent(doCreatureSay, 800, cid, "Kaiten!", TALKTYPE_MONSTER)
		local level = getPlayerLevel(cid) 
		local jutsuDmg = 10
		local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/3)
		local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
		local pos = getCreaturePosition(cid)
		addEvent(doSendMagicEffect, 900, {x = pos.x+1, y = pos.y+1, z = pos.z}, 105)
		addEvent(doSendMagicEffect, 1400, {x = pos.x+1, y = pos.y+1, z = pos.z}, 105)
		addEvent(doSendMagicEffect, 1800, {x = pos.x+1, y = pos.y+1, z = pos.z}, 105)
		addEvent(Defense, 500, cid, 1600)
		pos = getPosfromArea(cid,area)
		n = 0
		while n < #pos do
				n = n+1
				addEvent(quakePush, 900, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z}, COMBAT_JUUKEN, -dmg, -dmg, 255, true)
				addEvent(quakePush, 1400, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z}, COMBAT_JUUKEN, -dmg, -dmg, 255, true)
				addEvent(quakePush, 1800, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z},COMBAT_JUUKEN, -dmg, -dmg, 255, true)
				addEvent(quakePush, 1850, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z}, COMBAT_JUUKEN, -dmg, -dmg, 255, true)
		end
end