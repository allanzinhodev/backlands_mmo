--Circles
AREA_CIRCLE2X2 =
{
   {0, 1, 1, 1, 0},
   {1, 1, 1, 1, 1},
   {1, 1, 3, 1, 1},
   {1, 1, 1, 1, 1},
   {0, 1, 1, 1, 0}
}

AREA_CIRCLE3X3 =
{
   {0, 0, 1, 1, 1, 0, 0},
   {0, 1, 1, 1, 1, 1, 0},
   {1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 3, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1},
   {0, 1, 1, 1, 1, 1, 0},
   {0, 0, 1, 1, 1, 0, 0}
}

-- Crosses
AREA_CROSS1X1 =
{
   {0, 1, 0},
   {1, 3, 1},
   {0, 1, 0}
}

AREA_CROSS5X5 =
{
   {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
   {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
   {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
   {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
   {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
   {1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
   {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
   {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
   {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
   {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
   {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}
}

AREA_CROSS6X6 =
{
   {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
   {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
   {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
   {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
   {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
   {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
   {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
   {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
   {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}
}

--Squares
AREA_SQUARE1X1 =
{
   {1, 1, 1},
   {1, 3, 1},
   {1, 1, 1}
}

-- Walls
AREA_WALLFIELD = {
   {1, 1, 3, 1, 1}
}

AREADIAGONAL_WALLFIELD =
{
   {0, 0, 0, 0, 1},
   {0, 0, 0, 1, 1},
   {0, 1, 3, 1, 0},
   {1, 1, 0, 0, 0},
   {1, 0, 0, 0, 0},
}

TYPE_NEAR = 1
TYPE_DISTANCE = 2

petExhaust = 3 --in seconds
petSayExhaust = 3 --in seconds

petGainTicks =
{
   health = {func = doCreatureAddHealth, time = 3000, count = 1},
   mana = {func = doCreatureAddMana, time = 3000, count = 2}
}

petGainHealth = 25
petGainMana = 15
petExpRate = 5.0

carryItems = 10

petItemsBase = 1250
petItems = {}
blockedItems = {6132, 2195}

for i = 1, carryItems do
   table.insert(petItems, petItemsBase + i)
end

petBase = 61200
petStorages =
{
   pet = petBase + 1,
   level = petBase + 2,
   exp = petBase + 3,
   items = petBase + 4,
   isPet = petBase + 5,
   isDead = petBase + 6,
   exhaust = petBase + 7,
   sayExhaust = petBase + 8,
   moveExhaust = petBase + 9,
   health = petBase + 10,
   mana = petBase + 11,
   chakra = petBase + 12,
   res = petBase + 13,
   nick = petBase + 14,
   maxHealth = petBase + 15,
   maxChakra = petBase + 16,
   petSkill = petBase + 17,
   petSpeed = petBase + 18,
   saveSpeed = petBase + 19
}

reviveCost = 1000

pets =
{
   [1] =
   {
	  monster = "Pet",
	  vocations = {2},
	  level = 1,
   },
}

function gainStat(pid, stat)

   if pid and pid > 0 and isMonster(pid) then
	  stat.func(pid, stat.count)
   end
   addEvent(gainStat, stat.time, pid, stat)
end

function getLevelByExp(exp)
    return math.floor((math.sqrt(3) * math.sqrt(243*(exp+1)^2-48600*(exp+1)+3680000)+27 * (exp+1)-2700)^(1/3)/30^(2/3)-(5*10^(2/3))/(3^(1/3)*(math.sqrt(3)*math.sqrt(243*(exp+1)^2-48600*(exp+1)+3680000)+27*(exp+1)-2700)^(1/3))+2)
end

function getPetInfo(pet)
   if isNumber(pet) then
	  return pets[pet] or false
   else
	  for _, v in pairs(pets) do
		 if pet:lower() == v.monster then
		    return v
		 end
	  end
   end
   return false
end

function getPetByLevel(cid)
   local level = getPlayerLevel(cid)
   local pet
   for i = 1, #pets do
	  v = pets[i]
	  if level >= v.level and isInArray(v.vocations, getPlayerVocation(cid)) then
		 pet = v
	  end
   end
   return (pet ~= nil and pet or false)
end

function getAttackFormula(pid, attack)
    return {
		 min = ((getPetLevel(pid) * 2) * (1 + attack.damageMin) + getPetLevel(pid)) / 1.2,
		 max = ((getPetLevel(pid) * 3) * (1 + attack.damageMax) + getPetLevel(pid)) / 1.2
		  }
end

function doAttack(pid, target, param)

   local pet = getPetInfo(getCreatureName(pid))
   if pet then
	  if pet.attacks and pet.attacks[param] then
		 local attack = pet.attacks[param]
		 if target > 0 and attack.type and attack.type == TYPE_DISTANCE and getDistanceBetween(getCreaturePosition(pid), getCreaturePosition(target)) > (attack.range or 3) or attack.type == TYPE_NEAR and target > 0 and getDistanceBetween(getCreaturePosition(pid), getCreaturePosition(target)) > attack.range then
		    return doPlayerSendCancel(getCreatureMaster(pid), "Target is too far.") and doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF)
		 end
		 if target > 0 and not isSightClear(getCreaturePosition(pid), getCreaturePosition(target), true) then
		    return doPlayerSendCancel(getCreatureMaster(pid), "There is not enough room.") and doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF)
		 end
		 if target == 0 then
		    return doPlayerSendCancel(getCreatureMaster(pid), "Please select a target first.") and doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF)
		 end
		 if getPlayerLevel(getCreatureMaster(pid)) < attack.level then
		    return doPlayerSendCancel(getCreatureMaster(pid), "You need level " .. attack.level .. " or higher to use this attack.") and doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF)
		 end
		 if getPetLevel(pid) < attack.petLevel then
		    return doPlayerSendCancel(getCreatureMaster(pid), "Your pet needs level " .. attack.petLevel .. " or higher to use this attack.") and doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF)
		 end
		 if attack.mana and getCreatureMana(pid) < attack.mana then
		    return doPlayerSendCancel(getCreatureMaster(pid), "Your pet does not have enough mana.") and doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF)
		 end
		 if attack.area then
		    doCastAreaAttack(pid, target, attack.area, attack)
		 else
		    doTargetCombatHealth(pid, target, attack.combat, -getAttackFormula(pid, attack).min, -getAttackFormula(pid, attack).max, attack.effect)
		 end
		 doCreatureAddMana(pid, -attack.mana)
		 return doSendDistanceShoot(getCreaturePosition(pid), (attack.type == TYPE_DISTANCE and getCreaturePosition(target) or getCreaturePosition(pid)), attack.distEffect) and doCreatureSay(pid, attack.name, TALKTYPE_MONSTER)
	  else
		 return doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF)
	  end
   else
	  return doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF) and doPlayerSendCancel(getCreatureMaster(pid), "There is a tecnical problem, please contact a gamemaster.")
   end
end

function callPet(cid)

   for i = 1, #petStorages do
	  if getCreatureStorage(cid, petStorages[i]) < 0 then
		 doCreatureSetStorage(cid, petStorages[i], 0)
	  end
   end

   local pet = getPetByLevel(cid)
   if not pet then
	  return doPlayerSendCancel(cid, "You do not have enough level to call a pet.")
   end
   
   local ret =  doCreateMonsterNick(pet.monster, getPetName(cid), getThingPos(cid))
   
   if getCreatureStorage(cid, petStorages.level) < 1 then
	  doCreatureSetStorage(cid, petStorages.level, pet.level)
   end

   if getCreatureStorage(cid, petStorages.exp) < 1 then
	  doCreatureSetStorage(cid, petStorages.exp, getExperienceForLevel(pet.level))
   end

   if getCreatureStorage(cid, petStorages.level) < pet.level then
	  doCreatureSetStorage(cid, petStorages.level, pet.level)
   elseif getPlayerLevel(cid) * 3 < getCreatureStorage(cid, petStorages.level) then
	  doCreatureSetStorage(cid, petStorages.level, (getPetByLevel(cid).level or 0))
	  doCreatureSetStorage(cid, petStorages.exp, getExperienceForLevel((getPetByLevel(cid).level or 0)))
   end

   if getLevelByExp(getCreatureStorage(cid, petStorages.exp)) < getCreatureStorage(cid, petStorages.level) then
	  doCreatureSetStorage(cid, petStorages.exp, getExperienceForLevel(getCreatureStorage(cid, petStorages.level)))
   end

   if getCreatureStorage(cid, petStorages.health) < 1 then
	  doCreatureSetStorage(cid, petStorages.health, getCreatureStorage(cid, petStorages.level) * petGainHealth)
   end
   
   if getCreatureStorage(cid, petStorages.chakra) < 0 then
	  doCreatureSetStorage(cid, petStorages.chakra, 0)
   end
   
   if getCreatureStorage(cid, petStorages.res) < 0 then
	  doCreatureSetStorage(cid, petStorages.res, 0)
   end
   
   if getCreatureStorage(cid, petStorages.petSkill) < 0 then
	  doCreatureSetStorage(cid, petStorages.petSkill, 0)
   end
   
   if getCreatureStorage(cid, petStorages.maxHealth) < 0 then
	  doCreatureSetStorage(cid, petStorages.maxHealth, 0)
   end
   
   if getCreatureStorage(cid, petStorages.maxChakra) < 0 then
	  doCreatureSetStorage(cid, petStorages.maxChakra, 0)
   end
   
   if getCreatureStorage(cid, petStorages.petSpeed) < 0 then
	  doCreatureSetStorage(cid, petStorages.petSpeed, 0)
   end
   
    if getCreatureStorage(cid, petStorages.saveSpeed) < 0 then
	  doCreatureSetStorage(cid, petStorages.saveSpeed, 400)
   end
   
   if getCreatureStorage(cid, petStorages.health) < 1 then
	  doCreatureSetStorage(cid, petStorages.health, getCreatureStorage(cid, petStorages.level) * petGainHealth)
   end

   if getCreatureStorage(cid, petStorages.mana) < 1 then
	  doCreatureSetStorage(cid, petStorages.mana, getCreatureStorage(cid, petStorages.level) * petGainMana)
   end

   doCreatureSetStorage(ret, petStorages.level, getCreatureStorage(cid, petStorages.level))
   doCreatureSetStorage(ret, petStorages.exp, getCreatureStorage(cid, petStorages.exp))
   doConvinceCreature(cid, ret)
   doCreatureSetStorage(ret, petStorages.isPet, 1)
   doSendMagicEffect(getCreaturePosition(cid), 2)
   setCreatureMaxHealth(ret, getPetLevel(ret) * petGainHealth +  getPetMaxHealth(cid))
   doCreatureAddHealth(ret, -getCreatureHealth(ret) + getCreatureStorage(cid, petStorages.health)) 
   setCreatureMaxMana(ret, getPetLevel(ret) * petGainMana + getPetMaxChakra(cid))
   doCreatureAddMana(ret, -getCreatureMana(ret) + getCreatureStorage(cid, petStorages.mana))
   local set = getPlayerPet(cid)
   local speed = getPlayerStorageValue(cid, petStorages.saveSpeed)
   doChangeSpeed(set, -getCreatureSpeed(set))
   doChangeSpeed(set, speed)
   local dogInfo = "HP = ".. getCreatureHealth(set) .."  MHP = ".. getCreatureMaxHealth(set).." HPe-LV = 1 LVe-CL = ".. getCreatureMana(set) .."  MCL = "..getCreatureMaxMana(set).." CLe-HPe-LVPET = "..getPetLevel(set).." LVPETe-XP = ".. getPetExperience(set) .." XPe-SP = "..getCreatureSpeed(set).." SPe-SCL = "..getPetChakraLevel(cid).." SCLe-SRT = "..getPetResistenceLevel(cid).." SRTe-DS = "..getPetSkill(cid).." DSe-PSS = "..getPetSpeed(cid).." PSSe-"	
   doSendPlayerExtendedOpcode(cid, 102, dogInfo)
   doSendPlayerExtendedOpcode(cid, 103, getCreatureName(set))
   return doCreatureSay(cid, "Go "..getPetName(cid).."!", TALKTYPE_SAY)
end

function doCastAreaAttack(pid, target, area, attack)
   local center = {}
   local areaxx = {}
   center.y = math.floor(#area/2)+1
   for y = 1, #area do
	  for x = 1, #area[y] do
		 local number = area[y][x]
		 if number > 0 then
		    center.x = math.floor(table.getn(area[y])/2)+1
		    if attack.type == TYPE_DISTANCE then
			   table.insert(areaxx, {x = getCreaturePosition(target).x + x - center.x, y = getCreaturePosition(target).y + y - center.y, z = getCreaturePosition(target).z})
		    else
			   table.insert(areaxx, {x = getCreaturePosition(pid).x + x - center.x, y = getCreaturePosition(pid).y + y - center.y, z = getCreaturePosition(pid).z})
		    end		   
		 end
	  end
   end
   for i = 1, #areaxx do
	  doAreaCombatHealth(pid, attack.combat, areaxx[i], 0, -getAttackFormula(pid, attack).min, -getAttackFormula(pid, attack).max, attack.effect)
   end
end

function isPet(pid)
   return getCreatureStorage(pid, petStorages.isPet) > 0 and true or false
end

function doPetAddExperience(pid, exp)

   doCreatureSetStorage(pid, petStorages.exp, getCreatureStorage(pid, petStorages.exp) + exp)
   doCreatureSetStorage(getCreatureMaster(pid), petStorages.exp, getPetExperience(pid))
   doSendAnimatedText(getCreaturePosition(pid), exp, getConfigValue("gainExperienceColor"))
   return true
end

function getPetExperience(pid)
   return getCreatureStorage(pid, petStorages.exp)
end

function getPetLevel(pid)
   return getCreatureStorage(pid, petStorages.level)
end

function getPetName(pid)
   return getCreatureStorage(pid, petStorages.nick)
end

function getPetChakraLevel(pid)
   return getCreatureStorage(pid, petStorages.chakra)
end

function getPetResistenceLevel(cid)
   return getCreatureStorage(cid, petStorages.res)
end

function getPetSkill(cid)
   return getCreatureStorage(cid, petStorages.petSkill)
end

function getPetMaxHealth(cid)
   return getCreatureStorage(cid, petStorages.maxHealth)
end

function getPetMaxChakra(cid)
   return getCreatureStorage(cid, petStorages.maxChakra)
end

function getPetSpeed(cid)
   return getCreatureStorage(cid, petStorages.petSpeed)
end

function doPetSetLevel(pid, level)

   doCreatureSetStorage(pid, petStorages.level, level)
   doCreatureSetStorage(getCreatureMaster(pid), petStorages.level, level)
   setCreatureMaxHealth(pid, getPetLevel(pid) * petGainHealth)
   setCreatureMaxMana(pid, getPetLevel(pid) * petGainMana)
   return true
end

function getPlayerPet(cid)
   local pet
   if #getCreatureSummons(cid) < 1 then
	  pet = false
   end

   for _, it in ipairs(getCreatureSummons(cid)) do
	  if isPet(it) then
		 pet = it
		 break
	  end
   end
   return pet
end

function getTopItem(p)
   p.stackpos = 0
   local v = getThingFromPos(p)
   repeat
	  p.stackpos = p.stackpos + 1
	  v = getThingFromPos(p)
   until v.itemid == 0
   p.stackpos = p.stackpos - 1
   return getThingFromPos(p)
end