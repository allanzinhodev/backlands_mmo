function onPrepareDeath(cid, lastHitKiller, mostDamageKiller)
if isPlayer(cid) == true then
setPlayerStorageValue(cid, initStorages.death, 1)
return true
end
return true
end