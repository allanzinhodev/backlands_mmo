function onUse(cid, item, fromPosition, itemEx, toPosition)
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot throw while you are molding chakra.")
	end
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot throw while you are resting.")
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "You cannot use throw while you are in kagemane.")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end

local kunai = 12685
local shuriken = 2399
local kunaiexplosiva = 13227
local senbom = 13033
local fuumashuriken = 13035
local slot = getPlayerSlotItem(cid, CONST_SLOT_LEFT)
	if slot.itemid ~= kunai and slot.itemid ~= shuriken and slot.itemid ~= kunaiexplosiva and slot.itemid ~= senbom and slot.itemid ~= fuumashuriken then
		return doPlayerSendCancel(cid, "put the kunai's or shurikens and senbons in pocket.")
	end
	if getPlayerItemCount(cid, kunai) >= 1 and slot.itemid == kunai then
		local min = (8 + (getPlayerSkill(cid,4)*0.3))
		local max = (10 + (getPlayerSkill(cid,4)*0.7))
		addEvent(doSendDistanceShoot, 100, getCreaturePosition(cid), toPosition, 1)
		addEvent(doAreaCombatHealth, 200, cid, 1, toPosition, 0, -min, -max, 3)
		addEvent(doCreateItem, 500, kunai, 1, toPosition)
		doPlayerRemoveItem(cid,kunai,1)
	elseif getPlayerItemCount(cid, shuriken) >= 1 and slot.itemid == shuriken then
		local min = (6 +(getPlayerSkill(cid,4)*0.3))
		local max = (8 +(getPlayerSkill(cid,4)*0.7))
		addEvent(doSendDistanceShoot, 100, getCreaturePosition(cid), toPosition, 7)
		addEvent(doAreaCombatHealth, 200, cid, 1, toPosition, 0, -min, -max, 3)
		addEvent(doCreateItem, 500, shuriken, 1, toPosition)
		doPlayerRemoveItem(cid, shuriken,1)
	elseif getPlayerItemCount(cid, kunaiexplosiva) >= 1 and slot.itemid == kunaiexplosiva then
		local min = (13 + (getPlayerSkill(cid,4)*0.3))
		local max = (16 + (getPlayerSkill(cid,4)*0.7))
		addEvent(doSendDistanceShoot, 100, getCreaturePosition(cid), toPosition, 2)
		addEvent(doSendMagicEffect, 300, toPosition, 138)
		addEvent(doAreaCombatHealth, 1100, cid, 1, toPosition, 0, -min, -max, 5)
		doPlayerRemoveItem(cid, kunaiexplosiva,1)
	elseif getPlayerItemCount(cid, senbom) >= 1 and slot.itemid == senbom then
		local min = (16 +(getPlayerSkill(cid,4)*0.3))
		local max = (18 +(getPlayerSkill(cid,4)*0.7))
		addEvent(doSendDistanceShoot, 100, getCreaturePosition(cid), toPosition, 40)
		addEvent(doAreaCombatHealth, 200, cid, 1, toPosition, 0, -min, -max, 3)
		addEvent(doCreateItem, 500, senbom, 1, toPosition)
		doPlayerRemoveItem(cid, senbom,1)
	elseif getPlayerItemCount(cid, fuumashuriken) >= 1 and slot.itemid == fuumashuriken then
		local min = (18 +(getPlayerSkill(cid,4)*0.3))
		local max = (20 +(getPlayerSkill(cid,4)*0.7))
		addEvent(doSendDistanceShoot, 100, getCreaturePosition(cid), toPosition, 6)
		addEvent(doAreaCombatHealth, 200, cid, 1, toPosition, 0, -min, -max, 3)
		addEvent(doCreateItem, 500, fuumashuriken, 1, toPosition)
		doPlayerRemoveItem(cid, fuumashuriken,1)
	end
	
	-- Quest Tetsuo//
	if itemEx.itemid == 1223 then
		local posDoor = {x = 2542, y = 2069, z = 11}
		if doComparePositions(toPosition, posDoor) then
		doTransformItem(getThingfromPos({x=2542,y=2069,z=11,stackpos = 1}).uid,1219)
		doSendMagicEffect(getThingfromPos({x=2542,y=2069,z=11}), 11)
		doSendAnimatedText(getThingfromPos({x=2542,y=2069,z=11}), "BROKE", COLOR_RED)
		end
	end

	----------
end

