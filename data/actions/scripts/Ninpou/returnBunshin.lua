local confg = {
level = 0,
chakra = 0
}

function onUse(cid, item, fromPosition, itemEx, toPosition)

-----[Restrições]-----
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
--------------------	
	if not isCreature(cid) then
		return true
	end
	
    if getPlayerLevel(cid) < confg.level then
        doPlayerSendCancel(cid, "You need to be atleast level ".. confg.level ..".") 
    return true
    end
	local function removeSummon(pid)
	if isCreature(pid) then
      doSendMagicEffect(getCreaturePosition(pid), 107)
      doRemoveCreature(pid)
	end
	end
 
if #getCreatureSummons(cid) >= 1 then
   local summons = getCreatureSummons(cid)
   for i, pid in ipairs(summons) do
      if getCreatureName(pid) == getPlayerName(cid) then
         addEvent(removeSummon, (i-1)*300, pid)
      end
   end
else
   doPlayerSendCancel(cid, "You not have Bunshin.")  
end
end