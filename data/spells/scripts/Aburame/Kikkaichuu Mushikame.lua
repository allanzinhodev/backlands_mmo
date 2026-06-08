function onCastSpell(cid, var)
		if not isCreature(cid) then
				return true
		end
		local area = {
				{1, 1, 1},
				{1, 2, 1},
				{1, 1, 1},
		}
	
        actionMove(cid, 372, 500)
        addEvent(actionMove, 500, cid, 373, 1800)
        noMove(cid, 2400)
        addEvent(doCreatureSay, 200, cid, "Kikkaichu", TALKTYPE_MONSTER)
        addEvent(doCreatureSay, 500, cid, "Mushikame!!", TALKTYPE_MONSTER)
        local level = getPlayerLevel(cid) 
		local jutsuDmg = 19
		local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
		local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.20))
		local pos = getCreaturePosition(cid)
		addEvent(doSendMagicEffect, 300, {x = pos.x+1, y = pos.y+1, z = pos.z}, 36)
		addEvent(doSendMagicEffect, 800, {x = pos.x+1, y = pos.y+1, z = pos.z}, 36)
		addEvent(doSendMagicEffect, 1300, {x = pos.x+1, y = pos.y+1, z = pos.z}, 36)
		addEvent(Defense, 300, cid, 1700)
		pos = getPosfromArea(cid,area)
		n = 0
		while n < #pos do
				n = n+1
				addEvent(quakePush, 350, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z}, COMBAT_KIKAICHUU, -dmg, -dmg, 255, true)
				addEvent(quakePush, 850, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z}, COMBAT_KIKAICHUU, -dmg, -dmg, 255, true)
				addEvent(quakePush, 1350, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z}, COMBAT_KIKAICHUU, -dmg, -dmg, 255, true)
				addEvent(quakePush, 1850, cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z}, COMBAT_KIKAICHUU, -dmg, -dmg, 255, true)
		end
end