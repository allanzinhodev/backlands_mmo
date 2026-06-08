function onKill(cid, target, lastHit)

if isPlayer(target) then
	return true
end

if not isMonster(target) or getConfigValue("rateExperience") < 0.1 then
   local ret = getMonsterInfo(getCreatureNickRealName(target))
   if not next(ret) or ret.experience < 1 then
      return true
   end 
end	

   local pet = getPlayerPet(cid)
   if pet then
	     doPetAddExperience(pet, getMonsterInfo(getCreatureNickRealName(target)).experience * petExpRate)
 
	local dogInfo = "HP = ".. getCreatureHealth(pet) .."  MHP = ".. getCreatureMaxHealth(pet).." HPe-LV = 1 LVe-CL = ".. getCreatureMana(pet) .."  MCL = "..getCreatureMaxMana(pet).." CLe-HPe-LVPET = "..getPetLevel(pet).." LVPETe-XP = ".. getPetExperience(pet) .." XPe-SP = "..getCreatureSpeed(pet).." SPe-SCL = "..getPetChakraLevel(cid).." SCLe-SRT = "..getPetResistenceLevel(cid).." SRTe-DS = "..getPetSkill(cid).." DSe-"	     doSendPlayerExtendedOpcode(cid, 102, dogInfo)
   if getLevelByExp(getPetExperience(pet)) > getPetLevel(pet) then
		 doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Your pet advanced from level " .. getPetLevel(pet) .. " to level " .. getLevelByExp(getPetExperience(pet)) .. ".")
		 doPetSetLevel(pet, getLevelByExp(getPetExperience(pet)))
	local dogInfo = "HP = ".. getCreatureHealth(pet) .."  MHP = ".. getCreatureMaxHealth(pet).." HPe-LV = 1 LVe-CL = ".. getCreatureMana(pet) .."  MCL = "..getCreatureMaxMana(pet).." CLe-HPe-LVPET = "..getPetLevel(pet).." LVPETe-XP = ".. getPetExperience(pet) .." XPe-SP = "..getCreatureSpeed(pet).." SPe-SCL = "..getPetChakraLevel(cid).." SCLe-SRT = "..getPetResistenceLevel(cid).." SRTe-DS = "..getPetSkill(cid).." DSe-"	    doSendPlayerExtendedOpcode(cid, 102, dogInfo)
   end
	  return true
   end
   return true
end