local function olhos(uid)
local pos = getThingPos(uid)
         doSendMagicEffect({x=pos.x+3, y=pos.y-1, z=pos.z}, 50, uid) -- Esquerdo
         doSendMagicEffect({x=pos.x-2, y=pos.y-1, z=pos.z}, 52, uid) -- Direito
end

local function effect(uid, life, times, effectFire, effectExplosion, effectThunder)

local pos = getThingPos(uid)
             addEvent(doSendMagicEffect, 800, {x=pos.x+math.random(-4, 4), y=pos.y+math.random(1, 4), z=pos.z}, 5, uid)
             addEvent(doSendMagicEffect, 800, {x=pos.x-math.random(-4, 4), y=pos.y-math.random(1, 4), z=pos.z}, 14, uid)
             addEvent(doSendMagicEffect, 1000, {x=pos.x+math.random(-4, 4), y=pos.y+math.random(1, 4), z=pos.z}, 14, uid)
             addEvent(doSendMagicEffect, 1000, {x=pos.x-math.random(-4, 4), y=pos.y-math.random(1, 4), z=pos.z}, 5, uid)
			 addEvent(doSendMagicEffect, 1600, {x=pos.x+math.random(-4, 4), y=pos.y+math.random(1, 4), z=pos.z}, 5, uid)
             addEvent(doSendMagicEffect, 1600, {x=pos.x-math.random(-4, 4), y=pos.y-math.random(1, 4), z=pos.z}, 14, uid)
             addEvent(doSendMagicEffect, 1900, {x=pos.x+math.random(-4, 4), y=pos.y+math.random(1, 4), z=pos.z}, 14, uid)
             addEvent(doSendMagicEffect, 1900, {x=pos.x-math.random(-4, 4), y=pos.y-math.random(1, 4), z=pos.z}, 5, uid)
			 addEvent(doSendMagicEffect, 2400, {x=pos.x+math.random(-4, 4), y=pos.y+math.random(1, 4), z=pos.z}, 5, uid)
             addEvent(doSendMagicEffect, 2400, {x=pos.x-math.random(-4, 4), y=pos.y-math.random(1, 4), z=pos.z}, 14, uid)
             addEvent(doSendMagicEffect, 2800, {x=pos.x+math.random(-4, 4), y=pos.y+math.random(1, 4), z=pos.z}, 14, uid)
             addEvent(doSendMagicEffect, 2800, {x=pos.x-math.random(-4, 4), y=pos.y-math.random(1, 4), z=pos.z}, 5, uid)
			 addEvent(doSendMagicEffect, 3200, {x=pos.x+math.random(-4, 4), y=pos.y+math.random(1, 4), z=pos.z}, 5, uid)
             addEvent(doSendMagicEffect, 3200, {x=pos.x-math.random(-4, 4), y=pos.y-math.random(1, 4), z=pos.z}, 14, uid)
             addEvent(doSendMagicEffect, 3600, {x=pos.x+math.random(-4, 4), y=pos.y+math.random(1, 4), z=pos.z}, 14, uid)
             addEvent(doSendMagicEffect, 3600, {x=pos.x-math.random(-4, 4), y=pos.y-math.random(1, 4), z=pos.z}, 5, uid)
			 return true
      end


function onUse(cid, item, fromPosition, itemEx, toPosition)
if not isCreature(cid) then
return true
end


if not isCreature(itemEx.uid) then
		return doPlayerSendCancel(cid, "Use only in creatures!")		
end
if getPlayerSkillLevel(cid, 2) > getPlayerSkillLevel(itemEx.uid, 5) and math.random(1,100) < 50 or math.random(1,100) > 80 then
local min = (getPlayerLevel(cid)*0.1 + getPlayerSkill(cid,2)*0.1)
local max = (getPlayerLevel(cid)*0.2 + getPlayerSkill(cid,2)*0.2)
addEvent(doAreaCombatHealth, 800, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 1200, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 1500, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 1800, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 2200, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 2400, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 2700, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 3000, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 3400, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 3700, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)
addEvent(doAreaCombatHealth, 4000, cid, 1, {x = 2405, y = 52, z = 7}, 0, -min, -max, 4)



registerCreatureEvent(cid, "Tsuk")
	if #getCreatureSummons(itemEx.uid) >= 1 then
		local summons = getCreatureSummons(itemEx.uid)
			for _,pid in ipairs(summons) do
		if getCreatureName(pid) == getPlayerName(itemEx.uid) then
			doSendMagicEffect(getCreaturePosition(pid), 107)
				doRemoveCreature(pid) 
		end
			end
	end
local outfit = getCreatureOutfit(itemEx.uid)
outfit.lookType = infoClan[getPlayerVocation(itemEx.uid)].outfit

	local oldPos = {}
	local target = {}		
	local pos = getPlayerPosition(itemEx.uid)
	local bpos = {x=pos.x+2, y = pos.y, z = pos.z} 
	local farAwayPos = {x = 2347, y = 56, z = 7} 
	doCreatureSetLookDir(itemEx.uid, 2)
		position = getThingPos(itemEx.uid)
	table.insert(oldPos, position)
			addEvent(doSendPlayerExtendedOpcode, 450, itemEx.uid, 124, "Radial Blur")
				addEvent(effect, 450, itemEx.uid, dano, tempo, efeitoFogo, efeitoExplosao, efeitoRaio)
					addEvent(olhos, 450, itemEx.uid)
	if getGlobalStorageValue(itemEx.uid, 910562) == 1 then
		addEvent(doSendPlayerExtendedOpcode, 5000, itemEx.uid, 124, "Sepia")
	end
	if getGlobalStorageValue(itemEx.uid, 910562) == 2 then
		addEvent(doSendPlayerExtendedOpcode, 5000, itemEx.uid, 124, "Default")
	end
		addEvent(doCreatureSay, 500, itemEx.uid, "You will suffer this in the next 72\nhours.", TALKTYPE_MONSTER)
		doPlayerSendTextMessage(cid,22,"You have caught '"..getPlayerName(itemEx.uid).."' on your Genjutsu! (Tsukuyomi)")
			doPlayerSendTextMessage(itemEx.uid,22,"You are under influence of a '"..getPlayerName(cid).."' Genjutsu! (Tsukuyomi)")	  
				addEvent(doTeleportThing, 400, itemEx.uid, {x = 2405, y = 52, z = 7})
	tsukuyomis = addEvent(doTeleportThing, 5300, itemEx.uid, oldPos[1])
					addEvent(actionMove, 500, itemEx.uid, 380, 4450)
-----------------------------------------------------------------------------------------	
	local Tsukuyomi = doCreateMonster("Bunshin", farAwayPos)
			doConvinceCreature(cid, Tsukuyomi)
				setCreatureMaxHealth(Tsukuyomi, getCreatureMaxHealth(itemEx.uid))
					doCreatureAddHealth(Tsukuyomi, getCreatureHealth(itemEx.uid)-30)
						doSetCreatureOutfit(Tsukuyomi, outfit, -1)
							setCreatureName(Tsukuyomi, "".. getCreatureName(itemEx.uid) .."", "the player ".. getCreatureName(itemEx.uid) .." on the influence of this genjutsu. (Tsukuyomi)")
								doChangeSpeed(Tsukuyomi, -getCreatureSpeed(cid))
									addEvent(doTeleportThing, 100, Tsukuyomi, getThingPos(itemEx.uid))
										doSendMagicEffect(getThingPos(itemEx.uid), 107)
	if #getCreatureSummons(cid) >= 1 then
		local summons = getCreatureSummons(cid)
			for _,pid in ipairs(summons) do
		if getCreatureName(pid) == getPlayerName(itemEx.uid) then
			addEvent(doSendMagicEffect, 5000, getCreaturePosition(itemEx.uid), 107)
				addEvent(doRemoveCreature, 5300, pid) 
-----------------------------------------------------------------------------------------
		end
			end
				return true
			end
		else
	end
		doSendMagicEffect(getCreaturePosition(itemEx.uid), 3)
		doPlayerSendCancel(cid, "his genjutsu did not succeed.")
		return true
	end