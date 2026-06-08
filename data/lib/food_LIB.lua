function doHealOverTime(cid, div, turn, effect) --Script por: Teno
if not isCreature(cid) then return true end

if turn <= 0 or (getCreatureHealth(cid) == getCreatureMaxHealth(cid)) or getPlayerStorageValue(cid, 435642) <= 0 then 
setPlayerStorageValue(cid, 435642, -1)
return true 
end

local d = div / 10000
local amount = math.floor(getCreatureMaxHealth(cid) * d)
doCreatureAddHealth(cid, amount)
if math.floor(turn/10) == turn/10 then
doSendMagicEffect(getThingPos(cid), effect)
end
addEvent(doHealOverTime, 200, cid, div, turn - 1, effect)
end


function hasTile(pos)    --Verifica se tem TILE na pos
pos.stackpos = 0
if getTileThingByPos(pos).itemid >= 1 then
   return true
end
return false
end

function getThingFromPosWithProtect(pos)  --Pega uma creatura numa posiçao com proteçoes
if hasTile(pos) then
pos.stackpos = 253
   pid = getThingfromPos(pos).uid
else
   pid = getThingfromPos({x=1,y=1,z=10,stackpos=253}).uid
end
return pid
end

