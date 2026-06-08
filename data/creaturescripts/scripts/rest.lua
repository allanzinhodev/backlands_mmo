function onStatsChange(cid, attacker, type, combat, value)

local rest = getCreatureOutfit(cid)
rest.lookType = infoClan[getPlayerVocation(cid)].restOutfit

local mold = getCreatureOutfit(cid)
mold.lookType = infoClan[getPlayerVocation(cid)].moldOutfit


   if isPlayer(cid) and type == STATSCHANGE_HEALTHLOSS and getPlayerStorageValue(cid, 2138) == 0 then
   if getPlayerStorageValue(cid, 2138) == 0 then
        mayNotMove(cid, false)
		doSetCreatureOutfit(cid, rest, 0)
        setPlayerStorageValue(cid, 2136, 1)
		setPlayerStorageValue(cid, 2138, 1)
      end
   end

    if isPlayer(cid) and type == STATSCHANGE_HEALTHLOSS and getPlayerStorageValue(cid, 2139) == 0  then
    if getPlayerStorageValue(cid, 2139) == 0 then
		mayNotMove(cid, false)
		doSetCreatureOutfit(cid, mold, 0)
		setPlayerStorageValue(cid, 2137, 1)
		setPlayerStorageValue(cid, 2139, 1)
		setPlayerStorageValue(cid, 2136, 1)
      end
	  return true
   end
   return true
end


