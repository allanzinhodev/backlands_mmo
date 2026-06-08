function onUse(cid, item, fromPosition, itemEx, toPosition)
local temp = {
	exhausted = 4,
}

local pet = getPlayerPet(cid)

	if not pet then
		return doPlayerSendCancel(cid, "Call your dog.")
	end

	if getCreatureMana(pet) < 5 then
		return doPlayerSendCancel(cid, "Your dog no have chakra.")
	end

	if not isCreature(cid) then
		return true
	end

	if getPlayerStorageValue(cid, STORAGE_PET_REST) == 1 then
		return doPlayerSendCancel(cid, "Your dog are resting.")
	end

	if(getPlayerStorageValue(cid, sto_inuzuka[4]) > os.time() and getPlayerStorageValue(cid, sto_inuzuka[4]) < 100+os.time()) then
		return doPlayerSendTextMessage(cid, 24, "Your dog are already doing a jutsu")
	end

		local dogInfo = "HP = ".. getCreatureHealth(pet) .."  MHP = ".. getCreatureMaxHealth(pet).." HPe-LV = 1 LVe-CL = ".. getCreatureMana(pet) .."  MCL = "..getCreatureMaxMana(pet).." CLe-HPe-LVPET = "..getPetLevel(pet).." LVPETe-XP = ".. getPetExperience(pet) .." XPe-SP = "..getCreatureSpeed(pet).." SPe-SCL = "..getPetChakraLevel(cid).." SCLe-SRT = "..getPetResistenceLevel(cid).." SRTe-DS = "..getPetSkill(cid).." DSe-PSS = "..getPetSpeed(cid).." PSSe-"
		doSendPlayerExtendedOpcode(cid, 102, dogInfo)

		doPlayerAddMana(pet, -5)
		doTeleportThing(pet, toPosition)
		doPlayerCastSpell(cid, "#YZinuzuka4")
		setPlayerStorageValue(cid, sto_inuzuka[4], os.time() + temp.exhausted)

end