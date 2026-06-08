function onDeath(cid, deathList)
if getPlayerStorageValue(cid, PLAYERSTORAGE) > 0 then
   doPlayerSetNoMove(getPlayerStorageValue(cid, PLAYERSTORAGE), false)
   setPlayerStorageValue(getPlayerStorageValue(cid, PLAYERSTORAGE), PEIXESTORAGE, 0)
end

  return true
end