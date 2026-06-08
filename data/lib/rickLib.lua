getStorage = getPlayerStorageValue
STORAGE_DOING_JUTSU = 9000
STORAGE_SHADOW_1 = 9001
STORAGE_SHADOW_2 = 9002
STORAGE_SHADOW_3 = 9003
STORAGE_KAGEMANE_TRAPED_QTY = 9004
STORAGE_SHADOW_DIST = 9005
STORAGE_MAX_SHADOW_DIST = 9006
STORAGE_KAGEMANELASTPOS_X = 9007
STORAGE_KAGEMANELASTPOS_Y = 9008
STORAGE_KAGEMANELASTPOS_Z = 9009
STORAGE_KAGEMANE_TARGETS_START = 9010
STORAGE_KAGEMANE_TARGETS_END = 9060 -- botei até 50 targets
STORAGE_TRAPED_ON_KAGEMANE = 9061
STORAGE_KAGEMANE_ATTACKER_NAME = 9062
STORAGE_KAGE_KUBI = 9063
 
 
SHADOW_ITEMID_FIRST = 12333-- mudar
SHADOW_ITEMID_LAST = 12344-- mudar
 
KAGEMANE_TIME = 300 -- MS
 
 
 local function getLanguage(cid)
  return 0
end

local kagemaneShadows =
{
 --old dir
 [0] =  
 {
 -- current dir
   [0] = 12336,  --itemid
   [1] = 12339,
   [2] = 12336,
   [3] = 12338 ,  
 },
 
 [1] =
 {
   [0] = 12337,
   [1] = 12333,
   [2] = 12338,
   [3] = 12333,  
 },
 
 [2] =
 {
   [0] = 12336,
   [1] = 12343,
   [2] = 12336,
   [3] = 12344,  
 },
 
 [3] =
 {
   [0] = 12343,
   [1] = 12333,
   [2] = 12342,
   [3] = 12333,  
 },
 
}
 
function breakKagemane(cid, target)
                   
if not isCreature(cid) then
   freeFromKagemane(target)
end
 
  if (isPlayer(target)) then
      doPlayerSendTextMessage(target, 22, "You have been broke ".. getCreatureName(cid).."'s kagemane no jutsu!")
  end
 
  doRemoveCondition(cid, CONDITION_OUTFIT)
  mayNotMove(target, false)
  removeFromKagemaneTargetList(cid, target)
  doPlayerSendTextMessage(cid, 22, "".. getCreatureName(target).." have broken your kagemane no jutsu!")
 
  setPlayerStorageValue(target, STORAGE_TRAPED_ON_KAGEMANE, 0)
  setPlayerStorageValue(target, STORAGE_KAGEMANE_ATTACKER_NAME, 0)
 
  doSendAnimatedText(getCreaturePosition(target), "Broke!", TEXTCOLOR_DARKRED)
 
  return TRUE
end
 
function getPositionByDir(pos, dir)
   if dir == 0 then
      return {x=pos.x, y=pos.y - 1, z=pos.z}
   elseif dir == 1 then
      return {x=pos.x+1, y=pos.y, z=pos.z}
   elseif dir == 2 then
      return {x=pos.x, y=pos.y+1, z=pos.z}
   elseif dir == 3 then
      return {x=pos.x-1, y=pos.y, z=pos.z}
   --
   elseif dir == 4 then
      return {x=pos.x-1, y=pos.y+1, z=pos.z}
   elseif dir == 5 then
      return {x=pos.x+1, y=pos.y+1, z=pos.z}
   elseif dir == 6 then
      return {x=pos.x-1, y=pos.y-1, z=pos.z}
   elseif dir == 7 then
      return {x=pos.x+1, y=pos.y-1, z=pos.z}
   end
end
 
function createKagemane(cid, pos, shadowsId)
  if(isCreature(cid)) then
  local dir = getPlayerLookDir(cid)
  local oldDir = dir
  local nextPos = getPositionByDir(pos, dir)
  local currentPos = pos
  local oldPos = pos
 
  local shadowList = {}
  setPlayerStorageValue(cid, STORAGE_SHADOW_1, 1)
  doKagemane(cid, pos, dir, shadowsId, shadowList)
  end
  return TRUE
end
 
 
function doKagemane(cid, oldPosition, oldDir, shadowsId, shadowList, monster)
 
   if (not isCreature(cid)) then
      for i = 1, #shadowList do
      local auxPos = oldPosition
      auxPos.x = shadowList[i][1]
      auxPos.y = shadowList[i][2]
      auxPos.z = shadowList[i][3]
      removeShadow(auxPos, 1)
      removeShadow(auxPos, 2)
      removeShadow(auxPos, 3)
      end  
   return true
   end
 
   local shadowStorages = {
      [1] = STORAGE_SHADOW_1,
      [2] = STORAGE_SHADOW_2,
      [3] = STORAGE_SHADOW_3,
   }
 
  if(getPlayerStorageValue(cid, STORAGE_SHADOW_DIST) <= 0) then
     setPlayerStorageValue(cid, STORAGE_SHADOW_1, 0)
     setPlayerStorageValue(cid, STORAGE_SHADOW_2, 0)
     setPlayerStorageValue(cid, STORAGE_SHADOW_3, 0)
  else
     setPlayerStorageValue(cid, STORAGE_SHADOW_DIST, getPlayerStorageValue(cid, STORAGE_SHADOW_DIST) - 1)
  end
 
if getPlayerStorageValue(cid, STORAGE_SHADOW_1)  == 0  then
      for i = 1, #shadowList do
      local auxPos = oldPosition
      auxPos.x = shadowList[i][1]
      auxPos.y = shadowList[i][2]
      auxPos.z = shadowList[i][3]
      removeShadow(auxPos, 1)
      removeShadow(auxPos, 2)
      removeShadow(auxPos, 3)    
      end  
    doRemoveCondition(cid, CONDITION_OUTFIT)
     mayNotMove(cid, false)
   return true
   end
 
  if getPlayerStorageValue(cid, shadowStorages[shadowsId]) <= 1 then
     if(getPlayerStorageValue(cid, STORAGE_SHADOW_2) == 2) then
      setPlayerStorageValue(cid, STORAGE_SHADOW_2, 1)
        createKagemaneDuplicate(cid)
     end
 
     if(getPlayerStorageValue(cid, STORAGE_SHADOW_3) == 2) then
     setPlayerStorageValue(cid, STORAGE_SHADOW_3, 1)
      createKagemaneTriplicate(cid)
     end    
     
     local currentDir = getPlayerLookDir(cid)
     local currentPosition = getPositionByDir(oldPosition, oldDir)
     
     if isMonster(cid) then
        local target = getCreatureTarget(cid)
        if isCreature(target) then
           currentDir = getSimpleDirectionTo(oldPosition, getCreaturePosition(target))
           if currentDir == 50 then
              currentDir = 0
           end
       
        else
           for i = 1, #shadowList do
           local auxPos = oldPosition
           auxPos.x = shadowList[i][1]
           auxPos.y = shadowList[i][2]
           auxPos.z = shadowList[i][3]
           removeShadow(auxPos, 1)
           removeShadow(auxPos, 2)
           removeShadow(auxPos, 3)    
           end  
        end
     end
     
     
     if(not isWalkable(currentPosition)) then  
      for i = 1, #shadowList do
      local auxPos = oldPosition
      auxPos.x = shadowList[i][1]
      auxPos.y = shadowList[i][2]
      auxPos.z = shadowList[i][3]
      removeShadow(auxPos, 1)
      removeShadow(auxPos, 2)
      removeShadow(auxPos, 3)
      end  
        doRemoveCondition(cid, CONDITION_OUTFIT)
        mayNotMove(cid, false)
        return true
     end
     local newShadowId = getNextShadowId(oldDir, currentDir)
     local newShadow = doCreateItem(newShadowId, 1, currentPosition)
     doItemSetAttribute(newShadow, "name","a shadow. It belongs to ".. cid)
     doItemSetAttribute(newShadow, "aid", (shadowsId*1000))
     local nshadowpos = getThingPosition(newShadow)
     table.insert(shadowList, {nshadowpos.x,nshadowpos.y,nshadowpos.z})
    setPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_X, nshadowpos.x)
     setPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_Y, nshadowpos.y)
     setPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_Z, nshadowpos.z)
     
     if not getTilePzInfo(currentPosition) then
     local target = getCreatureOnPosition(currentPosition)
     if(isCreature(target)) then
           if((getCreatureName(cid) ~= getCreatureName(target)) and not isKagemaneTarget(target, cid) and (isPlayer(target) or isMonster(target))) then
              if(getPlayerStorageValue(target,STORAGE_TRAPED_ON_KAGEMANE) ~= 1 and getStorage(target, STORAGE_KAGEMANE_TRAPED_QTY) <= 0) then
                 if(isPlayer(target)) then
                       if addKagemaneTarget(cid, target) then
                            for i = 1, #shadowList do
                            local auxPos = oldPosition
                            auxPos.x = shadowList[i][1]
                            auxPos.y = shadowList[i][2]
                            auxPos.z = shadowList[i][3]
                            removeShadow(auxPos, 1)
                            removeShadow(auxPos, 2)
                            removeShadow(auxPos, 3)
 
                        end
                        doRemoveCondition(cid, CONDITION_OUTFIT)
                        mayNotMove(cid, false)
                          setPlayerStorageValue(cid, shadowStorages[shadowsId], 0)
                          return true
                       end        
                 else
                 addKagemaneTarget(cid, target)
                            for i = 1, #shadowList do
                            local auxPos = oldPosition
                            auxPos.x = shadowList[i][1]
                            auxPos.y = shadowList[i][2]
                            auxPos.z = shadowList[i][3]
                            removeShadow(auxPos, 1)
                            removeShadow(auxPos, 2)
                            removeShadow(auxPos, 3)
 
                          end
                          doRemoveCondition(cid, CONDITION_OUTFIT)
                          mayNotMove(cid, false)
                 setPlayerStorageValue(cid, shadowStorages[shadowsId], 0)
                  return true            
                 end
                 return doKagemane(cid, currentPosition, currentDir, shadowsId, shadowList)    
              end
           end
     end
     end
     
     
          return addEvent(doKagemane, KAGEMANE_TIME, cid, currentPosition, currentDir, shadowsId, shadowList)    
 
  else
   if shadowsId == 1 then
 
      if getPlayerStorageValue(cid, shadowStorages[2]) == 1 or getPlayerStorageValue(cid, shadowStorages[3]) == 1 then
         return addEvent(doKagemane, KAGEMANE_TIME, cid, currentPosition, currentDir, shadowsId, shadowList)
      else
 
         for i = 1, #shadowList do
         local auxPos = getCreaturePosition(cid) or currentPosition
         auxPos.x = shadowList[i][1]
         auxPos.y = shadowList[i][2]
         auxPos.z = shadowList[i][3]
         removeShadow(auxPos, shadowsId)
         doPlayerSetNoMove(cid, false)
   
         end    
         return TRUE
      end
   end      
 
      for i = 1, #shadowList do
      local auxPos = getCreaturePosition(cid)
      auxPos.x = shadowList[i][1]
      auxPos.y = shadowList[i][2]
      auxPos.z = shadowList[i][3]
       removeShadow(auxPos, shadowsId)
      end  
       
      return TRUE
  end
end
 
 
function removeShadow(pos, shadowId)
  for i = 0,10 do
     pos.stackpos = i
     local item = getThingfromPos(pos)
     local aid = item.actionid
     local x = item.itemid
     if x >= SHADOW_ITEMID_FIRST and x <= SHADOW_ITEMID_LAST then
        if (shadowId*1000) == aid then
           doRemoveItem(item.uid,1)
        end
     end
  end
return true
end      
 
 
 
function getSimpleDirectionTo(pos1, pos2)
 
if pos2.x > pos1.x and pos2.y > pos1.y then
   return 2
elseif pos2.x > pos1.x and pos2.y < pos1.y then
   return 0
elseif pos2.x > pos1.x and pos2.y == pos1.y then
   return 1
elseif pos2.x < pos1.x and pos2.y > pos1.y then
   return 3
elseif pos2.x < pos1.x and pos2.y < pos1.y then
   return 0
elseif pos2.x < pos1.x and pos2.y == pos1.y then
   return 3
elseif pos2.x == pos1.x and pos2.y > pos1.y then
   return 2
elseif pos2.x == pos1.x and pos2.y < pos1.y then
   return 0
end
return 50
end
 
 
function getNextShadowId(oldDir, currentDir)
    return kagemaneShadows[oldDir][currentDir]
end  
 
function getCreatureOnPosition(pos)
    for i = 253, 255 do
       pos.stackpos = i
       if isCreature(getThingfromPos(pos).uid) then
          return getThingfromPos(pos).uid
       end  
    end
  return false
end  
 
function isKagemaneTarget(cid, x)
   for i = STORAGE_KAGEMANE_TARGETS_START, STORAGE_KAGEMANE_TARGETS_END do
      if getPlayerStorageValue(cid, i) == x then
         return true
      end
   end
  return false
end
 
 
function addKagemaneTarget(cid, target)
  local ppos = getCreaturePosition(cid)
  local epos = getCreaturePosition(target)
  local protection = getConfigValue('protectionLevel')

  if isPlayer(cid) and isPlayer(target) then
    if (getPlayerLevel(target) <= protection) then --Proteger ProtectionLevel
      return false
    end
    if (getPlayerLevel(cid) <= protection) then --ProtectionLevel nao pode prender players
      return false
    end
  end



   registerCreatureEvent(cid, "kagemaneDeath")
   registerCreatureEvent(target, "kagemaneDeath")
 
  if getTilePzInfo(ppos) or getTilePzInfo(epos) then
     return false
  end
 
  if isPlayer(cid) then
    if (isPlayer(target)) then
      doPlayerSendTextMessage(target, 22, "You have been caught on ".. getCreatureName(cid).."'s kagemane no jutsu!")
    end              
  end
 
 
  mayNotMove(target, true)
  doRemoveCondition(cid, CONDITION_OUTFIT)
 
  addKagemaneTargetToList(cid, target)
  doPlayerSendTextMessage(cid, 22, "You have caught ".. getCreatureName(target).." on your kagemane no jutsu!")
 
  setPlayerStorageValue(target, STORAGE_TRAPED_ON_KAGEMANE, 1)
  setPlayerStorageValue(target, STORAGE_KAGEMANE_ATTACKER_NAME, cid)
  registerCreatureEvent(target, "creatureMove")
  registerCreatureEvent(target, "direction")
  addEvent(checkKagemaneBreak, 1000, target)
 
  return TRUE
end
 
 
function removeKagemaneTarget(cid, target)
  if not isCreature(cid) then
    if (isPlayer(target)) then
      doPlayerSendTextMessage(target, 22, "You have been freed from ".. getCreatureName(cid).."'s kagemane no jutsu!")
    else
      doMonsterSetTarget(target, cid)
     end
      mayNotMove(target, false)
      setPlayerStorageValue(target, STORAGE_TRAPED_ON_KAGEMANE, 0)
      setPlayerStorageValue(target, STORAGE_KAGEMANE_ATTACKER_NAME, 0)
     return true
  end
 
  removeFromKagemaneTargetList(cid, target)
 
  if isMonster(target) then
     doMonsterSetTarget(target, cid)
  end
 
  if(not isCreature(target)) then return false end
 
  if (isPlayer(target)) then
      doPlayerSendTextMessage(target, 22, "You have been freed from ".. getCreatureName(cid).."'s kagemane no jutsu!")
  end
 
  mayNotMove(target, false)
  setPlayerStorageValue(target, STORAGE_TRAPED_ON_KAGEMANE, 0)
  setPlayerStorageValue(target, STORAGE_KAGEMANE_ATTACKER_NAME, 0)
  doPlayerSendTextMessage(cid, 22, "You have freed ".. getCreatureName(target).." from your kagemane no jutsu!")
 
  return true
end
 
 
 
function checkKagemaneBreak(cid)
        if(isCreature(cid)) then
          if(getPlayerStorageValue(cid, STORAGE_TRAPED_ON_KAGEMANE) == 1) then
             local master = getPlayerStorageValue(cid, STORAGE_KAGEMANE_ATTACKER_NAME)
             local breakChance = 10 -- chance de quebrar
         
             if(not isCreature(master)) then
                 return breakKagemane(master, cid)
             end
         
             local random = math.random(1,100)
                   
             if(random <= breakChance or not isCreature(master)) then
                return breakKagemane(master, cid)
             end
 
             addEvent(checkKagemaneBreak, 1000, cid)
          end
        end
end
 
 
function getKagemaneTargetList(cid)
   local list = {}
   for i = STORAGE_KAGEMANE_TARGETS_START, STORAGE_KAGEMANE_TARGETS_END do
       local storage = getPlayerStorageValue(cid, i)
       if storage > 1 then
          table.insert(list, storage)
       end
   end
   return list
end      
   
function addKagemaneTargetToList(cid, target)
if(not isCreature(target)) then return false end
 
   for i = STORAGE_KAGEMANE_TARGETS_START, STORAGE_KAGEMANE_TARGETS_END do
       local storage = getPlayerStorageValue(cid, i)
       if storage < 1 then
          setPlayerStorageValue(cid, i, target)
          setPlayerStorageValue(cid, STORAGE_KAGEMANE_TRAPED_QTY, getPlayerStorageValue(cid, STORAGE_KAGEMANE_TRAPED_QTY) + 1)
          return true
       end
   end
end  
 
function removeFromKagemaneTargetList(cid, target)
if not isCreature(cid) then return false end
if(not isCreature(target)) then return false end
   for i = STORAGE_KAGEMANE_TARGETS_START, STORAGE_KAGEMANE_TARGETS_END do
       local storage = getPlayerStorageValue(cid, i)
       if storage == target then
          setPlayerStorageValue(cid, i, 0)
          setPlayerStorageValue(cid, STORAGE_KAGEMANE_TRAPED_QTY, getPlayerStorageValue(cid, STORAGE_KAGEMANE_TRAPED_QTY) - 1)
          return true
       end
   end
end
 
function cleanKagemaneTargetList(cid)
   for i = STORAGE_KAGEMANE_TARGETS_START, STORAGE_KAGEMANE_TARGETS_END do
      local storage = getPlayerStorageValue(cid, i)
      if(isCreature(storage)) then
 
         removeKagemaneTarget(cid, storage)
      end
      setPlayerStorageValue(cid, i, 0)
   end
   setPlayerStorageValue(cid, STORAGE_KAGEMANE_TRAPED_QTY,0)
return true
end
 
function freeFromKagemane(cid)
   local master = getPlayerStorageValue(cid, STORAGE_KAGEMANE_ATTACKER_NAME)
   removeKagemaneTarget(master, cid)  
end
 
function doCreateItem2(itemid, qty, pos)
   local tileThing = getTileThingByPos({x=pos.x, y=pos.y, z=pos.z, stackpos=0})
   local item = doCreateItem(itemid,qty,pos)
   for i = 1, 10 do
       pos.stackpos = i
       local nitem = getThingfromPos(pos)
       if(nitem)then
          if(nitem.itemid == itemid) then
             return item
          end
       end
   end
doRemoveItem(item,qty)  
return false
end
 
 
function createKagemaneDuplicate(cid)
 
  local shadows_db = {}
 
  local dir = getPlayerLookDir(cid)
  local playername = cid
  local kagePos = getCreaturePosition(cid)
kagePos.x = getPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_X)
  kagePos.y = getPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_Y)
  kagePos.z = getPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_Z)
 
 
 
 
  local npos1 = kagePos
 
  local pos = getPositionByDir(kagePos, dir)
            if dir == 0 then
         
          -- sombra principal --
             local sombra = doCreateItem2(12339, 1, pos)
             if(sombra) then
             table.insert(shadows_db, {pos.x,pos.y,pos.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 2000)
             end
          ----------------------
          -- lateral 1 --
             npos1 = getPositionByDir(pos, 1)
             local sombra = doCreateItem2(12337, 1, npos1)
             if(sombra) then
             table.insert(shadows_db, {npos1.x,npos1.y,npos1.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 2000)
             end
          ----------------------
       
          ----------------------
                                     
          elseif dir == 1 then
             local sombra = doCreateItem(12337, 1, pos)
             if(sombra) then
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 2000)
             table.insert(shadows_db, {pos.x,pos.y,pos.z})
             end
          ----------------------
          -- lateral 1 --
             npos1 = getPositionByDir(pos, 0)
             local sombra = doCreateItem(12339, 1, npos1)
             if(sombra) then
             table.insert(shadows_db,{npos1.x,npos1.y,npos1.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 2000)
             end
          ----------------------
     
          ----------------------
     
          elseif dir == 2 then
     
             local sombra = doCreateItem2(12343, 1, pos)
             if(sombra) then
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 2000)
             table.insert(shadows_db,{pos.x,pos.y,pos.z})
             end
          ----------------------
          -- lateral 1 --
             npos1 = getPositionByDir(pos, 1)
             local sombra = doCreateItem2(12338, 1, npos1)
             if(sombra) then
             table.insert(shadows_db, {npos1.x,npos1.y,npos1.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 2000)
             end
          ----------------------
          -- lateral 2 --
     
          ----------------------
   
          elseif dir == 3 then
 
             local sombra = doCreateItem2(12343, 1, pos)
             if(sombra) then
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 2000)
             table.insert(shadows_db, {pos.x,pos.y,pos.z})
             end
          ----------------------
          -- lateral 1 --
             npos1 = getPositionByDir(pos, 0)
             local sombra = doCreateItem2(12338 , 1, npos1)
             if(sombra) then
             table.insert(shadows_db, {npos1.x,npos1.y,npos1.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 2000)
             end
          ----------------------
          -- lateral 2 --
       
          ----------------------
          end
  doKagemane(cid, npos1, dir, 2, shadows_db)
  return TRUE
end
 
function createKagemaneTriplicate(cid)
 
 
   local shadows_db = {}
   
  local dir = getPlayerLookDir(cid)
  local playername = cid
  local kagePos = getCreaturePosition(cid)
  kagePos.x = getPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_X)
  kagePos.y = getPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_Y)
  kagePos.z = getPlayerStorageValue(cid, STORAGE_KAGEMANELASTPOS_Z)
 
  local npos1 = kagePos
  local npos2 = kagePos
 
  local pos = getPositionByDir(kagePos, dir)
  createKagemaneDuplicate(cid)
            if dir == 0 then        
             local sombra = doCreateItem2(12337, 1, pos)
             if(sombra) then
             table.insert(shadows_db, {pos.x,pos.y,pos.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          ----------------------
          -- lateral 1 --
             npos1 = getPositionByDir(pos, 1)
             local sombra = doCreateItem2(12337, 1, npos1)
             if(sombra) then
             table.insert(shadows_db, {npos1.x,npos1.y,npos1.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          -- lateral 2 --
             npos2 = getPositionByDir(pos, 3)
             local sombra = doCreateItem2(12343, 1, npos2)
             if(sombra) then
             table.insert(shadows_db, {npos2.x,npos2.y,npos2.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          ----------------------
                                     
          elseif dir == 1 then
             local sombra = doCreateItem2(12339, 1, pos)
             if(sombra) then
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             table.insert(shadows_db, {pos.x,pos.y,pos.z})
             end
          ----------------------
          -- lateral 1 --
             npos1 = getPositionByDir(pos, 0)
             local sombra = doCreateItem2(12339, 1, npos1)
             if(sombra) then
             table.insert(shadows_db,{npos1.x,npos1.y,npos1.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          ----------------------
          -- lateral 2 --
             npos2 = getPositionByDir(pos, 2)
             local sombra = doCreateItem2(12343, 1, npos2)
             if(sombra) then
             table.insert(shadows_db,{npos2.x,npos2.y,npos2.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          ----------------------
     
          elseif dir == 2 then
     
              -- sombra principal --
             local sombra = doCreateItem2(12338, 1, pos)
             if(sombra) then
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             table.insert(shadows_db,{pos.x,pos.y,pos.z})
             end
          ----------------------
          -- lateral 1 --
             npos1 = getPositionByDir(pos, 1)
             local sombra = doCreateItem2(12338, 1, npos1)
             if(sombra) then
             table.insert(shadows_db, {npos1.x,npos1.y,npos1.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          ----------------------
          -- lateral 2 --
             npos2 = getPositionByDir(pos, 3)
             local sombra = doCreateItem2(12342, 1, npos2)
             if(sombra) then
             table.insert(shadows_db,{npos2.x,npos2.y,npos2.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          ----------------------
   
          elseif dir == 3 then
         
          -- sombra principal --
             local sombra = doCreateItem2(12338, 1, pos)
             if(sombra) then
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             table.insert(shadows_db, {pos.x,pos.y,pos.z})
             end
          ----------------------
          -- lateral 1 --
             npos1 = getPositionByDir(pos, 0)
             local sombra = doCreateItem2(12338, 1, npos1)
             if(sombra) then
             table.insert(shadows_db, {npos1.x,npos1.y,npos1.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          ----------------------
          -- lateral 2 --
             npos2 = getPositionByDir(pos, 2)
             local sombra = doCreateItem2(12344, 1, npos2)
             if(sombra) then
             table.insert(shadows_db, {npos2.x,npos2.y,npos2.z})
             doItemSetAttribute(sombra, "name","a shadow. It belongs to "..playername)
             doItemSetAttribute(sombra, "aid", 3000)
             end
          ----------------------
          end
 
   doKagemane(cid, npos1, dir, 3, shadows_db)
   addEvent(doKagemane, 300, cid, npos2, dir, 3, shadows_db)
 
  return TRUE
end