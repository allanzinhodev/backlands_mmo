local temp = {
exhausted = 3,
}


local confg = {
level = 35,
chakra = 50,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
if not isCreature(cid) then
return true
end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
----[Restriçoes]-----    
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You in this area pz.")
	end 
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
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
		addEvent(doCreatureSay, 100, cid, "Kikkaichu", TALKTYPE_MONSTER)
		addEvent(doCreatureSay, 400, cid, "Tsumoji !", TALKTYPE_MONSTER)
		noMove(cid, 900)
		actionMove(cid, 372, 100)
		addEvent(actionMove, 300, cid, 373, 500)
		local level = getPlayerLevel(cid) 
		local jutsuDmg = 24
		local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
		local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.20))
		addEvent(doAreaCombatHealth, 400, cid, COMBAT_KIKAICHUU, toPosition, 0, dmg, dmg, 35)
		addEvent(doAreaCombatHealth, 700, cid, COMBAT_KIKAICHUU, toPosition, 0, dmg, dmg, 35)
		addEvent(doAreaCombatMana, 400, cid, toPosition, 1, -dmg, -dmg, 255)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	else
		doPlayerSendCancel(cid, "You do not have chakra.")
		return true
	end
end