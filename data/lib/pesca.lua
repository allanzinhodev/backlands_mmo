-- IDSTORAGES
PLAYERPOSX = 7931 
PLAYERPOSY = 7932 
PLAYERPOSZ = 7933

PEIXESTORAGE = 7925 
PLAYERSTORAGE = 7928 
CTRLPLAYER = 7926

PLAYERPOSBOIAX = 7941
PLAYERPOSBOIAY = 7942
PLAYERPOSBOIAZ = 7943

ITEMBOIA = 7575

SKILLFISHING = 7429
EXPSKFISHING = 7430
--a cada 10 skill deve ser add um peixe novo
MAXSKILL = 50 -- SOMENTE NUMERO INTEIROS E MULTIPLOS DE 10

waterIds = {4624, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625}
peixe =
{
        [1] = {nome = 'Fish'},
        [2] = {nome = 'Fish'},
        [3] = {nome = 'Fish'},
        [4] = {nome = 'Fish'},
        [5] = {nome = 'Fish'},
}


-- doMoveBoia
function doMoveBoia(cid, pos, direction, interval, limit, value)
        value = value or 0
        if value >= limit then
            return true
        end
        item = getThingfromPos(pos)
        doRemoveItem(item.uid)
        if direction == 2 then 
        pos.y = pos.y + 1
        effect_a = 1
        elseif direction == 0 then
        pos.y = pos.y - 1
        effect_a = 1       
        elseif direction == 1 then
        pos.x = pos.x + 1
        effect_a = 1
        elseif direction == 3 then
        pos.x = pos.x - 1
        effect_a = 1
        elseif direction == 4 then
        pos.x = pos.x - 1
        pos.y = pos.y + 1        
        effect_a = 1
        elseif direction == 6 then
        pos.x = pos.x - 1
        pos.y = pos.y - 1        
        effect_a = 1

        elseif direction == 5 then
        pos.x = pos.x + 1
        pos.y = pos.y + 1        
        effect_a = 1
        elseif direction == 7 then
        pos.x = pos.x + 1
        pos.y = pos.y - 1        
        effect_a = 1
        end


        if isWalkable(pos, cid, 0, 0) == false then
            local map = getWalkablePositionByPos(pos, 1, 1)
            local nPos = math.random(1, map[0])
            pos  = {x=map[nPos].x, y=map[nPos].y, z=map[nPos].z, stackpos=pos.stackpos}            
        end

        doCreateItem(item.itemid, 1, pos)
        doSendMagicEffect(pos, effect_a)

        setPlayerStorageValue(cid, PLAYERPOSBOIAX, pos.x)
        setPlayerStorageValue(cid, PLAYERPOSBOIAY, pos.y)
        setPlayerStorageValue(cid, PLAYERPOSBOIAZ, pos.z)
        
        return addEvent(doMoveBoia, cid, interval, pos, direction, interval, limit, value+1)
end

function isWalkable(pos, creature, proj, pz)-- by Nord
    if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
    if getTopCreature(pos).uid > 0 and creature then return false end
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


function getWalkablePosition(cid, rangeX, rangeY)
    local centerPos = getCreaturePosition(isCreature(getCreatureMaster(cid)) and (getCreatureMaster(cid)) or (cid))
    local map = {}
    local initPos = {x=centerPos.x-rangeX, y=centerPos.y-rangeY, z=centerPos.z}
    z = 1
    for x=0, rangeX*2 do
        for y=0, rangeY*2 do
            pos = {x=initPos.x+x, y=initPos.y+y, z=initPos.z}
            if isWalkable(pos, cid, 0, 0) then
                map[z] = pos
                map[0] = z
                z = z+1             
            end
        end
    end
    return map
end

function getWalkablePositionByPos(centerPos, rangeX, rangeY)
    local map = {}
    local initPos = {x=centerPos.x-rangeX, y=centerPos.y-rangeY, z=centerPos.z}
    z = 1
    for x=0, rangeX*2 do
        for y=0, rangeY*2 do
            pos = {x=initPos.x+x, y=initPos.y+y, z=initPos.z}
            if isWalkable(pos, cid, 0, 0) then
                map[z] = pos
                map[0] = z
                z = z+1             
            end
        end
    end
    return map
end