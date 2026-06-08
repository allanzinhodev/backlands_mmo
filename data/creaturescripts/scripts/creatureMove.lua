local function movercriatura(cid, pos)
if not isCreature(cid) then return false end
   if(isWalkable(pos) and isCreature(cid)) then
      doTeleportThing(cid, pos, true)
   end
end


function onCreatureMove(cid, old, current)
if getPlayerStorageValue(cid, STORAGE_KAGEMANE_TRAPED_QTY > 0) then
local list = getKagemaneTargetList(cid)
if(#list > 0) then
          local dir = getDirectionTo(old, current)
          local list = getKagemaneTargetList(cid)
          for _,v in pairs(list) do
             if isCreature(v) then 
                if not getStorage(v, STORAGE_TRAPED_ON_KAGEMANE) == 1 then removeKagemaneTarget(cid, v) end 
                if getStorage(v, STORAGE_KAGEMANE_TRAPED_QTY) > 0 then removeKagemaneTarget(cid, v) end 
                local targetPos = getCreaturePosition(v)
                local npos = getPositionByDirection(targetPos, dir)
                if getTilePzInfo(targetPos) or getTilePzInfo(npos) then
                
                else
                  if isWalkable(npos) then
                     addEvent(movercriatura, 400, v, npos)
                  end            
                  local targetPos = getCreaturePosition(v)
                  local dist = getDistanceBetween(targetPos, current)
                  if dist > 7 or targetPos.z ~= current.z  then
                     removeKagemaneTarget(cid, v)
                  end 
                end
             else
                removeKagemaneTarget(cid, v)
             end
          end 
       end
end

return true
end