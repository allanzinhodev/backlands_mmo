function onUse(cid, item)
    if not isCreature(cid) then                             
       return true 
    end
local pet = getPlayerPet(cid)
	if not pet then
	return true
	end
	
	if getPlayerStorageValue(cid, 2933) == 0 then
		return doPlayerSendCancel(cid, "você não pode usar Juujin Bunshin enquanto estiver usando rest PET.")
	end

	if not pet then
		doPlayerSendCancel(cid, "You dont have pet")
	return true
	end
 
	if getPlayerStorageValue(cid, temp.storage) >= os.time() then 
		return doPlayerSendCancel(cid, "You are exhausted.")
	end
 
	if getPlayerStorageValue(cid, STORAGE_PET_REST) > 0 then
	    local speed = getPlayerStorageValue(cid, petStorages.saveSpeed)
		local petOutfit = getCreatureOutfit(pet)
		petOutfit.lookType = 403
		doSetCreatureOutfit(pet, petOutfit, -1)
		doChangeSpeed(pet, speed)
		setPlayerStorageValue(cid, STORAGE_PET_REST, 0)
		local dogInfo = "HP = ".. getCreatureHealth(pet) .."  MHP = ".. getCreatureMaxHealth(pet).." HPe-LV = 1 LVe-CL = ".. getCreatureMana(pet) .."  MCL = "..getCreatureMaxMana(pet).." CLe-HPe-LVPET = "..getPetLevel(pet).." LVPETe-XP = ".. getPetExperience(pet) .." XPe-SP = "..getCreatureSpeed(pet).." SPe-SCL = "..getPetChakraLevel(cid).." SCLe-SRT = "..getPetResistenceLevel(cid).." SRTe-DS = "..getPetSkill(cid).." DSe-PSS = "..getPetSpeed(cid).." PSSe-"	
		doSendPlayerExtendedOpcode(cid, 102, dogInfo)
	return true
	end
	doPlayerSendCancel(cid, "Your pet are resting.")
	setPlayerStorageValue(cid, STORAGE_PET_REST, 1)
	setPlayerStorageValue(cid, temp.storage, os.time() + temp.exhausted)
	petRest(cid, 15, 524, 4, STORAGE_PET_REST)
	doCreatureSay(cid, "rest "..getCreatureName(pet).."!", TALKTYPE_SAY)
 return true
end