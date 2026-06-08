function onStepIn(cid, item, position, fromPosition)

--if not isPlayer(cid) then doTeleportThing(cid, fromPosition, true) return false end

--if isPlayer(cid) then
	if getCreatureStorage(cid, sto_jutsu[3]) == 0 then
		doSendMagicEffect(getThingPos(cid), 1)
		removeChakraLife(cid, -1)
	end
	if getCreatureStorage(cid, sto_jutsu[3]) == 1 then
		doTeleportThing(cid, fromPosition, true) 
		return false
	end
--end

return true
end