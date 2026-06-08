local temp = {
exhausted = 4,
}

local confg = {
level = 25,
chakra = 65
}

function onUse(cid, item, frompos, itemEx, topos)
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
				doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkJutsu(cid, "Nikudan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu.")
	end
	if checkJutsu(cid, "Hari") then
		return doPlayerSendCancel(cid, "you cannot use jutsu.")
	end
	if checkJutsu(cid, "Tongarashigan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end	

	local info = {
		speed = 100,
	}
	

	if not isCreature(cid) then
		return true
	end


	if isPlayer(cid) and getPlayerStorageValue(cid, sto_sensha[6]) > 0 then
       	removeChakraLife(cid, - confg.chakra)
		iniBaika(cid)
		addEvent(doSendMagicEffect, 550, getCreaturePosition(cid),111)
		setPlayerStorageValue(cid, sto_sensha[6], 0)
	    doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid) -info.speed)
		removeChakra(cid, 1, 3, sto_sensha[6], "sharingan")
	else
		endBaika(cid)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid))
		setPlayerStorageValue(cid, sto_sensha[6], 1)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end
	
	