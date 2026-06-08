local CONDICAO_POISON = createConditionObject(CONDITION_POISON)
  setConditionParam(CONDICAO_POISON, CONDITION_PARAM_TICKINVERVAL, 10000)  
  addDamageCondition(CONDICAO_POISON, 10, 2000, -1)


function onCastSpell(cid, var)
	if not isCreature(cid) then
		return true
	end
		local pet = getPlayerPet(cid)
		local find_area = getFirstCreaturePosOnDirection(pet, 1)
		local level = getPlayerLevel(cid) 
		local jutsuDmg = 6
		local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
		local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
		actionMove(pet, 398, 600)
		doCreatureSetLookDirection(pet, 0)
		stopNow(pet, 500)
		doAreaCombatHealth(cid, 1, getThingPos(pet), Marking_area, dmg, dmg, 72)
		addEvent(doAreaCombatHealth, 200, cid, 1, getThingPos(pet), Marking_area, dmg, dmg, 72)
		doAreaCombatCondition(cid, getThingPos(pet), Marking_area, CONDICAO_POISON, 72)
		doCreatureSay(cid, "Dynamic Marking", TALKTYPE_MONSTER)
end 