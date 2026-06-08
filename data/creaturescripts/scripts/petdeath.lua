function onDeath(cid, corpse, deathList)

   if not isMonster(cid) or not isPet(cid) then return true end
  
		doCreatureSetStorage(getCreatureMaster(cid), petStorages.isDead, 1)
		doPlayerSendTextMessage(getCreatureMaster(cid), MESSAGE_STATUS_CONSOLE_BLUE, "Your pet is dead.")
   
	local pet = getPlayerPet(cid)
	
	if pet then
	
	local dogInfo = "HP = ".. getCreatureHealth(pet) .."  MHP = ".. getCreatureMaxHealth(pet).." HPe-LV = 1 LVe-CL = ".. getCreatureMana(pet) .."  MCL = "..getCreatureMaxMana(pet).." CLe-HPe-LVPET = "..getPetLevel(pet).." LVPETe-XP = ".. getPetExperience(pet) .." XPe-SP = "..getCreatureSpeed(pet).." SPe-SCL = "..getPetChakraLevel(cid).." SCLe-SRT = "..getPetResistenceLevel(cid).." SRTe-DS = "..getPetSkill(cid).." DSe-"
		doSendPlayerExtendedOpcode(cid, 102, dogInfo)
	end
	
   return true
end