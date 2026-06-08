function isKagemane(pos, cid)
    if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
    if getTopCreature(pos).uid > 0 then return false end
    if getTileInfo(pos).protection and pz then return false, true end
    local n = not proj and 3 or 2
    for i = 0, 255 do
        pos.stackpos = i
        local tile = getTileThingByPos(pos)
        if tile.itemid ~= 0 and not isCreature(tile.uid) then
            if hasProperty(tile.uid, n) or hasProperty(tile.uid, 7) then
                return false
            end
        end
    end
    return true
end


function move(attacker, cid, playerpos, targetpos, times)
    if not isCreature(attacker) then
        stopNows(cid, 0)
        setPlayerStorageValue(cid, sto_nara[2], 1)
        setPlayerStorageValue(cid, sto_nara[6], 1)
        return true
    end
        if not isCreature(cid) then
            mayNotMove(attacker, false)
            setPlayerStorageValue(attacker, sto_nara[1], 1)
            setPlayerStorageValue(attacker, sto_nara[2], 1)
            setPlayerStorageValue(attacker, sto_nara[10], 1)
            setPlayerStorageValue(attacker, sto_nara[9], 1)
            return true
        end

        if playerdir ~= getCreatureLookDirection(attacker) then
            doCreatureSetLookDirection(cid, getCreatureLookDirection(attacker))
        end

    if playerpos ~= getCreaturePosition(attacker) then
        if playerpos.z == getCreaturePosition(attacker).z then
            local ntpos = getCreaturePosition(attacker)
            local x,y,z = ntpos.x-playerpos.x,ntpos.y-playerpos.y,ntpos.z-playerpos.z
            ntpos = getCreaturePosition(cid)
            ntpos.x, ntpos.y, ntpos.z = ntpos.x+x,ntpos.y+y,ntpos.z+z
                if queryTileAddThing(cid, ntpos) == RETURNVALUE_NOERROR and getCreaturePosition(attacker).z == getCreaturePosition(cid).z then
                    doMoveCreature(cid, getCreatureLookDirection(attacker))
                end
        end
    end
    
    local playerpos, targetpos = getCreaturePosition(attacker), getCreaturePosition(cid)
    local times = times+1
    
    if times  <  160 then
        addEvent(move, 1, attacker, cid, playerpos, targetpos, times)
    else
        stopEvent(Kubi)
        setPlayerStorageValue(attacker, sto_nara[1], 1)
        setPlayerStorageValue(cid, sto_nara[2], 1)
        setPlayerStorageValue(attacker, sto_nara[2], 1)
        setPlayerStorageValue(attacker, sto_nara[3], 1)
        setPlayerStorageValue(attacker, sto_nara[4], 1)
        setPlayerStorageValue(attacker, sto_nara[5], 1)
        setPlayerStorageValue(cid, sto_nara[6], 1)
        setPlayerStorageValue(attacker, sto_nara[10], 1)
        setPlayerStorageValue(attacker, sto_nara[9], 1)
        stopNows(cid, 0)
        mayNotMove(attacker, false)
        doPlayerSendTextMessage(attacker, MESSAGE_EVENT_ADVANCE, "'"..getPlayerName(cid).."' is not longer tied to your Kagemane")
    end
end