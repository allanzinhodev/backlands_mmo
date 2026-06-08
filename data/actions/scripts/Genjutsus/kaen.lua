function onUse(cid, item, fromPosition, itemEx, toPosition)
	local level = getPlayerLevel(cid) 
	local jutsuDmg = 5
	local skill_factor = math.ceil((jutsuSkill_factor(cid, 2) + level)/2)
	local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.30))
	local tempo = 8
	local efeito = 4

	function kaenDamage(uid, life, times, effect)
	if not isCreature(itemEx.uid) then
		return true
	end

	for i = 1, times do
		addEvent(doSendMagicEffect, i*1000, getThingPos(uid), effect, uid)
	end
	return true
	end

	if not isCreature(cid) then
		return true
	end
	
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You in this area pz.") 
    end 

       if getTilePzInfo(getPlayerPosition(itemEx.uid)) then
        return doPlayerSendCancel(cid, "You in this area pz.") 
    end
	
	if itemEx.uid == cid then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")	
	end
	
	if not isCreature(itemEx.uid) then
		setPlayerStorageValue(cid, sto_gen[2], 1)
		return true		
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
			doCreatureSay(cid, "Kaen!", TALKTYPE_MONSTER)
			if isPlayer(itemEx.uid) then
				doPlayerSendTextMessage(itemEx.uid,22,"You are under influence of a '"..getPlayerName(cid).."' Genjutsu! (Kaen)")
			end
			doPlayerSendTextMessage(cid,22,"You have caught '"..getPlayerName(itemEx.uid).."' on your Genjutsu! (Kaen)")	 
			doSendMagicEffect(getThingPos(cid), 3)
			kaenDamage(itemEx.uid, dmg, tempo, efeito)
			removeChakraLife(cid, - 95)
			setPlayerStorageValue(cid, sto_gen[2], os.time() + 15)
			setPlayerStorageValue(itemEx.uid, sto_gen[1], os.time() + 8)
			doSendPlayerExtendedOpcode(itemEx.uid, 124,  "Grayscale")
			stopNow(itemEx.uid, 8000)
			addEvent(doPlayerSendTextMessage, 8000, cid, 22, "'"..getPlayerName(itemEx.uid).."' escaped his genjutsu (Kaen)")
			addEvent(doSendPlayerExtendedOpcode, 8000, itemEx.uid, 124,  "Default")
		end
			return true
end