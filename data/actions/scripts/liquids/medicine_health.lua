local temp = {
exhausted = 3,
}

function onUse (cid, item, frompos, itemEx, topos)
    local pos = getCreaturePosition(cid)
	
	if not isCreature(cid) then
		return true
	end
		
    if itemEx.uid <= 1 then
		return doPlayerSendCancel(cid,"You can't do that.")
    end
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "You are exhausted") 
	return true
	end
	if isPlayer(cid) then
		health = 80
		doSendAnimatedText(getThingPos(cid), " +".. health .."", COLOR_GREEN)
		doCreatureAddHealth(itemEx.uid, health)
        doSendMagicEffect(pos ,7)
		doPlayerSendTextMessage(cid, 24, "You are healed") 
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
			doRemoveItem(item.uid, 1)
end
end
