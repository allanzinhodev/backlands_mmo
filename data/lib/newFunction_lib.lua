function impossibleUse(cid)

  if getTilePzInfo(getPlayerPosition(cid)) then
    return doPlayerSendCancel(cid, "You cannot use in Protect Zone.")
  end 

  if checkCmd(cid, "rest") then
    return doPlayerSendCancel(cid, "You cannot use jutsu while you are resting.")
  end

  if checkCmd(cid, "mold") then
    return doPlayerSendCancel(cid, "You cannot use jutsu while you are mold chakra")
  end

  if checkJutsu(cid, "Kagemane") then
    return doPlayerSendCancel(cid, "You can't use.")
  end

    if(getPlayerStorageValue(cid, sto_gen[1]) > os.time() and getPlayerStorageValue(cid, sto_gen[1]) < 100+os.time()) then
      return doPlayerSendTextMessage(cid, 24, "Desculpe você não pode fazer isso.")
    end

    if(getPlayerStorageValue(cid, sto_gen[5]) > os.time() and getPlayerStorageValue(cid, sto_gen[5]) < 100+os.time()) then
      return doPlayerSendTextMessage(cid, 24, "Desculpe você não pode fazer isso.")
    end
end

function checkDoing(cid)
    if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
      return doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
    end
end

function normalizeOutfit(cid)
    doRemoveCondition(cid, CONDITION_OUTFIT)
  return true
end


function Nehan(cid, time, effect, storage)
  if not isCreature(cid) then
    return true
  end
if getPlayerStorageValue(cid, storage) == 0 then
  doSendMagicEffect(getPlayerPosition(cid), effect)
  mayNotMove(cid, true)
  addEvent(mayNotMove, time*1000, cid, false)
  addEvent(Nehan, time*400, cid, time, effect, storage)
end
  addEvent(setPlayerStorageValue, time*1000, cid, storage, 1)
  return true
end
