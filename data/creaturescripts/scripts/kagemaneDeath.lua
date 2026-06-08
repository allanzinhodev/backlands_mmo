function onPrepareDeath(cid, lastHitKiller, mostDamageKiller)
	if not isCreature(cid) then
   		return true
 	end
 
	if(getPlayerStorageValue(cid, STORAGE_TRAPED_ON_KAGEMANE) == 1) then
		freeFromKagemane(cid)
	end

	if #getKagemaneTargetList(cid) > 0 then
		cleanKagemaneTargetList(cid)
	end
	return true
end