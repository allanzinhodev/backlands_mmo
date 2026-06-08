local function countdown(cid, qnt, t)
   if not isCreature(cid) or getPlayerStorageValue(cid, 172) <= 0 then
      return
   elseif t == 0 then
      doCreatureAddHealth(cid, qnt)
	  doSendMagicEffect(getThingPos(cid), 11)
      setPlayerStorageValue(cid, 172, -1)
      return
   end
   addEvent(countdown, 1000, cid, qnt, t-1)
end

function onUse(cid, item, frompos, item2, topos)
local health = 500
  
if not isCreature(cid) then
	return true
end

if getCreatureHealth(cid) == getCreatureMaxHealth(cid) then
	return doPlayerSendCancel(cid, "This is already at full health.")
end

   
   setPlayerStorageValue(cid, 172, 1)
   countdown(cid, health , 3)
return true
end