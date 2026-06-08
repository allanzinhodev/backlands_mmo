infoClan = {
	[1] = {outfit = 467, runOutfit = 468, restOutfit = 536, moldOutfit = 598},
	[2] = {outfit = 359, runOutfit = 361, restOutfit = 535, moldOutfit = 464},
	[3] = {outfit = 370, runOutfit = 371, restOutfit = 533, moldOutfit = 372},
	[4] = {outfit = 374, runOutfit = 375, restOutfit = 585, moldOutfit = 376},
	[5] = {outfit = 383, runOutfit = 384, restOutfit = 538, moldOutfit = 385},
	[6] = {outfit = 399, runOutfit = 400, restOutfit = 537, moldOutfit = 401},
	[7] = {outfit = 418, runOutfit = 419, restOutfit = 534, moldOutfit = 420},	 
}

infoClanS = {
	[1] = {outfit = 646, runOutfit = 647, restOutfit = 648, moldOutfit = 598},
	[2] = {outfit = 545, runOutfit = 546, restOutfit = 590, moldOutfit = 595},	
    [3] = {outfit = 541, runOutfit = 542, restOutfit = 588, moldOutfit = 593},	
    [4] = {outfit = 543, runOutfit = 544, restOutfit = 589, moldOutfit = 594},	
    [5] = {outfit = 547, runOutfit = 548, restOutfit = 592, moldOutfit = 597},
	[6] = {outfit = 539, runOutfit = 540, restOutfit = 591, moldOutfit = 596},
    [7] = {outfit = 643, runOutfit = 644, restOutfit = 645, moldOutfit = 420},
}


-- Exhausted Player
temp = {
	exhausted = 1,
	storage = 3000,
}

function isLooking(uid, target)      
        local var = {
                [0] = "x",
                [1] = "y",
                [2] = "x",
                [3] = "y",
        }
       
        local look = getCreatureLookDirection(uid)
       
        local pos_a, pos_b = getThingPos(uid), getThingPos(target)
       
        if math.abs(look - getCreatureLookDirection(target)) == 2 and pos_a[var[look]] == pos_b[var[look]] then
                return true
        end
        return false
end

function checkCmd(cid, cmd)
	if cmd == "rest" then
		if getPlayerStorageValue(cid, 2136) == 0 then
			return true
		end
	elseif cmd == "mold" then
		if getPlayerStorageValue(cid, 2137) == 0 then
			return true
		end
	elseif cmd == "run" then
		if getPlayerStorageValue(cid, 2135) == 0 then
			return true
		end
	end
	return false
end

function removeHealth(cid, percent, time, storage)
	if not isCreature(cid) then
		return true
	end

	if (getPlayerStorageValue(cid, storage) < 1) then
		doCreatureAddHealth(cid, percent)
		addEvent(removeHealth, time*1000, cid, percent, time, storage)
	end
end

function removeChakra(cid, percent, time, storage, type)
 local remove = percent
 if not isCreature(cid) then
  return true
 end

 if (getCreatureStorage(cid, storage) < 1) then
  if type == "none" then
   doCreatureAddMana(cid, remove)
  elseif type == "mold" then
   doCreatureAddMana(cid, remove)
   doSendMagicEffect(getCreaturePosition(cid),7)
  elseif type == "sharingan" then
   if getCreatureMana(cid) > remove then
    doCreatureAddMana(cid, -remove)
   else
    doCreatureAddMana(cid, -remove)
    doCreatureAddHealth(cid, -remove)
    doSendAnimatedText(getCreaturePosition(cid), remove, COLOR_RED)
   end
  else
   doCreatureAddMana(cid, remove)
  end
  addEvent(removeChakra, time*1000, cid, remove, time, storage, type)
  if type == "mold" then
  addEvent(doSendMagicEffect, 400, getCreaturePosition(cid),7)
  end
 end
end

function stopNow(cid, time)   
   if not isCreature(cid) or not tonumber( time ) then 
      return true 
   end
                                                       
   local function podeMover(cid)                         
      if isPlayer(cid) then 
         mayNotMove(cid, false) 
      elseif isCreature(cid) then 
         doChangeSpeed(cid, getCreatureBaseSpeed(cid)) 
      end
   end
   
   if isPlayer(cid) then 
      mayNotMove(cid, true) 
   else 
      doChangeSpeed(cid, -getCreatureSpeed(cid)) 
   end
   addEvent(podeMover, time, cid)
end

function stopNows(cid, time)   
   if not isCreature(cid) or not tonumber( time ) then 
      return true 
   end
   
   if time == -1 then
      if isPlayer(cid) then 
         mayNotMove(cid, true) 
      else 
         doChangeSpeed(cid, -getCreatureSpeed(cid)) 
      end
   elseif time == 0 then
      if isPlayer(cid) then 
         mayNotMove(cid, false) 
      elseif isCreature(cid) then 
         doChangeSpeed(cid, getCreatureBaseSpeed(cid)) 
      end
   end               
end

function petRest(cid, health, outfit, time, storage)
	if not isCreature(cid) then
		return true
	end
	
	if getPlayerStorageValue(cid, storage) < 1 then
		return true
	end
 
	local pet = getPlayerPet(cid)
	if not pet then
		return true
	end
	doCreatureAddHealth(pet, health)
	doCreatureAddMana(pet, health)
 
	doChangeSpeed(pet, -getCreatureSpeed(pet))

	local petOutfit = getCreatureOutfit(pet)
	petOutfit.lookType = outfit
	
	doSetCreatureOutfit(pet, petOutfit, -1)

	local dogInfo = "HP = ".. getCreatureHealth(pet) .."  MHP = ".. getCreatureMaxHealth(pet).." HPe-LV = 1 LVe-CL = ".. getCreatureMana(pet) .."  MCL = "..getCreatureMaxMana(pet).." CLe-HPe-LVPET = "..getPetLevel(pet).." LVPETe-XP = ".. getPetExperience(pet) .." XPe-SP = "..getCreatureSpeed(pet).." SPe-SCL = "..getPetChakraLevel(cid).." SCLe-SRT = "..getPetResistenceLevel(cid).." SRTe-DS = "..getPetSkill(cid).." DSe-PSS = "..getPetSpeed(cid).." PSSe-"	
	doSendPlayerExtendedOpcode(cid, 102, dogInfo)
	addEvent(petRest, time*1000, cid, health, outfit, time, storage)
end

function hasTile(pos)    --Verifica se tem TILE na pos
pos.stackpos = 0
if getTileThingByPos(pos).itemid >= 1 then
   return true
end
return false
end


function getThingFromPosWithProtect(pos)  --Pega uma creatura numa posiçao com proteçoes
if hasTile(pos) then
   if isCreature(getRecorderCreature(pos)) then
      return getRecorderCreature(pos)
   else
      pos.stackpos = 253
      pid = getThingfromPos(pos).uid
   end
else
   pid = 0
end
return pid
end

