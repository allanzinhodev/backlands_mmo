local shadowStorages = {
[1] = 9001,
[2] = 9002,
[3] = 9003,
}
 
 
function onStepIn(cid, item, position, fromPosition)
    local name = getItemAttribute(item.uid, "name")
    local player = name:match("a shadow. It belongs to (.*)")
    player = player + 0
   
    if not isCreature(player) then
       doRemoveItem(item.uid, 1)
       return true
    end
   
    if(isNpc(cid)) then
       return true
    end
   
   
    local aid = 9000 + (item.actionid/1000)
     
    if isCreature(player) then
    if((getCreatureName(cid) ~= getCreatureName(player)) and not isKagemaneTarget(player, cid) and (isPlayer(cid) or isMonster(cid))) then
      if(getPlayerStorageValue(cid,STORAGE_TRAPED_ON_KAGEMANE) ~= 1) then
           if addKagemaneTarget(player, cid) then
               setPlayerStorageValue(player, aid, 0)
           end
      end  
    end
    else
       doRemoveItem(item.uid, 1)
    end
   
   
    return true
end