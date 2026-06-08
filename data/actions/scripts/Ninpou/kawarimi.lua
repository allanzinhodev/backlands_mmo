function onUse (cid, item, frompos, item2, topos)
local _ = {410, 459, 1394, 1388, 1390, 369, 428}

        if item2.uid <= 1 then
        return doPlayerSendCancel(cid,"You can't do that.")
        end
		
    if getTilePzInfo(getPlayerPosition(cid)) then
        return doPlayerSendCancel(cid, "You can't use.")
    end 

		if isInArray(_, item2.itemid) then
             return doPlayerSendCancel(cid,"You can't do that.")
        end

        if getTileHouseInfo(getCreaturePosition(cid)) then
        return doPlayerSendCancel(cid, "You can't use Kawarimi inside houses.")
        end


         if getPlayerStorageValue(cid, sto_nara[2]) == 0 then
               return doPlayerSendCancel(cid, "Sorry this is not possible.")
         end

        if getTileHouseInfo(topos) then
        return doPlayerSendCancel(cid, "You can't enter houses with Kawarimi.")
        end

        if getPlayerMana(cid) < 5 then
        return doPlayerSendCancel(cid, "You don't have enough chakra.")
        end

        if not hasTile(topos) then
            return doPlayerSendCancel(cid, "You can't reach this place.")
        end

        if doTileQueryAdd(cid, topos) ~= 1 then
            return doPlayerSendCancel(cid, "You can't reach this place.")
        end

          if checkCmd(cid, "rest") then
             return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
         end
        if checkCmd(cid, "mold") then
            return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
         end
         if checkJutsu(cid, "Kagemane") then
            return doPlayerSendCancel(cid, "you cannot use jutsu")
         end


        playerpos = getPlayerPosition (cid)
        doTeleportThing (cid, topos, false)
        doSendMagicEffect (playerpos ,2)
        doSendMagicEffect (topos ,110)
        doCreatureSay(cid, "Kawarimi!", TALKTYPE_MONSTER)
        doPlayerAddMana(cid, -5)
end
