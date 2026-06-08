local storage = 201

function onUse(cid, item, fromPosition, itemEx, toPosition)
      if not isCreature(itemEx.uid) then
         return doPlayerSendCancel(cid, "Use only in creatures")
      end
   if(getPlayerStorageValue(cid,storage) <= 0) then
         actionMove(cid, 191, -1)
		 doCreatureSetHideHealth(cid,TRUE)
		 doSendMagicEffect(getThingPos(cid), 107)
		 doCreatureSay(cid, "Kakuremino!", TALKTYPE_MONSTER)
        mayNotMove(cid, true) 
		setPlayerStorageValue(cid,storage, 1)
	else
	if (getPlayerStorageValue(cid,storage) == 0) then
         return doPlayerSendCancel(cid, "You can't use Henge on yourself")
      end
	  mayNotMove(cid, false)
	  doCreatureSetHideHealth(cid,false)
      setPlayerStorageValue(cid,storage, 0)
      doSendMagicEffect(getThingPos(cid), 107)	  
      doRemoveCondition(cid, CONDITION_OUTFIT)
   end
 end
  