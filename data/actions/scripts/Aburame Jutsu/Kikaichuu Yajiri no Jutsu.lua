local temp = {
exhausted = 3,
}


local confg = {
level = 20,
chakra = 25,
}

function conditSquareArea(pos, condt)
local position = {
[1] = {x = pos.x+1, y = pos.y, z = pos.z , stackpos=253},
[2] = {x = pos.x, y = pos.y+1, z = pos.z , stackpos=253},
[3] = {x = pos.x-1, y = pos.y, z = pos.z , stackpos=253},
[4] = {x = pos.x, y = pos.y-1, z = pos.z , stackpos=253},
[5] = {x = pos.x+1, y = pos.y-1, z = pos.z , stackpos=253},
[6] = {x = pos.x+1, y = pos.y+1, z = pos.z , stackpos=253},
[7] = {x = pos.x-1, y = pos.y-1, z = pos.z , stackpos=253},
[8] = {x = pos.x-1, y = pos.y+1, z = pos.z , stackpos=253},
[9] = {x = pos.x, y = pos.y, z = pos.z , stackpos=253}
}
for n = 1,9 do
if isCreature(getThingfromPos(position[n]).uid) then
doAddCondition(getThingfromPos(position[n]).uid, condt)
end
end
end

slow = createConditionObject(CONDITION_PARALYZE)
setConditionParam(slow, CONDITION_PARAM_TICKS, 4000)
setConditionFormula(slow, -0.63, -0.63, -0.63, -0.63)

function onUse(cid, item, fromPosition, itemEx, toPosition)

----[Restriçoes]-----    
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You in this area pz.") end 
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
---[Restriçoes]------
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
    elseif getPlayerLevel(cid) < confg.level then
				doPlayerSendCancel(cid, "You need to be atleast level ".. confg.level ..".") 
				return true
	end
   if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		addEvent(doCreatureSay, 300, cid, "Kikkaichu..", TALKTYPE_MONSTER)
		addEvent(doCreatureSay, 600, cid, "Yajiri!!", TALKTYPE_MONSTER)
		noMove(cid, 600)
		actionMove(cid, 373, 300)
		local level = getPlayerLevel(cid) 
		local jutsuDmg = 17
		local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
		local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.20))
		for n = 1,1 do
			addEvent(conditSquareArea, 600*n, toPosition, slow)
			addEvent(doAreaCombatHealth, 600*n, cid, COMBAT_KIKAICHUU, toPosition, 1, dmg, dmg, 30)
			addEvent(doAreaCombatMana, 600*n, cid, toPosition, 1, dmg, dmg, 255)
		end
			setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		return true
	else
			doPlayerSendCancel(cid, "you do not have chakra.")
		return true
	end
end