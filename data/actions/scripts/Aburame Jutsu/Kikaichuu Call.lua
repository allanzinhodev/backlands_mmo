function onUse(cid, item, fromPosition, itemEx, toPosition)
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You in this area pz.") end 
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
	
	if getPlayerStorageValue(cid, sto_kikkais[1]) >= 1 and getPlayerStorageValue(cid, sto_kikkais[1]) <= 300 then
	local SmallKikais = doCreateMonster("Small Kikkais", getCreaturePosition(cid))
		actionMove(cid, 373, 1000)
		noMove(cid, 1000)
		addEvent(doCreatureSay, 300, cid, "Kikkaichu no Jutsu!", TALKTYPE_MONSTER)
		doConvinceCreature(cid, SmallKikais)
		setCreatureMaxHealth(SmallKikais, getPlayerStorageValue(cid, sto_kikkais[1]))
		doCreatureAddHealth(SmallKikais, getPlayerStorageValue(cid, sto_kikkais[1]))
		setPlayerStorageValue(cid, sto_kikkais[1], getPlayerStorageValue(cid, sto_kikkais[1]) - getPlayerStorageValue(cid, sto_kikkais[1])) 
	else
		doPlayerSendCancel(cid, "You do not have enough kikais.")
	end
		if getPlayerStorageValue(cid, sto_kikkais[1]) >= 310 and getPlayerStorageValue(cid, sto_kikkais[1]) <= 1000 then
			local MediumKikais = doCreateMonster("Medium Kikkais", getCreaturePosition(cid))
				actionMove(cid, 373, 1000)
				noMove(cid, 1000)
				addEvent(doCreatureSay, 300, cid, "Kikkaichu no Jutsu!", TALKTYPE_MONSTER)
				doConvinceCreature(cid, MediumKikais)
				setCreatureMaxHealth(MediumKikais, getPlayerStorageValue(cid, sto_kikkais[1]))
				doCreatureAddHealth(MediumKikais, getPlayerStorageValue(cid, sto_kikkais[1]))
				setPlayerStorageValue(cid, sto_kikkais[1], getPlayerStorageValue(cid, sto_kikkais[1]) - getPlayerStorageValue(cid, sto_kikkais[1])) 
		else
	doPlayerSendCancel(cid, "You do not have enough kikais.")
	end
end
