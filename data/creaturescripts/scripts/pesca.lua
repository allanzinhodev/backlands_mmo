function onDirection(cid, old, current)
if getPlayerNoMove(cid) == false then
   return true
end

local posPlayer = getCreaturePosition(cid)
local peixe = getPlayerStorageValue(cid, PEIXESTORAGE)

if peixe > 0 then
    local posPeixe  = getCreaturePosition(peixe)

    if isCreature(peixe) == false then
        doPlayerSetNoMove(cid, false)
        return true
    else
        local posWalk = getPosByDir( getThingPos(peixe), getDirectionTo(posPeixe, posPlayer) )
        local vidaAtual = getCreatureHealth(peixe)
        local Forca = math.random(1, math.floor(vidaAtual/2)+1)
        local ForcaAdicional = getDistanceBetween(posPeixe, posPlayer)*5
        doCreatureAddHealth(peixe, -(Forca+ForcaAdicional))

        local DirPlayer = getDirectionTo(posPeixe, posPlayer)

        if isWalkable(posWalk, peixe, 0, 0) == false then
            local map = getWalkablePosition(peixe, 1, 1)
            local nPos = math.random(1, map[0])
            local NextPos = {x=map[nPos].x, y=map[nPos].y, z=map[nPos].z}
            DirPlayer = getDirectionTo(posPeixe, NextPos)
        end

        
        doSendMagicEffect(getCreaturePosition(peixe), 1)
        doMoveCreature(getPlayerStorageValue(cid, PEIXESTORAGE), DirPlayer)

        if getDistanceBetween(posPeixe, posPlayer) <= 2 then
            doSendMagicEffect(getCreaturePosition(cid), 250)
            doPlayerSetNoMove(cid, false)
            setPlayerStorageValue(cid, PEIXESTORAGE, 0)
            doRemoveCreature(peixe)

            setPlayerStorageValue(cid, EXPSKFISHING, (getPlayerStorageValue(cid, EXPSKFISHING)+100) )
            if getPlayerStorageValue(cid, EXPSKFISHING) >= 1000 then
                setPlayerStorageValue(cid, EXPSKFISHING, 0)
                setPlayerStorageValue(cid, SKILLFISHING,  getPlayerStorageValue(cid, SKILLFISHING)+1 )
            end    
            --unregisterCreatureEvent(cid, "LookPesca") PRECISA VER SE FUNFA< NO MEU N FUNFO, precisa disso pra funfa certinho...
            return true
        end 
        return false
    end
else
    local interval = 250
    local times = 1    
    local pos = {x=getPlayerStorageValue(cid, PLAYERPOSBOIAX), y=getPlayerStorageValue(cid, PLAYERPOSBOIAY), z=getPlayerStorageValue(cid, PLAYERPOSBOIAZ), stackpos=1}
    local directionMove = getDirectionTo(pos, posPlayer)

    doMoveBoia(cid, pos, directionMove, interval, times)
    pos = {x=getPlayerStorageValue(cid, PLAYERPOSBOIAX), y=getPlayerStorageValue(cid, PLAYERPOSBOIAY), z=getPlayerStorageValue(cid, PLAYERPOSBOIAZ), stackpos=1}

    if getDistanceBetween(pos, posPlayer) <= 2 then
        item = getThingfromPos(pos)
        doRemoveItem(item.uid)
        doPlayerSetNoMove(cid, false)        
       return true
    end

return false    
end

return true
end