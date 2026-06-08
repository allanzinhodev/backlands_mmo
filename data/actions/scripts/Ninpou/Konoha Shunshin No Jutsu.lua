local temp = {
exhausted = 3,
}


local confg = {
level = 0,
chakra = 10
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(cid) then
		return true
	end

	if 	getCreatureCondition(cid, CONDITION_INFIGHT) then
		return doPlayerSendCancel(cid, "Voce nao pode usar em batalha.")
	end
-----[Restrições]-----
if impossibleUse(cid) then
	return true
end
--------------------	
	if(getPlayerStorageValue(cid, sto_jutsu[4]) > os.time())  then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu") 
	return true
	end
	
	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		noMove(cid, 3000)
		doSendMagicEffect(getThingPos(cid), 139)
		doSendMagicEffect({x=2575, y=1815, z= 4}, 139)		
		addEvent(doSendMagicEffect, 600, getThingPos(cid), 139)
		addEvent(doSendMagicEffect, 600,{x=2575, y=1815, z= 4}, 139)
		addEvent(doSendMagicEffect, 1200,getThingPos(cid), 139)
		addEvent(doSendMagicEffect, 1200,{x=2575, y=1815, z= 4}, 139)
		addEvent(doSendMagicEffect, 1800,getThingPos(cid), 139)
		addEvent(doSendMagicEffect, 1800,{x=2575, y=1815, z= 4}, 139)
		addEvent(doSendMagicEffect, 2400,getThingPos(cid), 139)
		addEvent(doSendMagicEffect, 2400,{x=2575, y=1815, z= 4}, 139)
		addEvent(doTeleportThing, 3000, cid, {x=2575, y=1815, z= 4})
		doCreatureSay(cid,"Shunshin no Jutsu!!", TALKTYPE_FIRST)		
	    setPlayerStorageValue(cid, sto_jutsu[4]	, os.time() + temp.exhausted*60)
	end
	return true
end
