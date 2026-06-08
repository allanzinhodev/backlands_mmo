local temp = {
   exhausted = 4,
}

local confg = {
		level = 50,
		chakra = 80,
}


function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
      return true
	end
   
	if itemEx.uid == cid then
		return doPlayerSendCancel(cid, "You cannot use.")
	end
	
	if not isCreature(itemEx.uid) then
		doPlayerSendCancel(cid, "Use only in creatures!")		
    return true
	end

	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
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
---[Restriçoes]------
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
		return true
	end
   
		if isPlayer(cid) then
			removeChakraLife(cid, - confg.chakra)
			addEvent(doCreatureSay, 300, cid, "Kikaichuu!", TALKTYPE_MONSTER)
			addEvent(doCreatureSay, 600, cid, "Mushidama !!!", TALKTYPE_MONSTER)
			stopNow(itemEx.uid, 3000)
			stopNow(cid, 1000)
			actionMove(cid, 372, 600)
			doSendMagicEffect({x = toPosition.x+1, y = toPosition.y+1, z = toPosition.z}, 32)	
local level = getPlayerLevel(cid) 
local jutsuDmg = 19
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.20))
			addEvent(function()
			if not isCreature(cid) then return true end
			doAreaCombatHealth(cid, COMBAT_KIKAICHUU, toPosition, 0, dmg, dmg, 37)
			end, 600)
			addEvent(function()
			if not isCreature(cid) then return true end
			doAreaCombatHealth(cid, COMBAT_KIKAICHUU, toPosition, 0, dmg, dmg, 37)
			end, 1200)
			addEvent(function()
			if not isCreature(cid) then return true end
			doAreaCombatHealth(cid, COMBAT_KIKAICHUU, toPosition, 0, dmg, dmg, 37)
			end, 1800)
			setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		end
	return true
end