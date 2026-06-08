function onStatsChange(cid, attacker, type, combat, value)

   if getPlayerPet(cid) and getPlayerPet(cid) == attacker then
	  return false
   end
   
if isPet(cid) then 
  if type == STATSCHANGE_HEALTHLOSS then
  local dmg = value
     local pet = getPlayerPet(getCreatureMaster(cid))
 
	local dogInfo = "HP = ".. getCreatureHealth(pet) - dmg .."  MHP = ".. getCreatureMaxHealth(pet).." HPe-LV = 1 LVe-CL = ".. getCreatureMana(pet) .."  MCL = "..getCreatureMaxMana(pet).." CLe-HPe-LVPET = "..getPetLevel(pet).." LVPETe-XP = ".. getPetExperience(pet) .." XPe-SP = "..getCreatureSpeed(pet).." SPe-SCL = "..getPetChakraLevel(cid).." SCLe-SRT = "..getPetResistenceLevel(cid).." SRTe-DS = "..getPetSkill(cid).." DSe-PSS = "..getPetSpeed(cid).." PSSe-"	
	doSendPlayerExtendedOpcode(getCreatureMaster(cid), 102, dogInfo)
  end
  end
  return true
end