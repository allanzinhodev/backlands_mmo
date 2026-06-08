function iniNikudan(cid)
             mayNotMove(cid, true)
             addEvent(changeMove, 0, cid, 427, 500)
             addEvent(changeMove, 200, cid, 428, 500)
             addEvent(changeMove, 400, cid, 429, 500)
             addEvent(changeMove, 600, cid, 422, -1)
			 addEvent(doCreatureSay, 200, cid, "Baika no Jutsu!", TALKTYPE_MONSTER)
             addEvent(doCreatureSay, 400, cid, "NIKUDAN SENSHAAA!!!!", TALKTYPE_MONSTER)
end

function endNikudan(cid)
             mayNotMove(cid, false)
             addEvent(changeMove, 0, cid, 429, 500)
             addEvent(changeMove, 200, cid, 428, 500)
             addEvent(changeMove, 400, cid, 427, 500)
             addEvent(changeMove, 600, cid, 418, -1)
end

function iniMizudan(cid)
             mayNotMove(cid, true)
             addEvent(changeMove, 0, cid, 427, 500)
             addEvent(changeMove, 200, cid, 428, 500)
             addEvent(changeMove, 400, cid, 429, 500)
             addEvent(changeMove, 600, cid, 422, -1)
			 addEvent(doCreatureSay, 200, cid, "Baika no Jutsu!", TALKTYPE_MONSTER)
             addEvent(doCreatureSay, 400, cid, "MIZUDAN SUISHAAA!!!!", TALKTYPE_MONSTER)
end

function endMizudan(cid)
             mayNotMove(cid, false)
             addEvent(changeMove, 0, cid, 429, 500)
             addEvent(changeMove, 200, cid, 428, 500)
             addEvent(changeMove, 400, cid, 427, 500)
             addEvent(changeMove, 600, cid, 418, -1)
end


function nikudanSensha(cid, chakra, oldLook)
   if not isCreature(cid) or getPlayerStorageValue(cid, sto_sensha[1]) < 1 then
      return false
   end
   
   local minDmg = -(getPlayerLevel(cid)*0.2 + getPlayerSkill(cid, 0) * 0.2)
   local maxDmg = -(getPlayerLevel(cid)*0.5 + getPlayerSkill(cid, 0) * 0.5)
   local efeito = CONST_ME_NONE
   local poslook = getCreatureLookPosition(cid)
   poslook.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
   local newLook = getCreatureLookDir(cid)
   
     if isWalkable(poslook, false, false, true) then
      if (oldLook == 0 and newLook == 2) or (oldLook == 2 and newLook == 0) or
         (oldLook == 1 and newLook == 3) or (oldLook == 3 and newLook == 1) then
		 doSendMagicEffect(getThingPos(cid), 107)
         addEvent(nikudanSensha, 800, cid, chakra, newLook)
         return true
      end
      if not isCreature(getThingfromPos(poslook).uid) then
         doMoveCreature(cid, getPlayerLookDirection(cid))
      else
         doMoveCreature(cid, getPlayerLookDirection(cid))
         doAreaCombatHealth(cid, COMBAT_PHYSICALDAMAGE, getCreaturePosition(cid), area, minDmg, maxDmg, efeito)
      end
   else
      mayNotMove(cid, false)
      addEvent(changeMove, 0, cid, 429, 500)
      addEvent(changeMove, 200, cid, 428, 500)
      addEvent(changeMove, 400, cid, 427, 500)
      addEvent(changeMove, 600, cid, 418, -1)
      addEvent(doCreatureSay, 200, cid, "OUCH!", TALKTYPE_MONSTER)
      doCreatureAddHealth(cid, -5)
      setPlayerStorageValue(cid, sto_sensha[1], 0)
   end
   addEvent(nikudanSensha, 100, cid, chakra, newLook)
   return true
end


function mizudanSuisha(cid, chakra, oldLook)
 
        if not isCreature(cid) or getPlayerStorageValue(cid, sto_sensha[7]) < 1 then
                return false
        end
 
        local minDmg = -(getPlayerLevel(cid)*0.3 + getPlayerSkill(cid, 0) * 1.0)
        local maxDmg = -(getPlayerLevel(cid)*0.6 + getPlayerSkill(cid, 0) * 1.5)
        local efeito = CONST_ME_NONE
        local poslook = getCreatureLookPosition(cid)
        poslook.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
		local newLook = getCreatureLookDir(cid)
 
     if isWalkable(poslook, false, false, true) then
	   if (oldLook == 0 and newLook == 2) or (oldLook == 2 and newLook == 0) or
         (oldLook == 1 and newLook == 3) or (oldLook == 3 and newLook == 1) then
		 doSendMagicEffect(getThingPos(cid), 107)
         addEvent(mizudanSuisha, 800, cid, chakra, newLook)
         return true
      end
	   if not isCreature(getThingfromPos(poslook).uid) then
          doMoveCreature(cid, getPlayerLookDirection(cid))
		else
          doMoveCreature(cid, getPlayerLookDirection(cid))
          doAreaCombatHealth(cid, COMBAT_PHYSICALDAMAGE, getCreaturePosition(cid), area, minDmg, maxDmg, efeito)
		  end
else
            mayNotMove(cid, false)
            addEvent(changeMove, 0, cid, 429, 500)
            addEvent(changeMove, 200, cid, 428, 500)
            addEvent(changeMove, 400, cid, 427, 500)
            addEvent(changeMove, 600, cid, 418, -1)
			addEvent(doCreatureSay, 200, cid, "OUCH!", TALKTYPE_MONSTER)
			doCreatureAddHealth(cid, -5)
			setPlayerStorageValue(cid, sto_sensha[7], 0)
			 end
			addEvent(mizudanSuisha, 80, cid, chakra, newLook)
		return true
end

function iniHariNikudan(cid)
             mayNotMove(cid, true)
  addEvent(changeMove, 0, cid, 456, 500)
  addEvent(changeMove, 100, cid, 456, 500)
  addEvent(changeMove, 200, cid, 457, 500)
  addEvent(changeMove, 400, cid, 459, 500)
  addEvent(changeMove, 600, cid, 460, 500)
  addEvent(changeMove, 800, cid, 461, 500)
  addEvent(changeMove, 1000, cid, 462, 500)
  addEvent(changeMove, 1200, cid, 463, 500)
  addEvent(changeMove, 1400, cid, 423, -1)
			 addEvent(doCreatureSay, 200, cid, "Baika no Jutsu!", TALKTYPE_MONSTER)
             addEvent(doCreatureSay, 300, cid, "NIKUDAN HARI SENSHAA!!!", TALKTYPE_MONSTER)
end

function endHariNikudan(cid)
  noMove(cid, 2000)
  addEvent(changeMove, 0, cid, 463, 500)
  addEvent(changeMove, 200, cid, 462, 500)
  addEvent(changeMove, 400, cid, 461, 500)
  addEvent(changeMove, 600, cid, 460, 500)
  addEvent(changeMove, 800, cid, 459, 500)
  addEvent(changeMove, 1000, cid, 458, 500)
  addEvent(changeMove, 1200, cid, 457, 500)
   addEvent(changeMove, 1400, cid, 456, 500)
   addEvent(changeMove, 1600, cid, 455, 500)
   addEvent(changeMove, 1800, cid, 418, -1)
end

function harinikudanSensha(cid, chakra, oldLook)
 
        if not isCreature(cid) or getPlayerStorageValue(cid, sto_sensha[5]) < 1 then
                return false
        end
 
        local minDmg = -(getPlayerLevel(cid)*0.4 + getPlayerSkill(cid, 0) * 0.5)
        local maxDmg = -(getPlayerLevel(cid)*0.6 + getPlayerSkill(cid, 0) * 0.7)
        local efeito = CONST_ME_NONE
        local poslook = getCreatureLookPosition(cid)
        poslook.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
		local newLook = getCreatureLookDir(cid)
 
     if isWalkable(poslook, false, false, true) then
	    if (oldLook == 0 and newLook == 2) or (oldLook == 2 and newLook == 0) or
         (oldLook == 1 and newLook == 3) or (oldLook == 3 and newLook == 1) then
		 doSendMagicEffect(getThingPos(cid), 107)
         addEvent(harinikudanSensha, 800, cid, chakra, newLook)
         return true
		end
		if not isCreature(getThingfromPos(poslook).uid) then
          doMoveCreature(cid, getPlayerLookDirection(cid))
		else
          doMoveCreature(cid, getPlayerLookDirection(cid))
          doAreaCombatHealth(cid, COMBAT_PHYSICALDAMAGE, getCreaturePosition(cid), area, minDmg, maxDmg, efeito)
		end
		else
	        mayNotMove(cid, false)
			addEvent(changeMove, 0, cid, 429, 500)
            addEvent(changeMove, 200, cid, 428, 500)
            addEvent(changeMove, 400, cid, 427, 500)
            addEvent(changeMove, 600, cid, 418, -1)
			addEvent(doCreatureSay, 200, cid, "OUCH!", TALKTYPE_MONSTER)
			doCreatureAddHealth(cid, -5)
			setPlayerStorageValue(cid, sto_sensha[5], 0)
			 end
			addEvent(harinikudanSensha, 130, cid, chakra,newLook)
		return true
end

function iniBaika(cid)
  mayNotMove(cid, true)
  addEvent(actionMove, 0, cid, 427, 500)
  addEvent(actionMove, 300, cid, 428, 500)
  addEvent(actionMove, 600, cid, 429, 500)
  addEvent(changeMove, 700, cid, 430, -1)
  addEvent(mayNotMove, 600, cid, false)
  addEvent(doCreatureSay, 300, cid, "Chou Baika no Jutsu!!!", TALKTYPE_MONSTER)
end

function endBaika(cid)
  mayNotMove(cid, true)
  addEvent(changeMove, 0, cid, 429, 100)
  addEvent(changeMove, 200, cid, 428, 100)
  addEvent(changeMove, 400, cid, 427, 100)
  addEvent(changeMove, 600, cid, 418, -1)
  addEvent(mayNotMove, 1000, cid, false)
end
