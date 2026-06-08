local chakra = 10
function onUse(cid, item, fromPosition, itemEx, toPosition)
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
   if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
      return doPlayerSendCancel(cid, "Sorry this is not possible.")     
   end
	
   local target = itemEx.uid
   if not (target == cid) then
      if not isCreature(target) then
         return doPlayerSendCancel(cid, "Use only in creatures")
      end
  
      if(getPlayerStorageValue(cid,sto_jutsu[2]) <= 0) then
	  	if getPlayerStorageValue(cid, 4000) <= 0 then
			setPlayerStorageValue(cid, 4000, 1)
		end
         doSetCreatureOutfit(cid, getCreatureOutfit(target), -1)
		 doSendMagicEffect(getThingPos(cid), 110)
         removeChakraLife(cid, -chakra)
		 doCreatureSay(cid, "Henge!", TALKTYPE_MONSTER)
         setPlayerStorageValue(cid,sto_jutsu[2], 1)
      end 
   else
      if (getPlayerStorageValue(cid,sto_jutsu[2]) == 0) then
         return doPlayerSendCancel(cid, "You can't use Henge on yourself")
      end
      setPlayerStorageValue(cid,sto_jutsu[2], 0)
      doSendMagicEffect(getThingPos(cid), 110)	  
      doRemoveCondition(cid, CONDITION_OUTFIT)
   end
                                         
 return true 
end
