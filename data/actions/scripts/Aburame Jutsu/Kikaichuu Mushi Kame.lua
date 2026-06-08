local temp = {
		exhausted = 3,
}


local confg = {
		level = 25,
		chakra = 35,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
-----[Restrições]-----
	if not isCreature(cid) then
		return true
	end
	
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You in this area pz.") 
	end 
	
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end

	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
-----[Restrições]-----
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	elseif getPlayerLevel(cid) < confg.level then
		doPlayerSendCancel(cid, "You need to be atleast level ".. confg.level ..".") 
	return true
	end

   if isPlayer(cid) then
		setPlayerStorageValue(cid, sto_jutsu[1], (os.time() + temp.exhausted))
		removeChakraLife(cid, - confg.chakra)
		doPlayerCastSpell(cid, "#YZaburame2")
	else
		doPlayerSendCancel(cid, "you do not have chakra.")
	end
end