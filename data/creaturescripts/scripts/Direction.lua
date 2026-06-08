function onDirection(cid, old, current)
  if getPlayerStorageValue(cid, STORAGE_DIRECTION) > 0 then
    return false
end
--------------------------------------------------------------------


  if(isPlayer(cid)) then
     if(getPlayerStorageValue(cid, STORAGE_KAGEMANE_TRAPED_QTY) > 0) then    
        local list = getKagemaneTargetList(cid)
          for _,v in pairs(list) do
             if(isCreature(v)) then
                doCreatureSetLookDir(v, current)
             else
                freeFromKagemane(v)
             end       
          end
     end 
  end
 
 
  
  if(getPlayerStorageValue(cid, STORAGE_TRAPED_ON_KAGEMANE) > 0) then
     local kagemaneMaster = getPlayerStorageValue(cid, STORAGE_KAGEMANE_ATTACKER_NAME)
     if not isCreature(kagemaneMaster) then freeFromKagemane(cid) end
     local mDir = getPlayerLookDir(kagemaneMaster)
     if current ~= mDir then
        doCreatureSetLookDir(cid, mDir) 
        return false
     end 
  end
  
  return true
end          