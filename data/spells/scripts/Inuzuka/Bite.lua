local CONDICAO_DRUNK = createConditionObject(CONDITION_DRUNK)
  setConditionParam(CONDICAO_DRUNK, CONDITION_PARAM_TICKINVERVAL, 10000)  


function onCastSpell(cid, var)
	if not isCreature(cid) then
		return true
	end
		local pet = getPlayerPet(cid)
		local find_area = getFirstCreaturePosOnDirection(pet, 1)
local level = getPlayerLevel(cid) 
local jutsuDmg = 8
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
		stopNow(pet, 500)
		doAreaCombatHealth(cid, 1, find_area, 0, 0, 0, 77)
		doAreaCombatHealth(cid, 1, getThingPos(pet), Marking_area, dmg, dmg, 255)
		doAreaCombatCondition(cid, getThingPos(pet), Marking_area, CONDICAO_DRUNK, 255)
		doCreatureSay(cid, "Bite!!", TALKTYPE_MONSTER)
end 