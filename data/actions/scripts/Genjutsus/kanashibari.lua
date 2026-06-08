

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
		return true
	end
	
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You in this area pz.") 
    end 
	
	if itemEx.uid == cid then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")	
	end
	
	
	if not isCreature(itemEx.uid) then
		setPlayerStorageValue(cid, sto_gen[2], 1)
		return true
	end
	
	if not isCreature(itemEx.uid) then
		return doPlayerSendCancel(cid, "Use only in creatures!")		
	end
	

    if(getPlayerStorageValue(itemEx.uid, sto_gen[1]) > os.time() and getPlayerStorageValue(itemEx.uid, sto_gen[1]) < 100+os.time()) then
      return doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
    end
	
	if not isLooking(cid, itemEx.uid) then
		return doPlayerSendCancel(cid, "You need to look into the eyes of your enemy.")
	end
	
    if(getPlayerStorageValue(cid, sto_gen[2]) > os.time() and getPlayerStorageValue(cid, sto_gen[2]) < 100+os.time()) then
      return doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
    end

		if isPlayer(cid) then
			doCreatureSay(cid, "Kanashibari no Genjutsu!", TALKTYPE_MONSTER)
			if isPlayer(itemEx.uid) then
				doPlayerSendTextMessage(itemEx.uid,22,"You are under influence of a '"..getPlayerName(cid).."' Genjutsu! (Kanashibari)")
			end
			doPlayerSendTextMessage(cid,22,"You have caught '"..getPlayerName(itemEx.uid).."' on your Genjutsu! (Kanashibari)")	 
			doSendMagicEffect(getThingPos(cid), 3)
			removeChakraLife(cid, - 80)
			setPlayerStorageValue(cid, sto_gen[2], os.time() + 15)
			setPlayerStorageValue(itemEx.uid, sto_gen[1], os.time() + 8)
			doSendPlayerExtendedOpcode(itemEx.uid, 124,  "Bloom")
			stopNow(itemEx.uid, 8000)
			addEvent(doPlayerSendTextMessage, 8000, cid, 22, "'"..getPlayerName(itemEx.uid).."' escaped his genjutsu (Kanashibari)")
			addEvent(doSendPlayerExtendedOpcode, 8000, itemEx.uid, 124,  "Default")
		end
	return true
end
