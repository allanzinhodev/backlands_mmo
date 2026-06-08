function onUse(cid, item, itemEx)
		local info = {	
		health = 2,
		healthP = 4,
		storage = 2136,
	}

	local healthPercent = getCreatureMaxHealth(cid) * (info.health / 100)
	
	local healthPPercent = getCreatureMaxHealth(cid) * (info.healthP / 100)

	if not isCreature(cid) then
		return true
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot resting while you are molding chakra.")
	end
	if checkJutsu(cid, "Nikudan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end	
	if checkJutsu(cid, "Hari") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Horengan") then
		return doPlayerSendCancel(cid, "You cannot resting while you are use Jutsu.")
	end
	if checkJutsu(cid, "Karegan") then
		return doPlayerSendCancel(cid, "You cannot resting while you are use Jutsu.")
	end
	if checkJutsu(cid, "Tongarashigan") then
		return doPlayerSendCancel(cid, "You cannot resting while you are use Jutsu.")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
         if getPlayerStorageValue(cid, sto_nara[2]) == 0 then
               return doPlayerSendCancel(cid, "Sorry this is not possible.")
         end
		

	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	end

	if getPlayerStorageValue(cid, temp.storage) >= os.time() then 
		return doPlayerSendCancel(cid, "You are exhausted.")
	end

	if not infoClan[getPlayerVocation(cid)] then
		return doPlayerSendCancel(cid, "You cant use this item.")
	end

	local outfit = getCreatureOutfit(cid)
		outfit.lookType = infoClan[getPlayerVocation(cid)].restOutfit
	
	local Aoutfit = getCreatureOutfit(cid)
	Aoutfit.lookType = infoClanS[getPlayerVocation(cid)].restOutfit

	local speed = getCreatureSpeed(cid)

	if (getCreatureStorage(cid, info.storage) > 0) then
	if getPlayerStorageValue(cid, 87564) >= 1 then
		setPlayerStorageValue(cid,87564, 0)
		doSendMagicEffect(getThingPos(cid), 110)
		end
	if not isCreature(cid) then return true end
		if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		doSetCreatureOutfit(cid, Aoutfit, -1)
		elseif getPlayerStorageValue(cid, initStorages.graduation) ~= "Academy Student" then
		doSetCreatureOutfit(cid, outfit, -1)
		end
		registerCreatureEvent(cid, "noMove")
		doPlayerSendCancel(cid, "You are now resting.")
		mayNotMove(cid, true)
		setPlayerStorageValue(cid, 2138, 0)
		if isPremium(cid) then
			removeHealth(cid, healthPPercent, 2, 2138)
		else	
			removeHealth(cid, healthPercent, 2, 2138)
		end
		setPlayerStorageValue(cid, info.storage, 0)
		setPlayerStorageValue(cid, temp.storage, os.time() + temp.exhausted)
	else
		mayNotMove(cid, false)
		if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		doSetCreatureOutfit(cid, Aoutfit, 0)
		elseif getPlayerStorageValue(cid, initStorages.graduation)  ~= "Academy Student" then
		doSetCreatureOutfit(cid, outfit, 0)
		end
		setPlayerStorageValue(cid, 2138, 1)
		setPlayerStorageValue(cid, info.storage, 1)
		setPlayerStorageValue(cid, temp.storage, os.time() + temp.exhausted)
	end
	return true
end