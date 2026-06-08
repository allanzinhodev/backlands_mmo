local temp = {
exhausted = 7,
}

local confg = {
level = 35,
chakra = 65
}


function onUse(cid, item, fromPosition, itemEx, toPosition)
-----[Restrições]-----
	if not isCreature(itemEx.uid) then
		return doPlayerSendCancel(cid, "Use only in creatures!")
	end
	if not isCreature(cid) then
		return true
	end
	if not isLooking(cid, itemEx.uid) then
		return doPlayerSendCancel(cid, "You need to look into the eyes of your enemy.")
	end
	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	
-----[Restrições]-----
	if isPlayer(cid) then
		removeChakraLife(cid , - confg.chakra)
		for n = 0,1 do
			local pos = getFirstCreaturePosOnDirection(cid,(n+1))
			local level = getPlayerLevel(cid) 
			local jutsuDmg = 50
			local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
			local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.25))
				if not isCreature(cid) then
					return true
				end
			 local poslook = getCreatureLookPosition(cid)
		if isWalkable(poslook, false, false, true) then
			local distance = getDistanceBetween(getThingPos(cid), getThingPos(getThingfromPos(toPosition).uid))
			for i = 1, distance do
				addEvent(doMoveCreature, (	600+(100*i)), cid, getCreatureLookDirection(cid))
			end
			actionMove(cid, 503, 200)
			addEvent(actionMove, 100, cid, 504, 200)
			addEvent(actionMove, 200, cid, 503, 200)
			addEvent(actionMove, 300, cid, 504, 200)
			addEvent(actionMove, 400, cid, 505, -1)
			stopNow(itemEx.uid, 4000)
			addEvent(doCreatureSetLookDirection, (600+(100*distance+25)), cid, 0)
			addEvent(doAreaCombatHealth, (600+(100*distance+2300)), cid, 1, toPosition, area, dmg, dmg, 111)
			addEvent(doAreaCombatHealth, (600+(100*distance+2400)), cid, 1, toPosition, area, 0, 0, 93)
			addEvent(iniOmote, (600+(100*distance+50)), cid, item, fromPosition, itemEx, toPosition)
			addEvent(doRemoveCondition, (600+(100*distance+50)) , cid, CONDITION_OUTFIT)
			setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
			return true
		end
	end
	end
end
