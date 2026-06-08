local temp = {
exhausted = 5,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
		return true
	end

	if math.random(1, 100) <= 70 then
		return doPlayerSendCancel(cid, "Voce nao conseguiu.")
	end
	
	if itemEx.uid ~= cid then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")	
	end

	if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You can't use.")
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
	if not isCreature(itemEx.uid) then
		return doPlayerSendCancel(cid, "Use only in creatures!")		
	end

		if isPlayer(cid) then
		if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
			return doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu") 
		end
			doCreatureSay(cid, "KAI!", TALKTYPE_MONSTER)
			doPlayerSendTextMessage(cid,22,"You escaped his genjutsu..")	 
			doSendMagicEffect(getThingPos(cid), 10)
			setPlayerStorageValue(itemEx.uid, sto_gen[1], 1) 
			doSendPlayerExtendedOpcode(itemEx.uid, 124,  "Default")
			mayNotMove(cid, false)
		    setPlayerStorageValue(cid, sto_jutsu[1]	, os.time() + temp.exhausted)
		else
			doPlayerSendTextMessage(cid,22,"You've stopped the genjutsu!")
	end
	return true
end
