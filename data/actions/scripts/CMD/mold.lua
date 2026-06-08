function onUse(cid, item, itemEx)

	local info = {
		mana = 6,
		manap = 8,
		speed = 300,
		storage = 2137,
	}

	local manaPercent = getCreatureMaxMana(cid) * (info.mana / 100)
	local manaPPercent = getCreatureMaxMana(cid) * (info.manap / 100)

	if not isCreature(cid) then
		return true
	end
	
	
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot mold chakra while you are resting.")
	end
         if getPlayerStorageValue(cid, sto_nara[2]) == 0 then
               return doPlayerSendCancel(cid, "Sorry this is not possible.")
         end
		
	
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	end
	
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Nikudan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end	
	if checkJutsu(cid, "Hari") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end	
	if getPlayerStorageValue(cid, temp.storage) >= os.time() then 
		return doPlayerSendCancel(cid, "You are exhausted.")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
	
		local outfit = getCreatureOutfit(cid)
		outfit.lookType = infoClan[getPlayerVocation(cid)].moldOutfit
		
		local outfitA = getCreatureOutfit(cid)
		outfitA.lookType = infoClanS[getPlayerVocation(cid)].moldOutfit
		
		
		local speed = getCreatureBaseSpeed(cid)

	if (getCreatureStorage(cid, info.storage) > 0) then
		if getPlayerStorageValue(cid, 87564) >= 1 then
		setPlayerStorageValue(cid,87564, 0)
		doSendMagicEffect(getThingPos(cid), 110)
		end
		if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		doSetCreatureOutfit(cid, outfitA, -1)
		elseif getPlayerStorageValue(cid, initStorages.graduation) ~= "Academy Student" then
		doSetCreatureOutfit(cid, outfit, -1)
		end
		registerCreatureEvent(cid, "noMove")
		doPlayerSendCancel(cid, "You are now molding chakra.")
		mayNotMove(cid, true)
		setPlayerStorageValue(cid, 2139, 0)
		if isPremium(cid) then
		 	removeChakra(cid, manaPPercent, 2, 2139, "mold")
		else
			removeChakra(cid, manaPercent, 2, 2139, "mold")
		end
		setPlayerStorageValue(cid, info.storage, 0)
		setPlayerStorageValue(cid, temp.storage, os.time() + temp.exhausted)
	else
		if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		doSetCreatureOutfit(cid, outfitA, 0)
		elseif getPlayerStorageValue(cid, initStorages.graduation) ~= "Academy Student" then
		doSetCreatureOutfit(cid, outfit, 0)
		end
		setPlayerStorageValue(cid, 2139, 1)
        mayNotMove(cid, false)
		setPlayerStorageValue(cid, info.storage, 1)
		setPlayerStorageValue(cid, temp.storage, os.time() + temp.exhausted)
	end

	return true
end